# deploy infrastructure via bicep
param (
    [string]
    $resourceGroupName = "rg-pygoat-dev-003",
    [string]
    $location = "canadacentral",
    [string]
    $baseName = "pygoat-dev-003",
    [string]
    $imageName = "pygoat",
    [string]
    $deploymentName = "infra-deployment",
    [string]
    $subscriptionName = "IT Test"
)

# login to azure
Write-Output "Logging in to Azure"
az login

# set subscription
Write-Output "Setting subscription to $subscriptionName"
az account set --subscription $subscriptionName

Write-Output "Deploying infrastructure for $baseName in $location"
az group create --name $resourceGroupName `
    --location $location

Write-Output "Deploying infrastructure for $baseName in $location"
az deployment group create --name $deploymentName `
    --resource-group $resourceGroupName `
    --template-file main.bicep `
    --parameters baseName=$baseName `
    --parameters imageName=$imageName

Write-Output "Infrastructure deployed for $baseName in $location"

# get container registry name from deployment output
$acrName = az deployment group show --name $deploymentName `
    --resource-group $resourceGroupName `
    --query properties.outputs.containerRegistryName.value `
    --output tsv

Write-Output "ACR Name: $acrName"

# get app service name from deployment output
$appServiceName = az deployment group show --name $deploymentName `
    --resource-group $resourceGroupName `
    --query properties.outputs.appName.value `
    --output tsv

Write-Output "App Service Name: $appServiceName"