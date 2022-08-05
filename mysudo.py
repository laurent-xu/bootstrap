#!/usr/bin/env python3
# mysudo.py
import os
import sys
import hashlib

program_name = sys.argv[0].split("/")[-1]
if program_name not in ["sudo", "mysudo.py"]:
    raise ValueError(f"This program must be called directly, '{program_name}'")

if len(sys.argv) < 2:
    raise ValueError("Missing progam to call")

sudo_password = os.environ.get('MY_SUDO_PASSWORD').encode('utf-8', 'ignore')
sudo_password_hash = ''

if sudo_password is None:
    raise ValueError("MY_SUDO_PASSWORD env variable is not set")

print(sudo_password)
if sudo_password_hash != hashlib.md5(sudo_password).hexdigest():
    raise ValueError("Invalid password")
  

# call sys.argv[1], and pass the arguments to the program
# (you need to pass in argv[1] in the argument list
#  as well, it is not prepended)
real_sudo="/usr/bin/sudo"
os.execvp(real_sudo, [real_sudo] + sys.argv[1:])
