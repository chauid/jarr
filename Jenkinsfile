@Library('my-shared-library') _

pipeline {
    agent any

    environment {
        IMAGE_NAME = 'wellfit-hub.kr.ncr.ntruss.com/wellfit'
        TAG = "${env.BUILD_NUMBER}"
        APPLICATION_PROPERTIES = credentials('wellfit_application_properties')
        BRANCH_NAME = "${env.BRANCH_NAME}"
    }

    stages {
        stage('Hello World') {
            steps {
                script {
                    hello('Test1')
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

        stage('print test') {
            steps {
                script {
                    hello.printSomething(${BRANCH_NAME})
                }
            }
        }
    }
}