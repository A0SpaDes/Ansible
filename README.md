# Ansible

-> Tạo folder tree có thể dùng: <br>
$ ansible-galaxy init package

-> Cli chạy playbook với user ssh là "truongnqk". <br>
$ ansible-playbook -i host playbook.yaml --limit='test' --tags='package' -u truongnqk

-> Nếu file hosts đã chỉ định rõ user thì có thể dùng Cli rút gọn: <br>
$ ansible-playbook -i hosts playbook.yaml --tags='ping' --tags='package'
