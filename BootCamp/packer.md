# Packer

- Platforms and Builders: (Build AMI)
  - Supports AWS, GCP, Azure, VirtualBox, Docker
- Provisioners: (Supports installing and Uninstalling packages with in AMI)
  - Shell, ANsible, Puppet, Chef.
- Post-processors: (To be done after the Image is built)
  - 

# Installation
- Provide packer installation URL
  -

# Packer Basic
- Templates:
  - Setup a desired configuration for the image to be build
  - Written in JSON/HCL Config files.
 
- Variables:
  - Parameterize your configurations.
  - Helps reuse of the code
  - Maintainability will be easier
  - We can define variables within the packer file also we can have it in a different file.
  - File Name `variables.pkvars.hcl`
  - `packer build -var-file <variable file name> template.pkr.hcl`
  - `user variables` defined by users
  - `environment variables` access the variables at the host level. env("AWS_ACCESS_KEY"). evn is a function.
  - `locals` Gets calculated and stored in a variable. Can not be accessed outside of templates.
  
- Builders:
  - amazon-ebs
  - amazon-ebssurrogate
  - amazon-ebsvolume
  - amazon-instance
-
-

## CI/CD
How do you create a custom AMI?
Build AMI using CI/CD -> Security Checks -> Provision servers.

AMI Hardening: What does it mean?
