pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                echo 'Code pulled from GitHub successfully!'
                echo "Branch: ${env.BRANCH_NAME ?: 'main'}"
            }
        }

        stage('Build') {
            steps {
                echo 'Building the application...'
                sh 'echo "Build completed at $(date)"'
            }
        }

        stage('Test') {
            steps {
                echo 'Running test suite...'
                sh 'echo "All tests passed!"'
            }
        }

        stage('Deploy') {
            steps {
                echo 'Deploying application...'
                sh 'echo "Deployed successfully!"'
            }
        }
    }

    post {
        success {
            echo '✅ Pipeline completed successfully!'
        }
        failure {
            echo '❌ Pipeline failed — check the logs!'
        }
    }
}
