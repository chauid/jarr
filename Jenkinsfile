@Library('my-shared-library') _

pipeline {
    agent any

    stages {
        stage('Hello World') {
            steps {
                script {
                    hello.greet('Test1')
                }
            }
        }

        stage('greet') {
            steps {
                script {
                    hello.greet('Test2')
                }
            }
        }

        stage('farewell') {
            steps {
                script {
                    hello.farewell('Test3')
                }
            }
        }
    }
}