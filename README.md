# Human-Augmented-TOP
Human-Augmented Topology Optimization Design with Multi-Framework Intervention

## Overview  
This repository hosts a MATLAB implementation of a novel topology optimization method that integrates human input into the optimization process. The approach leverages designers' expertise to enable real-time adjustments and direct control over the optimization, facilitating faster convergence to solutions that meet design requirements without the need for constant re-tuning.  

A key innovation of this method is the seamless conversion strategy between the **SIMP (Solid Isotropic Material with Penalization)** method, which employs implicit geometry, and the **MMC/MMV (Moving Morphable Components/Voids)** method, which uses explicit geometry. This conversion enables the generation of structural members for SIMP-based designs, allowing designers to intuitively control topology and geometry parameters. Designers can interactively add, adjust, or remove these members, leading to improved buckling resistance, reduced stress concentration, and better management of design complexity.  

The code builds upon several foundational works in topology optimization, including the **88-line MATLAB code** by Andreassen et al. (2010), the **Moving Morphable Components (MMC)** framework by Guo Xu et al., and the **MMA (Method of Moving Asymptotes)** solver by Krister Svanberg. It also references advanced techniques from Ferrari et al.'s work on topology optimization with linearized buckling criteria.  

## How to Start Using the Code

- **Pre-requisites:** Make sure the Image Processing Toolbox is installed in MATLAB before starting.
- **Run the Code:** Simply run `main.m` in MATLAB to get started.
- **Real-time Status:** While the code is running, you can monitor the current status, stress load factors, and other information in the command window. Once optimization completes, the program will pause, and you'll enter the interaction phase.

<div style="display: flex; flex-direction: column; gap: 20px;">
  <img src="https://github.com/user-attachments/assets/41ae7b50-fa38-4236-9178-0aca6e7632b8" width="50%">
  <p><em>Information Display During Optimization</em></p>
  
  <img src="https://github.com/user-attachments/assets/6b15b864-eafb-4828-b3fa-82d2109ca4b9" width="50%">
  <p><em>SIMP Framework Optimization Results</em></p>
  
  <img src="https://github.com/user-attachments/assets/a8e386bb-28ff-42f8-99c4-a379eb5e8ffe" width="50%">
  <p><em>Component Explanation in MMC Framework</em></p>
  
  <img src="https://github.com/user-attachments/assets/f7c3c23f-f1eb-4c58-b233-b9a1cb228a64" width="50%">
  <p><em>Stress Distribution Cloud Plot of the Results</em></p>
</div>

### Interaction Instructions

#### **Deleting a Component**
1. Right-click in the gray space outside the plot window to bring up the menu.  
2. Choose the **"Delete"** option, select the component to delete, and confirm the deletion.

<div style="display: flex; flex-direction: column; gap: 20px;">
  <img src="https://github.com/user-attachments/assets/a4452519-3924-4cfe-b6ba-283357ada383" width="50%">
  <p><em>Right-click Menu Display</em></p>
  
  <img src="https://github.com/user-attachments/assets/d27df15a-6bc9-436f-8656-13d17cc61bcd" width="50%">
  <p><em>Confirm Deletion Popup</em></p>
  
  <img src="https://github.com/user-attachments/assets/54363bf3-432e-48ac-897e-f72cd680f8be" width="50%">
  <p><em>Result After Deletion</em></p>
</div>

---

#### **Adding a Component**
1. Choose **"Add Component"** from the menu.  
2. Drag the desired component into the window, adjust as needed, then double-click to confirm.

<div style="display: flex; flex-direction: column; gap: 20px;">
  <img src="https://github.com/user-attachments/assets/392136b9-5808-461c-a2cc-eb62112bb35d" width="50%">
  <p><em>Add Component Action Example</em></p>
  
  <img src="https://github.com/user-attachments/assets/cd8a6151-ce8b-4e39-8243-c31e096c3374" width="50%">
  <p><em>Result After Adding Component</em></p>
</div>

---

#### **Modifying Component Size**
1. Select **"Modify Size"** from the menu.  
2. Click on the component to resize, enter the new size in the popup window, and confirm the changes.

<div style="display: flex; flex-direction: column; gap: 20px;">
  <img src="https://github.com/user-attachments/assets/3ef5c7de-4e48-4fa0-9328-24d41a3885f6" width="50%">
  <p><em>Size Input Window</em></p>
</div>

---

#### **Resume Optimization**
After completing interactions, select **"Continue"** from the menu to resume the optimization process in the SIMP framework.

<div style="display: flex; flex-direction: column; gap: 20px;">
  <img src="https://github.com/user-attachments/assets/4ccbcf96-449f-49e1-a61f-360121c62279" width="50%">
  <p><em>Final Result</em></p>
</div>

---

#### **Repeat Interaction**
Once the optimization completes and the program pauses again, you can make further adjustments in an interactive loop.

---

### **Key Notes**
- Ensure the **Image Processing Toolbox** is installed in MATLAB before running the code.  
- Monitor the command window for real-time status updates during optimization.  
- Use the interactive menu to delete, add, or modify components as needed.  

---

## Future development
The interaction zone will no longer be treated as a non-designable region. Instead, the impact of user input during interaction will be considered, allowing more flexible adjustments. This change will expand the design space and lead to better-performing solutions.

## How to Cite  
If you use this code or the associated method in your research, please cite the following paper:  

```bibtex
@article{Zhang2024HumanAugmented,
  title={Human-Augmented Topology Optimization Design with Multi-Framework Intervention},
  author={Zhang, Weisheng and Zhuang, Xiaoyu and Guo, Xu and Youn, Sung-Kie},
  journal={Engineering with Computers},
  year={2024},
  doi={10.1007/s00366-024-02102-y},
  url={https://doi.org/10.1007/s00366-024-02102-y}
}
```  

## Contact
Open an issue for this repository or send emails to weishengzhang@dlut.edu.cn. 

## References  
[1] Weisheng Zhang, Xiaoyu Zhuang, Xu Guo, & Sung-Kie Youn. (2024). **Human-Augmented Topology Optimization Design with Multi-Framework Intervention**. *Engineering with Computers*. [https://doi.org/10.1007/s00366-024-02102-y](https://doi.org/10.1007/s00366-024-02102-y)  
[2] Andreassen, E., Clausen, A., Schevenels, M., Lazarov, B. S., & Sigmund, O. (2010). **Efficient topology optimization in MATLAB using 88 lines of code**. *Structural and Multidisciplinary Optimization*.  
[3] Guo Xu, Weisheng Zhang, & Jie Yuan. **Moving Morphable Components (MMC) framework**. Dalian University of Technology.  
[4] Krister Svanberg. **MMA (Method of Moving Asymptotes) solver**. KTH Royal Institute of Technology.  
[5] Ferrari, F., Sigmund, O., & Guest, J. K. (2021). **Topology optimization with linearized buckling criteria in 250 lines of MATLAB**. *Springer-Verlag GmbH*.  

## Disclaimer  
The authors reserve all rights to this code but do not guarantee that it is free of errors. The authors are not responsible for any consequences arising from the use of this code.  
