# Ansible

-> Tạo folder tree có thể dùng:
$ ansible-galaxy init package

-> Cli chạy playbook với user ssh là "truongnqk".
$ ansible-playbook -i host playbook.yaml --limit='test' --tags='package' -u truongnqk

-> Nếu file hosts đã chỉ định rõ user thì có thể dùng Cli rút gọn: \n
$ ansible-playbook -i hosts playbook.yaml --tags='ping' --tags='package'
