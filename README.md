## SainsBurry's Screening Test

# Box Version : 

    - ubuntu/vivid64 15.04  

# Configuration Management : 

    - cloud-init

# Host Description :

    - Nginx server : web-01 ( ip : 172.17.8.101 , url : http://172.17.8.101 , services : [ nginx , watchdog, etcd ]  )

    - App servers : app-01 ( ip : 172.17.8.111 , url : http://172.17.8.111:8484 , services : [  app, sidekick, etcd] ) / app-02 ( ip : 172.17.8.112 , url : http://172.17.8.112:8484 , services : [  app, sidekick, etcd ] )

#  Services Description :

	- etcd : holds configuration data for nginx backends
	- nginx : web server
	- watchdog : monitor configuration updates from etcd and update nginx configuration files ( nginx.conf , sites-enable/default ), revert nginx config  default if there is no backend configured
	- app :    download, build  and start the app  ( repo :  https://github.com/ebokumi/baseapp )
	- sidekick :  monitor app activitty and register to etcd if the app is available ( unregister the app if otherwise )

	See config/common/userdata/cloud-config for details 

#  Directory Tree :
  
   - config/common/userdata/cloud-config  : this file is the first being applied 
   - config/common/userdata/script.sh     : this file is will be applied after cloud-config 
   - config/*/inputs/user-data            : this file compile configuration files using mime 
   - config/*/inputs/meta-data            : this file holds meta-data ( like hostname )
   - config/*/init.so                     : this file holds the configuration consumed by cloud-init  

# Startup Instruction :
	
	- vagrant up   (To start all boxes at once)
	- wait 3 to 8 min ( Coffee ? )
	- Browse http://172.17.8.101 
	- Browse http://172.17.8.111:8484 
	- Browse http://172.17.8.112:8484 

# Comands to monitor Configuration Installation :
	
	- Example for Nginx server, web 
		vagrant ssh web-01
		tail -f /var/log/cloud-init*   ( as vagrant user )

# Test to trigger configuration update from Nginx server  :

	- Example to unregister a backend autmatically for App server 01, app01 
		vagrant ssh app-01 
		sudo systemctl stop app 

	- Example to register a backend autmatically for App server 01, app01 
		vagrant ssh app-01 
		sudo systemctl start app

	- Example to get the default web server configuration
		vagrant destroy app-01 app-02

	

# Notes 

Service availability : 
  - All services are started with a restart flag on failure using Systemd


# TroubleShoot 

  Cloud-init requires an iso to be loaded into the cdrom this means that we need to control cdrom name ( in our current case it is for me SATAController )

  - get the vm name : 
     VBoxManage list vms 

       "devbox_web_1442789757263_69527" {487f48c2-16bb-4767-a4b3-7b252ccddd1a}

  - get the controller name for storage controller for the cdrom : 
      VBoxManage showvminfo devbox_web_1442789757263_69527

      the ouput should contains something like this :

        Storage Controller Name (0):            SATAController
		Storage Controller Type (0):            IntelAhci
		Storage Controller Instance Number (0): 0
		Storage Controller Max Port Count (0):  30
		Storage Controller Port Count (0):      2
		Storage Controller Bootable (0):        on


 	In this case my controller name is SATAController. Change it if necessarry in the Vagrant file in the following section : 

 	     vb.customize ["storageattach", :id, "--storagectl", "SATAController", "--type", "dvddrive", "--medium", "./config/app01/init.iso", "--port", "1", "--device", "0"]


Don't hesitate to contact for more information





