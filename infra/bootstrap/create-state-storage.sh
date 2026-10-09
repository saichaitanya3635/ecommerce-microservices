#!/usr/bin/env bash
# One-time: Terraform remote state kosam Storage Account create chestundi.
set -euo pipefail

LOCATION="centralindia"
RG="rg-ecom-tfstate"
# Storage account name globally unique undali: subscription ID nunchi chinna suffix
SUFFIX=$(az account show --query id -o tsv | md5sum | cut -c1-6)
SA="stecomtfstate${SUFFIX}"
CONTAINER="tfstate"
TAGS="project=ecommerce env=shared managed-by=bootstrap"

echo ">> Resource group: $RG"
az group create -n "$RG" -l "$LOCATION" --tags $TAGS -o none

echo ">> Storage account: $SA"
az storage account create -n "$SA" -g "$RG" -l "$LOCATION" \
  --sku Standard_LRS --kind StorageV2 \
  --min-tls-version TLS1_2 \
  --allow-blob-public-access false \
  --allow-shared-key-access false \
  --tags $TAGS -o none

echo ">> Versioning + soft delete (state file recover cheyyadaniki)"
az storage account blob-service-properties update -n "$SA" -g "$RG" \
  --enable-versioning true \
  --enable-delete-retention true --delete-retention-days 30 \
  --enable-container-delete-retention true --container-delete-retention-days 30 -o none

echo ">> Naku (signed-in user) blob data access"
ME=$(az ad signed-in-user show --query id -o tsv)
SA_ID=$(az storage account show -n "$SA" -g "$RG" --query id -o tsv)
az role assignment create --assignee-object-id "$ME" --assignee-principal-type User \
  --role "Storage Blob Data Contributor" --scope "$SA_ID" -o none

echo ">> Role propagate avvadaniki 60s wait..."
sleep 60

echo ">> Container: $CONTAINER"
az storage container create -n "$CONTAINER" --account-name "$SA" --auth-mode login -o none

echo ">> Delete lock (pora patuna delete avvakunda)"
az lock create --name lock-tfstate --resource-group "$RG" --lock-type CanNotDelete -o none

echo ""
echo "✅ Done. Ee values Step 2.2 lo kavali:"
echo "   resource_group_name  = $RG"
echo "   storage_account_name = $SA"
echo "   container_name       = $CONTAINER"