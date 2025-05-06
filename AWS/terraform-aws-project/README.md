# Terraform AWS Project

This project is a Terraform configuration for deploying resources on AWS. It includes the necessary files to define, configure, and manage AWS resources using Terraform.

## Project Structure

- `main.tf`: The main configuration file where AWS resources such as EC2 instances and S3 buckets are defined.
- `provider.tf`: Configures the AWS provider, specifying the region and credentials for accessing AWS resources.
- `variables.tf`: Defines input variables for the Terraform configuration, including types and default values.
- `outputs.tf`: Specifies the output values that Terraform will display after applying the configuration, such as instance IDs and public IP addresses.

## Getting Started

1. **Install Terraform**: Ensure that Terraform is installed on your machine. You can download it from the [Terraform website](https://www.terraform.io/downloads.html).

2. **Configure AWS Credentials**: Set up your AWS credentials. You can do this by configuring the AWS CLI or by setting environment variables.

3. **Initialize the Project**: Navigate to the project directory and run the following command to initialize the Terraform project:
   ```
   terraform init
   ```

4. **Plan the Deployment**: Run the following command to see what resources will be created:
   ```
   terraform plan
   ```

5. **Apply the Configuration**: To create the resources defined in the configuration, run:
   ```
   terraform apply
   ```

6. **View Outputs**: After the apply command completes, you can view the output values defined in `outputs.tf`.

## Cleanup

To remove all resources created by this Terraform configuration, run:
```
terraform destroy
```

## License

This project is licensed under the MIT License. See the LICENSE file for more details.