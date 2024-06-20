<div align="center">
  <h1>VolETA: One- and Few-shot Food Volume Estimation</h1>
  <p>
    <a href="https://www.linkedin.com/in/amughrabi/">Ahmad AlMughrabi*</a>, 
    <a href="https://www.linkedin.com/in/umair-haroon-8729611ab">Umair Haroon*</a>, 
    <a href="https://www.linkedin.com/in/ricardo-marques-a3128847/">Ricardo Marques* ¹</a>, 
    <a href="https://www.linkedin.com/in/petia-radeva-71651334/">Petia Radeva* ²</a>
  </p>
  <p>
    AIBA Lab @ <a href="https://web.ub.edu/web/ub/">UB</a> (Universitat de Barcelona)*,
    Computer Vision Center ¹,
    Institut de Neurosciències ²
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
- [Methodology](#methodology)
- [Submodules](#submodules)
- [Results](#results)
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
We used the dataset Provided by MetaFood CVPR Workshop Challenge 2024. It comprises 20 food scenes  categorized by difficulty (simple, medium, hard).  

You can download the data from Kaggle: [MTF Challenge Dataset](https://www.kaggle.com/competitions/cvpr-metafood-3d-food-reconstruction-challenge/data)

### Evaluation
A two-phase evaluation process focuses on the precision of reconstructed 3D models in terms of shape and portion size.

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

| ![1](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/da79f623-0cbe-4ff1-bd07-ad230fabd318) | ![2](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/4133aace-0770-4c0c-91fa-5f92e7133904) | ![3](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/54f4c111-9d29-44a8-96b6-a99455e258ba) | ![4](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/dc8f2fc7-b8f0-476d-a5ff-3122a6330f67) | ![5](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/dfb7972d-7687-468f-b572-e45e82808ab6) | ![6](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/ece9a850-4495-4b75-abe5-e5ad706199c8) |
| -------------- | -------------- | -------------- | -------------- | -------------- | -------------- |
| ![7](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/5467754d-022a-4b3d-9e98-e3e2507c3745) | ![8](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/51e9c2ad-b89c-4960-ad38-3fe93fc20f4f) | ![9](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/464239c2-7ef7-46d7-9180-bde2cf59c263) | ![10](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/25cc7f42-16f6-4b0a-b8c2-fb6d93d463bc) | ![11](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/da9d1f1d-b7da-4c2a-bbaa-fae27464c4be) | ![12](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/e0c63852-026a-476f-8989-11c108ac042f) |
| ![14](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/c33114cb-9be9-4e3f-b3da-108818d65b13)| ![16](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/8d524726-b24f-4ab5-8613-b3290a986266) | ![17](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/834da62a-6e03-4e68-b87f-1b1741f18079) | ![18](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/5026569f-96cc-49c8-ad99-715d939d0e77) | ![19](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/e195e724-c728-40ef-99c2-d917e7f2788d) | ![20](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/858b4c77-57af-4893-ab2f-c60dd5e4daaa) |

#### Comparison Over Ground Truth
![Results](https://github.com/GCVCG/VolETA-MetaFood/assets/88880739/abf9cd58-fc0f-490e-992c-3be10a815b93)

## Acknowlegements

    
