# Change these values.
# Use a Client ID with Contributor permissions
#   on the Databricks workspace.
RESOURCE_GROUP=databricksaim-uksouth-rg
DATABRICKS_WORKSPACE=databricksdemobz45v0-workspace
CLIENT_ID=e252cac1-6f40-488e-xxxxxxxxxxxxxxxxxxxxxx
CLIENT_SECRET=rzI2Q1Xe9E~xxxxxxxxxxxxxxxxx

tenantId=$(az account show --query tenantId -o tsv)
wsId=$(az resource show \
  --resource-type Microsoft.Databricks/workspaces \
  -g "$RESOURCE_GROUP" \
  -n "$DATABRICKS_WORKSPACE" \
  --query id -o tsv)

getToken () {
  token_response=$(curl -X GET \
    https://login.microsoftonline.com/$tenantId/oauth2/token \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d "grant_type=client_credentials&client_id=$CLIENT_ID&resource=$1&client_secret=$CLIENT_SECRET"
  )
  jq .access_token -r <<< "$token_response"
}

# Get a token for the global Databricks application. This value is fixed and never changes.
token=$(getToken 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d)

# Get a token for the Azure management API
azToken=$(getToken https://management.core.windows.net/)

# Use both tokens in Databricks API call
#curl -sf https://uksouth.azuredatabricks.net/api/2.0/clusters/list \
#  -H "Authorization: Bearer $token" \
#  -H "X-Databricks-Azure-SP-Management-Token:$azToken" \
#  -H "X-Databricks-Azure-Workspace-Resource-Id:$wsId"

curl --netrc --request POST \
  https://uksouth.azuredatabricks.net/api/2.0/workspace/import \
  --header "Authorization: Bearer $token" \
  --header "X-Databricks-Azure-SP-Management-Token:$azToken" \
  --header "X-Databricks-Azure-Workspace-Resource-Id:$wsId" \
  --header 'Content-Type: multipart/form-data' \
  --form path=/Shared/MyFolder \
  --form content=@spark-001.zip
