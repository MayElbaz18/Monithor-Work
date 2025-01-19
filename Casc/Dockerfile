
FROM jenkins/jenkins

# Add a label to specify the maintainer of the Dockerfile
LABEL maintainer="may.elbaz12@gmail.com"

# Switch to root user for administrative tasks
USER root

# Update the package repository and install lsb-release to determine distribution info
RUN apt-get update && apt-get install -y lsb-release

# Download and add Docker's official GPG key for secure package verification
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg

# Add Docker's stable repository to the system's package sources
RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Update the package list again and install the Docker CLI (not the full Docker engine)
RUN apt-get update && apt-get install -y docker-ce-cli

# Switch back to the Jenkins user for subsequent operations
USER jenkins

# Disable the Jenkins setup wizard by setting a system property
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Specify the location of the Jenkins Configuration-as-Code (CASC) file
ENV CASC_JENKINS_CONFIG /var/jenkins_home/casc.yaml

# Copy the plugin list file to the Jenkins reference directory
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt

# Copy the Configuration-as-Code YAML file to the Jenkins home directory
COPY casc.yaml /var/jenkins_home/casc.yaml

# Copy the Groovy scripts for nodes into the container
COPY nodes.groovy /usr/local/nodes.groovy

# Install Jenkins plugins specified in the plugins.txt file
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/ref/plugins.txt