# Packer
Tool to create identical machine images for various platforms. (Cloud, VirtualMachines, Containers)

Develop -> Deploy(Server) -> Configure(server).

### Mutable Infrastrucuture
- Server deployed then
  - Patch Kernel
  - Update Repos for package installations
  - Configure Firewall
  - Secure/Harden server
  - Copy Application code

- Manageable when you have few servers, What about when you have thousands of servers. Leads to configuration drift in the server configs.

### Immutable Infrastructure
Develop -> Configure -> Deploy(server)
- Builds an AMI with application code and Server configs generates custom images

## Building AMI with Packer.
- Uses json format
- Building blocks of packers
  - Builders
  - Provisioners
  - Post-Processors

### Builders
- Are responsible for creating machines and generating images from them for various platforms.
```
{
  "builders": [
    {
       "type": "amazon-ebs",
       "access_key": "<Access-key>",
       "secret_key": "<sec_key>",
       "region": "us-east-1",
       "ami_name": "my-first-ami",
       "source_ami":  "ami-123456789",
       "instance_type": "<instance_size>"  #Temporary instance deployed by packer to configure the source image and create AMI from it
    }
  ]
}
```

### Provisioners
- Provisioners use built-in and thrid-party software to insta;; and configure the machine image after booting.
- Features:
  - Installing packages
  - patching the kernel
  - creating users
  - downloading application code.

#### Shell
```
{
  "builders": [
    {
       "type": "amazon-ebs",
       "access_key": "<Access-key>",
       "secret_key": "<sec_key>",
       "region": "us-east-1",
       "ami_name": "my-first-ami",
       "source_ami":  "ami-123456789",
       "instance_type": "<instance_size>"  #Temporary instance deployed by packer to configure the source image and create AMI from it
    }
  ],
  "provisioners": [
     {
       "type": "shell",
       "inline": ["sleep 30","sudo apt update","sudo apt install nginx -y"]
     }
  ]
}
```
- Instead of inline use script to simplify the json file.
```
setup.sh # Add all the command here
sudo systemctl enable nginx
sudo systemctl enable ufw
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https
```
```
{
  "builders": [
    {
       "type": "amazon-ebs",
       "access_key": "<Access-key>",
       "secret_key": "<sec_key>",
       "region": "us-east-1",
       "ami_name": "my-first-ami",
       "source_ami":  "ami-123456789",
       "instance_type": "<instance_size>"  #Temporary instance deployed by packer to configure the source image and create AMI from it
    }
  ],
  "provisioners": [
     {
       "type": "shell",
       "script": "setup.sh"
     }
  ]
}
```

#### File
- Upload files to machine built by Packer
```
{
  "builders": [
    {
       "type": "amazon-ebs",  # AWS
       "access_key": "<Access-key>",
       "secret_key": "<sec_key>",
       "region": "us-east-1",
       "ami_name": "my-first-ami",
       "source_ami":  "ami-123456789",
       "instance_type": "<instance_size>"  #Temporary instance deployed by packer to configure the source image and create AMI from it
    },
    {
      "type": "azure-rm",
      "client_secret": <>,
      "client_id": <>,
      "subscription_id": <>,

      "image_publisher": <>,
      "image_offer": <>,
      "image_sku": <>,

      "location": "East US",
      "os_type": "Linux",
      "managed_image_name": "Ubunut-nginx-projects",
      "managed_image_resource_gruop_name": "packer-rg"
  ],
  "provisioners": [
     {
       "type": "shell",
       "script": "setup.sh"
     },
     {
       "type": "file",
       "source": "index.html",
       "destination": "/tmp/" # Can not copy directly to /var/www/html/ permission issue
     },
     {
       "type": "shell",
       "inline": ["sudo cp /tmp/index.html /var/www/html/"]
     }
  ]
}
```
