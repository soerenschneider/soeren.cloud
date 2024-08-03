# soeren.cloud

## Table of Contents

1. [Overview](#overview)
1. [Motivation](#motivation)
1. [Requirements](#requirements)
   1. [Functional Requirements](#functional-requirements)
   1. [Non-functional Requirements](#non-functional-requirements)
   1. [Non-goals](#non-goals)
1. [Security Considerations](#security-considerations)
1. [Software Components](#software)
   - [Purpose-Built Software](#purpose-built-software)
   - [IaC](#iac)
1. [Cloud Infrastructure](#cloud-infrastructure)
   - [AWS Services](#aws-services)
   - [Connectivity](#connectivity)
   - [Regions](#regions)
1. [Hardware Components](#hardware-components)


## Overview
This repository serves as a meta repository for the project of building my personal hybrid cloud, an endevaour that started a couple of years ago and really gained serious traction during the Covid pandemic. 

The name is borrowed from the domain that serves all resources. 

## Motivation

Building a fully fledged hybrid cloud environment as a hobby project is/was driven by several motivations:

- **Passion for Technology and Skill Development**: The project is driven by an interest in exploring new technologies and deepen my knowledge in technologies I'm already familiar with. Also the project is contributing to personal and professional growth, especially in developing a project over a long time frame.

- **Sovereignty, Independence and Resilience**: Using the hybrid cloud to maximize data sovereignty and control to still serve when network partitions happen or hardware fails. 

- **Problem-solving and Creativity**: I like the challenge of continuously improving things, step by step over a long time.

- **A little bit of insanity**: This whole endeavour has been taking quite a lot of time, blood and sweat. Sometimes I think maybe a bit too much.

Each of these motivations contributes to a fulfilling and enriching experience, combining technical curiosity, skill development, and personal satisfaction in a significant hobby project.


## Requirements
### Functional Requirements

1. **Resource Management**
   - The system must support automatic provisioning and deprovisioning of virtual machines (VMs), containers, and other resources.
   - The system must *NOT* allow dynamic allocation and reallocation of resources (CPU, memory, storage) based on demand.
1. **Storage Management**
   - The system must provide seamless access to both on-premises and cloud-based storage.
   - The system must support automated data replication and backup between on-premises and cloud environments.
1. **Networking**
   - The system must enable secure, seamless networking between on-premises and cloud resources.
   - The system must support Virtual Private Network (VPN) connections for secure data transfer between local and remote datacenters.
   - The system must allow network segmentation to isolate different types of traffic and resources.
1. **Security**
   - The system must provide robust Identity and Access Management (IAM) to control access to resources.
   - The system must support encryption of data at rest and in transit.
1. **Monitoring and Management**
   - The system must offer a unified management dashboard for monitoring both on-premises and cloud resources.
   - The system must provide alerts and notifications for critical events and thresholds.
   - The system must monitor the performance of resources and applications and provide detailed metrics.
1. **Disaster Recovery**
   - The system must support automated failover of resources in case of on-premises failures.
   - The system should support the creation, testing, and execution of disaster recovery plans.
1. **Application Deployment and Management**
   - The system must provide orchestration tools for deploying and managing containerized applications.
   - The system must provide a GitOps mechanism for automated application deployment.
   - The system should provide Continuous Integration/Continuous Deployment (CI/CD) pipelines for automated configuration management.
1. **Interoperability**
   - The system must provide APIs for integrating with other systems and third-party tools.

### Non-Functional Requirements

1. **Resilience**: Everything eventually fails, all software should be built with this mindset to offer services even when not network partitions/hardware failures happen.
1. **Cost-Efficiency**: The spending on my monthly AWS bill should not exceed 5€.

### Non-Goals

1. **Scalability**: The cloud does not need to support large scaling of applications and infrastructure as the hardware still holds enough headroom for future workloads.
1. **Compliance**: My family members who also use the cloud do not require me to fill out compliance checklists
1. **Reliability**: Consumer hardware and consumer dial-up links fail all the time, it's impossible to ensure minimal downtime across all regions.

## Security Considerations

### Authentication / Authorization
A zero trust approach is used where possible, requiring mTLS for service-to-service authentication and OIDC for user authentication.
**Technologies**: Istio, haproxy, Vault

### Secrets Management
Vault is used as secret storage, virtual machine authentication, PKI (x509, SSH certificates) and creating short-lived credentials to services such as AWS, RabbitMQ, Kubernetes.

### OS Patching
An aggressive patching strategy that updates all installed packages each night during off-hours is being employed. On top of that, a self-hosted [renovate](https://docs.renovatebot.com) job is triggered multiple times a day that updates repositories.


## Software Components
My hybrid cloud is standing on the shoulders of giants and mainly consists of self-hosted off-the-shelf open source
software, a handful of public cloud services plus software I've purposely written for it.

This section contains a list of all my open sourced repositories that are involved in the cloud.

### Purpose-Built Software

Following a list of purposely built software to help solving problems of the hybrid cloud.

#### OS Baseline / Agent

- **Repository:** [sc-agent](https://github.com/soerenschneider/sc-agent)
  - **Description:** Agent running on all virtual machines performing common tasks needed to integrate the machine seamlessly in the Hybrid Cloud
  - **Key Technologies:** Golang, Vault, REST, code generators
  - **Key Topics:** Secrets management, observability, automation, x509, SSH

#### Security

- **Repository:** [vault-ssh-cli](https://github.com/soerenschneider/vault-ssh-cli)
  - **Description:** Automate signing SSH host- and client certificates for a more secure and scalable infrastructure.
  - **Key Technologies:** Golang, Vault, SSH


- **Repository:** [vault-pki-cli](https://github.com/soerenschneider/vault-pki-cli)
  - **Description:** Automation for PKI infrastructure, the backbone for the zero trust implementation.
  - **Key Technologies:** Golang, Vault, x509


- **Repository:** [occult](https://github.com/soerenschneider/occult)
  - **Description:** Read secrets from Vault and perform configured tasks based with them, such as decrypting disks on the fly.
  - **Key Technologies:** Golang, Vault, KMS


- **Repository:** [acmevault](https://github.com/soerenschneider/acmevault)
  - **Description:** Automatically unseals configured Vault instances using a push mechanism and no Cloud dependencies
  - **Key Technologies:** Golang, AWS Route53, Vault, x509


- **Repository:** [vault-unsealer](https://github.com/soerenschneider/vault-unsealer)
  - **Description:** Requests x509 certificates from Let's Encrypt via DNS challenge and secretly distributes them via Vault.
  - **Key Technologies:** Golang, Vault

#### Networking

- **Repository:** [dyndns](https://github.com/soerenschneider/dyndns)
  - **Description:** Keeps DNS records updated for internet connections that have dynamic IP addresses.
  - **Key Technologies:** Golang, MQTT, AWS Route53, AWS Lambda, AWS SQS
  - **Key Topics:** DNS, Resilience


- **Repository:** [ip-plz](https://github.com/soerenschneider/ip-plz)
  - **Description:** Minimal REST API that returns the public IPv4 of a caller.
  - **Key Technologies:** Golang, AWS Lambda
  - **Key Topics:** IPv4

### GitOps
- **Repository:** [k8s-gitops](https://github.com/soerenschneider/k8s-gitops)
  - **Description:** Kubernetes is used as the main platform that runs (almost) all payloads and is delivered via GitOps
  - **Key Technologies:** Kubernetes, K0s, Kustomize, Istio, GitOps, Flux

### IaC
#### AWS configuration
These repositories contain OpenTofu code responsible for maintaining all resources in AWS.

- **Repository:** [tf-aws-dyndns](https://github.com/soerenschneider/tf-aws-dyndns)
  - **Description:** IaC for setting resources in AWS to run [dyndns](https://github.com/soerenschneider/dyndns) and enable a highly available setup.
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, AWS IAM, AWS Route53, AWS Lambda, AWS SQS, AWS Api Gateway


- **Repository:** [tf-aws-ip-plz](https://github.com/soerenschneider/tf-aws-ip-plz)
  - **Description:** IaC for serving the [ip-plz](https://github.com/soerenschneider/ip-plz) tool via AWS.
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, AWS IAM, AWS Route53, AWS Lambda, AWS SQS, AWS Api Gateway


- **Repository:** [tf-aws-route53](https://github.com/soerenschneider/tf-aws-route53)
  - **Description:** Setting up my hosted zones and records on AWS Route53 using IaC.
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, AWS Route53


#### Machine- and OS Level

- **Repository:** [tf-libvirt](https://github.com/soerenschneider/tf-libvirt)
  - **Description:** Manages baremetal virtual machines via IaC.
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, libvirt


- **Repository:** [ansible](https://github.com/soerenschneider/ansible)
  - **Description:** Collection of Ansible playbooks and roles to provide low-level tools and establish (security) baseline on all virtual machines
  - **Key Technologies:** Ansible


#### Persistence & Messaging

- **Repository:** [tf-mariadb](https://github.com/soerenschneider/tf-mariadb)
  - **Description:** Includes OpenTofu configurations for setting up and managing MariaDB/MySQL clusters and instances.
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, MariaDB


- **Repository:** [tf-minio](https://github.com/soerenschneider/tf-minio)
  - **Description:** Provides OpenTofu scripts to configure MinIO clusters and instances.
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, Minio


- **Repository:** [tf-rabbitmq](https://github.com/soerenschneider/tf-rabbitmq)
  - **Description:** Contains OpenTofu configurations to manage RabbitMQ.
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, RabbitMQ

#### Secrets Management

- **Repository:** [tf-vault](https://github.com/soerenschneider/tf-vault)
  - **Description:** Vault is used for all secrets management except user authentication/authorization
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, Minio


- **Repository:** [tf-keycloak](https://github.com/soerenschneider/tf-keycloak)
  - **Description:** Keycloak provides OIDC for user authentication and authorization
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, RabbitMQ

#### Observability

- **Repository:** [tf-grafana](https://github.com/soerenschneider/tf-grafana)
  - **Description:** Sets up Grafana Datasources and Dashboards via IaC
  - **Key Technologies:** Terragrunt, OpenTofu/Terraform, RabbitMQ

## Cloud Infrastructure

### AWS Services

A list of AWS services that are used by the hybrid cloud.

| Service     | Region    | Purpose                                                                                                                              |
|-------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------|
| API Gateway | us-east-1 | Exposing Lambda functions via HTTPS                                                                                                  |
| Lambda      | us-east-1 | Redundant [dyndns-server](https://github.com/soerenschneider/dyndns) deployment, [ip-plz](https://github.com/soerenschneider/ip-plz) |
| Route 53    | global    | Domains, Let's Encrypt DNS challenges                                                                                                |                                              
| S3          | us-east-1 | Terraform state, Mirror for Minio buckets                                                                                            |
| SQS         | us-east-1 | Notification topics for [dyndns-server](https://github.com/soerenschneider/dyndns)                                                   |
| IAM         | global    | Authentication and authorization, short lived access credentials                                                                     |


### Connectivity

### Regions
Thanks again for my family that lets me run my machines across different regions and availability zones. :)

![regions](diagrams/regions.svg)

## Hardware Components

| Device                                         | Region       | Zone | Ram        | Purpose                 |
|------------------------------------------------|--------------|------|------------|-------------------------|
| ASRock Rack B650D4U / AMD Ryzen 9 7900 12c/24t | eu-central-d | -    | 128 ECC GB | Virtualization Host     |
| ASRock Rack B470D4U / AMD Ryzen 7 XXX  6c/12t  | eu-central-e | 1    | 64 ECC GB  | Virtualization Host     |
| Fujitsu D3644-B1 / Intel i3 9300T 4c/4t        | eu-central-e | 2    | 32 ECC GB  | Virtualization Host     |
| ASRock Rack B650D4U / AMD Ryzen 9 7900 12c/24t | eu-west-p    | -    | 64 ECC GB  | Virtualization Host     |
| Raspberry Pi 4                                 | eu-central-d | -    | 4 GB       | Hashicorp Vault Cluster |
| Raspberry Pi 4                                 | eu-central-d | -    | 4 GB       | Hashicorp Vault Cluster |
| Raspberry Pi 4                                 | eu-central-e | 1    | 4 GB       | Hashicorp Vault Cluster |
| Raspberry Pi 4                                 | eu-central-e | 2    | 4 GB       | Hashicorp Vault Cluster |
| Raspberry Pi 4                                 | eu-west-p    | -    | 4 GB       | Hashicorp Vault Cluster |
|                                                | eu-central-d | -    | 16 GB      | Router                  |
|                                                | eu-central-e | 1    | 16 GB      | Router                  |
|                                                | eu-west-p    | -    | 16 GB      | Router                  |
