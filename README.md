# Codebase for deep autonomous driving perception tasks

Segmentation models (**Deeplab, FCN, ERFNet**), Lane detection models (**ERFNet, ERFNet-SCNN and others**) based on Python 3.6 and PyTorch >=1.6.0 (CUDA 10) & TorchVision >=0.7.0 with mixed precision training.

**This repository implements (or plan to implement) the following interesting papers in a unified Python codebase:**

[Fully Convolutional Networks for Semantic Segmentation](https://arxiv.org/abs/1605.06211) CVPR 2015

[DeepLab: Semantic Image Segmentation with Deep Convolutional Nets, Atrous Convolution, and Fully Connected CRFs](https://arxiv.org/abs/1606.00915) TPAMI 2017

[Rethinking Atrous Convolution for Semantic Image Segmentation](https://arxiv.org/abs/1706.05587) ArXiv preprint 2017

[ERFNet: Efficient Residual Factorized ConvNet for Real-Time Semantic Segmentation](https://ieeexplore.ieee.org/abstract/document/8063438/) ITS 2017

[Spatial As Deep: Spatial CNN for Traffic Scene Understanding](https://arxiv.org/abs/1712.06080) AAAI 2018

[RESA: Recurrent Feature-Shift Aggregator for Lane Detection](https://arxiv.org/abs/2008.13719) AAAI 2021

[Learning Lightweight Lane Detection CNNs by Self Attention Distillation](https://arxiv.org/abs/1908.00821) ICCV 2019

[Polynomial Regression Network for Variable-Number Lane Detection](http://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123630698.pdf) ECCV 2020

[End-to-end Lane Shape Prediction with Transformers](https://arxiv.org/abs/2011.04233) WACV 2021

**This repository is under active development, which means performance reported could improve in the future. While results with models uploaded are probably stable.**

## Highlights

Fast probability map to poly line conversion, modulated (borrowed) mIOU & pixel acc calculation, "poly" learning rate schedule, basic input loading, transformations and visualizations, also tests of mixed precision training and tensorboard logging. **And you do not need matlab to test on CULane.**

And models from this repo are faster to train and often have better performance than other implementations, see [wiki](https://github.com/voldemortX/pytorch-auto-drive/wiki/Notes) for reasons.

## Supported datasets: 

| Task | Dataset |
| :---: | :---: |
| semantic segmentation | PASCAL VOC 2012 |
| semantic segmentation | Cityscapes |
| semantic segmentation | GTAV* |
| semantic segmentation | SYNTHIA* |
| lane detection | CULane |
| lane detection | TuSimple |
| lane detection | BDD100K (*In progress*) |

\* The UDA baseline setup, with Cityscapes *val* set as validation.

## Supported models:

| Task | Backbone | Model/Method |
| :---: | :---: | :---: |
| semantic segmentation | ResNet-101 | [FCN](https://arxiv.org/abs/1605.06211) |
| semantic segmentation | ResNet-101 | [DeeplabV2](https://arxiv.org/abs/1606.00915) |
| semantic segmentation | ResNet-101 | [DeeplabV3](https://arxiv.org/abs/1706.05587) |
| semantic segmentation | - | [ERFNet](https://ieeexplore.ieee.org/abstract/document/8063438/) |
| lane detection | ERFNet, VGG16, ResNets (18, 34, 50, 101) | Baseline |
| lane detection | ERFNet, VGG16, ResNets (18, 34, 50, 101) | [SCNN](https://arxiv.org/abs/1712.06080) |
| lane detection | VGG, ResNets (18, 34, 50, 101) | [RESA](https://arxiv.org/abs/2008.13719) (*In progress*) |
| lane detection | ERFNet, ENet | [SAD](https://arxiv.org/abs/1908.00821) (*In progress*) |
| lane detection | ERFNet | [PRNet](http://www.ecva.net/papers/eccv_2020/papers_ECCV/papers/123630698.pdf) (*In progress*) |
| lane detection | ERFNet, ResNet18-reduced | [LSTR](https://arxiv.org/abs/2011.04233) (*In progress*) |

*The VGG16 backbone corresponds to DeepLab-LargeFOV in SCNN.*

*The ResNet backbone corresponds to DeepLabV2 (w.o. ASPP) with output channels reduced to 128 as in RESA.*

*We keep calling it VGG/ResNet for consistency with common practices.*

## Lane detection performance:

| method | backbone | resolution | mixed precision? | dataset | metric | average | best | training time |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| Baseline | ERFNet | 288 x 800 | *yes* | CULane | F measure | 73.40 | 73.49 | 6h |
| SCNN | ERFNet | 288 x 800 | *yes* | CULane | F measure | 73.85 | 74.03 | 11.3h |
| Baseline | ERFNet | 360 x 640 | *yes* | TuSimple | Accuracy | 95.15% | 95.24% | 0.8h |
| SCNN | ERFNet | 360 x 640 | *yes* | TuSimple | Accuracy | 96.00% | 96.12% | 1.6h |
| Baseline | VGG16 | 288 x 800 | *yes* | CULane | F measure | 63.90 | 63.98 | 9.3h |
| SCNN | VGG16 | 288 x 800 | *yes* | CULane | F measure | 73.13 | 73.23 | 12.8h |
| Baseline | VGG16 | 360 x 640 | *yes* | Tusimple | Accuracy | 94.00% | 94.15% | 2h |
| SCNN | VGG16 | 360 x 640 | *yes* | Tusimple | Accuracy | 93.61% | 93.67% | 1.5h |


*All performance is measured with ImageNet pre-training and reported as 3 times average/best on test set.*

### Tusimple detailed performance (best):

| method | backbone | accuracy | FP | FN | |
| :---: | :---: | :---: | :---: | :---: | :---: |
| Baseline | ERFNet | 95.24% | 0.0569 | 0.0457 | [model](https://drive.google.com/file/d/12n_ck3Ir86j3VOhIn0hT96Ru4n8nhP5G/view?usp=sharing) |
| SCNN | ERFNet | 96.12% | 0.0468 | 0.0335 | [model](https://drive.google.com/file/d/1rzE2fZ5mQswMIm6ICK1lWH-rsQyjRbxL/view?usp=sharing) |
| SCNN | VGG16 | 94.15% | 0.0723 | 0.0812 |  |

### CULane detailed performance (best):

| category | ERFNet-Baseline | ERFNet-SCNN | VGG16-SCNN | VGG16-Baseline |
| :---: | :---: | :---: | :---: | :---: |
| normal | 91.48 | 91.82 | 91.17 | 83.67 |
| crowded | 71.27 | 72.13 | 71.56 | 61.64 |
| night | 68.09 | 69.49 | 67.83 | 58.12 |
| no line | 46.76 | 46.68 | 45.59 | 34.93 |
| shadow | 74.47 | 70.59 | 69.38 | 54.07 |
| arrow | 86.09 | 87.40 | 86.56 | 75.52 |
| dazzle light | 64.18 | 65.80 | 62.83| 52.65 |
| curve | 66.89 | 68.30 | 66.58 | 61.30 |
| crossroad | 2102 | 2236 | 1809 | 1985 |
| total | 73.49 | 74.03 | 73.23 | 63.98 |
| | [model](https://drive.google.com/file/d/16-Q_jZYc9IIKUEHhClSTwZI4ClMeVvQS/view?usp=sharing) | [model](https://drive.google.com/file/d/1YOAuIJqh0M1RsPN5zISY7kTx9xt29IS3/view?usp=sharing) |

## Semantic segmentation performance:

| model | resolution | mixed precision? | dataset | average | best | training time | best model link |
| :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| FCN | 321 x 321 | *yes* | PASCAL VOC 2012 | 70.72 | 70.83 | 3.3h | [model](https://drive.google.com/file/d/1SIIpApBdL0wXanlLeLWBSJJmX3AYLBnf/view?usp=sharing) |
| FCN | 321 x 321 | *no* | PASCAL VOC 2012 | 70.91 | 71.55 | 6.3h | [model](https://drive.google.com/file/d/1ZunsGFjXxSIwR8Blckyk-Ils6IdhSqV1/view?usp=sharing) |
| DeeplabV2 | 321 x 321 | *yes* | PASCAL VOC 2012 | 74.59 | 74.74 | 3.3h | [model](https://drive.google.com/file/d/1UGR4u1qvJcczLfcgmSHoVd0CGqHMfLoU/view?usp=sharing) |
| DeeplabV3 | 321 x 321 | *yes* | PASCAL VOC 2012 | 78.11 | 78.17 | 7h | [model](https://drive.google.com/file/d/1iYN73iqDD74HPZFGorARb6T2w7KkhbPM/view?usp=sharing) |
| FCN | 256 x 512 | *yes* | Cityscapes | 68.05 | 68.20 | 2.2h | [model](https://drive.google.com/file/d/1zT-lBElfkD1Sratu4WYiTCRU9PF16lLj/view?usp=sharing) |
| DeeplabV2 | 256 x 512 | *yes* | Cityscapes | 68.65 | 68.90 | 2.2h | [model](https://drive.google.com/file/d/16SR6EEdsuOtU6xyu7BsP-GQ16-y3OfGe/view?usp=sharing) |
| DeeplabV3 | 256 x 512 | *yes* | Cityscapes | 69.87 | 70.37 | 4.5h | [model](https://drive.google.com/file/d/1HUR09zcPpjD5Q3LAm4p5t7e9gl1ZkpqU/view?usp=sharing) |
| DeeplabV2 | 256 x 512 | *no* | Cityscapes | 68.45 | 68.89 | 4h | [model](https://drive.google.com/file/d/1fbxsPGu31plfgyQ0N0eiqk659F9osbRm/view?usp=sharing) |
| ERFNet | 512 x 1024 | *yes* | Cityscapes | 71.99 | 72.47 | 5h | [model](https://drive.google.com/file/d/1uzBSboKD-Xt0K6VHd2aF561Cy13q9xRe/view?usp=sharing) |
| ENet | 512 x 1024 | *yes* | Cityscapes | 65.54 | 65.74 | 10.6h |  |
| DeeplabV2 | 512 x 1024 | *yes* | Cityscapes | 71.78 | 72.12 | 9h | [model](https://drive.google.com/file/d/1MUG3PMMlFOtiX7G-TYCZhG_8D9aLqTPE/view?usp=sharing) |
| DeeplabV2 | 512 x 1024 | *yes* | GTAV | 32.90 | 33.88 | 13.8h | [model](https://drive.google.com/file/d/1udHozZzwka9ktMxaV0tynL1HToy0H6sI/view?usp=sharing) |
| DeeplabV2 | 512 x 1024 | *yes* | SYNTHIA* | 33.89 | 34.86 | 10.4h | [model](https://drive.google.com/file/d/1M-CO46zjXbVo8pguISUEw3M6NoKHIN0l/view?usp=sharing) |

*All performance is measured with ImageNet pre-training and reported as 3 times average/best mIoU (%) on val set.*

*\*SYHTHIA performance is mIoU-16.*

## Preparations:

1. Setup a Python3 environment (CUDA 10), with PyTorch >= 1.6, TorchVision >= 0.7.0, tqdm, tensorboard, numpy, imageio, opencv-python, yaml.

2. Download the code:
   
```
git clone https://github.com/voldemortX/pytorch-auto-drive.git
cd pytorch-auto-drive
```

3. Prepare the code:

```
chmod 777 *.sh
mkdir output
```

## Enable tensorboard (optional):

```
tensorboard --logdir=runs
```

## Getting started

Get started with [LANEDETECTION.md](LANEDETECTION.md) for lane detection.

Get started with [SEGMENTATION.md](SEGMENTATION.md) for semantic segmentation.

## Notes:

1. Cityscapes dataset is down-sampled by 2 when training at 256 x 512, to specify different sizes, modify them in [configs.yaml](configs.yaml); similar changes can be done with other experiments.

2. Training times are measured on **a single RTX 2080Ti**, including online validation time for segmentation, test time for lane detection.

3. All segmentation results reported are from single model without CRF and without multi-scale testing.

4. **Pull Requests** and **Issues** are most welcomed.
