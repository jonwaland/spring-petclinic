***

# Spring PetClinic - DevSecOps Pipeline

This repository contains the standard Spring PetClinic application, integrated with a **DevSecOps pipeline** using **GitHub Actions** and the **JFrog Platform**.

## Project Overview
The goal of this project is to demonstrate a secure software supply chain by:
1.  **Resolving dependencies** exclusively via JFrog Artifactory (proxied to Maven Central).
2.  **Continuous Integration** involving compilation and automated testing.
3.  **Containerisation** of the application into a Docker image.
4.  **Security Scanning** using JFrog Xray to identify vulnerabilities in both dependencies and the final container image.
5.  **Build Metadata** by publishing comprehensive build info to the JFrog Platform.

---

## Pipeline Architecture

The GitHub Actions workflow (`.github/workflows/pipeline.yml`) performs the following stages:

* **Setup:** Initialises Java 17 (Temurin distribution) and the JFrog CLI.
* **Maven Configuration:** Configures the environment to use Artifactory for all plugin and dependency resolutions.
* **Build & Test:** Executes `mvn clean install` to ensure code quality.
* **Local Security Scan:** Scans the local Docker image using JFrog Xray before it is pushed to the registry.
* **Publish Image:** Pushes the Docker image to the `docker-local` repository.
* **Metadata Collection:** Collects environment variables and links the Docker layers to the specific build.
* **Build Scan & Export:** Performs a final Xray scan on the published build and exports the results as JSON artifacts.

---

## How to Run the Project

To run the Docker image produced by this pipeline, follow these steps:

### 1. Prerequisites
Ensure you have Docker installed and network access to your JFrog instance.

### 2. Authenticate with JFrog
Log in to the Docker registry using your JFrog credentials or Access Token:
```bash
docker login ${{ secrets.JF_URL_HOST }}
```

### 3. Pull and Run the Image
Use the following command to pull and start the application. 
> **Note:** Replace `<TAG>` with the specific GitHub Run Number (e.g., `19`).

```bash
# Pull the image
docker pull ${{ secrets.JF_URL_HOST }}/docker-local/spring-petclinic:<TAG>

# Run the container
docker run -p 8080:8080 ${{ secrets.JF_URL_HOST }}/docker-local/spring-petclinic:<TAG>
```

### 4. Access the Application
Once the container starts, navigate to:
`http://localhost:8080`

---

## Deliverables Included

* **GitHub Actions Workflow:** `.github/workflows/pipeline.yml`
* **Dockerfile:** Multi-stage build for an optimised runtime image.
* **Xray Scan Data:** Exported JSON files available as GitHub Action artifacts (`xray-reports.zip`).
* **Secure Resolution Evidence:** Build logs confirming all dependencies were pulled from Artifactory.

## Verification of Secure Resolution
During the build process, Maven is forced to resolve all artifacts via the `maven-central` remote repository in Artifactory. This is verified by the following log output:

```text
[main] INFO org.eclipse.aether.internal.impl.DefaultArtifactResolver - 
Artifact ... verifying that is downloadable from [artifactory-release (/***/artifactory/maven-central)]
Downloading from artifactory-release: ***/artifactory/maven-central/...
Downloaded from artifactory-release: ***/artifactory/maven-central/...
```
