
all : odooupd.tmp erppeek.tmp bash.tmp openpyxl.tmp phonenumbers.tmp
	@echo Complete

openpyxl.tmp: 
        @sudo apt install python-dev libffi-dev
	@sudo pip install openpyxl
	@sudo pip install pybarcode
	@sudo pip install cairosvg
	@sudo pip install utils
	@touch openpyxl.tmp

phonenumbers.tmp: 
	@sudo pip install phonenumbers
	@touch phonenumbers.tmp

erppeek.tmp: 
	@sudo pip install erppeek
	@touch erppeek.tmp

odooupd.tmp: odooupd.py
	#@python -m py_compile odooupd.py
	@sudo cp odooupd.py /usr/bin/odooupd
	@sudo chmod a+x /usr/bin/odooupd
	@touch odooupd.tmp

bash.tmp: bash.odoo bash_completion.odoo
	@sudo cp bash.odoo /etc
	@sudo cp bash_completion.odoo /etc/bash_completion.d/odoo
	@touch bash.tmp

clean:
	@rm -f *pyc
	@echo "Cleaned up"


