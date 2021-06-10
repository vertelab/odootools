
all : odooupd.tmp erppeek.tmp openpyxl.tmp profile.tmp
	@echo Complete

openpyxl.tmp:
	@sudo apt install python3-dev libffi-dev
	@sudo pip3 install utils
	@touch openpyxl.tmp

profile.tmp: odootools.sh bash_completion.odoo
	@sudo cp bash_completion.odoo /etc/bash_completion.d/odoo
	@sudo cp odootools.sh /etc/profile.d/odootools
	@touch profile.tmp

erppeek.tmp:
	@sudo pip3 install erppeek
	@touch erppeek.tmp

odooupd.tmp: odooupd.py
	@sudo cp odooupd.py /usr/bin/odooupd
	@sudo chmod a+x /usr/bin/odooupd
	@touch odooupd.tmp

clean:
	@rm -f *pyc
	@rm -f *tmp
	@echo "Cleaned up"


