pipeline {
    agent any

    environment {
        DOCKERHUB_USERNAME = 'your-dockerhub-username'
        IMAGE_NAME         = 'jenkins-demo-app'
        IMAGE_TAG          = "${env.BUILD_NUMBER}"
    }

    stages {

        stage('Checkout') {
            steps {
                echo "📥 Pulling code from GitHub..."
                echo "Commit: ${env.GIT_COMMIT}"
            }
        }

        stage('Build App') {
            steps {
                echo "🔨 Installing dependencies..."
                sh 'npm install'
            }
        }

        stage('Test App') {
            steps {
                echo "🧪 Running tests..."
                sh 'npm test'
            }
        }

        stage('Build Docker Image') {
            steps {
                echo "🐳 Building Docker image..."
                sh """
                    docker build -t ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} .
                    docker tag ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG} \
                               ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest
                """
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "📤 Pushing image to Docker Hub..."
                withCredentials([usernamePassword(
                    credentialsId: 'dockerhub-credentials',
                    usernameVariable: 'wikkics',
                    passwordVariable: 'W!kk!cs@101200'
                )]) {
                    sh """
                        echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin
                        docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}
                        docker push ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest
                    """
                }
            }
        }

        stage('Deploy Container') {
            steps {
                echo "🚀 Deploying application..."
                sh """
                    # Stop existing container if running
                    docker stop jenkins-demo-app || true
                    docker rm jenkins-demo-app   || true

                    # Run new container
                    docker run -d \
                        --name jenkins-demo-app \
                        -p 3000:3000 \
                        ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:latest

                    echo "✅ App deployed on port 3000!"
                """
            }
        }
    }

    post {
        success {
            echo """
            ✅ Pipeline SUCCESS!
            Image: ${DOCKERHUB_USERNAME}/${IMAGE_NAME}:${IMAGE_TAG}
            App URL: http://localhost:3000
            """
        }
        failure {
            echo "❌ Pipeline FAILED at build #${env.BUILD_NUMBER}"
            sh 'docker stop jenkins-demo-app || true'
        }
        always {
            echo "🧹 Cleaning up unused Docker images..."
            sh 'docker image prune -f'
        }
    }
}
