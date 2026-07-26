# Packer Tutorial

### What is Packer?
- Packer is an open-source tool used to create machine images for multiple platforms
- such as AWS, Azure, Docker, and VirtualBox from a single configuration.

### Why do we need Packer?
- Packer helps automate image creation, reduces manual setup, and ensures consistent and repeatable environments across teams and deployments.

### What problem does it solve?
- It solves the problem of inconsistent environments by creating identical images with the same operating system, packages, and configuration every time.

### What is a plugin?
- A plugin extends Packer with support for specific builders such as Amazon AWS,
- Docker, VMware, or Azure. We need plugins to connect Packer with the platform we want to build for.
- Example refer to the code

### What is a source?
- A source defines the base image or builder configuration, such as an Amazon AMI source.
- It tells Packer where the image should come from and how to create it.
- Example refer to the code

### What is a build?
- A build is the process of creating an image using one or more sources and steps.
- It is the main action that runs the image creation workflow.
- Are responsible for creating machines and generating images from them for various platforms.
- Example refer to the code


### What are provisioners?
**Provisioners are decleared under the build block.**
- Provisioners are used to install software, copy files, and configure the machine after the base image is created. 
- Common types include:
  - shell   : runs shell commands or scripts
  - file    : copies files into the image
  - ansible : configures the machine using Ansible playbooks
  - inline  : Type of shell provisioner that executes an array of raw, inline commands directly on the remote instance instead of uploading a separate script file
- Example refer to the code

### How Packer works? Explain the image creation process
1. **Read the Packer template** – Packer reads the configuration file and understands the required plugin, source, build, and provisioners.
2. **Load the plugin** – The plugin connects Packer to the target platform such as AWS, Docker, or Azure.
3. **Create a temporary machine** – Based on the source block, Packer launches a temporary instance using the base image.
4. **Connect to the machine** – Packer connects to the machine using SSH or another supported communicator.
5. **Run provisioners** – It installs packages, copies files, and configures the machine using shell, file, or Ansible provisioners.
6. **Create the image** – Once the machine is configured, Packer captures it and creates a new image (for example, an AMI in AWS).
7. **Clean up** – The temporary machine is stopped or terminated, and the final image is available for use.

So, in simple terms, Packer creates a machine, configures it automatically, captures it as an image, and saves it for reuse.

