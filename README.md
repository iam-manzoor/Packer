# Build a Custom AWS AMI with Packer

This repository is a small, hands-on introduction to [HashiCorp Packer](https://developer.hashicorp.com/packer): a tool for creating repeatable machine images from code.

The examples here start with an Ubuntu AMI, install Nginx, add a simple web page, and create a reusable Amazon Machine Image (AMI). The second exercise shows how to make the template easier to reuse with variables.

## Why Packer?

Configuring servers by hand works for one machine, but it becomes unreliable as an environment grows. Small differences in packages, configuration, and patch levels eventually lead to configuration drift.

Packer supports an immutable-infrastructure workflow: define the desired server once, build an image, and deploy consistent copies of that image whenever they are needed.

```mermaid
flowchart LR
    A[Ubuntu base AMI] --> B[Packer template]
    B --> C[Temporary EC2 instance]
    C --> D[Install and configure Nginx]
    D --> E[Copy sample web page]
    E --> F[Custom AMI]
    F --> G[Consistent EC2 instances]
```

## What you will learn

- How a Packer template is structured with plugins, sources, and builds
- How the `amazon-ebs` builder creates an AWS AMI
- How shell and file provisioners configure an image during a build
- How variables make a template portable and easier to maintain

## Repository layout

```text
.
├── BootCamp/
│   └── packer.md                       # Additional learning notes
└── Exercise/Packer_Tutorial/
    ├── 01-Simple-Example/
    │   ├── aws-ubuntu.pkr.hcl          # Fixed-value Packer template
    │   ├── scripts/setup.sh             # Installs and enables Nginx
    │   └── Files/index.html             # Page copied into the image
    └── 02-variables/
        ├── aws-ubuntu.pkr.hcl           # Template using var.ami_id
        ├── variables.pkr.hcl            # Variable declaration
        ├── variables.pkrvars.hcl        # Variable value
        ├── scripts/setup.sh
        └── Files/index.html
```

## How the template fits together

Each example uses the same core Packer concepts:

| Block | Purpose in this project |
| --- | --- |
| `packer` | Declares the HashiCorp Amazon plugin required for AWS builds. |
| `source "amazon-ebs"` | Defines the base Ubuntu AMI, AWS region, instance type, and SSH user. |
| `build` | Connects the source to the provisioning steps. |
| `shell` provisioner | Runs `scripts/setup.sh` to install and start Nginx. |
| `file` provisioner | Uploads `Files/index.html` to the temporary EC2 instance. |
| inline `shell` provisioner | Moves the page into Nginx’s web root. |

During a build, Packer launches a temporary EC2 instance from the selected source AMI, applies these provisioners, captures the configured machine as a new AMI, and cleans up the temporary resources.

## Prerequisites

Before building an image, make sure you have:

- An AWS account and permissions to create EC2 resources and AMIs
- AWS credentials configured locally—for example, with the AWS CLI
- [Packer installed](https://developer.hashicorp.com/packer/install)
- An SSH-accessible Ubuntu base AMI available in the target region

> The sample templates use `us-east-1`, `t2.micro`, and a specific Ubuntu AMI ID. AMI IDs are region-specific and may no longer be available, so use a current Ubuntu AMI ID for the region you choose.

## Run the simple example

Move into the first exercise, initialize the required plugin, validate the template, and build the AMI:

```bash
cd Exercise/Packer_Tutorial/01-Simple-Example
packer init .
packer fmt -check .
packer validate .
packer build aws-ubuntu.pkr.hcl
```

Packer will use the credentials already available in your environment or AWS CLI profile. It will create temporary AWS resources during the build, which can incur AWS charges.

When the build finishes, find the new AMI in the EC2 console and launch an instance from it. Nginx should be running and serve the included `index.html` page.

## Run the variables example

The second exercise moves the source AMI ID out of the main template. This is helpful when the same configuration needs different values for regions or environments.

```bash
cd Exercise/Packer_Tutorial/02-variables
packer init .
packer validate -var-file=variables.pkrvars.hcl .
packer build -var-file=variables.pkrvars.hcl aws-ubuntu.pkr.hcl
```

Update `ami_id` in `variables.pkrvars.hcl` before building if you want to use a different Ubuntu image.

## Build with AWS CodeBuild

[`buildspec.yaml`](Exercise/Packer_Tutorial/01-Simple-Example/buildspec.yaml) is an AWS CodeBuild instruction file. It lets a CI/CD pipeline run the same Packer workflow automatically instead of building an AMI from a local machine.

```mermaid
flowchart LR
    A[Source repository] --> B[AWS CodeBuild]
    B --> C[Install Packer]
    C --> D[Validate template]
    D --> E[Build custom AMI]
    E --> F[Deploy or promote the AMI]
```

The file is organized into four phases:

| Phase | What it does |
| --- | --- |
| `install` | Downloads and unpacks Packer in the CodeBuild environment. |
| `pre_build` | Makes Packer available on the command path and validates the template. |
| `build` | Runs Packer to create the AMI. |
| `post_build` | Attempts to capture and print the resulting AMI ID for later pipeline steps. |

Before using this build specification, update it to reference this repository’s template, `aws-ubuntu.pkr.hcl`, rather than `ami-builder.pkr.hcl`. Add `./packer init .` before validation as well, so CodeBuild installs the required Amazon plugin. The CodeBuild service role also needs AWS permissions to create the temporary EC2 resources and register the AMI.

## Useful commands

```bash
# Format Packer configuration files in the current directory
packer fmt .

# Check the template before creating cloud resources
packer validate aws-ubuntu.pkr.hcl

# Show a detailed build log when troubleshooting
PACKER_LOG=1 packer build aws-ubuntu.pkr.hcl
```

## Next steps

- Replace the hard-coded settings with variables for region, instance type, and AMI name.
- Add automated image checks before promoting an AMI.
- Use the resulting AMI in a launch template, Auto Scaling group, or infrastructure-as-code workflow.
- Explore additional provisioners such as Ansible when the server configuration grows.

---

Packer turns server setup into version-controlled infrastructure: build once, then deploy the same image with confidence.
