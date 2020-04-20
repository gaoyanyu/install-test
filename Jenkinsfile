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
    image: docker:dind
    imagePullPolicy: IfNotPresent
    securityContext:
      privileged: true
    env:
    - name: DOCKER_HOST
      value: tcp://localhost:2375
    volumeMounts:
      - name: daemon-json
        mountPath: /etc/docker/daemon.json
      - name: dind-storage
        mountPath: /var/lib/docker
      - name: docker-file
        mountPath: /root/Dockerfile
  volumes:
    - name: daemon-json
      hostPath:
        path: /etc/docker/daemon.json
    - name: docker-file
      hostPath:
        path: /root/Dockerfile
    - name: dind-storage
      emptyDir: {}
"""
    }
  }
  stages {
    stage('Build docker image') {
      steps {
        container('docker-dind') {
          sh 'cd /root && sleep 100'
          //sh 'dockerd -H tcp://0.0.0.0:2376'
          sh 'cd /root && docker build -t ubuntu-with-vi-dockerfile .'
          sh 'cd /root && docker images'
          sh 'cd /root && sleep 600'
        }
      }
    }
  }
}
