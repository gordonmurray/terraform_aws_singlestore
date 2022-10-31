# Terraform AWS SingleStore

Create a single node SingleStore database cluster on AWS using Terraform

![singlestore ui](https://github.com/gordonmurray/terraform_aws_singlestore/blob/main/images/singlestore.png?raw=true)

### Requirements

* AWS Credentials
* A SingleStore license
* Packer - https://www.packer.io/
* Terraform - https://www.terraform.io/

### Usage

Update the variables in packer/variables.json and then use Packer to create an AMI:

```
cd packer
packer build --var-file=variables.json singlestore.json
```

This will create an AMI in your account that Terraform can use to create an EC2 instance.

Update the variables in terraform.tfvars and then run Terraform:

```
terraform init
terraform apply
```

The end result will be an EC2 instance running Singlestore. Terraform will provide an output showing the Singlestore IP address.

SingleStore Studio UI will be available at http://{singlestore_ip}:8080

### Cost estimate

```
Project: gordonmurray/terraform_aws_singlestore

 Name                                                  Monthly Qty  Unit   Monthly Cost 
                                                                                        
 aws_instance.singlestore                                                               
 ├─ Instance usage (Linux/UNIX, on-demand, t3.xlarge)          730  hours       $133.15 
 └─ root_block_device                                                                   
    └─ Storage (general purpose SSD, gp3)                      100  GB            $8.80 
                                                                                        
 OVERALL TOTAL                                                                  $141.95 
──────────────────────────────────
8 cloud resources were detected:
∙ 1 was estimated, it includes usage-based costs, see https://infracost.io/usage-file
∙ 7 were free:
  ∙ 5 x aws_security_group_rule
  ∙ 1 x aws_key_pair
  ∙ 1 x aws_security_group
  ```