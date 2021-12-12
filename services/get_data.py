# Crawl data
from shopee_crawler import Crawler
import urllib.request
import unidecode
import os
import json
import random
from db import product_data


crawler = Crawler()
crawler.set_origin(origin="shopee.vn")


def create_path_if_not_exist(path):
    if not os.path.exists(path):
        os.mkdir(path)


def convert_to_unicode(accented_string):
    return unidecode.unidecode(accented_string).replace(' ', '_')


def save_products(product, type_folder, label):
    file_name = product['product_id']
    image_url = product['product_image']
    create_path_if_not_exist(f'data/shopee/{type_folder}/{label}')

    urllib.request.urlretrieve(
        image_url, f'data/shopee/{type_folder}/{label}/{file_name}.jpg')


if __name__ == '__main__':
    create_path_if_not_exist('data/shopee')
    create_path_if_not_exist('data/shopee/train')
    create_path_if_not_exist('data/shopee/test')

    print(product_data[0])

    # for keyword in list_keyword:

    #     list_product = random.sample(data, 100)
    #     for product in list_product[:80]:
    #         save_products(product, 'train', convert_to_unicode(keyword))
    #     for product in list_product[80:]:
    #         save_products(product, 'test', convert_to_unicode(keyword))
