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
  - name: docker-dind
    image: hub.easystack.io/production/docker:dind-with-test-dockerfile
    imagePullPolicy: OnFailure
    command:
    - cat
    tty: true
    privileged: true
    volumeMounts:
      - name: daemon-json
        mountPath: /etc/docker/daemon.json
      - name: docker-build
        mountPath: /root/Dockerfile
  volumes:
    - name: daemon-json
      hostPath:
        path: /etc/docker/daemon.json
    - name: daemon-json
      hostPath:
        path: /root/Dockerfile
"""
    }
  }
  stages {
    stage('Build docker image') {
      steps {
        container('docker-dind') {
          sh 'cd /root && sleep 300'
          sh 'cd /root && docker build -t ubuntu-with-vi-dockerfile .'
          sh 'cd /root && docker images'
          sh 'cd /root && sleep 300'
        }
      }
    }
  }
}
