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
  - name: jnlp
    image: jenkins/jnlp-slave:3.35-5-alpine
    imagePullPolicy: Always
    env:
    - name: POD_IP
      valueFrom:
        fieldRef:
          fieldPath: status.podIP
    - name: DOCKER_HOST
      value: tcp://localhost:2375
  - name: docker-dind
    image: hub.easystack.io/production/docker:dind
    imagePullPolicy: Always
    command:
    - cat
    tty: true
    securityContext:
      privileged: true
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
        container('jnlp') {
          sh 'cd /root && sleep 100'
          sh 'cd /root && docker build -t ubuntu-with-vi-dockerfile .'
          sh 'cd /root && docker images'
          sh 'cd /root && sleep 600'
        }
      }
    }
  }
}
