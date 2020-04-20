pipeline {
  agent {
    kubernetes {
      yamlFile 'KubernetesPod.yaml'
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
