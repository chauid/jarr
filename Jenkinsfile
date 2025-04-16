@Library('my-shared-library') _

pipeline {
    agent any

    stages {
        stage('Hello World') {
            steps {
                hello('Test1')
            }
        }

        stage('greet') {
            steps {
                hello.greet('Test2')
            }
        }

        stage('farewell') {
            steps {
                hello.farewell('Test3')
            }
        }
    }
}