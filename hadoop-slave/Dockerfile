FROM ubuntu

LABEL maintainer="Jardel Kuhn <jardelkuhn@gmail.com.br>"

RUN apt-get update 
RUN apt-get install openssh-server -y
RUN apt-get install openjdk-8-jdk openjdk-8-jre -y
RUN apt-get install sshpass -y

RUN useradd -m hadoop
RUN echo 'hadoop:qwe123' | chpasswd
RUN chown -R hadoop /opt/

COPY slave.sh /opt/slave.sh
RUN chmod +x /opt/slave.sh
ENTRYPOINT /opt/slave.sh && bash