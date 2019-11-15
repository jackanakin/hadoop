su hadoop -c "/opt/hadoop/bin/hdfs namenode -format"
su hadoop -c "/opt/hadoop/sbin/start-dfs.sh"
su hadoop -c "/opt/hadoop/sbin/start-yarn.sh"

su hadoop -c "/opt/hadoop/bin/hdfs dfs -mkdir -p /user/hadoop"
su hadoop -c "/opt/hadoop/bin/hdfs dfs -mkdir books"
exit

# WordCount
su hadoop -c "/opt/hadoop/bin/yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.2.jar wordcount \"books/*\" output"
su hadoop -c "/opt/hadoop/bin/hdfs dfs -ls output"
su hadoop -c "/opt/hadoop/bin/hdfs dfs -cat output/part-r-00000"

/opt/hadoop/bin/yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.2.jar wordcount "books/*" output