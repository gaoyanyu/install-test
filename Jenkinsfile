pipeline {
  podTemplate(containers: [
    containerTemplate(
  containers:
    name: ‘docker-dind’,
    image: 'docker:dind',
    alwaysPullImage: false
    privileged: true
    envVars: [containerEnvVar(key: 'DOCKER_HOST', value: 'tcp://localhost:2375')]            
  volumes: [
    hostPathVolume(mountPath: '/root/Dockerfile/root/Dockerfile', hostPath: '/root/Dockerfile'),
    hostPathVolume(mountPath: '/etc/docker/daemon.json', hostPath: '/etc/docker/daemon.json'),
    emptyDirVolume(mountPath: '/var/lib/docker', memory: true)
  ]
  )]
  
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
