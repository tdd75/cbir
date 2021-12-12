import fastai
from fastai.layers import FlattenedLoss
from fastai.vision import (
    cnn_learner,
    DatasetType,
    ImageList,
    imagenet_stats,
    models,
    load_learner,
)

# sys.path.extend([".", "../.."])  # to access the utils_cv library
from lib.utils_cv.common.data import unzip_url
from lib.utils_cv.common.gpu import which_processor, db_num_workers
from lib.utils_cv.similarity.data import Urls
from lib.utils_cv.similarity.metrics import compute_distances, evaluate
from lib.utils_cv.similarity.model import compute_features, compute_features_learner
from lib.utils_cv.similarity.plot import plot_distances

import config

learner = load_learner('export')

# Load images into fast.ai's ImageDataBunch object
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

def query_image():
    query_images = (
        ImageList.from_folder('query')
        .split_none()
        .label_from_folder()
        .transform(size=config.IM_SIZE)
        .databunch(bs=config.BATCH_SIZE, num_workers=db_num_workers())
        .normalize(imagenet_stats)
    )

    query_im_path = 'query\\CDL10_1.jpg'
    query_feature = compute_features_learner(
        query_images, DatasetType.Fix, learner, embedding_layer)[query_im_path]
    print(query_feature)

    # Get the DNN feature for the query image
    print(f"Query image path: {query_im_path}")
    print(f"Query feature dimension: {len(query_feature)}")
    assert len(query_feature) == config.EMBEDDING_DIM

    # Compute the distances between the query and all reference images
    distances = compute_distances(query_feature, dnn_features)
    return distances