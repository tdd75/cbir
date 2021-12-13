import os
import pickle
from fastai.vision import (
    DatasetType,
    ImageList,
    imagenet_stats,
    load_learner,
)

from lib.utils_cv.common.gpu import db_num_workers
from lib.utils_cv.similarity.model import compute_features_learner

import config
from services import get_data
from services.db import product_data
from tqdm import tqdm

import warnings
warnings.filterwarnings("ignore")

learner = load_learner('export')
embedding_layer = learner.model[1][-2]

def extract_feature(path):
    data_rank = (
        ImageList.from_folder(path)
        .split_none()
        .label_from_folder()
        .transform(size=config.IM_SIZE)
        .databunch(bs=config.BATCH_SIZE, num_workers=db_num_workers())
        .normalize(imagenet_stats)
    )

    # Compute DNN features for all validation images
    features = compute_features_learner(
        data_rank, DatasetType.Train, learner, embedding_layer)

    return features
    
def update_feature_vector():
    get_data.get_product_db()
    features = extract_feature(config.DB_PATH)
    for key, feature in tqdm(features.items()):
        prod_id = key.split(os.path.sep)[-1].split('.')[0]
        product_data.update_one({'product_id': int(prod_id)}, {'$set': {'feature_vector': pickle.dumps(feature.tolist())}})

if __name__ == '__main__':
    update_feature_vector()