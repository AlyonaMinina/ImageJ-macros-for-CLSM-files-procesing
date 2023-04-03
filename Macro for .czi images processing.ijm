//This macro is designed for semi-automated processing of .czi (Carl Zeiss Image) files. It allows cropping of images, applying of Gaussian blur filter, export of individual channels and of the overlyed chaneels with a scale bar.

//Clear the log window if it was open
	if (isOpen("Log")){
		selectWindow("Log");
		run("Close");
	}

//Find the orignal directory and create a new one for processed pngs
original_dir = getDirectory("Select a directory");
output_dir = original_dir +"pngs" + File.separator;
File.makeDirectory(output_dir);

print("Welcome to the .czi files processing macro!");

//Dialog wundow to request info from the user about the desired processing parameters
	  Channel_1 = "GFP";
	  Color_for_Ch_1 = newArray("Green", "Magenta", "Grays");
	  Gaussian_blur_Ch_1 = 0.5; 
	  Channel_2 = "RFP";
	  Color_for_Ch_2 = newArray("Magenta","Green", "Grays");
	  Gaussian_blur_Ch_2 = 0.75; 
	  scale_bar_length = 10;
	  Dialog.create("Please type in the desired processing parameters");
	  Dialog.addString("Channel 1 is:", Channel_1);
	  Dialog.addToSameRow();
	  Dialog.addString("Channel 2 is:", Channel_2);
	  Dialog.addChoice("Pick a color for the Channel 1", Color_for_Ch_1);
	  Dialog.addToSameRow();
	  Dialog.addChoice("Pick a color for the Channel 2", Color_for_Ch_2);
	  Dialog.addNumber("Gaussian blur Sigma radius for Channel 1:", Gaussian_blur_Ch_1);
	  Dialog.addToSameRow();
	  Dialog.addNumber("Gaussian blur Sigma radius for Channel 2:", Gaussian_blur_Ch_2);
	  Dialog.addNumber("Draw scale bar in um ", scale_bar_length);
	  Dialog.show();
	  Channel_1 = Dialog.getString();
	  Color_for_Ch_1 = Dialog.getChoice();
	  Channel_2 = Dialog.getString();
	  Color_for_Ch_2 = Dialog.getChoice();
	  Gaussian_blur_Ch_1 = Dialog.getNumber();
	  Gaussian_blur_Ch_2 = Dialog.getNumber();
	  scale_bar_length = Dialog.getNumber();
  

// Get a list of all the files in the directory
	file_list = getFileList(original_dir);
	//create a shorter list contiaiing . czi files only
	czi_list = newArray(0);
	for(z = 0; z < file_list.length; z++) {
		if(endsWith(file_list[z], ".czi")) {
			czi_list = Array.concat(czi_list, file_list[z]);
			}
		}
		
print("");		
print(czi_list.length + " images were detected for analysis");

// Loop through the list of files, excluding subfolders
	for (i = 0; i < czi_list.length; i++){
	path = original_dir + czi_list[i];
		if (File.isFile(path)){
		print(" ");
		print("Processing image " + i+1 + " out of " + czi_list.length);
		run("Bio-Formats Windowless Importer",  "open=path");
	      
	      //get file title    
			title = getTitle();
			t = lengthOf(title);
			title_without_file_extension = substring(title, 0, t-4);
								
			//create and adjust the selection
			run("ROI Manager...");
			makeRectangle(138, 128, 800, 800);
			waitForUser("Draw ROI, then hit OK. Hold down SHIFT key to keep ROI square"); 
			roiManager("Add");
			
			//crop the selected ROI
			roiManager("select", 0);
			run("Crop");
						
			
			//Split channels
			run("Split Channels");
			
			//process and save the first channel
			Ch_1 = "C1-"+ title;
				selectWindow(Ch_1);		
				run("Gaussian Blur...", "sigma=" + Gaussian_blur_Ch_1);
				run("8-bit");
	            run(Color_for_Ch_1);
				//Find the length of the channel name and crop off C1 and .czi
				index = lengthOf(Ch_1);
				new_Ch1_title = substring(Ch_1, 3, index-4) +   " channel 1 " + Channel_1;
				saveAs("PNG", output_dir + new_Ch1_title + ".png");
				Ch1_name = new_Ch1_title + ".png";	
				
				
			
			//process and save the second channel
			Ch_2 = "C2-"+ title;
				selectWindow(Ch_2);		
				run("Gaussian Blur...", "sigma=" + Gaussian_blur_Ch_2);
				run("8-bit");
	            run(Color_for_Ch_2);
				//Find the length of the channel name and crop off C2 and .czi
				index = lengthOf(Ch_2);
				new_Ch2_title = substring(Ch_2, 3, index-4) + " channel 2 " + Channel_2;
				saveAs("PNG", output_dir + new_Ch2_title + ".png");
				Ch2_name = new_Ch2_title + ".png";
				
				
			//create and save the overlay of the two fluorescent channels with a scale bar
				run("Merge Channels...", "c2=["+ Ch1_name+"] c6=["+ Ch2_name+"] create");
				//Draw a scale bar
				run("Scale Bar...", "width=" + scale_bar_length + " height=5 thickness=2 font=14 color=White background=None location=[Lower Right] horizontal bold hide overlay");
				saveAs("PNG", output_dir + title_without_file_extension + " overlay.png");
			
			//process and save the DIC channel
			DIC = "C3-"+ title;
				selectWindow(DIC);	
				//Find the length of the channel name and crop off C2 and .czi
				index = lengthOf(DIC);
			    new_DIC_title = substring(DIC, 3, index-4);
				saveAs("PNG", output_dir + new_DIC_title + " channel 3 DIC.png");
				
			run("Close All");
			roiManager("reset");
			
	}
  }

selectWindow("ROI Manager");
run("Close");
print(" ");
print("Done!");
print("You can find your processed images in the folder " + output_dir);
print(" ");
print(" ");
print("Alyona Minina. 2023");
  
  
 