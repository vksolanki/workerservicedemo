$pathToZipFile = "Name of your-artifact-zipped-file;
$serviceName = "your service name";
$executable="Name of the .exe file ";
$serviceDir="where you want to store the unzipped artifact files";
$serviceDescription = "Your service description";
$binaryPath = "$serviceDir\$executable";


# need to check and stop existing service. Otherwise, we get 
# access error when replacing the old codes with the new ones 
# if the service is running. 
If (Get-Service $serviceName -ErrorAction SilentlyContinue) {
    If ((Get-Service $serviceName).Status -eq 'Running') {
         # service exists and is running, so stop it first
        Write-Output "Stopping service: $serviceName"
        Stop-Service $serviceName
    } 
} else {
    # service does not exist. So let's create it. We are not
    # going to start the service until we have put the new codes. 
    New-Service -Name $serviceName -Description $serviceDescription -BinaryPathName $binaryPath;
}

# Unzip the artifact. Without the -Force parameter, the command will fail if 
# the destination path already exists. The -Force parameter is for overriding 
# the destination path if it already exists. 
#Write-Output "Unzipping artifact at $pathToZipFile to $serviceDir";
#Expand-Archive -Force -Path $pathToZipFile -DestinationPath $serviceDir

# start the service to pick up new codes. 
Write-Output "Starting service $serviceName"
Start-Service $serviceName
