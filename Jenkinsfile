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
      - name: docker-config
        mountPath: /root/Dockerfile
        subPath: Dockerfile
  - name: docker-daemon
    image: docker:dind
    imagePullPolicy: IfNotPresent
    tty: true
    securityContext:
      privileged: true
    env:
      - name: DOCKER_TLS_CERTDIR
        value: ""
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
  stages {
    stage('create configmap') {
      steps {
        container('docker') {
          sh 'sleep 30'
          sh 'cd /root && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.7.0/bin/linux/amd64/kubectl'
          sh 'cd /root && chmod +x ./kubectl'
          sh 'cd /root && mv ./kubectl /usr/local/bin/kubectl'
          sh 'cd /home/jenkins/agent/workspace/test_master && kubectl create -f cm-test.yaml  --validate=false'
        }
      }
    }
    stage('login to harbor') {
      steps {
        container('docker-daemon') {
          sh 'sleep 30'
          sh 'cd /root/ && docker login hub.easystack.io -u ${JENKINS_HARBOR_USER} -p ${JENKINS_HARBOR_PASSWD}'
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
          sh 'cd /root/ && sleep 3600'
          sh 'docker push hub.easystack.io/production/testing-docker-in-docker:latest'
        }
      }
    }
  }
}
