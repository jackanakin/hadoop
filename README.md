## criar a imagem
docker build . -t jackanakin:hadoop
## criar a network
docker network create -d bridge hadoop_network

## iniciar slave-1
docker run -it -d --name hadoop-slave-1 -v /home/jardel/Documents/hadoop/data:/home/hadoop/data -v /home/jardel/Documents/hadoop/cfg:/opt/hadoop/etc/hadoop/ --memory="512m" --cpus=".5" --network=hadoop_network --hostname hadoop-slave-1 jackanakin:hadoop
## iniciar slave-2
docker run -it -d --name hadoop-slave-2 -v /home/jardel/Documents/hadoop/data:/home/hadoop/data -v /home/jardel/Documents/hadoop/cfg:/opt/hadoop/etc/hadoop/ --memory="512m" --cpus=".5" --network=hadoop_network --hostname hadoop-slave-2 jackanakin:hadoop
## iniciar slave-3
docker run -it -d --name hadoop-slave-3 -v /home/jardel/Documents/hadoop/data:/home/hadoop/data -v /home/jardel/Documents/hadoop/cfg:/opt/hadoop/etc/hadoop/ --memory="512m" --cpus=".5" --network=hadoop_network --hostname hadoop-slave-2 jackanakin:hadoop
## iniciar master
docker run -it -d --name hadoop-master -v /home/jardel/Documents/hadoop/data:/home/hadoop/data -v /home/jardel/Documents/hadoop/cfg:/opt/hadoop/etc/hadoop/ --memory="1024m" --network=hadoop_network --hostname hadoop-master -p 9864:9864 -p 9000:9000 -p 8042:8042 -p 50060:50060 -p 8021:8021 -p 50030:50030 -p 9870:9870 -p 8088:8088 -p 50070:50070 jackanakin:hadoop

## Baixar, extrair e mover para data/csv/london-outcomes.csv
https://www.kaggle.com/sohier/london-police-records/data#london-stop-and-search.csv

## Acessar o container
docker exec -it hadoop-master bash
## Executar script master.sh para copiar chaves ssh
cd /opt/
./master.sh

## formatar o sistema de arquivo hdfs
su hadoop -c "/opt/hadoop/bin/hdfs namenode -format"
## iniciar o cluster hadoop
su hadoop -c "/opt/hadoop/sbin/start-all.sh"
## criar diretório hdfs
su hadoop -c "/opt/hadoop/bin/hdfs dfs -mkdir -p /user/hadoop"
## criar diretório para os exemplos
su hadoop -c "/opt/hadoop/bin/hdfs dfs -mkdir london_crimes"

## mover o arquivo csv para o hdfs
su hadoop -c "/opt/hadoop/bin/hdfs dfs -put /home/hadoop/data/csv/* london_crimes"
## rodar o programa:
### 1 Extrair percentual de crimes resolvidos
su hadoop -c "/opt/hadoop/bin/yarn jar /home/hadoop/data/LondonCrimes.jar LondonCrimes \"london_crimes/*\" solved-result solved"
### 2 Extrair quantidade por localidade
su hadoop -c "/opt/hadoop/bin/yarn jar /home/hadoop/data/LondonCrimes.jar LondonCrimes \"london_crimes/*\" location-result location"
### 3 Extrair quantidade por resultado de investigação
su hadoop -c "/opt/hadoop/bin/yarn jar /home/hadoop/data/LondonCrimes.jar LondonCrimes \"london_crimes/*\" outcome-result outcome"

## Ver resultados
su hadoop -c "/opt/hadoop/bin/hdfs dfs -cat solved-result/part-00000"
su hadoop -c "/opt/hadoop/bin/hdfs dfs -cat location-result/part-00000"
su hadoop -c "/opt/hadoop/bin/hdfs dfs -cat outcome-result/part-00000"
http://localhost:9870/
http://localhost:8088/
