starttime=$(date +%s)
. ./setenv.sh

echo '-------Deleting Postgresql and Kasten K10'

helm uninstall postgres -n $ARO_MY_PREFIX-postgresql
helm uninstall k10 -n kasten-io
kubectl delete ns $ARO_MY_PREFIX-postgresql
kubectl delete ns kasten-io

echo '-------Deleting objects from Azure Blob Storage Bucket'
az storage blob delete-batch --account-name $ARO_MY_PREFIX$ARO_AZURE_STORAGE_ACCOUNT_ID -s $ARO_MY_PREFIX-$ARO_MY_CONTAINER --account-key $(cat aro_az_storage_key)

echo "" | awk '{print $1}'
endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang, Modified by Mariusz Rybusinski"
echo "-------Email me if any suggestions or issues mariuszr@outlook.com"
echo "" | awk '{print $1}'
