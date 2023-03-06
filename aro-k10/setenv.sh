#-------Set the environment variables"
export ARO_MY_LOCATION=westeurope                    #Customize the location of your cluster
export ARO_MY_GROUP=aro-rg4mariusz1                  #Customize your resource group name
export ARO_MY_CLUSTER=aro4mariusz1                   #Customize your cluster name
export ARO_AZURE_STORAGE_ACCOUNT_ID=aroazsa4mariusz1 #Customize your Storage Account
export ARO_MY_REGION="West Europe"                   #Customize region for Blob Storage
export ARO_MY_CONTAINER=aro-k10container4mariusz1    #Customize your container
export ARO_MY_OBJECT_STORAGE_PROFILE=aro-myazblob1   #Customize your profile name
export ARO_MY_PREFIX=$(echo $(whoami) | sed -e 's/\_//g' | sed -e 's/\.//g' | awk '{print tolower($0)}')
export PATH=$PATH:~/ocp-k10/aro-k10
