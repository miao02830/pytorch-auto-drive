#!/bin/bash
# Trained weights: resnet34_scnn-aug_tusimple_20210723.pt
exp_name=resnet34_scnn-aug_tusimple
url=tcp://localhost:12345
# Training
python -m torch.distributed.launch --nproc_per_node=2 --use_env main_landec.py --aug --epochs=50 --lr=0.2 --batch-size=10 --workers=8 --dataset=tusimple --method=scnn --backbone=resnet34 --world-size=2 --dist-url=${url} --exp-name=${exp_name}
# Predicting lane points for testing
python main_landec.py --state=2 --batch-size=40 --continue-from=${exp_name}.pt --dataset=tusimple --method=scnn --backbone=resnet34 --exp-name=${exp_name}
# Testing with official scripts
./autotest_tusimple.sh ${exp_name} test
