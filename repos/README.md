

To install all repos in the repos directory:


1) $ git clone -b 14 git@github.com:vertelab/odootools.git

First, download the Odoo toolbox.

2) Install repos + all requirements.

When done, go into folder odootools/repos and execure two files using the bash-command.

$ cd odootools/repos
odootools/repos: $ bash cloneall
odootools/repos: $ bash allrequirements

3) Not to forget, the owner...!

$ sudo chown odoo:odoo /usr/share/odoo*/ -R
$ sudo chmod g+w /usr/share/odoo*/ -R

