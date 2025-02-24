echo '-------Deleting an ARO Cluster only (typically about 35 mins)'
starttime=$(date +%s)
. ./setenv.sh

az aro delete --resource-group $ARO_MY_PREFIX-$ARO_MY_GROUP --name $ARO_MY_CLUSTER -y

endtime=$(date +%s)
duration=$(( $endtime - $starttime ))
echo "-------Total time to destroy an ARO Cluster is $(($duration / 60)) minutes $(($duration % 60)) seconds."
echo "" | awk '{print $1}'
echo "-------Created by Yongkang, Modified by Mariusz Rybusinski"
echo "-------Email me if any suggestions or issues mariuszr@outlook.com"
echo "" | awk '{print $1}'
