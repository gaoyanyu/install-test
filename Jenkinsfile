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
  stages {
    stage('create configmap') {
      steps {
        container('docker') {
          sh 'sleep 10'
          sh 'apk add curl'
          sh 'cd /root && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl'
          sh 'cd /root && chmod +x ./kubectl'
          sh 'cd /root && mv ./kubectl /usr/local/bin/kubectl'
          sh 'cd /home/jenkins/agent/workspace/test_master && kubectl create -f cm-jenkins.yaml  --validate=false'
        }
      }
    }
    stage('login to harbor') {
      steps {
        container('docker-daemon') {
          sh 'sleep 10'
          sh 'mkdir -p /etc/docker && cp /home/jenkins/agent/workspace/test_master/daemon.json /etc/docker/'
          sh 'cd /root/ && docker login hub.easystack.io -u admin -p Admin@Harbor2019'
        }
      }
    }
    stage('Build docker image') {
      steps {
        container('docker') {
          sh 'cd /root/ && sleep 30'
          //sh 'cd /root/ && cp /root/Dockerfile /home/jenkins/agent/workspace/test/Dockerfile'
          sh 'cd /home/jenkins/agent/workspace/test_master && docker build -t hub.easystack.io/production/testing-docker-in-docker:latest .'
          sh 'cd /root/ && docker images'
          sh 'cd /root/ && sleep 10'
          sh 'docker push hub.easystack.io/production/testing-docker-in-docker:latest'
        }
      }
    }
  }
}
