docker build . -t jackanakin:hadoop-slave
docker build . -t jackanakin:hadoop-master

docker network create -d bridge hadoop_network
docker run -it -d --name hadoop-slave-1 --network=hadoop_network --hostname hadoop-slave-1 jackanakin:hadoop-slave
docker run -it -d --name hadoop-slave-2 --network=hadoop_network --hostname hadoop-slave-2 jackanakin:hadoop-slave
docker run -it -d --name hadoop-master --network=hadoop_network --hostname hadoop-master -p 8088:8088 jackanakin:hadoop-master
