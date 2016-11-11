<p align="center">

  <img src="https://upload.wikimedia.org/wikipedia/commons/7/79/Docker_(container_engine)_logo.png">

</p>

# dockerhome

Dockerhome shares scripts to help you use Docker! 


# Security

Found any security problem? Send us an email to contact@budhi.com.br we will appreciate that!


# Scripts

## 1. Set Host (file: set_host.sh)

This script will publish, if we can say that, your active docker containers to /etc/hosts.

>You must have root access in order to use this script

Why we need that? Well, everytime you restart a machine or stop a container and start over, it might change the IP address of your container. In some cases, such as running some services on local server, you might want to have your container publish in the local machine so you can access through container name instead of *IP address*.

### Usage
```
sudo ./set_hosts.sh
``` 
This way you will publish all active containers into your */etc/hosts* file, if you want to publish only onde container, just add the container name:
```
sudo ./set_hosts.sh srv-elasticsearch-001
``` 


>If you will use it in *cron* we suggest you comment the outputs, we will publish a new version with this option soon...




#### Credits

In one of the research we have had help of a StackOverFlow user called [@steeldriver](http://unix.stackexchange.com/users/65304/steeldriver), check the [post](http://unix.stackexchange.com/questions/322598/match-exact-string-in-file-and-update-ip-address/322605).
