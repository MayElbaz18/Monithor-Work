# Monithor-Work
## SOP for running the infrastructure

1. Ensure you have ansible installed on your machine.
2. Clone the repository https://github.com/MayElbaz18/Monithor-Work.git.
3. Navigate to the /Monithor-Work/infra/ansible directory.
4. Create .env and hub.cfg files with the following variables that we send in the assignment.
5. Navigate to the /Monithor-Work/infra/tf directory
6. Change "key_name" and "key_path" variables in the terraform.tfvars file.
7. Run the following commands one by one:
    ```
    terraform init    # Will initialize the terraform project
    ```
    ```
    terraform plan    # Will plan the terraform project
    ```
    ```
    terraform apply   # Will apply the terraform project
    ```
Wait for the terraform and ansible to finish provisioning and configuring the infrastructure.

8. Navigate to the Jenkins UI. (The url will be printed in the end of running the ansible playbook.)

9. Select the "MoniThorDeployment" job and click on "Build Now".
Wait for the job to finish running.

10. Connect to the lb dns and start using Monithor-WebApp. (The url will be printed in the end of running the ansible playbook.)
