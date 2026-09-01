pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code from GitHub...'
                checkout scm
            }
        }
        stage('Build') {
            steps {
                echo 'Building application workspace...'
                sh 'ls -la'
            }
        }
        stage('Test') {
            steps {
                echo 'Executing basic sanity test...'
                sh 'test -f index.html && echo "index.html exists!"'
            }
        }
    }
    post {
        always {
            echo 'Pipeline execution finished.'
        }
    }
}
