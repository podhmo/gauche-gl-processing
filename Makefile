
install : 
		cp -r gl `gosh -e '(display (car *load-path*))' -E exit`
