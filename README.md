AWS IAM Policies
===============
This is an module to creates policies and roles to be used with DC/OS


EXAMPLE
-------
```hcl
module "dcos-iam" {
  source  = "dcos-terraform/iam/aws"
  version = "~> 0.1.0"

  cluster_name = "production"
}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws_s3_bucket | S3 Bucket for External Exhibitor | string | `` | no |
| cluster_name | Name of the DC/OS cluster | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws_agent_profile | Name of the agent profile |
| aws_master_profile | Name of the masters profile |

