<#
.SYNOPSIS
            Removing the JndiLookup.class from old log4j-core file using powershell
 
.DESCRIPTION
            A very basic script to remove JndiLookup.class from old log4j-core files to mitigate the log4j hack
 
.NOTES
            Author: Phillip Puggioni
            Website: https://philpug.com
            License: GNU GPL v3 https://opensource.org/licenses/GPL-3.0           
#>
 
# Variables
# Replace with the correct path for your application
$Path = "C:\temp\log4j-core-2.1.jar"
$split_path= $Path.Split('\')
$filename = $split_path[$split_path.Count-1]
$JndiLookup_class = "org\apache\logging\log4j\core\lookup\JndiLookup.class"
$destination_folder = $path.Replace("\"+$filename,'')
$Export = $destination_folder + "\" + $filename.Replace('jar','export')
 
<# 
The section will take a backup of the file, rename it to a zip file, expand the zip, remove the class and repackage it back to a jar file. 
#>
 
try{
Copy-Item -Path $Path -Destination ($destination_folder + "\" + "log4j-core-2X-Backup") -Force
Rename-Item -path $Path -newname $filename.Replace('jar','zip') -Force
New-Item -Path $destination_folder -Name $filename.Replace('jar','export') -ItemType Directory -Force
expand-archive -Path $Path.Replace('jar','zip') -DestinationPath $Export -Force
Remove-Item -Path ($Export + "\" + $JndiLookup_class) -Force
Compress-Archive -Path ($Export + "\*") -CompressionLevel Fastest -DestinationPath ($destination_folder + "\" + $filename.Replace('jar','zip')) -Force
Rename-Item -path $Path.Replace('jar','zip') -newname $filename.Replace('zip','jar') -Force
Remove-Item -Path $Export -Recurse -Force
}
catch { 
$Error[0] |  Out-File  c:\temp\errors.txt -Append
}