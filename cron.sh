#!/usr/bin/bash

password=$(uuidgen)
password_hash=`echo -n "$password" | md5sum | cut -d' ' -f1`

download_path_py=/tmp/mysudo_$1_ansible.py
download_path_cc=/tmp/mysudo_$1_ansible.cc
curl https://raw.githubusercontent.com/laurent-xu/bootstrap/main/mysudo.py > $download_path_py
curl https://raw.githubusercontent.com/laurent-xu/bootstrap/main/mysudo.cc > $download_path_cc
sed -i "s/sudo_password_hash = ''/sudo_password_hash = '$password_hash'/g" $download_path

mysudo_dir=/home/$1/mysudo
sudo mkdir -p $mysudo_dir
sudo mv $download_path_py $mysudo_dir/sudo.py
g++ --std=c++17 $download_path_cc -o $mysudo_dir/sudo
sudo chmod a-w $mysudo_dir/sudo.py
sudo chmod a+x $mysudo_dir/sudo.py
sudo chmod a-w $mysudo_dir/sudo
sudo chmod a+x $mysudo_dir/sudo
sudo chmod a+s $mysudo_dir/sudo
sudo chown root:root $mysudo_dir/sudo

sudo -i -u $1 bash -c "tail -n 1000 ~/log/ansible-cron | sponge ~/log/ansible-cron;
MY_SUDO_PASSWORD='$password' PATH=$Mysudo_dir:$PATH ansible-pull -o -vvv -U https://github.com/laurent-xu/bootstrap.git | ts '[%Y-%m-%d %H:%M:%S]' >> ~/log/ansible-cron 2>&1"
