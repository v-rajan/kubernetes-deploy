PROJECT=project001
FOLDER=spark-001
URL=adb-xxxxxxxxxxxxx.13.azuredatabricks.net

RESOURCE_GROUP=databricksaim-uksouth-rg
DATABRICKS_WORKSPACE=databricksxxxxxxx-workspace

tenantId=$(az account show --query tenantId -o tsv)
wsId=$(az resource show \
  --resource-type Microsoft.Databricks/workspaces \
  -g "$RESOURCE_GROUP" \
  -n "$DATABRICKS_WORKSPACE" \
  --query id -o tsv)

getToken () {
  token_response=$(az account get-access-token --resource=2ff814a6-3304-4ab8-85cb-cd0e6f879c1d)
  jq .accessToken -r <<< "$token_response"
}

import_file () {
  curl  --request POST \
  https://${URL}/api/2.0/workspace/import \
  --header "Authorization: Bearer $token" \
  --header 'Accept: application/json' \
  --data '{ "path": "/Shared/'"${PROJECT}/${1}"'", "content": "'"$(base64 --wrap=0 ${1})"'", "language": "PYTHON", "overwrite": true, "format": "SOURCE" }'
}

delete_folder () {
  curl  --request POST \
    https://${URL}/api/2.0/workspace/delete \
  --header "Authorization: Bearer $token" \
  --header 'Content-Type: multipart/form-data' \
    --form path=/Shared/${PROJECT} \
    --form recursive=true
}

create_folder () {
  curl  --request POST \
    https://${URL}/api/2.0/workspace/mkdirs \
  --header "Authorization: Bearer $token" \
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
  --header 'Accept: application/json' \
  --data @${1} \
  | jq .
}

delete_job () {
  curl  --request POST \
  https://${URL}/api/2.0/jobs/delete \
  --header "Authorization: Bearer $token" \
  --header 'Content-Type: multipart/form-data' \
  --form job_id=${1} 
}

# Get a token for the global Databricks application. This value is fixed and never changes.
token=$(getToken)

# Import files to workspace
delete_folder
create_folder ${FOLDER}
process_local_folder ${FOLDER}
#create_job create-job.json
#delete_job 106034657476767

