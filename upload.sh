#!/bin/sh

if [ -z "$1" ]; then
    echo "Usage: ./upload.sh REPO_CODENAME">&2
    exit 1
fi

if [ $(whoami) != "root" ]; then
    echo "only root can add files to the repo"
    exit
fi

INCOMING=/home/richo/apt-staging/
APT_REPO=/var/repo/apt

#
# Make sure we're in the apt/ directory
#
cd $APT_REPO

#
#  See if we found any new packages
#
found=0
for i in $INCOMING/*.changes; do
  if [ -e $i ]; then
    found=`expr $found + 1`
  fi
done


#
#  If we found none then exit
#
if [ "$found" -lt 1 ]; then
   exit
fi


#
#  Now import each new package that we *did* find
#
for i in $INCOMING/*.changes; do

  # Import package to 'sarge' distribution.
  reprepro -Vb . include $1 $i

  # Delete the referenced files
  sed '1,/Files:/d' $i | sed '/BEGIN PGP SIGNATURE/,$d' \
       | while read MD SIZE SECTION PRIORITY NAME; do

      if [ -z "$NAME" ]; then
           continue
      fi

      #
      #  Delete the referenced file
      #
      if [ -f "$INCOMING/$NAME" ]; then
          rm "$INCOMING/$NAME"  || exit 1
      fi
  done

  # Finally delete the .changes file itself.
  rm  $i
done
