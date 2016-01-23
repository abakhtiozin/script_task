# This script should be added to windows tasks scheduler
# periodic of execution should be set up to 'Every day', '00:00:00'

# In case of security powershell execution could be turn off on your computer
# to run this script you have to write in cmd or arguments of scheduler 
# this line 'powershell -ExecutionPolicy RemoteSigned -noprofile -noninteractive  -file %FILENAME.ps1%'

# I didn't understand what does 'BusinessDays' mean, I hope it's just a Working Days of week
$businessDays = "Monday", "Tuesday", "Wednesday", "Thursday", "Friday"
$weekendDays = "Saturday", "Sunday"

$targetDirectory = $PSScriptRoot + "\Target"
$isTargetDirectoryEmpty = !(Test-Path -Path($targetDirectory + "\*"));

$businessDayImage = $PSScriptRoot + "\BusinessDays\businessDay.jpg"
$weekendDayImage = $PSScriptRoot + "\Weekend\weekend.jpg"

function copyImageToTargetDirectory($imageFile)
{
Copy-Item $imageFile $targetDirectory
}

function deleteImageInTargetDirectory
{
Remove-Item($targetDirectory + "\*.jpg")
}

# function checks is target directory empty and in case of:
# YES - copy image to target directory
# NO - checks is current image file in target directory similar to new image file
# and in case of:
#	YES just leave it there without coping new image
#	NO - if two files are not the same, deletes current image file in target directory
#		and upload new image file to target directory
function upLoadFile($imageFile)
{
if ($isTargetDirectoryEmpty) { #check if Target directory is empty
		copyImageToTargetDirectory($imageFile)        #just copy image file there
    } else {        #if not empty
		$imageFileContent = Get-Content $imageFile #get content of the image 
        $targetDirectoryLogoContent = Get-Content($targetDirectory + "\*.jpg") #get content of the image in Target Directory
        if (Compare-Object -ReferenceObject $imageFileContent -DifferenceObject $targetDirectoryLogoContent){  #if files are different Compare-Object return True			
            deleteImageInTargetDirectory #delete image that exist in Target Directory
            copyImageToTargetDirectory($imageFile) #copy new image file to target directory
        }
    }
}

# function checks current day of the week and depends on that
# call to function that upload different type of image to Target directory
function upLoadImageDependsOnDayOfWeek {
	if ($businessDays -contains(get-date).DayOfWeek) { 
		"today is business day so let's upload business day image"	
		upLoadFile($businessDayImage)  #put businessDayImage to target directory
		write "Business image uploaded to " $targetDirectory
	} else {
		"today is weekend day so let's upload weekend day image"
		upLoadFile($weekendDayImage)   #put weekendDayImage to target directory 
		write "Weekend image uploaded to " $targetDirectory
	}
}

# main
# start point of the script
upLoadImageDependsOnDayOfWeek