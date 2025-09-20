# Wisecow Application

- Wisecow application https://www.shadab.dpdns.org/

Wisecow is a fun web application that serves wisdom quotes using `fortune` and `cowsay`. This project demonstrates **containerization, Kubernetes deployment, CI/CD automation, and TLS setup on AWS EKS**.

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
```bash
docker build -t wisecow:test .
```
### 2. Run Container
```bash
docker run -p 4499:4499 wisecow:test
```
### 3. Test Application
```bash
curl http://localhost:4499
```
## Kubernetes Deployment

### 1. Create Deployment & Service
```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```
### 2. Verify Pods & Service
```bash
kubectl get pods
kubectl get svc
```
### 3. Apply Ingress
```bash
kubectl apply -f k8s/ingress.yaml
```
### 4. Verify Ingress
```bash
kubectl get ingress wisecow-ingress
kubectl describe ingress wisecow-ingress
```
 
## GitHub Actions CI/CD
- Workflow automatically builds Docker image, pushes to DockerHub/ECR, and updates Kubernetes deployment.
- Secrets Required:
    - DOCKER_USERNAME, DOCKER_PASSWORD (for DockerHub)
    - AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY (for EKS deployment)
    - AWS_REGION (your cluster region)

## TLS / HTTPS Setup

### 1. Create ACM Certificate
- Region must match your EKS cluster

- Add your domain/subdomain

- Validate using DNS (add CNAME in your DNS provider)

### 2. Update Ingress with ACM ARN
```bash
alb.ingress.kubernetes.io/certificate-arn: <YOUR_ACM_CERTIFICATE_ARN>
alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80},{"HTTPS":443}]'
alb.ingress.kubernetes.io/ssl-redirect: 443
```

## Debugging Guide

### 1. Local Docker Issues
```bash
docker logs <container-id>
```
### 2. Verify installed prerequisites
```bash
docker exec -it <container-id> bash
command -v cowsay
command -v fortune
command -v nc
```
### 3. Kubernetes Issues
```bash
kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```
### 4. Check service & endpoints:
```bash
kubectl get svc
kubectl get endpoints
```
### 5. Check ingress & ALB logs:
```bash
kubectl describe ingress wisecow-ingress
kubectl get ingress -w
```
### 6. Verify nodes:
```bash
kubectl get nodes
```
### 7. Verify IAM permissions:
```bash
aws eks list-clusters --region <region>
aws eks update-kubeconfig --name <cluster-name> --region <region>
kubectl get configmap aws-auth -n kube-system
```
### 8. Verify ACM certificate:
```bash
aws acm describe-certificate --certificate-arn <certificate-arn> --region <region>
```

## Useful Commands
```bash
# Docker
docker build -t wisecow:test .
docker run -p 4499:4499 wisecow:test
docker logs <container-id>

# Kubernetes
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/ingress.yaml
kubectl get pods
kubectl get svc
kubectl get ingress
kubectl describe ingress <ingress-name>

# AWS EKS
aws eks list-clusters --region <region>
aws eks update-kubeconfig --name <cluster-name> --region <region>
kubectl get configmap aws-auth -n kube-system

# GitHub Actions
kubectl set image deployment/wisecow-deployment wisecow=<docker-image>
```
