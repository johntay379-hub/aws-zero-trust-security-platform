# 🔒 AWS Zero Trust Security Platform

![Terraform](https://img.shields.io/badge/Terraform-IaC-7B42BC?style=for-the-badge&logo=terraform)
![AWS](https://img.shields.io/badge/AWS-Cloud-FF9900?style=for-the-badge&logo=amazonaws)
![Status](https://img.shields.io/badge/Status-Live-success?style=for-the-badge)

A production-style AWS environment built entirely with Terraform that applies Zero Trust security principles end to end — least-privilege identity, network segmentation, encrypted audit logging, automated scaling, real-time alerting, and continuous compliance checking. No manual console clicks. `terraform apply` builds it the same way every time.

## What this project does

Most personal AWS projects stop at "I launched a server and it works." This one treats security and observability as part of the architecture, not an afterthought:

- Every EC2 instance runs under an IAM role scoped to only the permissions it needs
- Every API call made in the account is recorded by CloudTrail and stored in an encrypted, versioned S3 bucket
- Traffic only reaches compute through a load balancer — instances are never exposed directly
- The compute fleet scales itself up and down automatically based on real load
- CloudWatch alarms notify a human through SNS and trigger scaling policies without manual intervention
- AWS Config continuously checks the account against compliance rules instead of relying on a one-time audit

## Architecture

Internet traffic hits an **Application Load Balancer** in the public subnet, which distributes requests across an **Auto Scaling Group**. The ASG launches EC2 instances from a Terraform-managed **Launch Template** inside the **VPC**, and scales the fleet up or down using an attached **Auto Scaling Policy** based on load.

Every instance runs under an **IAM role** with an instance profile attached — scoped to the minimum permissions it needs, governed by an account-wide password policy with no admin users or wildcard permissions.

**CloudTrail** records every API call made in the AWS account and delivers the logs to an **S3 bucket** that is encrypted at rest, versioned, and fully blocked from public access — so even an attacker with some access can't read or permanently delete the audit trail.

**CloudWatch** watches infrastructure metrics continuously. When a threshold is crossed, it does two things at once: publishes to an **SNS topic** so a person gets notified by email, and feeds the scaling policy so the Auto Scaling Group adjusts capacity automatically.

Separately, **AWS Config** continuously evaluates the account against a set of compliance rules — not on a schedule, but as things change — and writes its findings into the same S3 bucket used for CloudTrail logs, so there's one place to check both "what happened" and "are we still compliant."

## Services used

| Service | Role in this platform |
|---|---|
| **VPC** | Network isolation — subnets, route tables, internet gateway, security groups |
| **IAM** | Least-privilege roles, instance profiles, and account password policy |
| **EC2 (via Auto Scaling)** | Compute instances launched from a managed Launch Template |
| **Auto Scaling Group** | Automatically scales EC2 capacity up or down based on load |
| **Application Load Balancer** | Single entry point for traffic, never exposes instances directly |
| **S3** | Encrypted, versioned, private storage for CloudTrail and Config logs |
| **CloudTrail** | Records every API call made in the account |
| **CloudWatch** | Metric alarms that detect issues and trigger alerts/scaling |
| **SNS** | Delivers alert notifications when CloudWatch alarms fire |
| **AWS Config** | Continuously evaluates the account against compliance rules |

## Why this matters

A lot of "I deployed an EC2 instance" projects prove that AWS works. This one proves the builder thought about what happens *after* deployment: who can access what, whether a misconfiguration would get noticed, whether the system survives a traffic spike without falling over, and whether compliance drift gets caught automatically instead of during an annual review. That gap — between "I can launch a server" and "I can run infrastructure responsibly" — is the whole point of this project.

## Project structure

```
.
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
└── modules/
    ├── vpc/
    ├── iam/
    ├── alb/
    ├── asg/
    ├── cloudtrail/
    ├── cloudwatch/
    ├── s3/
    └── config/
```

## Running it

```bash
terraform init
terraform plan
terraform apply
```

Requires AWS credentials configured locally, and an existing S3 backend if remote state is in use.
