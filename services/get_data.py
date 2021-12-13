import sys
sys.path.append('.')

import pandas as pd
import urllib.request
from sklearn.model_selection import train_test_split
from shopee_crawler import Crawler
from tqdm import tqdm

from utils import util
from services.db import product_data

crawler = Crawler()
crawler.set_origin(origin="shopee.vn")


def save_products(product, type_folder, label):
    file_name, image_url = product
    util.create_path_if_not_exist(f'data/shopee/{type_folder}/{label}')

    urllib.request.urlretrieve(
        image_url, f'data/shopee/{type_folder}/{label}/{file_name}.jpg')


def get_train_test():
    util.refresh_folders('data/shopee/train', 'data/shopee/test')

    df = pd.DataFrame(list(product_data.find())).sample(n=2000, random_state=1)

    X_train, X_test, y_train, y_test = train_test_split(
        df[['product_id', 'product_image']], df['category'], test_size=0.2, random_state=42)

    for product, category in tqdm(zip(X_train.values, y_train.array)):
        save_products(product, 'train', util.convert_to_unicode(category))
    for product, category in tqdm(zip(X_test.values, y_test.array)):
        save_products(product, 'test', util.convert_to_unicode(category))


def get_product_db():
    util.refresh_folders('data/shopee/db')

    df = pd.DataFrame(list(product_data.find({f'feature_vector': {'$type': 'array'}}))).sample(n=2000, random_state=1)
    
    for product, category in tqdm(zip(df[['product_id', 'product_image']].values, df['category'].array)):
        save_products(product, 'db', util.convert_to_unicode(category))