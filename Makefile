nothing:
	echo "nothing"
remove:
	@-rm -R /var/www/index.* /var/www/files/ /var/www/libs/ /var/www/web/ 2>/dev/zero
install:
	@cp -R  ./web ./www 
	@cp -R ./www/* /var/www
	@rm -R ./www
	@cd /var/www;php index.php 1>/var/www/error.html 2>&1
	@cd /var/www;rm error.html
update:
	@rm -R /var/www/mirrorinfo/
	cp -r ./mirrorinfo /var/www/
