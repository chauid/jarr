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
    image: jenkins/inbound-agent:latest
    resources:
      requests:
        memory: "512Mi"
        cpu: "500m"
  - name: kaniko
    image: gcr.io/kaniko-project/executor:debug
    command:
      - /busybox/cat
    tty: true
    resources:
      requests:
        memory: "512Mi"
        cpu: "500m"
    volumeMounts:
      - name: docker-secret
        mountPath: /kaniko/.docker/
  volumes:
    - name: docker-secret
      secret:
        secretName: docker-secret
            '''
        }
    }

    environment {
        IMAGE_NAME = 'wellfit-hub.kr.ncr.ntruss.com/jarr'
        TAG = "${env.BUILD_NUMBER}"
        APPLICATION_PROPERTIES = ('application.properties')
        NAVER_PROPERTIES = ('naver.properties')
    }

    stages {
        stage('properties') {
            steps {
                sh 'cp -f $APPLICATION_PROPERTIES ./src/main/resources/application.properties'
                sh 'cp -f $NAVER_PROPERTIES ./src/main/resources/naver.properties'
            }
        }

        stage('Build with Gradle') {
            steps {
                sh 'chmod +x ./gradlew'
                sh './gradlew clean build'
            }
        }

        stage('Build Docker Image & Push to Docker Hub') {
            steps {
                container('kaniko') {
                    sh 'ls -alF /kaniko/.docker'
                    sh 'cat /kaniko/.docker/.dockerconfigjson'
                    // sh "/kaniko/executor --context . --dockerfile Dockerfile --destination ${IMAGE_NAME}:${TAG}"
                }
            }
        }

        stage('kubectl check') {
            steps {
                sh 'kubectl version'
            }
        }
    }

    post {
        always {
            echo 'The process is completed. '
        }
    }
}
