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
      - name: JENKINS_HARBOR_USER
        valueFrom:
          configMapKeyRef:
            name: jenkins-harbor
            key: HARBOR_USER
      - name: JENKINS_HARBOR_PASSWD
        valueFrom:
          configMapKeyRef:
            name: jenkins-harbor
            key: HARBOR_PASSWD
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
  volumes:
    - name: docker-build
      hostPath:
        path: /root/Dockerfile
    - name: dind-storage
      emptyDir: {}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: jenkins-harbor
  namespace: ems
data:
  HARBOR_USER: admin
  HARBOR_PASSWD: Admin@Harbor2019
"""
    }
  }
  stages {
    stage('login to harbor') {
      steps {
        container('docker') {
          sh 'cd /root/ && docker login -u ${JENKINS_HARBOR_USER} -p ${JENKINS_HARBOR_PASSWD}'
        }
      }
    }
    stage('Build docker image') {
      steps {
        container('docker') {
          sh 'cd /root/ && sleep 600'
          sh 'cd /root/ && docker build -t jenkins-test-dind .'
          sh 'cd /root/ && docker images'
          sh 'cd /root/ && sleep 600'
        }
      }
    }
  }
}
