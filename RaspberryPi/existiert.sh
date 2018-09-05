#!/bin/bash

FILE=(yourfile)
if [ -f $FILE ]; then
   echo "File $FILE exists."
else
   echo "File $FILE does not exist."
   # COPY FILENAME
   while [ -f $FILE ]; do
     : # no-op
   done
   echo "File Copied"
fi
