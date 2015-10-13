#!/bin/bash

LIMIT=500000
#LIMIT=100
ITERATIONS=10

SEARCH="url=vg.no*&limit=${LIMIT}&fl=timestamp,mimetype&filter=!statuscode:200"
#SEARCH="url=vg.no*&limit=${LIMIT}"
#SEARCH="url=vg.no*&limit=${LIMIT}&fl=timestamp,mimetype"

echo "Search string: ${SEARCH}"

TIMEFORMAT=$'\t%3lR'
TIMEFORMAT=$'\t%3R'

OPTS=()

ACCEPT=(-H "Accept:application/json")
ACCEPT=(-H "Accept:text/plain")
#COMPRESS=(-H "Accept-Encoding:gzip,deflate,sdch" --compressed)

OPTS+=("${ACCEPT[*]}")
OPTS+=("${COMPRESS[*]}")

echo "Curl options: ${OPTS[*]}"

#echo curl ${OPTS[*]} -s -S -XGET "http://localhost:8080/j/cdx?url=vg.no*&limit=${LIMIT}"
#curl ${OPTS[*]} -s -S -XGET "http://localhost:8080/j/cdx?url=vg.no*&limit=${LIMIT}"
#exit


echo
for i in `seq 1 ${ITERATIONS}`; do
    echo -n "$i OLD"
    time curl ${OPTS[*]} -s -S -XGET "http://localhost:8080/search/cdx?${SEARCH}" -o legacy.cdx
done

echo
for i in `seq 1 ${ITERATIONS}`; do
    echo -n "$i NEW"
    time curl ${OPTS[*]} -s -S -XGET "http://localhost:8080/j/cdx?${SEARCH}" -o new.cdx
done

echo
for i in `seq 1 ${ITERATIONS}`; do
    echo -n "$i NEW2"
    time curl ${OPTS[*]} -s -S -XGET "http://localhost:8080/j/cdx/it?${SEARCH}&pool=128" -o new2.cdx
done

echo
diff -q legacy.cdx new.cdx
diff -q legacy.cdx new2.cdx

echo
head -1 new.cdx
head -1 new2.cdx
head -1 legacy.cdx

echo
wc -l new.cdx new2.cdx legacy.cdx
