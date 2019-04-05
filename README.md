AWS IAM Policies
===============
This is an module to creates policies and roles to be used with DC/OS

EXAMPLE
-------
```hcl
module "dcos-iam" {
  source  = "dcos-terraform/iam/aws"
  version = "~> 0.2.0"

  cluster_name = "production"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| aws\_s3\_bucket | S3 Bucket for External Exhibitor | string | `""` | no |
| cluster\_name | Name of the DC/OS cluster | string | n/a | yes |
| name\_prefix | Name Prefix | string | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| aws\_agent\_profile | Name of the agent profile |
| aws\_master\_profile | Name of the masters profile |

