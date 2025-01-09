# Human-Augmented-TOP
Human-Augmented Topology Optimization Design with Multi-Framework Intervention

## Overview
This code introduces a topology optimization method that integrates human input into the optimization process. The approach leverages designers' expertise to allow real-time adjustments and direct control over the optimization, enabling faster results that meet design requirements without the need for constant re-tuning.

A key feature is a conversion strategy between the SIMP (Solid Isotropic Material with Penalization) method, which uses implicit geometry, and the MMC/MMV (Moving Morphable Components/Voids) method, which uses explicit geometry. This conversion enables structural members for the SIMP-based design, making it easier to intuitively control topology and geometry parameters. Designers can interactively add, adjust, or remove these members, improving buckling resistance, reducing stress concentration, and managing complexity.

## How to Start Using the Code

- **Pre-requisites:** Make sure the Image Processing Toolbox is installed in MATLAB before starting.
- **Run the Code:** Simply run `main.m` in MATLAB to get started.
- **Real-time Status:** While the code is running, you can monitor the current status, stress load factors, and other information in the command window. Once optimization completes, the program will pause, and you'll enter the interaction phase.

![Information Display During Optimization](https://github.com/user-attachments/assets/41ae7b50-fa38-4236-9178-0aca6e7632b8)
*Information Display During Optimization*
![SIMP Framework Optimization Results](https://github.com/user-attachments/assets/6b15b864-eafb-4828-b3fa-82d2109ca4b9)
*SIMP Framework Optimization Results*
![Component Explanation in MMC Framework](https://github.com/user-attachments/assets/a8e386bb-28ff-42f8-99c4-a379eb5e8ffe)
*Component Explanation in MMC Framework*
![Stress Distribution Cloud Plot of the Results](https://github.com/user-attachments/assets/f7c3c23f-f1eb-4c58-b233-b9a1cb228a64)
*Stress Distribution Cloud Plot of the Results*

### Interaction Instructions:

- **Deleting a Component:**
  - Right-click in the gray space outside the plot window to bring up the menu.
  - Choose the "Delete" option, select the component to delete, and confirm the deletion.

![Right-click Menu Display](https://github.com/user-attachments/assets/a4452519-3924-4cfe-b6ba-283357ada383)
*Right-click Menu Display*
![Confirm Deletion Popup](https://github.com/user-attachments/assets/d27df15a-6bc9-436f-8656-13d17cc61bcd)
*Confirm Deletion Popup*
![Result After Deletion](https://github.com/user-attachments/assets/54363bf3-432e-48ac-897e-f72cd680f8be)
*Result After Deletion*

- **Adding a Component:**
  - Choose "Add Component" from the menu.
  - Drag the desired component into the window, adjust as needed, then double-click to confirm.

![Add Component Action Example](https://github.com/user-attachments/assets/392136b9-5808-461c-a2cc-eb62112bb35d)
*Add Component Action Example*
![Result After Adding Component](https://github.com/user-attachments/assets/cd8a6151-ce8b-4e39-8243-c31e096c3374)
*Result After Adding Component*

- **Modifying Component Size:**
  - Select "Modify Size" from the menu.
  - Click on the component to resize, enter the new size in the popup window, and confirm the changes.
 
![Size Input Window](https://github.com/user-attachments/assets/3ef5c7de-4e48-4fa0-9328-24d41a3885f6)
*Size Input Window*

- **Resume Optimization:** After completing interactions, select "Continue" from the menu to resume the optimization process in the SIMP framework.

![Final Result](https://github.com/user-attachments/assets/4ccbcf96-449f-49e1-a61f-360121c62279)
*Final Result*

- **Repeat Interaction:** Once the optimization completes and the program pauses again, you can make further adjustments in an interactive loop.

## Future development
The interaction zone will no longer be treated as a non-designable region. Instead, the impact of user input during interaction will be considered, allowing more flexible adjustments. This change will expand the design space and lead to better-performing solutions.

## Contact
Open an issue for this repository or send emails to weishengzhang@dlut.edu.cn. Pull requests are welcome.

## Reference
[1] Zhang, Weisheng, Zhuang, Xiaoyu, Guo, Xu, & Youn, Sung-Kie. (2024). Human-Augmented Topology Optimization Design with Multi-Framework Intervention. Engineering with Computers. https://doi.org/10.1007/s00366-024-02102-y
