
all : odooupd.tmp erppeek.tmp openpyxl.tmp phonenumbers.tmp profile.tmp
	@echo Complete

openpyxl.tmp:
	@sudo apt install python3-dev libffi-dev
	@sudo pip3 install openpyxl
	#@sudo pip3 install pybarcode
	@sudo apt install python3-cairo python3-cairosvg
#	@sudo pip install cairosvg
	@sudo pip3 install utils
	@touch openpyxl.tmp

profile.tmp: odootools.sh bash_completion.odoo
	@sudo cp bash_completion.odoo /etc/bash_completion.d/odoo
	@sudo cp odootools.sh /etc/profile.d/odootools
	@touch profile.tmp

phonenumbers.tmp:
	@sudo pip3 install phonenumbers
	@touch phonenumbers.tmp

erppeek.tmp:
	@sudo pip3 install erppeek
	@touch erppeek.tmp

odooupd.tmp: odooupd.py
	#@python -m py_compile odooupd.py
	@sudo cp odooupd.py /usr/bin/odooupd
	@sudo chmod a+x /usr/bin/odooupd
	@touch odooupd.tmp

odoobackup.tmp: odoobackup.py
	@sudo cp odoobackup.py /usr/bin/odoobackup
	@sudo chmod a+x /usr/bin/odoobackup
	@touch odoobackup.tmp

clean:
	@rm -f *pyc
	@echo "Cleaned up"


