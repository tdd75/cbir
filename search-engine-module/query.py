import pickle

from lib.utils_cv.similarity.metrics import compute_distances

from feature_vector import extract_feature
from services.db import product_data

dnn_features = {}
for prod in list(product_data.find({'featureVector': {'$type': 'binData'}})):
    dnn_features[prod['productId']] = pickle.loads(prod['featureVector'])


def query_image():
    query_feature = list(extract_feature('query').values())[0]

    distances = compute_distances(query_feature, dnn_features)

    distances.sort(key=lambda x: x[1])
    id_list = [prod[0] for prod in distances]

    return id_list


if __name__ == '__main__':
    print(query_image())
