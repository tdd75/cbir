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
                'productId': prod['product_id'],
                'productName': prod['product_name'],
                'productImage': prod['product_image'],
                'productPrice': prod['product_price']/100000,
                'productDiscount': prod['product_discount'],
                'ratingStar': prod['rating_star'],
                'sold': prod['sold'],
                'isFreeship': prod['is_freeship'],
                'shopLocation': prod['shop_location'],
                'category': keyword,
                'featureVector': [],
            })

    with open('services/product.json', 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False)
