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
  - name: maven
    image: maven:alpine
    command:
    - cat
    tty: true
  - name: docker-dind
    image: hub.easystack.io/production/docker:dind-with-test-dockerfile
    command:
    - cat
    tty: true
"""
    }
  }
  stages {
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
        }
        container('docker-dind') {
          sh 'cd /root && docker build -t ubuntu-with-vi-dockerfile .'
          sh 'cd /root && sleep 600'
        }
      }
    }
  }
}
