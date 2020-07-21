FROM docker.io/busybox
RUN hostname > host.txt
CMD echo "always run"
