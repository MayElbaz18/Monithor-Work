pipeline {
    agent none
    
    environment {
        COMMIT_ID = ''
    }
    
    stages {
        stage('Docker Operations') {
            agent {
                label 'docker-agent'
            }
            stages {
                stage('Docker Hub Login') {
                    steps {
                        script {
                            def configFile = readFile('/home/ubuntu/jenkins_agent/hub.cfg').trim()
                            def config = [:]
                            configFile.split('\n').each { line ->
                                def (key, value) = line.split('=')
                                config[key] = value
                            }
                            sh """
                            sudo docker login -u ${config.DOCKERHUB_USERNAME} -p ${config.DOCKERHUB_PASSWORD}
                            """
                            echo "Docker Hub login successful"
                        }
                    }
                }

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
                            // Clean the workspace completely
                            sh '''
                                sudo rm -rf *
                                sudo rm -rf .git
                            '''
                            
                            // Clone and setup
                            sh '''
                                sudo git clone https://github.com/MayElbaz18/MoniTHOR--Project.git .
                                sudo git checkout main
                            '''
                            
                            // Store commit ID in a temporary file to avoid any output formatting issues
                            sh '''
                                sudo git rev-parse HEAD > commit.txt
                                sudo chmod 666 commit.txt
                            '''
                            
                            // Read the commit ID from the file
                            env.COMMIT_ID = readFile('commit.txt').trim()
                            
                            echo "Environment COMMIT_ID: ${env.COMMIT_ID}"
                            
                            // Verify the commit ID was captured
                            if (!env.COMMIT_ID) {
                                error "Failed to get commit ID"
                            }
                            
                            // Clean up
                            sh 'rm -f commit.txt'
                        }
                    }
                }

                stage('Docker build & run - Monithor - WebApp image') {
                    steps {
                        script {
                            sh """
                            sudo docker build -t monithor:${env.COMMIT_ID} .
                            sudo docker run --network host -d -p 8080:8080 --name monithor_container monithor:${env.COMMIT_ID}
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
                        dir('selenium') {
                            script {
                                sh """
                                sudo docker build -t selenium:${env.COMMIT_ID} .
                                sudo docker run -d --network host --name selenium_container selenium:${env.COMMIT_ID}
                                """
                            }
                        }
                    }
                }

                stage('Docker push to docker hub') {
                    steps {
                        script {
                            def configFile = readFile('/home/ubuntu/jenkins_agent/hub.cfg').trim()
                            def config = [:]
                            configFile.split('\n').each { line ->
                                def (key, value) = line.split('=')
                                config[key] = value
                            }
                            sh """
                            sudo docker tag monithor:${env.COMMIT_ID} ${config.DOCKERHUB_USERNAME}/monithor:${env.COMMIT_ID}
                            sudo docker push ${config.DOCKERHUB_USERNAME}/monithor:${env.COMMIT_ID}
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
        }
        
        stage('Ansible Operations') {
            agent {
                label 'ansible-agent'
            }
            stages {
                stage('Deploy to prod nodes') {
                    steps {
                        script {
                            sh """
                            echo "Deploying using Ansible with Docker image tag: ${env.COMMIT_ID}"
                            cd /home/ubuntu/infra/ansible
                            ansible-playbook -i inventory.yaml main.yaml --extra-vars "docker_tag=${env.COMMIT_ID}"
                            """
                        }
                        echo "Finished deployment on prod nodes"
                    }
                }
            }
        }
    }
}
