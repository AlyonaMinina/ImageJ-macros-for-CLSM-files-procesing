//This macro is designed for semi-automated processing of .czi (Carl Zeiss Image) files. It allows cropping of images, applying of Gaussian blur filter, export of individual channels and of the overlayed channels with a scale bar.

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
  Channel_number = newArray("1", "2", "3");
  Channel_1 = "GFP";
  Color_for_Ch_1 = newArray("Green", "Magenta", "Grays");
  Gaussian_blur_Ch_1 = 0.5; 
  scale_bar_length = 10;
  Dialog.create("Please type in the desired processing parameters");
  Dialog.addChoice("Which channel to export:", Channel_number);
  Dialog.addString("Exported channel name:", Channel_1);
  Dialog.addChoice("Pick a color for the Channel 1", Color_for_Ch_1);
  Dialog.addNumber("Gaussian blur Sigma radius for Channel 1:", Gaussian_blur_Ch_1);
  Dialog.addNumber("Draw scale bar in um ", scale_bar_length);
  Dialog.show();
  Channel_number = Dialog.getChoice();
  Channel_1 = Dialog.getString();
  Color_for_Ch_1 = Dialog.getChoice();
  Gaussian_blur_Ch_1 = Dialog.getNumber();
  scale_bar_length = Dialog.getNumber();
  
//print the user-defined parameters that should be saved
  print("The following user-defined parameters were applied: ");
  print("Channel 1 name: " + Channel_1);
  print("Gaussian blur Sigma radius for the Channel 1: " + Gaussian_blur_Ch_1);
  print(" ");
  print("Scale bar = " + scale_bar_length + " um");
  
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
	
		//get and crop the file title    
		title = getTitle();
		t = lengthOf(title);
		title_without_file_extension = substring(title, 0, t-4);
							
		//create a ROI for cropping, place it by default in the center 
		setSlice(Channel_number);
		run("ROI Manager...");
		h=getHeight();
		w=getWidth();
		makeRectangle( w/4, h/4, w/2, h/2);
		waitForUser("Draw ROI, then hit OK. Hold down SHIFT key to keep ROI square"); 
		roiManager("Add");
		
		//Adjust the ROI  and crop the image using selected channel as visual guide
		roiManager("select", 0);
		run("Crop");
			
		//Duplicate the channel of interest		
		run("Duplicate...", "duplicate channels=Channel_number");
		
		//process and save the channel of interest
		Ch_1 = title_without_file_extension + "-1.czi";
		selectWindow(Ch_1);		
		run("Gaussian Blur...", "sigma=" + Gaussian_blur_Ch_1);
		run("8-bit");
	    run(Color_for_Ch_1);
	    
	    //Draw a scale bar
		run("Scale Bar...", "width=" + scale_bar_length + " height=5 thickness=2 font=14 color=White background=None location=[Lower Right] horizontal bold hide overlay");
		
		//Find the length of the channel name and crop off C1 and .czi
		index = lengthOf(Ch_1);
		new_Ch1_title = title_without_file_extension + Channel_1;
		saveAs("PNG", output_dir + new_Ch1_title + ".png");
		Ch1_name = new_Ch1_title + ".png";	
			
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
print("Alyona Minina. 2024");
selectWindow("Log");
saveAs("Text",  output_dir + "Analysis summary.txt");