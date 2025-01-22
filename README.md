# Monithor-Work

## SOP for running the infrastructure

1. Clone the repository https://github.com/MayElbaz18/Monithor-Work.git.
2. Change key_name and key_path in the terraform.tfvars file.
3. Navigate to the /Monithor-Work/infra/tf directory
// ... existing code ...
4. Run the following commands:
    ```
    terraform init    # Will initialize the terraform project
    terraform plan    # Will plan the terraform project
    terraform apply   # Will apply the terraform project
    ```
Wait for the terraform to finish provisioning the infrastructure.
// ... existing code ...

5. Ensure you have ansible installed on your machine.
6. Navigate to the /Monithor-Work/infra/ansible directory.

7. Run the following command:
    ```
    ansible-playbook -i inventory.yaml playbook.yaml
    ```

8. Wait for the ansible to finish configuring the infrastructure.

9. Navigate to the Jenkins UI.

10. Select the "MoniThorDeployment" job and click on "Build Now".

11. Wait for the job to finish running.

12. The job will deploy the infrastructure to the prod nodes.
