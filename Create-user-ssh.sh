#!/bin/bash
user=haubc
sshkey="ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAkj8e8Aeh5lMLY6TyVEieqhXNB3o13IqOvw1j
sLxpGDfN0yvouLqGc7MgOrMfS29YCg5xcSOW8RG+zEHzY5i3Ky0eLB8cQ9uU3fnC
OQsvcj175woZ3LwlPFpR8ChiQNNUJFW9b4udpZ37wD2nxQ4fZHK9zWqAPFo5i8ag
bVpuy376deR5zUFrTUV594XZgQnD1Q9gy6A0TSLQRwHDqPbVwOTRkTxnErzrRhAl
KGZJojJn0tgz8RxmCvLhy/1vGMF91n9RkZwEQtv9Bcl2gYkx+RNK7hWWsiFuzGpk
Z7iN3gx6WQsYPsJr7FYQ02a0aXR+52gzW7d+nnL3EZH09oY2eQ== haubc"
/usr/sbin/useradd ${user}
/bin/mkdir -p /home/${user}/.ssh
grep -rl "${sshkey}" /home/${user}/.ssh/authorized_keys
if [ $? != 0 ]; then echo "${sshkey}" >> /home/${user}/.ssh/authorized_keys; fi
grep -rl "${user}" /etc/sudoers
if [ $? != 0 ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; fi
chown -R ${user}.${user} /home/${user}
