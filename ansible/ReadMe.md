# Part 2: Configuration Management (Form Submission App)

## Objective
The goal of this phase is to automate the configuration of the cloud server created in Part 1 using **Ansible**.  
This includes installing and enabling Docker so that it starts automatically on system boot.

---

## Tools Used
- **Ansible** – For configuration management and automation  
- **Ubuntu EC2 Instance** – Provisioned using Terraform in Part 1  
- **Docker** – Container runtime to deploy the sample web application in later stages  

---

## Project Files
| File | Description |
|------|--------------|
| `inventory.ini` | Contains the target EC2 instance information and SSH key details |
| `docker-container.yml` | Ansible playbook that installs and configures Docker on the Ubuntu server |

---

## Inventory File Details
```ini
[formsub]
54.194.83.100 ansible_user=ubuntu ansible_ssh_private_key_file=~/.ssh/FormSubKeyPair.pem
