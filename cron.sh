function run_ansible() {
    password=$(uuidgen)
    password_hash=`echo -n "$password" | sha256sum | cut -d' ' -f1`

    download_path_py=~/mysudo_$1_ansible.py
    download_path_cc=~/mysudo_$1_ansible.cc
    sudo curl https://raw.githubusercontent.com/laurent-xu/bootstrap/main/mysudo.py > $download_path_py
    sudo curl https://raw.githubusercontent.com/laurent-xu/bootstrap/main/mysudo.cc > $download_path_cc
    sudo sed -i "s/sudo_password_hash = ''/sudo_password_hash = '$password_hash'/g" $download_path_py

    mysudo_dir=/home/$1/mysudo
    sudo mkdir -p $mysudo_dir
    sudo mv $download_path_py $mysudo_dir/sudo.py
    sudo g++ --std=c++17 $download_path_cc -o $mysudo_dir/sudo
    sudo chmod a-w $mysudo_dir/sudo.py
    sudo chmod a+x $mysudo_dir/sudo.py
    sudo chown root:root $mysudo_dir/sudo
    sudo chmod a-w $mysudo_dir/sudo
    sudo chmod a+x $mysudo_dir/sudo
    sudo chmod a+s $mysudo_dir/sudo

    ansible_dir=`grep ^$1: /etc/passwd | cut -d ':' -f6`/.ansible/pull
    sudo -i -u $1 bash -c "tail -n 10000 ~/log/ansible-cron | sponge ~/log/ansible-cron;
    MY_SUDO_PASSWORD='$password' PATH=$mysudo_dir:$PATH ansible-pull -o -vvv -U https://github.com/laurent-xu/bootstrap.git || rm -rf $ansible_dir

    sudo rm -rf $mysudo_dir"
}

run_ansible $1 | ts '[%Y-%m-%d %H:%M:%S]' >> ~/log/ansible-cron_$1 2>&1

