<div align="center">
  <h1>VolETA: One- and Few-shot Food Volume Estimation</h1>
  <p>
    <a href="https://www.linkedin.com/in/amughrabi/">Ahmad AlMughrabi</a>, 
    <a href="https://www.linkedin.com/in/umair-haroon-8729611ab">Umair Haroon</a>, 
    <a href="https://www.linkedin.com/in/ricardo-marques-a3128847/">Ricardo Marques</a>, 
    <a href="https://www.linkedin.com/in/petia-radeva-71651334/">Petia Radeva</a>
  </p>
  <p>
    AIBA Lab @ <a href="https://web.ub.edu/web/ub/">UB</a> (Universitat de Barcelona)
  </p>
</div>

-----

<div align="center">
  <h2>Meta Food CVPR Workshop Challenge 2024: <a href="https://sites.google.com/view/cvpr-metafood-2024/challenge">Physically Informed 3D Food Reconstruction</a></h2>
</div>

![CVPR winner TwitterX](https://github.com/umairharon/VolETA-MetaFood/assets/88880739/7982f8c5-4b41-4b0c-86e9-9eadba990f18)

<div align="center">
  <h2>We Won the Meta Food CVPR Workshop Challenge 2024!</h2>
</div>

We are thrilled to announce that our team has won the prestigious Meta Food CVPR Workshop Challenge 2024! This achievement is a testament to our hard work, innovative methodologies, and dedication to advancing the field of food recognition using computer vision.

-----

## Table of Contents

- [Introduction](#introduction)
- [Installation](#installation)
- [Usage](#usage)
- [Methodologies](#methodologies)
- [Submodules](#submodules)
- [Results](#results)
- [Contributing](#contributing)
- [License](#license)
- [Acknowledgements](#acknowledgements)

-----

## Introduction

Accurate dietary assessment using 2D images is crucial but challenging due to the need for precise food volume estimation. Our approach addresses these challenges by providing a semi-automated method that is adaptable and user-friendly.

### Challenges in Food Volume Estimation

- **2D Image Limitations**: Lack of depth information in standard 2D images.
- **Reference Object Methods**: 
  - Use standard-sized items or specific markers for 3D cues.
  - Computationally intensive and often impractical.
- **Non-Reference Object Methods**:
  - Estimate depth using image features and camera properties.
  - Variable camera orientations and positions pose limitations.

### Our Contributions

- **Unbounded Food Scenes**:
  - Flexible camera movement around the food object.
  - Handles varying capturing speeds and topologies.
- **Sparse Input Views**:
  - Requires only one or a few RGBD images.

### Our Framework

![VolETA](https://github.com/umairharon/VolETA-MetaFood/assets/88880739/36a646eb-d2eb-4c2d-8995-47b223b61c49)


## Installation:

To get started, clone this repository:

```bash 
git clone https://github.com/umairharon/VolETA-MetaFood

```

### Requirements

- Python 3.8+
- PyTorch 1.10+
- torchvision
- numpy
- pandas
- scikit-learn
- matplotlib
- OpenCV

You can install the required packages using pip:

```bash
pip install -r requirements.txt
```

## Submodules

Please note that this project relies on several submodules that are not included in this repository. You must clone and install these submodules from their respective repositories:

1. [Pixel-Perfect Structure-from-Motion with Featuremetric Refinement](https://arxiv.org/pdf/2108.08291)
      - Repository: [Pixel-Perfect-SfM](https://github.com/cvg/pixel-perfect-sfm)

2. [Segment Anything (SAM)](https://ai.meta.com/research/publications/segment-anything/)
      - Repository: [Segment-Anything](https://github.com/facebookresearch/segment-anything)

3. [XMem++: Production-level Video Segmentation From Few Annotated Frames](https://arxiv.org/pdf/2307.15958)
      - Repository: [XMem2](https://github.com/mbzuai-metaverse/XMem2?tab=readme-ov-file)

4. [NeuS2: Fast Learning of Neural Implicit Surfaces for Multi-view Reconstruction](https://arxiv.org/abs/2212.05231)
      - Repository: [NeuS2](https://github.com/19reborn/NeuS2?tab=readme-ov-file)

## Usage

After installing the necessary packages and submodules, you can run the main script to the Pipeline:

```bash
python main.py --config configs/config.yaml #Example
```
## Methodology

### Data:
We used the dataset Provided by MetaFood CVPR Workshop Challenge 2024. It consists of 20 food scenes  categorized by difficulty (simple, medium, hard).  

You can download the data from Kaggle: [MTF Challenge Dataset](https://www.kaggle.com/competitions/cvpr-metafood-3d-food-reconstruction-challenge/data)

### Evaluation
Two-phase evaluation process focusing on precision of reconstructed 3D models in shape and portion size.

#### Phase-I (Portion Size Evaluation):
- Metric: Mean Absolute Percentage Error (MAPE).
- Focus: Accuracy of volume estimation of 3D models.

#### Phase-II (Shape Evaluation):
- Eligibility: Top teams from Phase-I.
- Requirement: Submission of complete 3D mesh files for each food item.
- Metric: Chamfer distance.
- Focus: Accuracy of 3D shape reconstruction.

## Results

### Phase-I
- MAPE: 0.10973

### Phase-II
- Chamfer Distance With Transformation Matrix:
  - Average: 0.007258650766
  - Sum: 0.13066
- Chamfer Distance Without Transformation Matrix:
    - Average: 0.09528961389
    - Sum: 1.71521

### Visual Results

| ![1](../../../../../home/umairharoon/Pictures/Screenshots/Challenge_Results/BG/1-G.png) | ![2](../../../../../home/umairharoon/Pictures/Screenshots/Challenge_Results/BG/2.png) | ![GIF 3](url3) | ![GIF 4](url4) | ![GIF 5](url5) | ![GIF 6](url6) |
| -------------- | -------------- | -------------- | -------------- | -------------- | -------------- |
| ![GIF 7](url7) | ![GIF 8](url8) | ![GIF 9](url9) | ![GIF 10](url10) | ![GIF 11](url11) | ![GIF 12](url12) |
| ![GIF 13](url13) | ![GIF 14](url14) | ![GIF 15](url15) | ![GIF 16](url16) | ![GIF 17](url17) | ![GIF 18](url18) |

    