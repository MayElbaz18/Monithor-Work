import jenkins.model.*
import hudson.slaves.*
import hudson.model.Node.Mode
import hudson.slaves.EnvironmentVariablesNodeProperty.Entry

def createNode(name, remoteFS, labels, description) {
    def jenkins = Jenkins.getInstance()
    def existingNode = jenkins.getNode(name)

    if (existingNode == null) {
        println "Creating node: ${name}"
        def launcher = new hudson.slaves.JNLPLauncher()
        def node = new DumbSlave(
            name, // Node name
            description, // Description
            remoteFS, // Remote FS root
            "1", // Number of executors
            Mode.NORMAL, // Usage mode (NORMAL: used as much as possible)
            labels, // Labels
            launcher, // Launch method
            new RetentionStrategy.Always() // Retention strategy
        )

        // Add environment variables
        def envVarsNodeProperty = new EnvironmentVariablesNodeProperty(
            new Entry('NODE_TYPE', labels)
        )
        node.getNodeProperties().add(envVarsNodeProperty)

        jenkins.addNode(node)
        println "Node ${name} created successfully."
    } else {
        println "Node ${name} already exists."
    }
}

// Create a node for Docker jobs
createNode(
    name = "docker-node",
    remoteFS = "/var/jenkins_home/docker",
    labels = "docker",
    description = "Node dedicated to running Docker jobs"
)

// Create a node for Ansible jobs
createNode(
    name = "ansible-node",
    remoteFS = "/var/jenkins_home/ansible",
    labels = "ansible",
    description = "Node dedicated to running Ansible jobs"
)
