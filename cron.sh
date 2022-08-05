#!/usr/bin/bash

sudo -i -u $1 bash -c 'tail -n 1000 ~/log/ansible-cron | sponge ~/log/ansible-cron; ansible-pull -o -vvv -U https://github.com/laurent-xu/bootstrap.git | ts "[\%Y-\%m-\%d \%H:\%M:\%S]" >> ~/log/ansible-cron 2>&1'
