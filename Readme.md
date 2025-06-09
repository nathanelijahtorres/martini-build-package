
# Martini Sample Package for Github

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
  tags: <my.container.registry.io>/<my_app>:<my_tag> 
```

---

### **2. Create Artifacts**

This workflow zips all Martini packages matching a given name pattern into a single archive file (`packages.zip`), and stores it as an artifact.

- **Trigger**: Runs on `push` events.  
- **Location**: `.github/workflows/create_artifact.yml`  

**Steps:**

1. Checks out the repository.
2. Stores the package directory as an artifact named `packages.zip`.

**Example Configuration**:

```yaml
uses: actions/upload-artifact@v4
with:
   name: packages
   path: packages
```

---

### **3. Deploy Martini Packages**

This workflow uploads a Martini package to a Martini instance and validates its deployment.

- **Trigger**: Runs on `push` events.  
- **Location**: `.github/workflows/deploy.yml`  

**Steps:**

1. Uses the official **Martini Build Pipeline Github** to handle the entire zipping and uploading process.

2. Reads values from repository variables (`BASE_URL`, `MARTINI_ACCESS_TOKEN`, `PACKAGE_DIR`, `PACKAGE_NAME_PATTERN`, `ASYNC_UPLOAD`, `SUCCESS_CHECK_TIMEOUT`, `SUCCESS_CHECK_DELAY`, `SUCCESS_CHECK_PACKAGE_NAME`).

3. Validates that the `PACKAGE_NAME_PATTERN` is respected, zips the matching packages into a single `packages.zip` file.

4. Uploads the `packages.zip` to the Martini instance, then checks if the deployment was successful using a polling mechanism (if specified).

5. Confirms the deployment is complete—often by hitting a test endpoint or checking for package availability.

**Example Configuration**:

```yaml
uses: lontiplatform/martini-build-pipeline-github@v2
with:
  base_url: ${{ vars.MARTINI_BASE_URL }}
  access_token: ${{ secrets.MARTINI_ACCESS_TOKEN }}
```

---

### Github Variables

Set the following Variables in Github. You can do this by accessing Actions Secrets and Variables.

| Variable                  | Required | Usage                                                                                                                  |
|---------------------------|----------|------------------------------------------------------------------------------------------------------------------------|
| base_url                  | Yes      | Base URL of the Martini instance                                                                                       |
| access_token              | Yes      | The user's access token, obtainable via Martini or through the Lonti Console                                           |
| package_dir               | No       | Root directory containing packages (defaults to `packages` if not specified)                                           |
| package_name_pattern      | No       | Regex pattern to filter which package directories to include. Defaults to `.*` (all directories).                      |
| async_upload              | No       | If set to `true`, tolerates HTTP 504 as a success (used when uploads are handled asynchronously). Defaults to `false`. |
| success_check_timeout     | No       | Number of polling attempts before timing out when checking package deployment status. Defaults to `6`.                 |
| success_check_delay       | No       | Number of seconds between polling attempts. Defaults to `30`.                                                          |
| success_check_package_name| No       | If set, only this specific package is polled after upload. If unset, all matched packages are polled.                  |

You would also need to set `MARTINI_VERSION` as a Repository Variable to set the version of [Martini Server Runtime](https://hub.docker.com/r/lontiplatform/martini-server-runtime) for Docker Builds.

---

## References

- [Martini Documentation](https://developer.lonti.com/docs/martini)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Martini Build Pipeline Github](https://github.com/lontiplatform/martini-build-pipeline-github)
