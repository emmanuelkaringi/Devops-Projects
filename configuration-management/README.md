# Configuration Management with Ansible
This project introduces the basics of configuration management using Ansible. It involves writing an Ansible playbook to configure a Linux server with NGINX and deploying a static website on an EC2 instance.

## Prerequisites
Before you begin, ensure you have the following:
1. Install `Ansible` on your local machine. Use this [guide](https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html) for your respective system.
2. Access to an EC2 instance running a Linux distribution.
3. A tarball of your static website (e.g., website.tar.xz) available on your local machine.

## Project Setup
1. Clone the Repository and navigate to the directory containing the Ansible playbooks to your local machine:
    ```sh
    git clone git@github.com:emmanuelkaringi/Devops-Projects.git

    cd configuration-management
    ```
2. Edit the [`inventory.ini`](inventory.ini) file to include your EC2 instance's public IP address and path to your private key.
3. Ensure that you include the right location to your tarball (compressed) of your website in the [`app role`](roles/app/tasks/main.yml).
4. Generate an SSH Key Pair:

    `ssh-keygen -t rsa -b 4096 -f ~/.ssh/ansible_key`
5. View and copy the content from `ansible_key.pub`:

    `cat ~/.ssh/ansible_key.pub`
6. Paste the content to [`public_key.pub`](roles/ssh/files/public_key.pub).

## Running the Playbooks
1. To execute all roles in the playbook, run the following command:
    
    `ansible-playbook -i inventory.ini setup.yml`
2. If you wish to run only a specific role, you can use the `--tags` option. For example, to run only the `base` role, use:

    `ansible-playbook -i inventory.ini setup.yml --tags "base"`

## Accessing the Website
Once the playbook has been executed successfully, you should be able to access your static website by navigating to your EC2 instance's public IP address in a web browser.