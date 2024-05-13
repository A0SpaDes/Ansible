#!/bin/sh

user=soadmin
password='Ca@7>S5^r"H*8K(PfW+V;d'

adduser --quiet --disabled-password --shell /bin/bash --home /home/$user --gecos "User" $user

# set password
echo "$user:$password" | chpasswd
echo User: $user has been created with password: $password

# approve sudo
# grep -rl "${user}" /etc/sudoers
# if [ $? != 0 ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; fi

#SCRIPT END
