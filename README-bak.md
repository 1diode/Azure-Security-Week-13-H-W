## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![Azure Lab Network][logo]

[logo]: ../main/diagrams/azurelabnetwork.png "Azure Lab Network"


These files have been tested and used to generate a live ELK deployment on Azure. 
They can be used to either recreate the entire deployment pictured above. 
Alternatively, select portions of the yaml file may be used to install only certain pieces of it, such as Filebeat.


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

This document contains the following details:
- Description of the Topology
- Access Policies
- ELK Configuration
  - Beats in Use
  - Machines Being Monitored

- How to Use the Ansible Build

### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

Load balancing ensures that the application will be highly available via load ballancing, in addition to restricting access to the network by using a jumpbox as a remote access gateway

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the performance metrics and system logs. 


The configuration details of each machine may be found below.
### _Note: Use the [Markdown Table Generator](http://www.tablesgenerator.com/markdown_tables) to add/remove values from the table_.


| Name        | Function | IP Address        | Operating System |
|-------------|----------|-------------------|------------------|
| Jump Box    | Gateway  | 10.0.0.4          | Linux            |
|             |          | 191.239.183.201   |                  |
| web-1       | Web svr  | 10.0.0.5          | Linux            |
| web-2       | Web svr  | 10.0.0.6          | Linux            |
| web-3       | Web svr  | 10.0.0.7          | Linux            |
|             |          |                   |                  |

### Access Policies

The machines on the internal network are not exposed to the public Internet. 

Only the jumpbox machine can accept connections from the Internet.
Access to this machine is only allowed from the following IP address:

| Rule              | Port#  | Protocol  | SourceIP: (Witheld)  | Destination     | Action  |
|-------------------|--------|-----------|----------------------|-----------------|---------|
| PermitSSHfromDesk | 22     | TCP       | (curl ifconfig.me)   | Virtual Network | Permit  |


Remote management the machines within the private network can only be accessed by the Jumpbox /Ansible control Node on SSH TCP 22

A summary of the access policies in place can be found in the table below.

| Name RedSecGrp      | Publicly Accessible | Allowed IP Addresses |
|---------------------|---------------------|----------------------|
| permitSSHjpboxtoPvt | No                  | 10.0.0.5             |
|                     |                     | 10.0.0.6             |
|                     |                     | 10.0.0.7             |
|                     |                     | =PrivateNetwork      |


For external internet access to the DVWA application HTTP 8080 on the above 3 web servers

Made highly available via load balncer - 40.115.64.163 is the rule

| Name RedSecGrp      | Publicly Accessible | Allowed IP Addresses |
|---------------------|---------------------|----------------------|
| permitHTTPfromDesk  | yes                 | 40.115.64.163:5601   |                     |                     |                     |                      |


### Elk Configuration

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which is advantageous because Ansible allows for the automation and standardisation of software and configuration changes across multiple machines. The roles and trmplated created for Ansible are reusable.
_

The playbook implements the following tasks:
- Establish an SSH connection to the ELK server from the Ansible control node
- Employ apt to install Docker, Python# and PIP in order
- Via command line command and configure an increase of available virtual memory 
    (Especially for VM with only 4gig ram)
- Download and launch an ELK docker container and specify required TCP port number ranges
- Configure systemd to automatically restart Docker after a server reboot

The following screenshot displays the result of running `docker ps` after successfully configuring the ELK instance.

![Docker PS Output][logo1]

[logo1]: ../main/diagrams/docker_ps_output.png "Docker PS Output"

### Target Machines & Beats
This ELK server is configured to monitor the following machines:

| Name                | IP Addresses         |
|---------------------|----------------------|
| web-1               | 10.0.0.5             |
| web-2               | 10.0.0.6             |
| web-3               | 10.0.0.7             |


We have installed the following Beats on these machines: Both webbeat and filebeat

These Beats allow us to collect the following information from each machine:

Kibana Filebeat presents logged information about a hostnames syslog events and their processes, Sudo command use, SSH login attempts and new users & group activity.
EG. From wihin the Ansible Docker container the command `ansible -m ping all` will trigger an SSH connection to the target machines listed in the hosts file
These become 3x visible SSH events in Kibana / filebeats - one per web server

Kibana Metricbeat presents System, Host and Container performance metrics
By installing the stress utility and using the command `stress --cpu 2` a web server can be sent to high CPU which triggers a %99 CPU event for the server in the system and host dashboards

### Using the Playbook
In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the _____ file to _____.- Update the _____ file to include...
- Run the playbook, and navigate to ____ to check that the installation worked as expected.

_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it?_
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- _Which URL do you navigate to in order to check that the ELK server is running?

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._

## can you copy files over a SSH connection or ??? whats needed - try and document it