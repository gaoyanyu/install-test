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
    imagePullPolicy: Always
    command:
    - cat
    tty: true
    privileged: true
    volumeMounts:
      - name: daemon-json
        mountPath: /etc/docker/daemon.json
      - name: docker-build
        mountPath: /root/Dockerfile
      - name: docker-sock
        mountPath: /var/run/docker.sock
  volumes:
    - name: daemon-json
      hostPath:
        path: /etc/docker/daemon.json
    - name: docker-build
      hostPath:
        path: /root/Dockerfile
    - name: docker-sock
      hostPath:
        path: /var/run/docker.sock
"""
    }
  }
  stages {
    stage('Build docker image') {
      steps {
        container('docker-dind') {
          sh 'cd /root && sleep 200'
          sh 'cd /root && docker build -t ubuntu-with-vi-dockerfile .'
          sh 'cd /root && docker images'
          sh 'cd /root && sleep 300'
        }
      }
    }
  }
}
