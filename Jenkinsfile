pipeline {
  agent {
    docker {
      image 'sada'
    }

  }
  stages {
    stage('stage1') {
      agent {
        docker {
          image 'sadaaaaa'
        }

      }
      environment {
        test = 'haha'
      }
      steps {
        sh 'sadaa'
      }
    }

    stage('stage2') {
      parallel {
        stage('stage2') {
          agent {
            docker {
              image 'sadadsa'
            }

          }
          steps {
            sh 'sada'
          }
        }

        stage('') {
          agent {
            docker {
              image 'asda S'
            }

          }
          steps {
            sh 'sadad'
          }
        }

      }
    }

    stage('') {
      environment {
        sadsa = 'dsadsasa'
      }
      steps {
        echo 'ghsuiad'
      }
    }

  }
}