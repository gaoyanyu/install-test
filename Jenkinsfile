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
    volumeMounts:
      - name: docker-file
        mountPath: /root/Dockerfile
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
      - name: harbor-config
        mountPath: /var/harbor_config
  volumes:
    - name: docker-build
      hostPath:
        path: /root/Dockerfile
    - name: dind-storage
      emptyDir: {}
    - configMap:
        defaultMode: 420
        name: jenkins
      name: harbor-config
"""
    }
  }
  stages {
    stage('login to harbor') {
      steps {
        container('docker-daemon') {
          sh 'cd /root/ && docker login -u  -p  '
        }
      }
    }
    stage('Build docker image') {
      steps {
        container('docker') {
          sh 'cd /root/ && sleep 1000'
          sh 'cd /root/ && docker build -t jenkins-test-dind .'
          sh 'cd /root/ && docker images'
          sh 'cd /root/ && sleep 600'
        }
      }
    }
  }
}
