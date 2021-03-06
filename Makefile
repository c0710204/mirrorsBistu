nothing:
	@echo "nothing"
remove:
	@-rm -R /var/www/index.* /var/www/files/ /var/www/libs/ /var/www/web/ 2>/dev/zero
install:
	@echo  "prepare file";
	@cp -R  ./web ./www 
	@cp -R ./www/* /var/www
	@rm -R ./www
	@echo "..............ok\n";
	@echo "set chmod"
	@cd /var/www;chmod -R g+rw libs/ *.* files/ mirror*
	@echo "g=ok"
	@cd /var/www;chmod -R o+rw libs/ *.* files/ mirror*
	@echo "o=ok"
	@echo "..............ok\n"
	@echo "pre loading index page"
	@cd /var/www;php index.php 1>/var/www/error.html 2>&1
	@echo "..............ok\n"
	@cd /var/www;rm error.html
update:
	@rm -R /var/www/mirrorinfo/
	@echo "Updating mirror info"
	@cp -r ./mirrorinfo /var/www/
