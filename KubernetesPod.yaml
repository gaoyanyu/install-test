podTemplate(containers: [
  containerTemplate(
  name: 'docker-dind',
  image: 'docker:dind',
  alwaysPullImage: false,
  privileged: true,
  envVars: [containerEnvVar(key: 'DOCKER_HOST', value: 'tcp://localhost:2375')],
volumes: [
  hostPathVolume(mountPath: '/root/Dockerfile/root/Dockerfile', hostPath: '/root/Dockerfile'),
  hostPathVolume(mountPath: '/etc/docker/daemon.json', hostPath: '/etc/docker/daemon.json'),
  emptyDirVolume(mountPath: '/var/lib/docker', memory: true)
]
)]
)
