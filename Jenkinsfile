pipeline {
    agent any

    environment {
        IMAGE_NAME = 'wellfit-hub.kr.ncr.ntruss.com/jarr'
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('Clone Repository') {
            steps {
                checkout scm
            }
        }

        stage('Build with Gradle') {
            steps {
                sh 'chmod +x ./gradlew'
                sh './gradlew clean build -x test'
            }
        }

        stage('Docker Check') {
            steps {
                echo '====++++executing Docker Check++++===='
                sh 'docker version'
            }
            post {
                always {
                    echo '====++++always++++===='
                }
                success {
                    echo '====++++Docker Check executed successfully++++===='
                }
                failure {
                    echo '====++++Docker Check execution failed++++===='
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t ${IMAGE_NAME}:${TAG} .'
                sh 'docker push ${IMAGE_NAME}:${TAG}'
            }
        }
    }
}
