pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-hub-credentials'
        IMAGE_NAME = 'jayeshzimbal/portfolio'
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
                    // Build the image using the Jenkins Docker wrapper
                    app = docker.build("${env.IMAGE_NAME}")
                }
            }
        }

        stage('Push to Container Registry') {
            steps {
                echo "Pushing Docker image to registry..."
                script {
                    // This block automatically logs in, tags, and pushes securely using your credentials ID
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
