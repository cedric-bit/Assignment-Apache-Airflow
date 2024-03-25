#!/bin/bash

# Check arguments
[ $# -ne 3 ] && echo This script expects three arguments. >& 2 && exit 1
[ ! -f $1 ] && echo \'$1\' is not a file or does not exist in this directory. >& 2 && exit 1
[ ! -d $2 ] && echo \'$2\' is not a directory or does not exist at this location. >& 2 && exit 1
[ ! -d $3 ] && echo \'$3\' is not a directory or does not exist at this location. >& 2 && exit 1

# Check permissions
[ ! -r $1 ] && echo \'$1\' is not readable. >& 2 && exit 1
[ ! -r $2 ] && echo \'$2\' is not readable. >& 2 && exit 1
[ ! -w $3 ] && echo \'$3\' is not writable. >& 2 && exit 1

# Add absolute path if necessary
DIRS=$(realpath $1)
IN=$(realpath $2)
OUT=$(realpath $3)

ROOT=$OUT/University  # The root directory to which copy files
LOG=$ROOT/log.out

rm -rf $ROOT; mkdir -p $ROOT
rm -f $LOG; touch $LOG

# For each category in the given file
for dir in $(<$DIRS); do
  mkdir -p $ROOT/$dir
  log=
  # For each file in the source directory:
  #   - whose name matches with the pattern *"$dir"* (no case sensitive)
  #   - whose content matches with the pattern *"$dir"* (no case sensitive, recursive search)
  for file in $(find $IN -iname "*$dir*") $(grep -irlE ".*$dir.*" $IN); do
    cp $file $ROOT/$dir && log+="FROM $file TO $ROOT/$dir\n"
  done
  # Remove the last newline and update log file
  echo -e ${log%"\n"} >> $LOG
done

exit 0