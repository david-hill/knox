docker build -t centos8 .
docker run -it --privileged --net host -v /home/dhill:/home/dhill centos8
