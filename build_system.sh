coffee --compile --output bin/ src/
coffee -c test/*.coffee

node test/test.js
