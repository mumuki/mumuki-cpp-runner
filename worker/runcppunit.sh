#!/bin/sh

g++ -std=c++11 $1 -o test.out -lcppunit 2>&1
if [ $? -ne 0 ] ; then
  echo "!!TEST FINISHED WITH COMPILATION ERROR!!"
  exit 1
fi

./test.out 2 >&1
RESULT=$?

rm test.out

exit $RESULT
