#!/bin/bash
user=sysadmin05
sshkey="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCl5RQgXCi/KHeUW6tS0S8dsjX0RHXnKchcULcRxCVBF7R+R2tcvK2skdlI3TSUuSLJ1VCK3+dhNl/+pIrWyISlMJhK1XhG5XC5AgYrmefDyO1lPfnJEREHt81xrijbcuApaQSZbrR30T1C0Oi0MfcLBK4aV/FH2Qpwuz7YMa4MJZio0oHW0mtYTsjdvDrdt9EG9bkPeJjrWxDobuxzOyJCphHSTatFNEPIPo4KfZOzYtvP04mMaHyXIc3Gk7czHyISHyCKDts3Vds7Ve921jYJ92go/y26vDuRSRaPombcPUncwJTIFQTdsn0KObmDbIrBI0IZWV9b59pVvGW4pxSDboyVoouqLmpaCVF3JeWOHC2xs6wW4i/sd0pkLEI3avaZGqbzsRsYyB379FCCckwnp8fsr7pk06axUeldVh38qle4lsB92bM8Qlh+id/QT0DF4L2Y4vD3XKpEARiFKUBj8BS+lJzqG7gKWoLo+I4JQ3wsamDKZ9YsPK5miHQRPN8= truongnqk"
/usr/sbin/useradd ${user}
/bin/mkdir -p /home/${user}/.ssh
grep -rl "${sshkey}" /home/${user}/.ssh/authorized_keys
if [ $? != 0 ]; then echo "${sshkey}" >> /home/${user}/.ssh/authorized_keys; fi
grep -rl "${user}" /etc/sudoers
if [ $? != 0 ]; then echo "${user} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; fi
chown -R ${user}.${user} /home/${user}
