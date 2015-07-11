all: cstsn.js

clean:
	rm cstsn.js

cstsn.js: cstsn.coffee
	coffee -c cstsn.coffee
