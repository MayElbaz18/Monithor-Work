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
                            env.COMMIT_ID = sh(script: 'git rev-parse HEAD', returnStdout: true).trim()
                            commitId = env.COMMIT_ID.substring(0, 5)
                        }
                        echo "Clone repo success!"
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
                            sh """
                            sudo docker push monithor:${env.COMMIT_ID} .
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
                            ansible-playbook -i inventory main.yml --extra-vars "docker_tag=${env.COMMIT_ID}"
                            """
                        }
                        echo "Finished deployment on prod nodes"
                    }
                }
            }
        }
    }
}
