
```
We use SSH to connect to Github.

$ ssh-keygen
Press [enter][enter][enter][enter] (Don't enter password!)

Copy your password to Github:
$ cat .ssh/id_rsa.pub 
Make a note of where it is stored (example: /home/[username]/.ssh/id_rsa)

ssh-rsa AAAAB3NzaC1yc2EAAAAD...[reduced for space]..yqjlQqpECgyhNieLoskf+etAes= jakob@odoo14_local_server

At GitHub, go to "Settings" >> "SSH and PGP keys". Select "Add ke"y and paste all of your key in the box!
"ssh-rsa AAAAB3NzaC1yc2EAAAAD...[reduced for space]..yqjlQqpECgyhNieLoskf+etAes= jakob@odoo14_local_server"

* * * * 

To install all repos in the repos directory:

1) $ git clone -b 14.0 git@github.com:vertelab/odootools.git

First, download the Odoo toolbox.

2) Install repos + all requirements.

When done, go to the folder odootools/repos and execute two the commands below

$ cd odootools/repos
odootools/repos: $ bash cloneall
odootools/repos: $ bash allrequirements

3) Check your download:

$ cd /usr/share
/usr/share: $ ls | grep "odoo*"

Expected output is a list like this:
core-odoo
odooext-commitsun-pms
odooext-CybroOdoo-CybroAddons
odooext-itpp-labs-access-addons
odooext-itpp-labs-mail-addons


5) If you want to add additional customer unique repositories to the server
git clone -b 14.0 https://git.vertel.se/vertelab/odoo-customer-addons.git
and add a folder with your customer
or any other repository where there is a copy of a similar odootools/repos-folder with a list of repos in one of the folders.

Then copy the new downloaded libraries from your home direcoryt to the target
$ sudo mv odoo-customer-addons /usr/share/


5) Not to forget, the owner...!

$ sudo chown odoo:odoo /usr/share/odoo*/ -R
$ sudo chmod g+w /usr/share/odoo*/ -R

or run the Odootools command
$ sudo odoosetperm

/usr/share: $ ls -la | grep "odoo*"

Expected output:
lrwxrwxrwx   1 root root    36 Aug 24 07:08 core-odoo -> /usr/lib/python3/dist-packages/odoo/
drwxrwxr-x  10 odoo odoo  4096 Aug 24 07:56 odooext-commitsun-pms
drwxrwxr-x 128 odoo odoo  4096 Aug 24 07:59 odooext-CybroOdoo-CybroAddons
drwxrwxr-x  16 odoo odoo  4096 Aug 24 08:00 odooext-itpp-labs-access-addons
drwxrwxr-x   5 odoo odoo  4096 Aug 24 07:59 odooext-itpp-labs-mail-addons

6) Run the Odoo tools command to update the config-file with the new repositories and restart the server
$ odooaddons
$ odoorestart



6) Try your new server at port 8069!

http://odoo14_local_server:8069/
```
