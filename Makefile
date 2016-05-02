
all : odooupd.tmp erppeek.tmp
	@echo Complete

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


