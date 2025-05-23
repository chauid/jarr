@Library('my-shared-library') _

void setBuildStatus(String message, String context, String state) {
    step([
        $class: "GitHubCommitStatusSetter",
        reposSource: [$class: "ManuallyEnteredRepositorySource", url: env.GIT_URL],
        contextSource: [$class: "ManuallyEnteredCommitContextSource", context: context],
        errorHandlers: [[$class: "ChangingBuildStatusErrorHandler", result: "UNSTABLE"]],
        statusResultSource: [
            $class: "ConditionalStatusResultSource",
            results: [[$class: "AnyBuildResult", message: message, state: state]]
        ]
    ]);
}

pipeline {
    agent {
        kubernetes {
            yaml '''
apiVersion: v1
kind: Pod
metadata:
  namespace: jenkins
  labels:
    jenkins/agent-type: kaniko
spec:
  nodeSelector:
    nodetype: agent
  containers:
  - name: jnlp
    image: chauid/jenkins-inbound-agent:1.0
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
      - /busybox/cat
    tty: true
    volumeMounts:
      - name: docker-secret
        mountPath: /kaniko/.docker
  volumes:
    - name: docker-secret
      secret:
        secretName: docker-config-postsmith-hub
            '''
        }
    }

    stages {
        stage('Hello World') {
            steps {
                script {
                    test('Test1')
                    test.greet('World12')
                }
            }
        }

        stage('Bulid Status') {
            steps {
                script {
                    setBuildStatus("Build Pending1", "CI / Gradle Build", "PENDING")
                }
            }
        }

        stage('Copy Properties') {
            steps {
                script {
                    withCredentials([file(credentialsId: 'jarr_application_properties', variable: 'APPLICATION_PROPERTIES'), file(credentialsId: 'jarr_naver_properties', variable: 'NAVER_PROPERTIES')]) {
                        sh 'cp -f ${APPLICATION_PROPERTIES} ./src/main/resources/application.properties'
                        sh 'cp -f ${NAVER_PROPERTIES} ./src/main/resources/naver.properties'
                    }
                }
            }
        }

        stage('Build') {
            steps {
                script {
                    build()
                    build.gradle("BOOTJAR")
                    setBuildStatus("Build Complete2", "CD / ", "SUCCESS")
                }
            }
        }

        stage('set Dockerfile') {
            steps {
                script {
                    build.setDockerfile("springboot")
                }
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    def tag = sh(script: "sed -nE \"s/^version *= *'([^']+)'/\\1/p\" build.gradle", returnStdout: true).trim()
                    echo "tag: ${tag}"
                    build.image("postsmith-hub.kr.ncr.ntruss.com/jarr", env.BUILD_NUMBER, true)
                    setBuildStatus("Docker Image Build Complete3","CD / ", "PENDING")
                }
            }
        }

        stage('print test') {
            steps {
                echo "BRANCH_NAME: ${env.BRANCH_NAME}"
                echo "BRANCH_IS_PRIMARY: ${env.BRANCH_IS_PRIMARY}"
                echo "CHANGE_ID: ${env.CHANGE_ID}"
                echo "CHANGE_URL: ${env.CHANGE_URL}"
                echo "CHANGE_TITLE: ${env.CHANGE_TITLE}"
                echo "CHANGE_AUTHOR: ${env.CHANGE_AUTHOR}"
                echo "CHANGE_AUTHOR_DISPLAY_NAME: ${env.CHANGE_AUTHOR_DISPLAY_NAME}"
                echo "CHANGE_AUTHOR_EMAIL: ${env.CHANGE_AUTHOR_EMAIL}"
                echo "CHANGE_TARGET: ${env.CHANGE_TARGET}"
                echo "CHANGE_BRANCH: ${env.CHANGE_BRANCH}"
                echo "CHANGE_FORK: ${env.CHANGE_FORK}"
                echo "TAG_NAME: ${env.TAG_NAME}"
                echo "TAG_TIMESTAMP: ${env.TAG_TIMESTAMP}"
                echo "TAG_UNIXTIME: ${env.TAG_UNIXTIME}"
                echo "TAG_DATE: ${env.TAG_DATE}"
                echo "JOB_DISPLAY_URL: ${env.JOB_DISPLAY_URL}"
                echo "RUN_DISPLAY_URL: ${env.RUN_DISPLAY_URL}"
                echo "RUN_ARTIFACTS_DISPLAY_URL: ${env.RUN_ARTIFACTS_DISPLAY_URL}"
                echo "RUN_CHANGES_DISPLAY_URL: ${env.RUN_CHANGES_DISPLAY_URL}"
                echo "RUN_TESTS_DISPLAY_URL: ${env.RUN_TESTS_DISPLAY_URL}"
                echo "CI: ${env.CI}"
                echo "BUILD_NUMBER: ${env.BUILD_NUMBER}"
                echo "BUILD_ID: ${env.BUILD_ID}"
                echo "BUILD_DISPLAY_NAME: ${env.BUILD_DISPLAY_NAME}"
                echo "JOB_NAME: ${env.JOB_NAME}"
                echo "JOB_BASE_NAME: ${env.JOB_BASE_NAME}"
                echo "BUILD_TAG: ${env.BUILD_TAG}"
                echo "EXECUTOR_NUMBER: ${env.EXECUTOR_NUMBER}"
                echo "NODE_NAME: ${env.NODE_NAME}"
                echo "NODE_LABELS: ${env.NODE_LABELS}"
                echo "WORKSPACE: ${env.WORKSPACE}"
                echo "WORKSPACE_TMP: ${env.WORKSPACE_TMP}"
                echo "JENKINS_HOME: ${env.JENKINS_HOME}"
                echo "JENKINS_URL: ${env.JENKINS_URL}"
                echo "BUILD_URL: ${env.BUILD_URL}"
                echo "JOB_URL: ${env.JOB_URL}"
                echo "GIT_COMMIT: ${env.GIT_COMMIT}"
                echo "GIT_PREVIOUS_COMMIT: ${env.GIT_PREVIOUS_COMMIT}"
                echo "GIT_PREVIOUS_SUCCESSFUL_COMMIT: ${env.GIT_PREVIOUS_SUCCESSFUL_COMMIT}"
                echo "GIT_BRANCH: ${env.GIT_BRANCH}"
                echo "GIT_LOCAL_BRANCH: ${env.GIT_LOCAL_BRANCH}"
                echo "GIT_CHECKOUT_DIR: ${env.GIT_CHECKOUT_DIR}"
                echo "GIT_URL: ${env.GIT_URL}"
                echo "GIT_URL_1: ${env.GIT_URL_1}"
                echo "GIT_URL_2: ${env.GIT_URL_2}"
                echo "GIT_URL_3: ${env.GIT_URL_3}"
                echo "GIT_COMMITTER_NAME: ${env.GIT_COMMITTER_NAME}"
                echo "GIT_AUTHOR_NAME: ${env.GIT_AUTHOR_NAME}"
                echo "GIT_COMMITTER_EMAIL: ${env.GIT_COMMITTER_EMAIL}"
                echo "GIT_AUTHOR_EMAIL: ${env.GIT_AUTHOR_EMAIL}"

                echo "JAVA_HOME: ${env.JAVA_HOME}"
            }
        }

        stage('print test2') {
            steps {
                script {
                    test.printSomething("something")
                    sh "echo JAVA_HOME: ${env.JAVA_HOME}"
                    sh "echo JAVA_HOME: ${JAVA_HOME}"
                    setBuildStatus("Build Complete1", "asdf", "SUCCESS")
                    setBuildStatus("Build Complete2", "asdf", "SUCCESS")
                    setBuildStatus("Build Complete3", "asdf", "SUCCESS")
                }
            }
        }
    }
}