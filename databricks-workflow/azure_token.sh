PROJECT=project001
FOLDER=spark-001
URL=uksouth.azuredatabricks.net

# Change these values.
# Use a Client ID with Contributor permissions
#   on the Databricks workspace.
RESOURCE_GROUP=databricksaim-uksouth-rg
DATABRICKS_WORKSPACE=databricksdemobz45v0-workspace
SUBSCRIBTION_ID=3defgght-9073-xxxxxx-a5b9-9228f2dfxxxx
CLIENT_ID=e252cac1-6f40-xxxxxx-x2222-d053badxxxxxx
CLIENT_SECRET=s452XXXXX~MRc1~OzmB.xxxxxxxxxx-i

tenantId=67yhju3bxxxx-x3333-457f-xxxxx-ff4719xxxxxxx
wsId="/subscriptions/${SUBSCRIBTION_ID}/resourceGroups/${RESOURCE_GROUP}/providers/Microsoft.Databricks/workspaces/${DATABRICKS_WORKSPACE}"

# tenantId=$(az account show --query tenantId -o tsv)
# wsId=$(az resource show \
#  --resource-type Microsoft.Databricks/workspaces \
#  -g "$RESOURCE_GROUP" \
#  -n "$DATABRICKS_WORKSPACE" \
#  --query id -o tsv)

getToken () {
  token_response=$(curl -X GET \
    https://login.microsoftonline.com/$tenantId/oauth2/token \
    -H 'Content-Type: application/x-www-form-urlencoded' \
    -d "grant_type=client_credentials&client_id=$CLIENT_ID&resource=$1&client_secret=$CLIENT_SECRET"
  )
  jq .access_token -r <<< "$token_response"
}



import_file () {
  curl  --request POST \
  https://${URL}/api/2.0/workspace/import \
  --header "Authorization: Bearer $token" \
  --header "X-Databricks-Azure-SP-Management-Token:$azToken" \
  --header "X-Databricks-Azure-Workspace-Resource-Id:$wsId" \
  --header 'Accept: application/json' \
  --data '{ "path": "/Shared/'"${PROJECT}/${1}"'", "content": "'"$(base64 --wrap=0 ${1})"'", "language": "PYTHON", "overwrite": true, "format": "SOURCE" }'
}

delete_folder () {
  curl  --request POST \
    https://${URL}/api/2.0/workspace/delete \
  --header "Authorization: Bearer $token" \
  --header "X-Databricks-Azure-SP-Management-Token:$azToken" \
  --header "X-Databricks-Azure-Workspace-Resource-Id:$wsId" \
  --header 'Content-Type: multipart/form-data' \
    --form path=/Shared/${PROJECT} \
    --form recursive=true
}

create_folder () {
  curl  --request POST \
    https://${URL}/api/2.0/workspace/mkdirs \
  --header "Authorization: Bearer $token" \
  --header "X-Databricks-Azure-SP-Management-Token:$azToken" \
  --header "X-Databricks-Azure-Workspace-Resource-Id:$wsId" \
  --header 'Content-Type: multipart/form-data' \
    --form path=/Shared/${PROJECT}/${1}
}    

process_local_folder () {
  for f in ${1}/*;
  do
    if [[ -d $f ]]; then
      echo "$f is a directory"
      create_folder ${f}
      process_local_folder ${f}
    else
      echo Process ${f}
      case $f in 
       *.py) import_file ${f} ;; 
      esac
    fi
  done;
}

create_job () {
  curl --request POST \
  https://${URL}/api/2.0/jobs/create \
  --header "Authorization: Bearer $token" \
  --header "X-Databricks-Azure-SP-Management-Token:$azToken" \
  --header "X-Databricks-Azure-Workspace-Resource-Id:$wsId" \
  --header 'Accept: application/json' \
  --data @${1} \
  | jq .
}

delete_job () {
  curl  --request POST \
  https://${URL}/api/2.0/jobs/delete \
  --header "Authorization: Bearer $token" \
  --header "X-Databricks-Azure-SP-Management-Token:$azToken" \
  --header "X-Databricks-Azure-Workspace-Resource-Id:$wsId" \
  --header 'Content-Type: multipart/form-data' \
  --form job_id=${1} 
}

# Get a token for the global Databricks application. This value is fixed and never changes.
token=$(getToken 2ff814a6-3304-4ab8-85cb-cd0e6f879c1d)

# Get a token for the Azure management API
azToken=$(getToken https://management.core.windows.net/)

# Import files to workspace
delete_folder
process_local_folder ${FOLDER}
create_job create-job.json
delete_job 106034657476767

