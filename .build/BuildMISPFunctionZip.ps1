$ConnectorPath = "."
$RequirementsPath = "$ConnectorPath\requirements.txt"
$ArchiveName = "PythonFunctionDeploy.zip"
$ArchivePath = "..\.build\$ArchiveName"

If (Test-Path -Path $RequirementsPath){
    # Run build if requirements file is located
    Write-Host "Installing Python Packages from '$RequirementsPath'"
    #pip install --target="$ConnectorPath/.python_packages/lib/site-packages" -r $RequirementsPath

}

$AllTopFiles = Get-ChildItem -Path $ConnectorPath
$Ignore = Get-Content -Path "$ConnectorPath\.funcignore"
$FilesToCompress = @()

foreach ($TopFile in $AllTopFiles){
    $Add = $true
    foreach ($Path in $Ignore){
        Write-Debug "TopFile: $($TopFile.Name)"
        Write-Debug  "Path: $($Path)"
        if ($TopFile.Name -like $Path){
            $Add = $false
        }
    }
    if ($Add -eq $true){
        Write-Debug  "Adding : $($TopFile.Name)"
        $FilesToCompress += $TopFile.FullName.ToString()
    }else{
        Write-Debug  "Ignoring : $($TopFile.Name)"
    }
}

if ($FilesToCompress.count -gt 0 ){
    Write-Host "Compressing Function to '$ArchivePath'"
    $Params =@{
        Path = $FilesToCompress
        DestinationPath = "$ArchivePath"

    }   
    Compress-Archive @Params -Force
}