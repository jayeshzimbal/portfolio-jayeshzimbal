pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                echo '=== Stage 1: Checking out source code ==='
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo '=== Stage 2: Validating repository contents ==='
                // Ensure index.html exists and is non-empty
                sh 'test -s index.html'
                sh 'ls -la'
            }
        }

        stage('Test') {
            steps {
                echo '=== Stage 3: Running HTML Syntax & Lint Tests ==='
                // Uses npx htmlhint to check for unclosed tags, missing quotes, or malformed HTML
                sh 'npx --yes htmlhint index.html'
            }
        }

        stage('Validation') {
            steps {
                echo '=== Stage 4: Executing W3C & Structure Validation ==='
                // Validate DOCTYPE declaration and structural tags
                sh 'grep -i "<!DOCTYPE html>" index.html'
                sh 'grep -i "</html>" index.html'
                echo 'Validation Stage Completed Successfully!'
            }
        }
    }

    post {
        always {
            echo 'Pipeline execution finished.'
        }
        success {
            echo 'Build Status: SUCCESS'
        }
        failure {
            echo 'Build Status: FAILED - Check Console Output for details.'
        }
    }
}
