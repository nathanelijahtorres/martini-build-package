
# Martini Build Pipeline for GitHub

This repository provides GitHub Actions workflows to automate CI/CD processes for Martini applications. It streamlines building, packaging, and deploying Martini packages, enabling consistent and efficient delivery to Martini instances.

## Overview

The repository includes three primary workflows powered by GitHub Actions:

1. **Build Docker Images**:  
   Automates the creation of Docker images containing Martini packages and pushes them to a local Docker registry.

2. **Create Artifacts**:  
   Zips the Martini package and uploads it as an artifact to the GitHub repository. This artifact can be reused in subsequent workflows or shared with other repositories.

3. **Deploy Martini Packages**:  
   Uploads Martini packages to a local or remote Martini instance and validates the deployment by testing an API endpoint.

---

## Project Structure

The repository is organized as follows:

```plaintext
.
├── .github/
│   └── workflows/            # GitHub Actions workflows
│       ├── build_docker.yml      # Builds Docker images containing Martini packages
│       ├── create_artifact.yml   # Zips and uploads Martini package as an artifact
│       └── deploy.yml            # Deploys Martini packages and validates the API
├── conf/                    # Placeholder for configuration files
├── packages/                # Martini package source code
│   ├── sample-package/          # Example Martini package
│   ├── sample-package2/         # Second package
│   └── sample-package3/         # Third package
├── .gitignore               # Specifies files to be ignored by Git
├── Dockerfile               # Builds a Docker image containing Martini packages
└── Readme.md                # Documentation
```

---

## Workflows

### **1. Build Docker Images**

This workflow automates building and pushing a Docker image that includes a Martini package.

- **Trigger**: Runs on `push` events.  
- **Location**: `.github/workflows/build_docker.yml`  

**Steps:**

1. Sets up QEMU and Docker Buildx for multi-platform builds.
2. Builds a Docker image with the Martini package.
3. Pushes the image to a local Docker registry (`localhost:5000`).

**Example Configuration**:

```yaml
uses: docker/build-push-action@v6
with:
  build-args: |
    MARTINI_VERSION=${{ vars.BASE_DOCKER_MARTINI_VERSION }}
    PACKAGE_DIR=${{ vars.PACKAGE_DIR }}
  push: true
  tags: localhost:5000/sample/martini:latest
```

---

### **2. Create Artifacts**

This workflow zips the Martini package and uploads it as an artifact for reuse.

- **Trigger**: Runs on `push` events.  
- **Location**: `.github/workflows/create_artifact.yml`  

**Steps:**

1. Checks out the repository.
2. Zips the contents of the `packages/sample-package` directory.
3. Uploads the zipped package as an artifact named `sample-package`.

**Example Configuration**:

```yaml
uses: actions/upload-artifact@v4
with:
  name: sample-package.zip
  path: sample-package.zip
```

---

### **3. Deploy Martini Packages**

This workflow uploads a Martini package to a Martini instance and validates its deployment.

- **Trigger**: Runs on `push` events.  
- **Location**: `.github/workflows/deploy.yml`  

**Steps:**

1. Uploads the Martini package using the `martini-upload-package-action` GitHub Action.
2. Tests the deployment by sending an HTTP request to the Martini instance.

**Secrets and Variables**:

- `MARTINI_BASE_URL`: The base URL of the Martini instance.
- `MARTINI_ACCESS_TOKEN`: The access token for your Martini instance. You can obtain this from the instance directly or via the Lonti Console.
- `PACKAGE_DIR`: The path to the directory containing package folders.
- `ALLOWED_PACKAGES`: A comma-separated list of specific package names to upload (e.g., `package2, package3`). If not provided, all packages in the directory will be uploaded.

**Example Configuration**:

```yaml
uses: lontiplatform/martini-build-package@v1
with:
  base_url: ${{ vars.MARTINI_BASE_URL }}
  access_token: ${{ secrets.MARTINI_ACCESS_TOKEN }}
  package_dir: ${{ vars.PACKAGE_DIR }}
  allowed_packages: ${{ vars.ALLOWED_PACKAGES }}
```

---

## Prerequisites

Before using the workflows, ensure the following:

1. **GitHub Secrets**  
   - `MARTINI_ACCESS_TOKEN`: Martini Access Token.

2. **GitHub Variables**  
   - `MARTINI_BASE_URL`: Martini instance base URL.
   - `PACKAGE_DIR`: Package root directory.
   - `ALLOWED_PACKAGES`: Allowed packages to upload.
   - `BASE_DOCKER_MARTINI_VERSION`: Version of the Martini runtime for Docker builds.

3. **Docker Environment**  
   A local or remote Docker registry must be set up for building and pushing images.

---

## References

- [Martini Documentation](https://developer.lonti.com/docs/martini)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Martini Upload Package Action](https://github.com/lontiplatform/martini-build-package)
