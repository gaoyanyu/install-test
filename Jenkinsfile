pipeline {
  agent any
  stages {
    stage('stage1') {
      agent {
        docker {
          image 'busybox:1.32.0'
        }

      }
      steps {
        sh 'sleep 200'
        sh 'docker login hub.easystack.cn -u ${HUB_CREDS_USR} -p ${HUB_CREDS_PSW}'
      }
    }

  }
  environment {
    dockerHub = 'credentials(\'dockerHub\')'
  }
}
