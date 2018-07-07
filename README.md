# Evaluation_VR
**Evaluation_VR** is a subjective evaluation tool on VR video with GUI in *MATLAB*. **Single Stimulus Continuous Quality Scale (SSCQS)** and **Multiple Stimulus Continuous Quality Scale (MSCQS)**  method are provided for different aims. 
***



## How To Use
Run **"Evaluation_VR.m"** with *MATLAB* to begin.
### 1. Choose the VR Player
Choose a third-party VR Player installed in your computer in the popup open file dialog.
It's significant that **parameter passing through command line** is supported. Here, we suggest Virtual Desktop as HTC Vive video player.
### 2. Methods Settings
#### Session Type
When **"Training Run"** is selected, no scores will be recorded. If it is an formal test and files of scores are necessary, choose **"Actual Run"**.
#### Methodology
Choose the way to arrange the materials in the test session, either **"SSCQS"** or **"MSCQS"**.
#### TargetType
Choose the target of the test, either **"The Overall Video Quality"** or **"The Uniformity over All Directions"**.
### 3. Score Calculations
Check the corresponding checkbox for the calculations to be used. 
Note that if **"Calculate DMOS"** is checked, you should choose a **Method of DMOS Calculation**. And here, when **"Calculating with Z scores"** is chosen, the **"Calculate Z Scores"** should also be checked and a **Method of Z Score Calculation** is required, too. 
We recommend to check **"Calculate MOS"**, check **"Calculate DMOS"**,choose **"Calculating with Z scores"**, check **"Calculate Z Scores"** and choose **"Use difference score"** for ordinary use.
### 4. Add Files
Press the **"Reference Files ..."** Button to add References, and **"Test Files ..."** Button to add materials to be displayed and evaluated. 
Note that if **MSCQS** is adopted or **DMOS** is to be calculated, **Reference Files** is necessary.

The window of the **"Reference Files"** and the **"Test Files"** are the same.
#### Directory
All of the input box **"Current Directory:"**, the button **"Browse..."** and the list box **"Directories in current directory"** can be used to specify the directory of materials.
#### Files
After the directory is specified, files in it will be listed in the list box **"Files in current directory"**. Select files to be added and press the **"Add Selected Files"** button. The **"Add All"** button can also be used, but files in subdirectories will be added too.
Select files in the list box **"Selected files"** and press the **"Remove Selected files"** to remove undesired files wrongly added.
Only files of supported formats can be added, or there will be an error dialog to point out it. However, if there are formats that are actually supported by the player but can't be added here, modify **"\sysconfig\SupVFormats.csv"** to append other formats.
#### Save & Load File List
Here's a convenience feature to avoid repeating file selection each time a same file list is applied. After selecting files for the first time, check the **"Save selected filenames in file for future testing"**, and set output file's path, the file list will be saved as an *.xls* file.
To load the file list is just like to add video files: Just select the saved *.xls* file and  press the **"Add Selected Files"** button, then the file list in the *.xls* file will be loaded into the list box **"Selected files"**.
#### A Special Point of Reference Files
It's ***vital*** but ***often wrongly operated*** when adding reference files that their is an **one-to-one correspondence** between reference files and test files **in order**, and thus the number of reference files must be the same as test files. For each test files in the list, including the reference files themselves, there must be it's reference in the reference file list with a same index number.
For example, "11.avi" is the reference of "12.avi", "13.avi" and "14.avi"; "21.avi" is the reference of "22.avi" and "23.avi". Then the reference file list and the test file list must be like this:
| Index | Reference files| Test files |
| :--: 	| :--:| :--: |
| 1 | 11.avi | 11.avi |
| 2 | 11.avi | 12.avi |
| 3 | 11.avi | 13.avi |
| 4 | 11.avi | 14.avi |
| 5 | 21.avi | 21.avi |
| 6 | 21.avi | 22.avi |
| 7 | 21.avi | 23.avi |
### 5. Output Files
In any case, the raw subjective score should be recorded so that the corresponding output file should be specified by **"Output file for raw subjective score ..."** button.
If any **score calculations** is checked, **Output file for MOS, DMOS, STD ...** is also necessary. And if Z scores is used, **Output file for Z Scores ...** is to be specified too.
Notice that if you want the program to record data from different subjects in one sheet and calculate the DMOS of all the subjects automatically, just select the same files in above settings to append new data to the files each time an evaluation begins.
### 6. Test Session
After completing all the settings, Press the **"Start"** button to start a test session with a popup window.
After reading the test instructions, begin with the **"Continue"** button and watch the video in HMD device. To rate the video just played, fully close the video player and then the rating panel is ready. There is a slide bar represents the grading scale. Drag the red pointer to rate for it, and the corresponding score is above the slide bar. 
Press **"Rate"** to confirm that the current scores is to be recorded, and press **"Next"** to play the next test material. Before Press **"Next"**, you can change the scores of the recently played video  and **"Rate"** as many times as you like. But after the next video is played, you can't change the scores of previous videos.
A count for videos have been rated is at the top of the window. 
After rating the last video, press the **"Next"** button to finish the test session, and then the scores will be written to the files.

### 7.About the V-DMOS
We provide sample codes of calculating viewing frequency and V-DMOS under 6-region partition in folder "VDMOS".

## Copyright
Copyright (c) 2017 Letv Cloud Computing & Beihang University. All Rights Reserved. 
Contact: Mai Xu (MaiXu@buaa.edu.cn) and Maosheng Bai (baimaosheng@le.com) 
This copyright statement may not be removed from any file containing it or from modifications to these files. 
This copyright notice must also be included in any file or product that is derived from the source files. 
