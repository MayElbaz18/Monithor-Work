pipeline {
    agent {
        label 'docker'
    }

    stages {
        stage('Clean Workspace') {
            steps {
                script {
                    cleanWs()
                    echo "Workspace cleaned."
                    sh '''
                    sudo docker rm -f $(sudo docker ps -a -q) || true
                    '''
                }
                echo "Docker containers removed."
            }
        }

        stage('Clone repo') {
            steps {
                script {
                    git branch: 'main', url: 'https://github.com/MayElbaz18/MoniTHOR--Project.git'             
                    fullCommitId = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                    commitId = fullCommitId.substring(0, 5)                
                }
                echo "Clone repo success!"
            }
        }        

        stage('Docker build & run - Monithor - WebApp image') {
            steps {
                script {
                    sh """
                    sudo docker build -t monithor:${fullCommitId}  .
                    sudo docker run --network host -d -p 8080:8080 --name monithor_container monithor:temp
                    """
                }
            }
        }

        stage('Move .env file to dir') {
            steps {
                script {
                    sh """
                    sudo docker cp /root/.env monithor_container:/MoniTHOR--Project
                    """
                }
            }
        }

        stage('Docker build & run - Selenium image') {
            steps {
                dir('selenium'){
                    script {
                        sh """
                        sudo docker build -t selenium:${fullCommitId} .
                        sudo docker run -d --network host --name selenium_container selenium:temp
                        """
                    }
                }
            }
        }


        stage('Docker push to docker hub ') {
            steps {
                    script {
                        sh """
                        sudo docker push monithor:${fullCommitId}  .
                        """               
                    }
            }
        }



        stage('Show Results - Selenium') {
            steps {
                script {
                    sh """
                    sudo docker logs -f selenium_container
                    """
                }
            }
          
        }

        stage('Check Requests In Monithor-WebApp') {
            steps {
                script {
                    sh """
                    sudo docker logs monithor_container
                    """
                }
            }
        }
    }


agent {
        label 'ansible'
}
    
        stage('Deploy to prod nodes ') {
            steps {
                script {
                    
                    sh '''
                    
                    "ansible playbook" 

                    '''
                }
                echo "Finished deployment on prod nodes"
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    