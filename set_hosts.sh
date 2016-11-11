#!/bin/bash

# Variables
declare -a CONTAINERS
HOSTS_FILE=/etc/hosts

## Functions

# Get Container IP Address
getContainerIP()
{
# $1 - Container Name 
    if [ $1 ]; then
        echo $(docker inspect $1 | grep IPAddress | grep -E "([0-9]{1,3}\.){3}[0-9]{1,3}" | awk '{ print $2 }' | cut -f2 -d\" | head -n1)
#        return 0
    else
	    return 1
    fi
}

# Get Container Name
getContainerName()
{
# $1 - Container Name 
    if [ $1 ]; then
        echo $(docker inspect $1 | grep Name | grep -E '"/' | awk '{ print $2 }' | cut -f2 -d\" | cut -f2 -d/)
        return 0
    else
        return 1
    fi
}

# Check if container was publish in hosts
checkIfExistsInHosts()
{
# $1 - Container Name 
    if [[ $(sed -En -e "/\<$1(\s|$)/p" $HOSTS_FILE) ]] && [ $1 ]; then
        return 0
    else
        return 1
    fi
}

# Update IP Address in hosts file
updateIpAddress()
{
# $1 - Container Name 
# $2 - Container IP Address
    if [ $1 ] && [ $2 ]; then
#$(sed -i -E -e "s/(^ *[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})(\s*)(\<$1(\s|$))/192.168.200.0\2\3/" $HOSTS_FILE) 
       $(sed -i -E -e "s/(^ *[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3})(\s*)(\<$1(\s|$))/$2\2\3/" $HOSTS_FILE) 
        return 0
    else 
        return 1
    fi
}

addNewHost()
{
# $1 - Container Name 
# $2 - Container IP Address
    if [ $1 ] && [ $2 ]; then
        $(echo -e "$2\t$1" >> $HOSTS_FILE)
        return 0
    else 
        return 1
    fi
}

setHost()
{
# Main function to publish or update container IP
#
# $1 - Container Name 
CONTAINER_NAME=$(getContainerName $1)
CONTAINER_IP=$(getContainerIP $1)

    if [ -z $1 ] ; then
        echo "No containers found!"
        exit 0
    fi

    # Check if it has been published (in /etc/hosts)
    if checkIfExistsInHosts $CONTAINER_NAME ; then
        echo "Updating IP: " $CONTAINER_NAME-$CONTAINER_IP
        # Update the IP Address
        updateIpAddress $CONTAINER_NAME $CONTAINER_IP
    else
        echo "Publishing new server: " $CONTAINER_NAME-$CONTAINER_IP
        # Publish the container IP Address
        addNewHost $CONTAINER_NAME $CONTAINER_IP
    fi
}


## End Functions
echo 
echo 'Beginning process...'
echo 

# Check if you have any specific host
if [ -z $1 ]; then
    # Get all containers
    CONTAINERS=$(docker ps -q)

    # Loop through all Containers
    for CONTAINER in $CONTAINERS; do
        setHost $CONTAINER        
    done
else
    setHost $1
fi

exit 0
