# Enable F5 Distributed Cloud API Security for HTTP Load Balancer

This [workflow](/.github/workflows/enable-api-discovery.yaml) automatically updates the API discovery setting for selected F5 Distributed Cloud HTTP Load Balancers. The workflow utilizes the F5 Distributed Cloud CLI tool to retrieve the current HTTP Load Balancer configuration and updates the API discovery setting.

## Prerequisites

### For CI/CD

- [F5 Distributed Cloud Account (F5XC)](https://console.ves.volterra.io/signup/usage_plan)
  - [F5XC API certificate](https://docs.cloud.f5.com/docs/how-to/user-mgmt/credentials)
- [GitHub Account](https://github.com)

### GitHub Configuration Instructions

- **Fork and Clone Repo. Navigate to `Actions` tab and enable it.**

- **Actions Secrets:** Create the following GitHub Actions secrets in your forked repo. To create a secret, navigate to your repository, click on `Settings` and then `Secrets and Variables` -> `Actions` . Click on `New repository secret` and add the following secrets:

  | **Name**        | **Required** | **Description**                                                                                                                                            |
  | --------------- | ------------ | ---------------------------------------------------------------------------------------------------------------------------------------------------------- |
  | XC_API_P12_FILE | true         | [Base64 encoded](https://f5devcentral.github.io/f5-xc-terraform-examples/tools/binary-to-base64-converter/index.html) F5 Distributed Cloud API certificate |
  | XC_P12_PASSWORD | true         | Password for F5 Distributed Cloud API certificate                                                                                                          |
  | XC_API_URL      | true         | URL for F5 Distributed Cloud API (example: https://yourtenant_here.console.ves.volterra.io/api)                                                            |

## Workflow Runs

**STEP 1:** Open GitHub Actions and select the `Enable API Discovery` workflow.

**STEP 2:** Click Run workflow and enter the required inputs:

- `HTTP Load Balancer Name` - Name of the HTTP Load Balancer to update the API discovery setting
- `HTTP Load Balancer Namespace` - Namespace of the HTTP Load Balancer

**STEP 3:** Click Run workflow and monitor the progress. Once the workflow is completed, the API discovery setting for the selected HTTP Load Balancer will be updated.
