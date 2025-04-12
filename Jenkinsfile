pipeline {
    agent any

    environment {
        IMAGE_NAME = "wellfit-hub.kr.ncr.ntruss.com/jarr"
        TAG = "${env.BUILD_NUMBER}"
    }

    stages {
        stage('git clone') {
            steps {
                checkout scm
            }
        }

        stage('Build with Gradle') {
            steps {
                sh './gradlew clean build -x test'
            }
        }
    }
}