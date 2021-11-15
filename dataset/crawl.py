from shopee_crawler import Crawler
import urllib.request
import unidecode
import random
import math
import os

os.chdir('E:\\ai\\cbir')

crawler = Crawler()
crawler.set_origin(origin="shopee.vn")


def create_path_if_not_exist(path):
    if not os.path.exists(path):
        os.mkdir(path, 0o666)


def convert_to_unicode(accented_string):
    return unidecode.unidecode(accented_string).replace(' ', '_')


def save_products(product, type_folder, label):
    file_name = product['product_id']
    image_url = product['product_image']
    create_path_if_not_exist(f'data/{type_folder}/{label}')

    urllib.request.urlretrieve(image_url, f'data/{type_folder}/{label}/{file_name}.jpg')


list_keyword = ['áo sơ mi', 'áo phông', 'áo phao', 'áo hoodie', 'áo gile', 'áo khoác', 'áo len',
                'quần đùi', 'quần jean', 'quần bó', 'quần âu', 'quần ống rộng', 'chân váy',
                'giày thể thao', 'giày lười', 'giày tây', 'boots', 'dép', 'mũ lưỡi trai', 'kính râm']

if __name__ == '__main__':
    create_path_if_not_exist('data/gallery')
    create_path_if_not_exist('data/query')
    create_path_if_not_exist('retrieved_images')

    for keyword in list_keyword:
        data = crawler.crawl_by_search(keyword=keyword)
        list_product = random.sample(data, 1000)
        for product in list_product[:800]:
            save_products(product, 'gallery', convert_to_unicode(keyword))
        for product in list_product[800:]:
            save_products(product, 'query', convert_to_unicode(keyword))
