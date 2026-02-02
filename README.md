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

