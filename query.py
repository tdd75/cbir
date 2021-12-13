import pickle

from lib.utils_cv.similarity.metrics import compute_distances

from feature_vector import extract_feature
from services.db import product_data

dnn_features = {}
for prod in list(product_data.find({'feature_vector': {'$type': 'binData'}})):
    dnn_features[prod['product_id']] = pickle.loads(prod['feature_vector'])

def query_image():

    query_feature = list(extract_feature('query').values())[0]

    distances = compute_distances(query_feature, dnn_features)

    distances.sort(key=lambda x: x[1])
    distances = [prod[0] for prod in distances]

    return distances


if __name__ == '__main__':
    print(query_image())
