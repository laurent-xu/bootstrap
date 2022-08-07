#!/usr/bin/env python3
# mysudo.py
import os
import sys
import hashlib

if len(sys.argv) < 2:
    raise ValueError("Missing progam to call")

sudo_password = os.environ.get('MY_SUDO_PASSWORD').encode('utf-8', 'ignore')
sudo_password_hash = ''

if sudo_password is None:
    raise ValueError("MY_SUDO_PASSWORD env variable is not set")

if sudo_password_hash != hashlib.md5(sudo_password).hexdigest():
    raise ValueError("Invalid password")
  

path_folders = os.environ["PATH"].split(":")
for i, path in enumerate(path_folders):
    if "mysudo" in path:
        os.environ["PATH"] = ':'.join(path_folders[:i] + path_folders[i + 1:])
real_sudo_path = '/usr/bin/sudo'
os.execvp(real_sudo_path, [real_sudo_path] + sys.argv[1:])
