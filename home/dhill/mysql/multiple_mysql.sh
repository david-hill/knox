set -x
user=dhill
hostname=knox.orion
file=

if [ -z $1 ]; then
  exit;
fi

if [ ! -e /cases/ ]; then
   echo creating /cases
   sudo mkdir /cases
   sudo chmod 777 /cases
fi

case=$1
if [ ! -e $case ]; then
  mkdir $case
else
  sudo rm -rf $case
  mkdir $case
fi

cd $case
while ssh supportshell-1.sush-001.prod.us-west-2.aws.redhat.com "ps -fu $user | grep -v grep | grep -q '[y]ank'"; do
   echo -n "."
   sleep 10
done

ssh supportshell-1.sush-001.prod.us-west-2.aws.redhat.com "yank -y $case"
ssh supportshell-1.sush-001.prod.us-west-2.aws.redhat.com "cd /cases/$case; count=\$(ls -1 *.sql 2>/dev/null | wc -l); if [ \$count -gt 0 ]; then gzip *.sql; fi"
ssh supportshell-1.sush-001.prod.us-west-2.aws.redhat.com "cd /cases/$case; count=\$(ls -1 *.sql.gz | wc -l); if [ \$count -gt 0 ]; then exit 0; else exit 1; fi"
if [ -z "$file" ]; then
  scp supportshell-1.sush-001.prod.us-west-2.aws.redhat.com:/cases/$case/*sql.gz .
else
  scp supportshell-1.sush-001.prod.us-west-2.aws.redhat.com:/cases/$case/*-$file.gz .
fi 
#scp supportshell-1.sush-001.prod.us-west-2.aws.redhat.com:/cases/$case/*cell1_db_dump*sql.gz .
#gunzip -f *.gz

cd ..
chmod -R 777 $case/

podman ps | grep maria | awk '{ print $1 }' | xargs -I% podman rm -f %

podman --log-level=debug run -d --replace  --name mariadb_$case  -v /cases/$case:/var/lib/mysql:z -v /etc/localtime:/etc/localtime:ro --mount type=tmpfs,destination=$HOME/tmp --net=host -e MYSQL_ROOT_PASSWORD=root registry.redhat.io/rhel8/mariadb-103:1-234

while ! podman exec -it mariadb_$case mysql -uroot -proot -h$hostname -e "show processlist"; do
  echo -n "."
  sleep 1
done

tmpsqlfiles=$(ls $case/*.sql.gz)

inc=0
for sqlfile in $tmpsqlfiles; do
  sqlfile=$(echo $sqlfile | xargs basename)

#sqlfile=$(ls -1 $case/*.sql | tail -1 | xargs basename)

#podman exec -it mariadb_$case "mysql -uroot -proot -h$hostname -e "source /var/lib/mysql/$sqlfile"
#podman exec -it mariadb_$case "zcat /var/lib/mysql/$sqlfile | mysql -uroot -proot -h$hostname"
  podman exec -it mariadb_$case echo "create database ${case}_${inc};" | mysql -uroot -proot -h$hostname
  podman exec -it mariadb_$case zcat /var/lib/mysql/$sqlfile | mysql -uroot -proot -h$hostname -D ${case}_${inc}
  inc=$(( $inc + 1 ))
done

notify-send "Database is ready!" '\\o/'

echo podman exec -it mariadb_$case mysql -uroot -proot -h$hostname


