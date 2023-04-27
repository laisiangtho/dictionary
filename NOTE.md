# Note

## bash

```sh
gzip tar czvf
bzip2 tar cjvf

tar -czvf working/word-czvf.tar.gz word.db sense.db thesaurus.db
tar -czvf working/word word.db sense.db thesaurus.db
4736 ms
tar -cjvf word-cjvf.tar.bz2 *.db
8087 ms

zip

tar -cvjSf word-cvjSf.tar.bz2 *.db

tar -czvSf word-czvSf.tar.gz *.db


tar -cjf word-cjf.tar.bz2 *.db

tar -czvf word-czvf.tar.bz2 *.db

tar -cvjSf word-cvjSf.tar.gz *.db 
tar -cvSf word-cvSf-tar-gz.zip *.db  *.json

tar -czvf word-czvf-tar-gz.zip *.db

tar -czvf word-czvf.tgz *.db


tar -czvf word-czvf.tgz *.db

openssl zlib -d < /d/tmp/archive
openssl enc -z -none -e < /d/tmp/archive

gzip -c *.db > word.gz

gzip -c sense.db > sense.gz
gzip -c thesaurus.db > thesaurus.gz
gzip -c word.db > word.gz

gzip -c sense.db thesaurus.db word.db > allInOne.gz
gzip -r allInOne > allInOne.gz
gzip -lN sense.db thesaurus.db word.db > word.gz

cat sense.db thesaurus.db word.db | gzip -c > allInOne.gz
```

## keep each

```sh
echo -e "\x00\x001" > test.bin

# To view bytes of a file in hexadecimal:
xxd -g1 test.bin

xxd -b -c4 test.bin

cat -e test.txt > test.bin

# hexdump -Cv test.bin

# hex from string
# echo "hello World"$'\157' | xxd -p
echo "Hello: sir" | xxd -p
# 48656c6c6f3a207369720a

# "reverse" an hex from string
echo "48656c6c6f3a207369720a" | xxd -r -p
# Hello: sir

# each character representation
echo "Hello: sir" | od -vAn -tcx1
# H   e   l   l   o   :       s   i   r  \n
# 48  65  6c  6c  6f  3a  20  73  69  72  0a


# Text file to 
# Hexadecimal
xxd test.txt > test.bin
xxd -p test.txt > test.bin
# ??
xxd -b test.txt > test.bin
xxd -t test.txt > test.bin

xxd -p test-czvf.tar.gz > test.bin
xxd -p test.txt > test.bin
# xxd -p sense.db > sense.bin

# HEX file to text
cat test.bin | xxd -p -r > test-text.txt
cat test.bin | od -vAn -tcx1 > test-od.txt
cat test.bin | xxd -p -r > word-czvf-reverse.tar.gz

# String to
# Hexadecimal
echo "abc" | od -vAn -tcx1
echo "abc" | xxd -p
echo "=>?" | xxd -p
echo "=>?" | od -vAn -tcx1
# Decimal
echo "abc" | od -vAn -td1
# for decimal
echo "abc" | od -An -vtu1
# for hexadecimal
echo "abc" | od -An -vtx1

od -vAn -vtu1 test.txt > test.bin
cat test.bin | xxd -p -r > test-text.txt

tar -czvf test-czvf.tar.gz test.txt
od -vAn -vtu1 test-czvf.tar.gz > test-czvf.bin
cat test-czvf.bin | xxd -p -r > test-reverse.tar.gz
```

```js
'K'.charCodeAt(0)
String.fromCharCode(75)
k = '?'.charCodeAt(0); f = 'Ê'.charCodeAt(0); s = 'G'.charCodeAt(0); console.log(k,f,s)
k = '?'.charCodeAt(0); f = ''.charCodeAt(0); s = '‹'.charCodeAt(0); console.log(k,f,s)
k = 200; f = k+31; s = k+139; console.log(k,f,s)
```

?: 63 P:80 K:75 -> 63 ?+63 ?+63
?ºµ -> 63 143 138

tar.gz hack
HEX: 1f 8b 08
DEC: 31 139 8
HAC: 94 202 71 -> ?ÊG
?ÊG -> 63 202 71 <-> ?‹ 63 138 8
PK: 80 75

## bug

```sql
UPDATE `list_sense` AS a
  INNER JOIN (select id, word from `list_sense` GROUP BY word HAVING COUNT(*) = 1) AS b ON a.word = b.word
  SET a.dated = '2021-04-30 10:00:00'
  WHERE a.word NOT LIKE '% %' AND a.exam IS NOT NULL AND a.wrid > 0
```

```sh
# keep each
SqfliteDatabaseException (DatabaseException(no such table: main.list (code 1 SQLITE_ERROR): , while compiling: CREATE UNIQUE INDEX IF NOT EXISTS wordIdIndex ON list (id, word)) sql 'CREATE UNIQUE INDEX IF NOT EXISTS wordIdIndex ON list (id, word)' args [])

# keep archive each
SqfliteDatabaseException (DatabaseException(Cannot perform this operation because there is no current transaction.) sql 'COMMIT' args [])

# keep archive single
SqfliteDatabaseException (DatabaseException(Cannot perform this operation because there is no current transaction.) sql 'COMMIT' args [])

# keep word single
SqfliteDatabaseException (DatabaseException(database is locked (code 5 SQLITE_BUSY)) sql 'BEGIN IMMEDIATE' args [])
