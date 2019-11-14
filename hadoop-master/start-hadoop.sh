su hadoop -c "/opt/hadoop/bin/hdfs namenode -format"
su hadoop -c "/opt/hadoop/sbin/start-dfs.sh"
su hadoop -c "/opt/hadoop/sbin/start-yarn.sh"
exit

/opt/hadoop/bin/hdfs dfs -mkdir -p /user/hadoop
/opt/hadoop/bin/hdfs dfs -mkdir books
cd /home/hadoop
wget -O alice.txt https://www.gutenberg.org/files/11/11-0.txt
wget -O holmes.txt https://www.gutenberg.org/files/1661/1661-0.txt
wget -O frankenstein.txt https://www.gutenberg.org/files/84/84-0.txt
/opt/hadoop/bin/hdfs dfs -put alice.txt holmes.txt frankenstein.txt books
/opt/hadoop/bin/hdfs dfs -ls books
/opt/hadoop/bin/hdfs dfs -get books/alice.txt
/opt/hadoop/bin/hdfs dfs -cat books/alice.txt

# WordCount
/opt/hadoop/bin/yarn jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.2.jar wordcount "books/*" output
/opt/hadoop/bin/hdfs dfs -ls output
/opt/hadoop/bin/hdfs dfs -cat output/part-r-00000 | less
