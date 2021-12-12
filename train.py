import random
import math
import torch.nn as nn
import scrapbook as sb
import fastai
from fastai.layers import FlattenedLoss
from fastai.vision import (
    DatasetType,
    ImageList,
    cnn_learner,
    ImageList,
    imagenet_stats,
)

from lib.utils_cv.common.gpu import db_num_workers
from lib.utils_cv.similarity.metrics import compute_distances, evaluate
from lib.utils_cv.similarity.model import compute_features_learner

import config
from model import EmbeddedFeatureWrapper, L2NormalizedLinearLayer, NormSoftmaxLoss

def train_model(use_evaluate=True):
    random.seed(642)
    data_finetune = (
        ImageList.from_folder(config.DATA_FINETUNE_PATH)
        .split_by_rand_pct(valid_pct=0.05, seed=20)
        .label_from_folder()
        .transform(size=config.IM_SIZE)
        .databunch(bs=config.BATCH_SIZE, num_workers=db_num_workers())
        .normalize(imagenet_stats)
    )

    learn = cnn_learner(
        data_finetune,
        config.ARCHITECTURE,
        metrics=[],
        ps=config.DROPOUT
    )

    if config.EMBEDDING_DIM != 4096:
        modules = []
        pooling_dim = 2048
    else:
        modules = [l for l in learn.model[1][:3]]
        pooling_dim = 4096

    modules.append(EmbeddedFeatureWrapper(input_dim=pooling_dim,
                                        output_dim=config.EMBEDDING_DIM,
                                        dropout=config.DROPOUT))
    modules.append(L2NormalizedLinearLayer(input_dim=config.EMBEDDING_DIM,
                                        output_dim=len(data_finetune.classes)))
    learn.model[1] = nn.Sequential(*modules)

    learn = fastai.vision.Learner(data_finetune, learn.model)

    learn.loss_func = FlattenedLoss(NormSoftmaxLoss)

    learn.fit_one_cycle(config.EPOCHS_HEAD, config.HEAD_LEARNING_RATE)
    learn.unfreeze()
    learn.fit_one_cycle(config.EPOCHS_BODY, config.BODY_LEARNING_RATE)

    # Export model
    learn.export('../../../export/export.pkl')

    # Evaluate model
    if use_evaluate == False:
        return
        
    data_rank = (
        ImageList.from_folder(config.DATA_RANKING_PATH)
        .split_none()
        .label_from_folder()
        .transform(size=config.IM_SIZE)
        .databunch(bs=config.BATCH_SIZE, num_workers=db_num_workers())
        .normalize(imagenet_stats)
    )

    # Compute DNN features for all validation images
    embedding_layer = learn.model[1][-2]
    dnn_features = compute_features_learner(
        data_rank, DatasetType.Train, learn, embedding_layer)

    count = 0
    labels = data_rank.train_ds.y
    im_paths = data_rank.train_ds.items
    assert len(labels) == len(im_paths) == len(dnn_features)

    # Use a subset of at least 500 images from the ranking set as query images.
    step = math.ceil(len(im_paths)/500.0)
    query_indices = range(len(im_paths))[::step]

    # Loop over all query images
    for query_index in query_indices:
        if query_index+1 % (step*100) == 0:
            print(query_index, len(im_paths))

        # Get the DNN features of the query image
        query_im_path = str(im_paths[query_index])
        query_feature = dnn_features[query_im_path]

        # Compute distance to all images in the gallery set.
        distances = compute_distances(query_feature, dnn_features)

        # Find the image with smallest distance
        min_dist = float('inf')
        min_dist_index = None
        for index, distance in enumerate(distances):
            if index != query_index:  # ignore the query image itself
                if distance[1] < min_dist:
                    min_dist = distance[1]
                    min_dist_index = index

        # Count how often the image with smallest distance has the same label as the query
        if labels[query_index] == labels[min_dist_index]:
            count += 1

    recallAt1 = 100.0 * count / len(query_indices)
    print("Recall@1 = {:2.2f}".format(recallAt1))

    # Log some outputs using scrapbook which are used during testing to verify correct notebook execution
    sb.glue("recallAt1", recallAt1)

    ranks, mAP = evaluate(data_rank.train_ds, dnn_features, use_rerank=False)
    ranks, mAP = evaluate(data_rank.train_ds, dnn_features, use_rerank=True)