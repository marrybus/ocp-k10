
I just want to build an Azure Red Hat OpenShift Cluster to play with the various Data Management capabilities e.g. Container's Backup/Restore, Disaster Recovery and Application Mobility. 

It is challenging to create an ARO cluster from Azure Cloud if you are not familiar to it. After the ARO Cluster is up running, we still need to install Kasten, create a sample DB, create policies etc.. The whole process is not that simple.


This script based automation allows you to build a Ready-to-Use Kasten K10 demo environment running on ARO Cluster on Azure in about 35 minutes. In order to demonstrate Container Backup capabilities, an Azure Blob Storage account will be created. And this will be built in a new vnet with new subnets etc.. This is bash shell based scripts which has been tested on Azure Cloud Shell in the West Europe region. 

# Here're the preparation tasks. 
1. Log in to https://portal.azure.com, then open Azure Cloud Shell
2. Clone the github repo to your local host, run below command
````
git clone https://github.com/marrybus/ocp-k10.git
````
3. Complete the preparation tasks first
````
cd ocp-k10/aro-k10;./aroprep.sh
````
4. Optionally, you can customize the clustername, location, region, bucketname etc.
````
vim setenv.sh
````

# Deploy based on your needs

| Don't have an ARO cluster | Already have an ARO cluster      | Have nothing                     |
|---------------------------|----------------------------------|----------------------------------|
| Deploy ARO only           | Deploy K10 only                  | Deploy ARO and K10               |
| ``` ./aro-deploy.sh ```   | ``` ./k10-deploy.sh ```          | ``` ./deploy.sh ```              |
| 1. Create an ARO Cluster  |                                  | 1. Create an ARO Cluster         |
|                           | 1. Install Kasten K10            | 2. Install Kasten K10            |
|                           | 2. Deploy a PostgreSQL database  | 3. Deploy a PostgreSQL database  |
|                           | 3. Create an Azure Blob location | 4. Create an Azure Blob location |
|                           | 4. Create a backup policy        | 5. Create a backup policy        |
|                           | 5. Kick off on-demand backup job | 6. Kick off on-demand backup job |

# Destroy based on your needs

| Destroy ARO only          | Destroy K10 only                     | Destroy ARO and K10                 |
|---------------------------|--------------------------------------|-------------------------------------|
| ``` ./aro-destroy.sh ```  | ``` ./k10-destroy.sh ```             | ``` ./destroy.sh ```                |
| 1. Remove the ARO Cluster |                                      | 1. Remove the Resource Group        |
|                           | 1. Remove PostgreSQL database        |    + Remove ARO Kubernetes Cluster  |
|                           | 2. Remove Kasten K10                 |    + Remove the disks and snapshots |
|                           | 3. Remove Azure Blob storage bucket  |    + Remove the storage account etc.|



# For more details about OCP Backup and Restore
https://blog.kasten.io/kubernetes-backup-with-openshift-container-storage

https://blog.kasten.io/kasten-and-red-hat-migration-and-backup-for-openshift

# Kasten - No. 1 Kubernetes Backup
https://kasten.io 

# Contributors

#### Created by [@YongkangHe](https://linktr.ee/yongkang) on Linktree, Join [Kubernetes Data Management](https://www.linkedin.com/groups/13983251) LinkedIn Group
#### Modified by Mariusz Rybusiński (https://www.linkedin.com/in/rybusinski/) 