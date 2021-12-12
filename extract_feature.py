from fastai.vision import (
    DatasetType,
    ImageList,
    imagenet_stats,
    load_learner,
)

from lib.utils_cv.common.gpu import db_num_workers
from lib.utils_cv.similarity.model import compute_features_learner

import config


def extract_feature(entire=False):
    learner = load_learner('export')

    data_rank = (
        ImageList.from_folder(config.DATA_QUERY_PATH)
        .split_none()
        .label_from_folder()
        .transform(size=config.IM_SIZE)
        .databunch(bs=config.BATCH_SIZE, num_workers=db_num_workers())
        .normalize(imagenet_stats)
    )

    # Compute DNN features for all validation images
    embedding_layer = learner.model[1][-2]
    dnn_features = compute_features_learner(
        data_rank, DatasetType.Train, learner, embedding_layer)
    