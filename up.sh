docker build . -t jackanakin:hadoop-slave
docker build . -t jackanakin:hadoop-master

docker run -it -d --name hadoop-slave-1 --network=hadoop_network --ip 192.168.1.211 jackanakin:hadoop-slave
docker run -it -d --name hadoop-master --network=hadoop_network --ip 192.168.1.210 jackanakin:hadoop-master

#docker network create -d macvlan --subnet=192.168.1.0/24 --gateway=192.168.1.1 -o parent=enp2s0 hadoop_network
#docker run -it -d --name hadoop-slave-1 --network=hadoop_network --ip 192.168.1.211 jackanakin:hadoop