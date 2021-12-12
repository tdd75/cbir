import os
from fastai.vision import models


# Dataset
data_root_dir = 'data/shopee'
DATA_FINETUNE_PATH = os.path.join(data_root_dir, "train")
DATA_RANKING_PATH = os.path.join(data_root_dir, "test")
DATA_QUERY_PATH = os.path.join(data_root_dir, "query")

# DNN configuration and learning parameters. Use more epochs to possibly improve accuracy.
EPOCHS_HEAD = 6  # 12
EPOCHS_BODY = 6  # 12
HEAD_LEARNING_RATE = 0.01
BODY_LEARNING_RATE = 0.0001
BATCH_SIZE = 16
IM_SIZE = (224, 224)
DROPOUT = 0
ARCHITECTURE = models.resnet50

# Desired embedding dimension. Higher dimensions slow down retrieval but often provide better accuracy.
EMBEDDING_DIM = 2048
assert EMBEDDING_DIM == 4096 or EMBEDDING_DIM <= 2048
