import sys
sys.path.append('.')

import uvicorn
from io import BytesIO
from PIL import Image
from fastapi import FastAPI, File, UploadFile
from fastapi.encoders import jsonable_encoder

from train import train_model
from feature_vector import update_feature_vector
from query import query_image
from utils import util


app = FastAPI()

def save_image(file, filename) -> Image.Image:
    util.refresh_folders('query')
    image = Image.open(BytesIO(file))
    image.save(f'query/{filename}')


@app.post("/query")
async def query(file: UploadFile = File(...)):
    save_image(await file.read(), file.filename)
    product_list = query_image()
    return jsonable_encoder({
        'status': 200,
        'message': 'Query image successfully',
        'product_list': product_list
    })

@app.get("/train")
async def train():
    # train_model()
    return jsonable_encoder({
        'status': 200,
        'message': 'Train model successfully'
    })
    
@app.get("/update-feature")
async def update_feature():
    # update_feature_vector()
    return jsonable_encoder({
        'status': 200,
        'message': 'Update feature vector successfully'
    })

if __name__ == "__main__":
    uvicorn.run(app, debug=True)