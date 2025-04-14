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
  - name: kaniko
    image: gcr.io/kaniko-project/executor:latest
    args: ["--help"]
    tty: true
    volumeMounts:
      - name: kaniko-secret
        mountPath: /kaniko/.docker
  restartPolicy: Never
  volumes:
    - name: kaniko-secret
      secret:
        secretName: docker-secret
            '''
        }
    }

    environment {
        IMAGE_NAME = 'wellfit-hub.kr.ncr.ntruss.com/jarr'
        TAG = "${env.BUILD_NUMBER}"
        APPLICATION_PROPERTIES = credentials('jarr_application_properties')
        NAVER_PROPERTIES = credentials('jarr_naver_properties')
    }

    stages {
        stage('properties') {
            steps {
                sh 'cp -f ${APPLICATION_PROPERTIES} ./src/main/resources/application.properties'
                sh 'cp -f ${NAVER_PROPERTIES} ./src/main/resources/naver.properties'
            }
        }

        stage('Build with Gradle') {
            steps {
                sh 'chmod +x ./gradlew'
                sh './gradlew clean build'
            }
        }
        
        stage('kubectl check') {
            steps {
                sh 'kubectl version'
            }
        }

        // stage('Build Docker Image & Push to Docker Hub') {
        //     steps {
        //         container('kaniko') {
        //             sh 'ls -alF /kaniko/.docker'
        //             sh 'cat /kaniko/.docker/.dockerconfigjson'
        //             // sh "/kaniko/executor --context . --dockerfile Dockerfile --destination ${IMAGE_NAME}:${TAG}"
        //         }
        //     }
        // }

        // stage('Build Docker Image with Kaniko') {
        //     steps {
        //         container('kaniko') {
        //             sh '''
        //             /kaniko/executor \
        //             --dockerfile=Dockerfile \
        //             --context=. \
        //             --destination=${IMAGE_NAME}:${TAG}
        //             '''
        //         }
        //     }
        // }
    }

    post {
        always {
            echo 'The process is completed. '
        }
    }
}
