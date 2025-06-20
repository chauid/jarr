@Library('my-shared-library') _

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
    image: chauid/jenkins-inbound-agent:jdk17-k8s
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
                    env.STAGE_NUMBER = 0
                    test('Test1')
                    test.greet('World12')
                }
            }
        }

        stage('Bulid Status') {
            steps {
                script {
                    echo "${env.GIT_URL}"
                    env.DEPLOY_TAG = build.getProjectVersion("springboot")
                    env.DEPLOY_NAME = "postsmith-hub.kr.ncr.ntruss.com/jarr"
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
                    env.STAGE_NUMBER = 1
                    github.setCommitStatus("Build Pending1", "CI / Gradle Build", "PENDING")
                    build()
                    build.gradle("BOOTJAR")
                    github.setCommitStatus("Build Complete2", "CI / Gradle Build", "SUCCESS")
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
                    env.STAGE_NUMBER = 2
                    github.setCommitStatus("Build Pending3", "CI / Docker Build", "PENDING")
                    build.image(env.DEPLOY_NAME, env.DEPLOY_TAG, true)
                    github.setCommitStatus("Build Complete4", "CI / Docker Build", "SUCCESS")
                }
            }
        }

        stage('Deploy K8s') {
            when {
                anyOf { branch 'main'; branch 'PR-*' }
            }
            steps {
                script {
                    env.STAGE_NUMBER = 3
                    github.setCommitStatus("Deploy Pending", "CD / Kubernetes Rollout", "PENDING")
                    k8s()
                    k8s.deploy("jarr-app-deploy", "jarr-app", "default", env.DEPLOY_NAME, env.DEPLOY_TAG)
                    github.setCommitStatus("Deploy Complete", "CD / Kubernetes Rollout", "SUCCESS")
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
                    github.setCommitStatus("Pipeline Complete Successfully", "Jenkins Pipeline", "SUCCESS")
                }
            }
        }
    }

    post {
        unsuccessful {
            script {
                switch (env.STAGE_NUMBER) {
                    case 0:
                        github.setCommitStatus("Failed to initialize the build process.", "Jenkins", "FAILURE")
                        break
                    case 1:
                        github.setCommitStatus("Build Pending1", "CI / Gradle Build", "FAILURE")
                        break
                    case 2:
                        github.setCommitStatus("Build Pending3", "CI / Docker Build", "FAILURE")
                        break
                    case 3:
                        github.setCommitStatus("Deploy Pending", "CD / Kubernetes Rollout", "FAILURE")
                        break
                }
            }
        }
    }
}