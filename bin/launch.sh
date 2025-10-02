#!/bin/bash
# -*- coding: utf-8 -*-
# @Author: H. T. Duong Vu

set -e  # stop if any command fails

# --- Environment setup for MMGX ---
git clone https://github.com/kurosawaxyz/MMGX.git
cd MMGX

# Create and activate conda environment
conda create -n mmgx python=3.11 -y
source $(conda info --base)/etc/profile.d/conda.sh
conda activate mmgx

# Install requirements
pip install -r requirements.txt

# Install torch-scatter and torch-sparse matching torch version
TORCH_VERSION=$(python -c "import torch; print(torch.__version__.split('+')[0])")
pip install torch-scatter -f https://data.pyg.org/whl/torch-${TORCH_VERSION}.html
pip install torch-sparse -f https://data.pyg.org/whl/torch-${TORCH_VERSION}.html

# --- Launch MMGX hyperparameter tuning ---
python3 hyperparameter.py \
    -f egfr_data \
    -m GIN \
    --schema A \
    --reduced \
    --mol_embedding 256 \
    --batch_normalize \
    --fold 5 \
    --seed 42

python3 hyperparameter.py \
    -f egfr_data \
    -m GIN \
    --schema R \
    --reduced pharmacophore \
    --mol_embedding 256 \
    --batch_normalize \
    --fold 5 \
    --seed 42

python3 hyperparameter.py \
    -f egfr_data \
    -m GIN \
    --schema AR_0 \
    --reduced functional pharmacophore \
    --mol_embedding 256 \
    --batch_normalize \
    --fold 5 \
    --seed 42

echo "DONE"

# Train and test the model will be done later after hyperparameter tuning (All informations necessary for training and testing are provided in the output of hyperparameter tuning)