pipeline {
    agent {
        docker { image 'maven:alpine' }
    }
    stages {
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
        }
        container('busybox') {
          sh '/bin/busybox'
        }
      }
    }
    }
}
