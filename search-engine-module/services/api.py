from model import EmbeddedFeatureWrapper, L2NormalizedLinearLayer, NormSoftmaxLoss
from services.get_data import get_products_by_ids
from utils import util
from query import query_image
from feature_vector import update_featureVector
from train import train_model
from fastapi.encoders import jsonable_encoder
from fastapi import FastAPI, File, UploadFile
from PIL import Image
from io import BytesIO
import uvicorn
import sys
sys.path.append('.')


app = FastAPI()


def save_image(file, filename) -> Image.Image:
    util.refresh_folders('query')
    image = Image.open(BytesIO(file))
    image.save(f'query/{filename}')


@app.post("/query")
async def query(file: UploadFile = File(...)):
    save_image(await file.read(), file.filename)
    id_list = query_image()
    product_list = get_products_by_ids(id_list)
    return jsonable_encoder({
        'code': 200,
        'message': 'Query image successfully.',
        'data': product_list
    })


@app.get("/train")
async def train():
    train_model()
    return jsonable_encoder({
        'code': 200,
        'message': 'Train model successfully.'
    })


@app.get("/update-feature")
async def update_feature():
    update_featureVector()
    return jsonable_encoder({
        'code': 200,
        'message': 'Update feature vector successfully.'
    })

if __name__ == "__main__":
    uvicorn.run(app, debug=True, host='0.0.0.0')
