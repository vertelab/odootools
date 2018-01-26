
all : odooupd.tmp erppeek.tmp openpyxl.tmp phonenumbers.tmp profile.tmp
	@echo Complete

openpyxl.tmp:
	@sudo apt install python-dev libffi-dev
	sudo apt install -y $(shell . ./odoo.tools;grep python- $$ODOO_CORE/debian/control | sed s/,//)
	@sudo pip install -r $(shell . ./odoo.tools; echo $$ODOO_CORE)/requirements.txt
	@sudo pip install openpyxl
	@sudo pip install openpyxl
	@sudo pip install pybarcode
	@sudo apt install python-cairo python-cairosvg
#	@sudo pip install cairosvg
	@sudo pip install utils
	@touch openpyxl.tmp

profile.tmp: odootools.sh bash_completion.odoo
	@sudo cp bash_completion.odoo /etc/bash_completion.d/odoo
	@sudo cp odootools.sh /etc/profile.d/odootools
	@touch profile.tmp

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

clean:
	@rm -f *pyc
	@echo "Cleaned up"


