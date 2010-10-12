dst = `gosh -e '(display (car *load-path*))' -E exit`

install : 
	# cd ext && rake && cd ../
	# cp -r ext $(dst)
	cp -r gl $(dst)
