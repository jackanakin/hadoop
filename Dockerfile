FROM ubuntu:18.04

LABEL maintainer="Jardel Kuhn <jardelkuhn@gmail.com.br>"

RUN apt-get update 
RUN apt-get install openssh-server -y
RUN apt-get install openjdk-8-jdk openjdk-8-jre -y
RUN apt-get install sshpass -y

RUN useradd -m hadoop
RUN echo 'hadoop:qwe123' | chpasswd
RUN mkdir ~/.ssh/

WORKDIR /opt/
RUN wget http://mirror.nbtelecom.com.br/apache/hadoop/common/hadoop-3.2.1/hadoop-3.2.1.tar.gz
RUN tar -xvzf hadoop-3.2.1.tar.gz
RUN rm hadoop-3.2.1.tar.gz
RUN mv hadoop-3.2.1 hadoop
RUN chown -R hadoop /opt/

COPY master.sh /opt/master.sh
RUN chmod +x /opt/master.sh

ENTRYPOINT service ssh start & bash