# Honeypot Infrastructure as Code

Terraform configuration for an AWS SSH honeypot (Cowrie), written retroactively against a live, already-running system rather than from a blank slate.

## Why retroactive?

The honeypot was originally built by hand in the AWS console to learn AWS fundamentals from zero. Once it was live and collecting real attacker data, I went back and wrote Terraform to describe the exact running infrastructure, then used terraform import to bring each real resource under Terraform's management without disrupting the live collection. terraform plan was then used to verify the code was an accurate description of production.

This proves the code actually matches reality, rather than just describing what I intended to build.

## What's here

- provider.tf: AWS provider config, authenticates via a scoped IAM profile (not root, not AdministratorAccess)
- main.tf: all 7 resources: VPC, public subnet, internet gateway, route table plus association, security group, EC2 instance

## Security design

- Managed by a dedicated IAM user with a custom least-privilege policy scoped to EC2/VPC actions only, not AdministratorAccess
- Admin SSH access locked to a single source IP on a non-default port 2222; the honeypot's decoy SSH listens on the standard port 22
- Credentials are never stored in this repo; Terraform authenticates via a local AWS CLI named profile

## Verification

Running terraform plan against this configuration returns:

No changes. Your infrastructure matches the configuration.

Zero drift between code and the live AWS environment at time of import.

## Stack

Terraform, AWS (EC2, VPC), Cowrie SSH honeypot

## Related

Part of a broader security portfolio. See also the honeypot's live threat dashboard and data analysis pipeline, built on the captured attacker telemetry from this infrastructure.
