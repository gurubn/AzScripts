### This script iterates through the blob container folders , finds specific blob inside folders and removes it
param(
[Parameter(Mandatory)]$resourceGroupName,
[Parameter(Mandatory)]$storageAccName,
[Parameter(Mandatory)]$blobName,
[Parameter(Mandatory)]$env = "ppe"

)

# blobName is the name of the file which you would like to delete

#Pre-requisites
# Az powershell module
# In Powershell console, connect to respective subscription using Connect-AzConnect first before running this script
  
## Function to delete a blob  
Function DeleteBlob  
{  
    ## Get the storage account in which container has to be created  
    $storageAcc = Get-AzStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccName    
    ## Get the storage account context  
    $ctx = $storageAcc.Context

    $containers = Get-AzStorageContainer -Context $ctx
    foreach ($container in $containers)
    {
        if($container.Name -eq $env){
            $blobData = Get-AzStorageblob -Container $container.Name -Context $ctx
            Write-Host $blobData.Name
            if($null -ne $blobData) {
                #Loop through the blobs
                foreach ( $blob in $blobData )
                {
                    if ($blob.Name -match $blobName) #it will match for a substring
                    {
                        Write-Host "Blob: " $blobName " found under path: " $blob.Name -ForegroundColor Green
                        $blob.Name | Out-File -FilePath ".\output.txt" -Append
                        Remove-AzStorageBlob -Container $container.Name -Context $ctx -Blob $blob.Name
                        Write-Host -ForegroundColor Green "Deleted the blob.."  $blob.Name   
                    }
                }
          }
          else {
            Write-host "null"
          }
        }
    }
  
}   
  
DeleteBlob   
