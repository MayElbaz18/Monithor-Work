all:
  children:
    jenkins_servers:
      hosts:
        jenkins:
          ansible_host: ${jenkins_master_ip}
          ansible_user: ${ssh_user}
          ansible_ssh_private_key_file: ${key_name}
    
    docker_agents:
      hosts:
        docker:
          ansible_host: ${docker_agent_ip}
          ansible_user: ${ssh_user}
          ansible_ssh_private_key_file: ${key_name}
    
    ansible_agents:
      hosts:
        ansible:
          ansible_host: ${ansible_agent_ip}
          ansible_user: ${ssh_user}
          ansible_ssh_private_key_file: ${key_name}
    
    monitoring:
      hosts:
%{ for index, ip in monitoring_instances_ips ~}
        monithor${index + 1}:
          ansible_host: ${ip}
%{ endfor ~}
    
    servers:
      children:
        jenkins_servers:
        docker_agents:
        ansible_agents:
        monitoring:
  
  vars:
    ansible_user: ${ssh_user}
    ansible_ssh_private_key_file: ${key_name}
    ansible_python_interpreter: /usr/bin/python3