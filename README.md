# ImageJ macros for confocal images processing

The scripts are designed to prepare for publication images obtained using Carl Zeiss confocal microscopes. They can process all .czi files in a selected folder, export one or multoiple individual channels, apply Gaussian blur filter and add a scale bar.


## **The ImageJ Macro for exporting three channels.** 
Export of two fluorescent channels and one transmitted light (DIC) channel.

**Step by step:**

1. Put all images that you wish to process into a single folder.
2. Download the macro file and drag&drop it into ImageJ -> the script will opwn in the Editor window
3. Click on "Run"
4. Follow the macro to open the folder from the Step 1
5. If needed rename the channels, select with what colors you want to present them and choose the length of scale bar most suitable for your application.
6. If needed adjust the size and position of ROI for cropping out the unnecessary information.
7. Hit ok-> macro will process each channel with the same crop settings
8. Repeat steps 6 and 7 for each image in your folder. Macro will generate a "pngs" subfolder in the directory selected in the Step 1, it will contain png images of each channel from the original file  and their overlay with scale bar. The images will be also processed with the Gaussian blur filter settings selected in  step 5.


<p align="center"> <a href="https://youtu.be/eX0ZGklK-tk"><img src="https://github.com/AlyonaMinina/ImageJ-macros-for-CLSM-files-procesing/blob/main/Images/youtube%20preview.PNG?raw=true" width = 480> </img></a></p>



<details><summary> <b>The ImageJ Macro for exporting a single fluorescent channel from a single or multi-channel .czi files </b></summary><br/> 

**Step by step:**
  </br>
1. Put all images that you wish to process into a single folder
2. Download the macro file (Exporting a single channel out of a multichannel scan.ijm) and drag&drop it into ImageJ -> the script will opwn in the Editor window
3. Click on "Run"
4. Follow the macro to open the folder from the Step 1
5. Select the number of the channel you want to export. If needed rename the channel, select with what colors you want to present it and choose the length of scale bar most suitable for your application.
6. If needed adjust the size and position of the ROI for cropping out the unnecessary information.
7. Hit ok-> macro will process your image
8. Repeat steps 6 and 7 for each image in your folder. Macro will generate a "pngs" subfolder in the directory selected in the Step 4, it will contain png images of the cropped selected channel with a scale bar. The images will be also processed with the Gaussian blur filter settings selected in  step 5.
</details>

