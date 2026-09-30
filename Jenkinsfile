pipeline {
    agent any

    environment {
        // Replace with your actual Docker Hub credentials ID created in Jenkins
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        IMAGE_NAME = 'jayeshzimbal/portfolio' // Update with your Docker Hub username/repo
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo "Preparing static portfolio assets..."
                sh 'ls -la'
            }
        }

        stage('Test') {
            steps {
                echo "Running automated checks on HTML files..."
                sh '''
                    if [ -f "index.html" ]; then
                        echo "Test Passed: index.html exists."
                    else
                        echo "Test Failed: index.html is missing!"
                        exit 1
                    fi
                '''
            }
        }

        stage('Package & Docker Build') {
            steps {
                echo "Building Docker image..."
                script {
                    app = docker.build("${env.IMAGE_NAME}:${env.TAG}")
                }
            }
        }

        stage('Push to Container Registry') {
            steps {
                echo "Pushing Docker image to registry..."
                script {
                    docker.withRegistry('https://registry.hub.docker.com', "${env.DOCKER_CREDENTIALS_ID}") {
                        app.push("${env.TAG}")
                        app.push("latest")
                    }
                }
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Portfolio image pushed with tag ${env.TAG}."
        }
        failure {
            echo "Pipeline failed. Please check the logs."
        }
    }
}
