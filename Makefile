
all : odooupd.tmp erppeek.tmp bash.tmp openpyxl.tmp phonenumbers.tmp click.tmp odoobackup.tmp
	@echo Complete

openpyxl.tmp: 
	@sudo apt install python-dev libffi-dev
	@sudo pip install openpyxl
	@sudo pip install pybarcode
	@sudo pip install cairosvg
	@sudo pip install utils
	@touch openpyxl.tmp

click.tmp: 
	@sudo pip install click
	@touch click.tmp

phonenumbers.tmp: 
	@sudo pip install phonenumbers
	@touch phonenumbers.tmp

erppeek.tmp: 
	@sudo pip install erppeek
	@touch erppeek.tmp

odooupd.tmp: odooupd.py db_backup
	#@python -m py_compile odooupd.py
	@sudo cp odooupd.py /usr/bin/odooupd
	@sudo cp db_backup /etc/cron.daily/db_backup
	@sudo chmod a+x /usr/bin/odooupd
	@touch odooupd.tmp

bash.tmp: bash.odoo bash_completion.odoo
	@sudo cp bash.odoo /etc
	@sudo cp bash_completion.odoo /etc/bash_completion.d/odoo
	@touch bash.tmp

odoobackup.tmp: odoobackup.py
	@sudo cp odoobackup.py /usr/bin/odoobackup
	@sudo chmod a+x /usr/bin/odoobackup
	@touch odoobackup.tmp

clean:
	@rm -f *pyc
	@echo "Cleaned up"


