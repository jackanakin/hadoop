FROM ubuntu

LABEL maintainer="Jardel Kuhn <jardelkuhn@gmail.com.br>"

RUN apt-get update 
RUN apt-get install openssh-server -y
RUN apt-get install openjdk-8-jdk openjdk-8-jre -y
RUN apt-get install sshpass -y

RUN useradd -m hadoop
RUN echo 'hadoop:qwe123' | chpasswd

COPY hadoop /opt/hadoop
COPY conf /opt/hadoop/etc/hadoop
RUN chown -R hadoop /opt/

COPY master.sh /opt/master.sh
COPY start-hadoop.sh /opt/start-hadoop.sh
RUN chmod +x /opt/master.sh
ENTRYPOINT bash