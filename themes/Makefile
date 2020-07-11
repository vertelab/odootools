
all : repo.tmp 
	@echo Complete

repo.tmp:
	@./cloneall
	@touch repo.tmp

unzip: 
	@for file in `ls *zip`
	do
	   unzip $file
	done
clean:
	@rm -f *pyc *tmp
	@echo "Cleaned up"


