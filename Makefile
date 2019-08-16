
all : odooupd.tmp erppeek.tmp bash.tmp openpyxl.tmp phonenumbers.tmp odoobackup.tmp db_backup.tmp
	@echo Complete

openpyxl.tmp:
	@sudo apt install python-dev libffi-dev
	@sudo apt install python-openpyxl
	@sudo pip install pybarcode
	@sudo apt-get install python-cairosvg
	@sudo pip install utils
	@touch openpyxl.tmp

phonenumbers.tmp:
	@sudo pip install phonenumbers
	@touch phonenumbers.tmp

erppeek.tmp:
	@sudo pip install erppeek
	@touch erppeek.tmp

odooupd.tmp: odooupd.py
	@sudo cp odooupd.py /usr/bin/odooupd
	@sudo chmod a+x /usr/bin/odooupd
	@touch odooupd.tmp

odoobackup.tmp: odooupd.py
	@sudo cp odoobackup.py /usr/bin/odoobackup
	@sudo chmod a+x /usr/bin/odoobackup
	@touch odoobackup.tmp

db_backup.tmp: db_backup
	@sudo cp db_backup /etc/cron.daily/db_backup
	@sudo chmod a+x /etc/cron.daily/db_backup

bash.tmp: odootools.sh bash_completion.odoo
	@sudo cp odootools.sh /etc/profile.d
	@sudo cp bash_completion.odoo /etc/bash_completion.d/odoo
	@touch bash.tmp

clean:
	@rm -f *pyc
	@echo "Cleaned up"
