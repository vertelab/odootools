
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

Test your new key:
ssh -T git@github.com
Expected result is:  Hi username! You've successfully authenticated, but GitHub does not > provide shell access.
See: https://docs.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh/testing-your-ssh-connection for responses.

* * * * 

To install all repos in the repos directory:

1) $ git clone -b 14.0 git@github.com:vertelab/odootools.git

2) Then add the your user to the Odoo-group
$ sudo adduser username odoo

3) Install repos + all requirements.

When done, go to the folder odootools/repos and execute two the commands below

$ cd odootools/repos
```
odootools/repos: $ bash cloneall
```
Just to confirm - run this one more time (sometimes it times out).

Then run:
```
odootools/repos: $ bash allrequirements
```

4) Check your download:

$ cd /usr/share
/usr/share: $ ls | grep "odoo*"

Expected output is a list like this:
core-odoo
odooext-commitsun-pms
odooext-CybroOdoo-CybroAddons
odooext-itpp-labs-access-addons
odooext-itpp-labs-mail-addons


5) If you want to add additional customer unique repositories to the server
$ git clone -b 14.0 git@github.com:vertelab/odoo-customer-addons.git
and add a folder with your customer
or any other repository where there is a copy of a similar odootools/repos-folder with a list of repos in one of the folders.

Then copy the new downloaded libraries from your home direcoryt to the target and use the nameing convention:
odoo-ext-reponame (where reponame is the original reponame at the supplier) as with this example:
$ sudo mv odoo-customer-addons /usr/share/odooext-vertel-odoo-customer-addons


6) Not to forget, the owner...!

$ sudo chown odoo:odoo /usr/share/odoo*/ -R;sudo chmod g+w /usr/share/odoo*/ -R

or run the Odootools command
$ sudo odoosetperm

/usr/share: $ ls -la | grep "odoo*"

Expected output:
lrwxrwxrwx   1 root root    36 Aug 24 07:08 core-odoo -> /usr/lib/python3/dist-packages/odoo/
drwxrwxr-x  10 odoo odoo  4096 Aug 24 07:56 odooext-commitsun-pms
drwxrwxr-x 128 odoo odoo  4096 Aug 24 07:59 odooext-CybroOdoo-CybroAddons
drwxrwxr-x  16 odoo odoo  4096 Aug 24 08:00 odooext-itpp-labs-access-addons
drwxrwxr-x   5 odoo odoo  4096 Aug 24 07:59 odooext-itpp-labs-mail-addons

7) Run the Odoo tools command to update the config-file with the new repositories and restart the server
$ odooaddons
$ odoorestart


8) Try your new server at port 8069!

http://odoo14_local_server:8069/

9) error: cannot open .git/FETCH_HEAD: Permission denied
odoogitpull -- load all repos from remote.

Solution: $ sudo adduser username odoo (add user to the group odoo.)
Ctrl + D (Close the SSH connection.)
$ ssh username@odoo14 (Connect to server.)
```
