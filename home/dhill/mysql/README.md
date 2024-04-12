podman --log-level=debug run -d --replace  --name mariadb_03785133  -v /cases/03785133:/var/lib/mysql:z -v /etc/localtime:/etc/localtime:ro --mount type=tmpfs,destination=$HOME/tmp --net=host -e MYSQL_ROOT_PASSWORD=root registry.redhat.io/rhel8/mariadb-103:1-234

podman exec -it mariadb_03785133 mysql -uroot -proot -hknox.orion
