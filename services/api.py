import uvicorn
import numpy as np
from io import BytesIO
from PIL import Image
from fastapi import FastAPI, File, UploadFile
from fastapi.encoders import jsonable_encoder

app = FastAPI()


def read_data(file, filename) -> Image.Image:
    image1 = Image.open(BytesIO(file))
    filepath = f'../data/imgs_uploaded/{filename}'
    image1.save(filepath)
    return filepath


@app.post("/query")
async def query_image(file: UploadFile = File(...)):
    path = read_data(await file.read(), file.filename)


if __name__ == "__main__":
    uvicorn.run(app,  debug=True, host='0.0.0.0')