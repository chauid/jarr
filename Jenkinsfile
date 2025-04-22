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
                    hello.sum(2, 3)
                }
            }
        }

        stage('print test') {
            steps {
                script {
                    hello.printSomething("${TAG}")
                    echo "BRANCH_NAME: ${BRANCH_NAME}"
                    echo "APPLICATION_PROPERTIES: ${APPLICATION_PROPERTIES}"
                    echo "BUILD_ID: ${BUILD_ID}"
                    echo "BUILD_NUMBER: ${BUILD_NUMBER}"
                    echo "BUILD_TAG: ${BUILD_TAG}"
                    echo "BUILD_URL: ${BUILD_URL}"
                    echo "EXECUTOR_NUMBER: ${EXECUTOR_NUMBER}"
                    echo "JAVA_HOME: ${JAVA_HOME}"
                    echo "JENKINS_URL: ${JENKINS_URL}"
                    echo "JOB_NAME: ${JOB_NAME}"
                    echo "NODE_NAME: ${NODE_NAME}"
                    echo "WORKSPACE: ${WORKSPACE}"

                    echo "RUN_DISPLAY_URL: ${RUN_DISPLAY_URL}"
                    echo "RUN_NUMBER: ${RUN_NUMBER}"
                    echo "RUN_URL: ${RUN_URL}"

                }
            }
        }
    }
}