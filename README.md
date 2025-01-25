# Monithor-Work

## SOP for running the infrastructure

1. Clone the repository https://github.com/MayElbaz18/Monithor-Work.git.
2. Navigate to the /Monithor-Work/infra/ansible directory and create .env and hub.cfg files with the following variables that we send in the assignment.
3. Navigate to the /Monithor-Work/infra/tf directory
4. Change key_name and key_path in the terraform.tfvars file.
5. Run the following commands one by one:
    ```
    terraform init    # Will initialize the terraform project
    ```
    ```
    terraform plan    # Will plan the terraform project
    ```
    ```
    terraform apply   # Will apply the terraform project
    ```
    Wait for the terraform to finish provisioning the infrastructure.

6. Ensure you have ansible installed on your machine.
7. Navigate to the /Monithor-Work/infra/ansible directory.

8. Run the following command:
    ```
    ansible-playbook -i inventory.yaml main.yaml
    ```

9. Wait for the ansible to finish configuring the infrastructure.

10. Navigate to the Jenkins UI.

11. Select the "MoniThorDeployment" job and click on "Build Now".

12. Wait for the job to finish running.

13. The job will deploy the infrastructure to the prod nodes.

14. After the job is finish connect to the lb dns and create user in Monithor-WebApp.