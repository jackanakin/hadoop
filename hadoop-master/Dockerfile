FROM ubuntu

LABEL maintainer="Jardel Kuhn <jardelkuhn@gmail.com.br>"

RUN apt-get update 
RUN apt-get install openssh-server -y
RUN apt-get install openjdk-8-jdk openjdk-8-jre -y
RUN apt-get install sshpass -y

RUN useradd -m hadoop
RUN echo 'hadoop:qwe123' | chpasswd

#COPY java /usr/local/java
COPY hadoop /opt/hadoop

#COPY java-setup.sh /opt/java-setup.sh
#RUN chmod +x /opt/java-setup.sh
#RUN /opt/java-setup.sh

RUN chown -R hadoop /opt/hadoop


#RUN ssh -o StrictHostKeyChecking=no -l "hadoop" "hadoop-master"

#COPY ssh-setup.sh .
#RUN chmod +x /opt/hadoop/ssh-setup.sh
#RUN /opt/hadoop/ssh-setup.sh

#COPY hadoop-key.pub .

COPY master.sh /opt/master.sh
RUN chmod +x /opt/master.sh
ENTRYPOINT /opt/master.sh && bash