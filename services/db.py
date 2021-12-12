from pymongo import MongoClient

client = MongoClient(
    'mongodb+srv://admin:admin@cluster0.fm4xh.mongodb.net/test')
db = client['shop-db']
product_data = db['product']
