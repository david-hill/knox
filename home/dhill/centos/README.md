podman build -t brew .
podman  run  -it  --privileged -v /home/dhill:/home/dhill localhost/brew:latest  bash
