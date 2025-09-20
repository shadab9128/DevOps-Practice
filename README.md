# Wisecow Application

Wisecow is a fun web application that serves wisdom quotes using `fortune` and `cowsay`. This project demonstrates **containerization, Kubernetes deployment, CI/CD automation, and TLS setup on AWS EKS**.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Prerequisites](#prerequisites)
3. [Local Docker Setup](#local-docker-setup)
4. [Kubernetes Deployment](#kubernetes-deployment)
5. [GitHub Actions CI/CD](#github-actions-cicd)
6. [TLS / HTTPS Setup](#tls--https-setup)
7. [Debugging Guide](#debugging-guide)
8. [Useful Commands](#useful-commands)

---

## Project Overview

- **Language / Environment:** Bash script, Docker, Kubernetes  
- **Functionality:** Provides wisdom quotes via HTTP (and HTTPS after TLS setup)  
- **CI/CD:** Automated Docker build, push, and Kubernetes deployment using GitHub Actions  
- **Cloud:** AWS EKS with ALB Ingress and TLS

---

## Prerequisites

- **Local / EC2:** Docker, kubectl, AWS CLI, eksctl  
- **AWS IAM:** Role or User with:
  - `AmazonEKSClusterPolicy`
  - `AmazonEKSWorkerNodePolicy`
  - `AmazonEC2ContainerRegistryFullAccess`
  - Permissions to manage ACM, EKS, and assume roles if needed
- **Domain:** For HTTPS (optional for TLS), e.g., via Cloudflare or dpdns.org  

---

## Local Docker Setup

### 1. Build Docker Image
'''bash
docker build -t wisecow:test .
'''