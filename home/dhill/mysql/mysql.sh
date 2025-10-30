set -x
user=dhill
hostname=$(hostname)
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

#podman ps | grep maria | awk '{ print $1 }' | xargs -I% podman rm -f %

index=$(( $(cat index) + 1))
echo $index > index

echo podman --log-level=debug run -d --replace --expose $index -p $index:3306 --name mariadb_$case  -v /cases/$case:/var/lib/mysql:z -v /etc/localtime:/etc/localtime:ro --mount type=tmpfs,destination=$HOME/tmp --net=private -e MYSQL_ROOT_PASSWORD=root registry.redhat.io/rhel8/mariadb-103:1-234 > start_$case
podman --log-level=debug run -d --replace  --expose $index -p $index:3306 --name mariadb_$case  -v /cases/$case:/var/lib/mysql:z -v /etc/localtime:/etc/localtime:ro --mount type=tmpfs,destination=$HOME/tmp --net=private -e MYSQL_ROOT_PASSWORD=root registry.redhat.io/rhel8/mariadb-103:1-234

while ! podman exec -it mariadb_$case mysql -uroot -proot -h mariadb_$case -e "show processlist"; do
  echo -n "."
  sleep 1
done

sqlfile=$(ls -1 $case/*.sql.gz | tail -1 | xargs basename)
#sqlfile=$(ls -1 $case/*.sql | tail -1 | xargs basename)

#podman exec -it mariadb_$case "mysql -uroot -proot -h mariadb_$case -e "source /var/lib/mysql/$sqlfile"
#podman exec -it mariadb_$case "zcat /var/lib/mysql/$sqlfile | mysql -uroot -proot -h$hostname"
#podman exec -it mariadb_$case zcat /var/lib/mysql/$sqlfile | mysql -uroot -proot -h $hostname -P $index
zcat $case/$sqlfile | mysql -uroot -proot -h $hostname -P $index

notify-send "Database is ready!" '\\o/'

echo podman exec -it mariadb_$case mysql -uroot -proot -h mariadb_$case >> start_$case
echo mysql -uroot -proot -h $hostname -P $index
