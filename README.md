## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![Azure Lab Network][logo]

[logo]: ../main/diagrams/azurelabnetwork1.png "Azure Lab Network"


These files have been tested and used to generate a live ELK deployment on Azure. 
They can be used to recreate the entire deployment pictured above. 
Alternatively, select portions of the yaml file may be used to install pieces of it, such as Filebeat.


Ansible .yml files

Playbooks:

[ansible/roles/filebeat-playbook.yml](../main/ansible/roles/filebeat-playbook.yml)

[ansible/roles/metricbeat-playbook.yml](../main/ansible/roles/metricbeat-playbook.yml)

Confugurations:

[ansible/files/filebeat-config.yml](../main/ansible/files/filebeat-config.yml)

[ansible/files/metricbeat-config.yml](../main/ansible/files/metricbeat-config.yml)

Installation:

[ansible/hosts](../main/ansible/hosts.txt)

[ansible/install-elk.yml](../main/ansible/install-elk.yml)

[ansible/install-DVWA.yml](../main/ansible/install-DVWA.yml)

### Table of Contents:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored

- How to Use the Ansible Build

### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available
 Access to the network is restricted by using a jumpbox as a remote access gateway via SSH

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the performance metrics and system logs. 


The configuration details of each machine may be found below.

| Name        | Function | IP Address        | Operating System |
|-------------|----------|-------------------|------------------|
| Jump Box    | Gateway  | 10.0.0.4          | Linux            |
|             |          | 191.239.183.201   |                  |
| web-1       | Web svr  | 10.0.0.5          | Linux            |
| web-2       | Web svr  | 10.0.0.6          | Linux            |
| web-3       | Web svr  | 10.0.0.7          | Linux            |
| ELK         | ELK Svr  | 10.1.0.4          | Linux            |
| 

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jumpbox machine can accept connections from the Internet.
Access to this machine is allowed only from the following IP address:

| Rule              | Port#  | Protocol  | SourceIP: (Witheld)  | Destination     | Action  |
|-------------------|--------|-----------|----------------------|-----------------|---------|
| PermitSSHfromDesk | 22     | TCP       | (curl ifconfig.me)   | Virtual Network | Permit  |


Remote management of the machines within the private network can only be accessed by the Jumpbox /Ansible control Node on SSH TCP 22

This table is a summary of the access policies in place.

| Name RedSecGrp      | Publicly Accessible | Allowed IP Addresses |
|---------------------|---------------------|----------------------|
| permitSSHjpboxtoPvt | No                  | 10.0.0.5             |
|                     |                     | 10.0.0.6             |
|                     |                     | 10.0.0.7             |
|                     |                     | =PrivateNetwork      |
| permitSSHjpBoxtoELK | No                  | 10.1.0.4


For external internet access to the DVWA application HTTP 8080 on the above 3 web servers

Made highly available via load balncer - 40.115.64.163 is the rule

| Name RedSecGrp      | Publicly Accessible | Allowed IP Addresses |
|---------------------|---------------------|----------------------|
| permitHTTPfromDesk  | yes                 | 40.115.64.163:5601   |                     |                     |                     | (Load ballancer IP)  |


### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because Ansible allows for the automation and standardisation of software and configuration changes across multiple machines. The roles and templates created for Ansible are reusable.
_

The playbook implements the following tasks in order:
- Establish an SSH connection to the ELK server from the Ansible control node
- Employ apt to install Docker, Python# and PIP in order
- Via inserted command line configure an increase of available virtual memory 
    (Especially for VM with only 4gig ram)
- Download and launch an ELK docker container and specify the required TCP port number ranges
- Configure systemd to automatically restart Docker after a server reboot

This screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![Docker PS Output][logo1]

[logo1]: ../main/diagrams/docker_ps_output.png "Docker PS Output"

### Target Machines & Beats
The ELK server is configured to accept beats information from the following machines:

| Name                | IP Addresses         |
|---------------------|----------------------|
| web-1               | 10.0.0.5             |
| web-2               | 10.0.0.6             |
| web-3               | 10.0.0.7             |


I have installed the following Beats on these machines: Both webbeat and filebeat

These Beats allow me to collect the following information from each machine:

Kibana Filebeat presents logged information about hostname syslog events and their processes, Sudo command use, SSH login attempts and new users & group activity.

EG. From wihin the Ansible Docker container the command `ansible -m ping all` will trigger an SSH connection to the 3x target web server machines that are listed in the hosts file
These become 3x visible SSH events in Kibana / filebeats - one per web server

Kibana Metricbeat presents System, Host and Container performance metrics

EG Installing the stress utility and using the command `stress --cpu 2` will send the server to high CPU. 
This is observable in the Kibana Metricbeat system and host dashboard as a %99 CPU utilisation event for that server

### Using the Playbook
In order to use the playbook, I will need to have an Ansible control node already configured. 
Using this control node: 

SSH into the Ansible control node and follow the steps below:

- Using curl copy the ELK config file to /etc/ansible/ directory
curl https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat > /etc/ansible/filebeat-config.yml

- Configure/test SSH connectivity from the Ansible docker node to each target server
Create ssh keygen key pair without a password
Within azure 'password and security' place the public key on all 3 x web VM 

- Update the /etc/ansible/hosts file to include the SSH connection command line for each target server
    Differentiate between `[webservers]` and `[elk]` server by using these headings
Test connectivity from within the Ansible container:  ansible all -m ping
This generates a SSH connection to each web server and the ELK server and produces a response per server
EG: sysadmin@10.0.0.9 | SUCCESS => {
     "changed": false,
     "ping": "pong"

- Run the ELK installation playbook, and navigate to the ELK server to check that the installation worked as expected.    ansible-playbook /etc/ansible/install-elk.yml

    Confirm the ELK server web GUI is up by connecting from desktop to http://20.36.45.50:5601/app/kibana 

    END


