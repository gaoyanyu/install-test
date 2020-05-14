def Version_Major = '1'
def Version_Minor  = '0'
def Version_Patch  = '0'
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
    image: hub.easystack.io/production/jnlp-slave:3.27-1
  - name: docker
    image: hub.easystack.io/production/docker:19.03.1
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
    image: hub.easystack.io/production/docker:dind
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
  environment {
      VERSION = VersionNumber([
          versionNumberString: '${Version_Major}.${Version_Minor}.${Version_Patch}.${BUILD_MONTH}', 
          worstResultForIncrement: 'SUCCESS'
      ]);
  }
  stages{
    stage('login to harbor') {
      steps{
          container('docker') {
            withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable: 'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
                sh "docker login hub.easystack.io -u ${dockerHubUser} -p ${dockerHubPassword}"
            }
          }
      }
    }
    stage('Build docker image') {
      steps{
          container('docker') {
              sh 'sleep 3'
              sh "echo $VERSION"
              sh 'cd /root/ && sleep 3600'
              sh 'cd /home/jenkins/agent/workspace/test_master && docker build -t hub.easystack.io/production/testing-docker-in-docker:latest .'
              sh 'cd /root/ && docker images'
              sh 'docker push hub.easystack.io/production/testing-docker-in-docker:latest'
          }
      }
    }
  } 
}
