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
    image: hub.easystack.io/production/docker:19.03.1
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
    image: hub.easystack.io/production/docker:dind
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
      - name: docker-config
        mountPath: /etc/docker/daemon.json
        subPath: daemon.json
  volumes:
    - name: dind-storage
      emptyDir: {}
    - name: docker-config
      configMap:
        name: jenkins-harbor
"""
    }
  }
  stages{
    stage('login to harbor') {
      steps {
        container('docker') {
          sh "sleep 100"
          withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
              sh "docker login hub.easystack.io -u ${dockerHubUser} -p ${dockerHubPassword}"
              sh "sleep 60"
          }
        }
      }
    }
    stage('Build docker image') {
      steps {
        container('docker') {
          sh 'cd /root/ && sleep 60'
          sh 'cd /home/jenkins/agent/workspace/test_master && docker build -t hub.easystack.io/production/testing-docker-in-docker:latest .'
          sh 'cd /root/ && docker images'
          sh 'cd /root/ && sleep 60'
          sh 'docker push hub.easystack.io/production/testing-docker-in-docker:latest'
        }
      }
    }
  } 
}
