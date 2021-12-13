# Crawl data
from shopee_crawler import Crawler
import json


crawler = Crawler()
crawler.set_origin(origin="shopee.vn")

list_keyword = ['áo sơ mi', 'áo phông', 'áo phao', 'áo hoodie', 'áo gile', 'áo khoác', 'áo len',
                'quần đùi', 'quần jean', 'quần bó', 'quần âu', 'quần ống rộng', 'chân váy',
                'giày thể thao', 'giày lười', 'giày tây', 'boots', 'dép', 'mũ lưỡi trai', 'kính râm']


if __name__ == '__main__':
    data = []

    for keyword in list_keyword:
        raw_data = crawler.crawl_by_search(keyword=keyword)

        for prod in raw_data:
            data.append({
                'product_id': prod['product_id'],
                'product_name': prod['product_name'],
                'product_image': prod['product_image'],
                'product_price': prod['product_price']/100000,
                'product_discount': prod['product_discount'],
                'rating_star': prod['rating_star'],
                'sold': prod['sold'],
                'is_freeship': prod['is_freeship'],
                'shop_location': prod['shop_location'],
                'category': keyword,
                'feature_vector': [],
            })

    with open('services/product.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False)