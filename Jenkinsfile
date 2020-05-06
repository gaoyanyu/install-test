pipeline {
  agent {
    kubernetes {
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    some-label: some-label-value
spec:
  nodeSelector:
    openstack-control-plane: enabled
  containers:
  - name: docker
    image: docker:19.03.1
    imagePullPolicy: IfNotPresent
    command:
    - sleep
    args:
    - 99d
    tty: true
    env:
      - name: DOCKER_HOST
        value: tcp://localhost:2375
  - name: docker-daemon
    image: docker:dind
    imagePullPolicy: IfNotPresent
    tty: true
    securityContext:
      privileged: true
    env:
      - name: DOCKER_TLS_CERTDIR
        value: ""
    volumeMounts:
      - name: dind-storage
        mountPath: /var/lib/docker
  volumes:
    - name: dind-storage
      emptyDir: {}
"""
    }
  }
  stages{
    stage('login to harbor') {
      checkout scm
      def docker_registry = "hub.easystack.io"
      steps {
        container('docker') {
          sh "sleep 30"
          withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')])
          sh "docker login ${docker_registry} -u ${dockerHubUser} -p ${dockerHubPassword}"
          sh "sleep 60"
          //sh 'cd /root/ && docker login hub.easystack.io -u ${JENKINS_HARBOR_USER} -p ${JENKINS_HARBOR_PASSWD}'
        }
      }
    }
    stage('Build docker image') {
      steps {
        container('docker') {
          sh 'cd /root/ && sleep 60'
          //sh 'cd /root/ && cp /root/Dockerfile /home/jenkins/agent/workspace/test/Dockerfile'
          sh 'cd /home/jenkins/agent/workspace/test_master && docker build -t hub.easystack.io/production/testing-docker-in-docker:latest .'
          sh 'cd /root/ && docker images'
          sh 'cd /root/ && sleep 60'
          sh 'docker push hub.easystack.io/production/testing-docker-in-docker:latest'
        }
      }
    }
  } 
}
