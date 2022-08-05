#!/usr/bin/bash

password=$(uuidgen)
password_hash=`echo -n "$password" | md5sum | cut -d' ' -f1`

download_path=/tmp/mysudo_$1_ansible.py
curl https://raw.githubusercontent.com/laurent-xu/bootstrap/main/mysudo.py > $download_path
sed -i "s/sudo_password_hash = ''/sudo_password_hash = '$password_hash'/g" $download_path

mysudo_dir=/home/$1/mysudo
sudo mkdir -p $mysudo_dir
sudo mv $download_path $mysudo_dir/sudo
sudo chmod a-w $mysudo_dir/sudo
sudo chmod a+s $mysudo_dir/sudo
sudo chown root:root $mysudo_dir/sudo

old_sudo=`which sudo`
export MY_SUDO_PASSWORD="$password"
export PATH=$mysudo_dir:$PATH

$old_sudo -i -u $1 bash -c 'tail -n 1000 ~/log/ansible-cron | sponge ~/log/ansible-cron; ansible-pull -o -vvv -U https://github.com/laurent-xu/bootstrap.git | ts "[%Y-%m-%d %H:%M:%S]" >> ~/log/ansible-cron 2>&1'
