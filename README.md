AWS IAM Policies
===============
This is an module to creates policies and roles to be used with DC/OS


EXAMPLE
-------
```hcl
module "dcos-iam" {
  source  = "dcos-terraform/iam/aws"
  version = "~> 0.1"

  cluster_name = "production"
}
```



## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cluster_name | Cluster name all resources get named and tagged with | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| aws_agent_profile | Name of the agents profile |
| aws_master_profile | Name of the masters profile |

