service ssh start
su hadoop -c "mkdir ~/.ssh/"
su hadoop -c "ssh-keygen -t rsa -N \"\" -f ~/.ssh/id_rsa"
su hadoop -c "ssh-keyscan  hadoop-master >> ~/.ssh/known_hosts"
su hadoop -c "ssh-keyscan  hadoop-slave-1 >> ~/.ssh/known_hosts"
su hadoop -c "ssh-keyscan  hadoop-slave-2 >> ~/.ssh/known_hosts"
su hadoop -c "sshpass -p qwe123 ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@hadoop-master -p 22"
su hadoop -c "sshpass -p qwe123 ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@hadoop-slave-1 -p 22"
su hadoop -c "sshpass -p qwe123 ssh-copy-id -i ~/.ssh/id_rsa.pub hadoop@hadoop-slave-2 -p 22"
exit