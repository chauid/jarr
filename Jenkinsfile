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
        secretName: docker-config
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
        stage('Copy Properties') {
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

        stage('Spring Boot Version Check') {
            steps {
                sh """
                    VERSION=\$(sed -nE "s/^version *= *'([^']+)'/\\1/p" build.gradle)
                    sed -i "s/{VERSION}/\${VERSION}/g" Dockerfile
                """
            }
        }

        stage('Build Docker Image & Push to Registry') {
            steps {
                container('kaniko') {
                    sh "/kaniko/executor --context . --dockerfile Dockerfile --destination ${IMAGE_NAME}:${TAG}"
                }
            }
        }

        stage('Deploy to Kubernetes') {
            steps {
                script {
                    def deploymentName = 'wellfit-app'
                    def namespace = 'wellfit-deploy'
                    def imageTag = "${IMAGE_NAME}:${TAG}"

                    sh """
                        kubectl set image deployment/\${deploymentName} \${deploymentName}=\${imageTag} -n \${namespace}
                        kubectl rollout status deployment/\${deploymentName} -n \${namespace}
                    """
                }
            }
        }
    }

    post {
        always {
            echo 'The process is completed. '
        }
    }
}
