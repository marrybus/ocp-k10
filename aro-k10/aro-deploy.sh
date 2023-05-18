echo '-------Creating an ARO Cluster only (typically ~35 mins)'
starttime=$(date +%s)
. ./setenv.sh

az group create \
  --name $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --location $ARO_MY_LOCATION

az network vnet create \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --name $ARO_VNET \
  --address-prefixes 10.8.0.0/23

az network vnet subnet create \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --vnet-name $ARO_VNET \
  --name master-$ARO_SUBNET \
  --address-prefixes 10.8.0.0/24 \
  --service-endpoints Microsoft.ContainerRegistry

az network vnet subnet create \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --vnet-name $ARO_VNET \
  --name worker-$ARO_SUBNET \
  --address-prefixes 10.8.1.0/24 \
  --service-endpoints Microsoft.ContainerRegistry

az network vnet subnet update \
  --name master-$ARO_SUBNET \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --vnet-name $ARO_VNET \
  --disable-private-link-service-network-policies true

az aro create \
  --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP \
  --name $ARO_MY_CLUSTER \
  --vnet $ARO_VNET \
  --master-subnet master-$ARO_SUBNET \
  --worker-subnet worker-$ARO_SUBNET \
  --pull-secret @pull-secret.txt

echo '-------Create a Azure Storage account'
ARO_RG=$(az group list -o table | grep $ARO_MY_GROUP | awk '{print $1}')
az storage account create -n $ARO_MY_PREFIX$ARO_AZURE_STORAGE_ACCOUNT_ID -g $ARO_RG -l $ARO_MY_LOCATION --sku Standard_LRS
ARO_AZURE_STORAGE_KEY=$(az storage account keys list -g $ARO_RG -n $ARO_MY_PREFIX$ARO_AZURE_STORAGE_ACCOUNT_ID --query [].value -o tsv | head -1)
echo $ARO_AZURE_STORAGE_KEY > aro_az_storage_key
#echo $(az storage account keys list -g $ARO_RG -n $ARO_MY_PREFIX$ARO_AZURE_STORAGE_ACCOUNT_ID --query [].value -o tsv | head -1) > aro_az_storage_key
az storage container create --account-name $ARO_MY_PREFIX$ARO_AZURE_STORAGE_ACCOUNT_ID --account-key $ARO_AZURE_STORAGE_KEY --name $ARO_MY_PREFIX-$ARO_MY_CONTAINER

# oc annotate sc managed-premium storageclass.kubernetes.io/is-default-class-
# oc annotate sc managed-csi storageclass.kubernetes.io/is-default-class=true
# oc annotate volumesnapshotclass csi-azuredisk-vsc k10.kasten.io/is-snapshot-class=true

PASSWORD=$(az aro list-credentials --name $ARO_MY_CLUSTER --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP -o tsv --query kubeadminPassword)

apiServer=$(az aro show -g $ARO_MY_PREFIX-$ARO_MY_GROUP -n $ARO_MY_CLUSTER --query apiserverProfile.url -o tsv)

oc login $apiServer -u kubeadmin -p $PASSWORD --insecure-skip-tls-verify
echo "" | awk '{print $1}'
oc get no

#aroui=$(az aro list | grep $ARO_MY_CLUSTER | awk '{print $6}')
#aroui=$(az aro list | awk '/url/{i++}i==2{print $2; exit}'| sed -e 's/\"//g')
aroui=$(az aro show -g $ARO_MY_PREFIX-$ARO_MY_GROUP -n $ARO_MY_CLUSTER --query consoleProfile.url -o tsv)
echo -e "\nCopy the password before clicking the link to access OpenShift Web Console" > aro_ui_token
echo -e "\nThe Username is kubeadmin and the Password is as below" >> aro_ui_token
echo -e "\n$PASSWORD" >> aro_ui_token
echo -e "\nThe OpenShift Web Console is as below" >> aro_ui_token
echo -e "\n$aroui" >> aro_ui_token
cat aro_ui_token
echo "" | awk '{print $1}'

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time to build an ARO Cluster is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang, Modified by Mariusz Rybusinski"
echo "-------Email me if any suggestions or issues mariuszr@outlook.com"
echo "" | awk '{print $1}'
