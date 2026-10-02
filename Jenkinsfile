pipeline {
    agent any

    environment {
        DOCKER_CREDENTIALS_ID = 'docker-tocken'
        IMAGE_NAME = 'jayeshzimbal/portfolio'
        TAG = "${env.BUILD_NUMBER}"
        PREV_TAG = "${env.BUILD_NUMBER.toInteger() - 1}"
        CONTAINER_NAME = 'portfolio-app'
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
                    app = docker.build("${env.IMAGE_NAME}")
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

        stage('Rolling Deployment') {
            steps {
                echo "Performing rolling deployment for version ${env.TAG}..."
                sh '''
                    # Ensure docker network or ports are handled safely
                    # If an old container exists, stop it gracefully or start a new version on a temporary port / swap
                    docker stop ${CONTAINER_NAME} || true
                    docker rm ${CONTAINER_NAME} || true
                    
                    # Run the new container version
                    docker run -d --name ${CONTAINER_NAME} -p 80:80 ${IMAGE_NAME}:${TAG}
                '''
            }
        }

        stage('Verify') {
            steps {
                echo "Verifying application health..."
                sh '''
                    sleep 3
                    # Check if local endpoint returns HTTP 200
                    HTTP_STATUS=$(curl -o /dev/null -s -w "%{http_code}\n" http://localhost)
                    if [ "$HTTP_STATUS" -eq 200 ]; then
                        echo "Verification Passed: Application is live and responding with HTTP 200."
                    else
                        echo "Verification Failed: Endpoint returned HTTP status $HTTP_STATUS"
                        exit 1
                    fi
                '''
            }
        }
    }

    post {
        success {
            echo "Pipeline completed successfully! Portfolio image pushed and deployed with tag ${env.TAG}."
        }
        failure {
            echo "Pipeline failed or verification failed! Initiating automated rollback..."
            sh '''
                echo "Rolling back to previous stable tag: ${PREV_TAG}"
                docker stop ${CONTAINER_NAME} || true
                docker rm ${CONTAINER_NAME} || true
                
                # Try running the previous tag, fallback to latest if previous doesn't exist
                docker run -d --name ${CONTAINER_NAME} -p 80:80 ${IMAGE_NAME}:${PREV_TAG} || docker run -d --name ${CONTAINER_NAME} -p 80:80 ${IMAGE_NAME}:latest || echo "Rollback container start failed."
            '''
        }
    }
}
