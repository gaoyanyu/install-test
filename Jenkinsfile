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
    imagePullPolicy: Always
    command:
    - cat
    tty: true
    securityContext:
      privileged: true
    env:
    - name: DOCKER_HOST
      value: tcp://localhost:2375
    volumeMounts:
      - name: daemon-json
        mountPath: /etc/docker/daemon.json
      - name: docker-build
        mountPath: /root/Dockerfile
      - name: dind-storage
        mountPath: /var/lib/docker
  volumes:
    - name: daemon-json
      hostPath:
        path: /etc/docker/daemon.json
    - name: docker-build
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
          sh 'cd /root/ && sleep 1000'
          sh 'cd /root/ && docker build -t jenkins-test-dind .'
          sh 'cd /root/ && docker images'
          sh 'cd /root/ && sleep 600'
        }
      }
    }
  }
}
