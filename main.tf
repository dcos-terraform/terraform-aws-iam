/**
 * AWS IAM Policies
 * ===============
 * This is an module to creates policies and roles to be used with DC/OS
 *
 *
 * EXAMPLE
 * -------
 * ```hcl
 * module "dcos-iam" {
 *   source  = "dcos-terraform/iam/aws"
 *   version = "~> 0.2.0"
 *
 *   cluster_name = "production"
 * }
 * ```
 *
 */

locals {
  cluster_name = "${var.name_prefix != "" ? "${var.name_prefix}-${var.cluster_name}" : var.cluster_name}"
}

# Define IAM role to create external volumes on AWS
resource "aws_iam_instance_profile" "agent_profile" {
  name = "dcos-${local.cluster_name}-instance_profile"
  role = "${aws_iam_role.agent_role.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "agent_policy" {
  name = "dcos-${local.cluster_name}-instance_policy"
  role = "${aws_iam_role.agent_role.id}"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "RexRay",
            "Action": [
                "ec2:CreateTags",
                "ec2:DescribeInstances",
                "ec2:CreateVolume",
                "ec2:DeleteVolume",
                "ec2:AttachVolume",
                "ec2:DetachVolume",
                "ec2:DescribeVolumes",
                "ec2:DescribeVolumeStatus",
                "ec2:DescribeVolumeAttribute",
                "ec2:CreateSnapshot",
                "ec2:CopySnapshot",
                "ec2:DeleteSnapshot",
                "ec2:DescribeSnapshots",
                "ec2:DescribeSnapshotAttribute"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Sid": "KubernetesCloudProvider",
            "Action": [
              "ec2:CreateTags",
              "ec2:DescribeInstances",
              "ec2:CreateVolume",
              "ec2:DeleteVolume",
              "ec2:AttachVolume",
              "ec2:DetachVolume",
              "ec2:DescribeVolumes",
              "ec2:DescribeVolumeStatus",
              "ec2:DescribeVolumeAttribute",
              "ec2:CreateSnapshot",
              "ec2:CopySnapshot",
              "ec2:DeleteSnapshot",
              "ec2:DescribeSnapshots",
              "ec2:DescribeSnapshotAttribute",
              "ec2:AuthorizeSecurityGroupIngress",
              "ec2:CreateRoute",
              "ec2:CreateSecurityGroup",
              "ec2:DeleteSecurityGroup",
              "ec2:DeleteRoute",
              "ec2:DescribeRouteTables",
              "ec2:DescribeSubnets",
              "ec2:DescribeSecurityGroups",
              "ec2:ModifyInstanceAttribute",
              "ec2:RevokeSecurityGroupIngress",
              "elasticloadbalancing:AttachLoadBalancerToSubnets",
              "elasticloadbalancing:ApplySecurityGroupsToLoadBalancer",
              "elasticloadbalancing:CreateLoadBalancer",
              "elasticloadbalancing:CreateLoadBalancerPolicy",
              "elasticloadbalancing:CreateLoadBalancerListeners",
              "elasticloadbalancing:ConfigureHealthCheck",
              "elasticloadbalancing:DeleteLoadBalancer",
              "elasticloadbalancing:DeleteLoadBalancerListeners",
              "elasticloadbalancing:DescribeLoadBalancers",
              "elasticloadbalancing:DescribeLoadBalancerAttributes",
              "elasticloadbalancing:DetachLoadBalancerFromSubnets",
              "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
              "elasticloadbalancing:ModifyLoadBalancerAttributes",
              "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
              "elasticloadbalancing:SetLoadBalancerPoliciesForBackendServer"
            ],
            "Resource": "*",
            "Effect": "Allow"
        },
        {
            "Sid": "SoakClusterLogsArchiveBucketLevel",
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket"
            ],
            "Resource": "arn:aws:s3:::soak-cluster-logs"
        },
        {
            "Sid": "SoakClusterLogsArchiveObjectLevel",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": "arn:aws:s3:::soak-cluster-logs/*"
        },
        {
          "Sid": "ElasticIndexSnapshot",
          "Action": [
            "s3:ListBucket",
            "s3:GetBucketLocation",
            "s3:ListBucketMultipartUploads",
            "s3:ListBucketVersions"
          ],
          "Condition": {
            "StringLike": {
              "s3:cluster_name": [
                "${local.cluster_name}/*"
              ]
            }
          },
          "Effect": "Allow",
          "Resource": [
            "arn:aws:s3:::soak-cluster-elk-snapshots"
          ]
        }
    ]
}
EOF
}

resource "aws_iam_role" "agent_role" {
  name = "dcos-${local.cluster_name}-instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "master_profile" {
  name = "dcos-${local.cluster_name}-master_instance_profile"
  role = "${aws_iam_role.master_role.name}"

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  bucket_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
      {
          "Sid": "DCOSExternalExhibitorBucketLevel",
          "Effect": "Allow",
          "Action": [
              "s3:ListBucket"
          ],
          "Resource": "arn:aws:s3:::${var.aws_s3_bucket}"
      },
      {
          "Sid": "DCOSExternalExhibitorObjectLevel",
          "Effect": "Allow",
          "Action": [
              "s3:PutObject",
              "s3:GetObject",
              "s3:DeleteObject"
          ],
          "Resource": "arn:aws:s3:::${var.aws_s3_bucket}/*"
      }
    ]
}
EOF

  // we need a valid policy so lets take an example
  nothing_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": {
    "Effect": "Allow",
    "Action": "s3:ListBucket",
    "Resource": "arn:aws:s3:::example_bucket"
  }
}
EOF
}

resource "aws_iam_role_policy" "master_policy" {
  name = "dcos-${local.cluster_name}-master_instance_policy"
  role = "${aws_iam_role.master_role.id}"

  policy = "${var.aws_s3_bucket != "" ? local.bucket_policy : local.nothing_policy }"
}

resource "aws_iam_role" "master_role" {
  name = "dcos-${local.cluster_name}-master_instance_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
