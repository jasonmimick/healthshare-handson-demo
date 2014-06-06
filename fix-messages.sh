#!/bin/bash -f
# Fix up these messages so we's can POST 'em

#
# For each message - grab it
# create a folder to split into
# then run csplit

# normalize a possibly relative file path
# usage normalize_path <path>
normalize_path()
{
  path=$1
  platform=$(uname)
  if [ $platform == "Darwin" ]; then
    np=$(ruby -e 'puts File.expand_path("'$path'")')
  else
    np=$(readlink -f $path)
  fi
  echo $np
}


source_dir=$( normalize_path $1 )
output_dir=$( normalize_path $2 )
current_dir=$(pwd)
echo "Building HL7 data in: $output_dir"
rm -rf $output_dir
mkdir $output_dir
for file in $(ls $source_dir)
do
	echo file=$file
	parts=(${file//./ })
	#echo "${parts[@]} ${parts[0]} ${parts[1]} ${parts[2]}"
	dude=${parts[1]}
	echo dude=$dude
	dir=$output_dir/$dude
	mkdir $dir
	cd $dir
	echo "Running in $dir"

	csplit -sk $source_dir/$file '/MSH|/' {9999999999999}
	for msg in $(ls)
	do
		echo "Working on $msg"
		f="$msg.tmp"
		g="$msg.hl7"
		tr -d "\n" < $msg > $f
		echo "" >> $$	
		# need to trim off the 1st char for all but xx00
		if ! [[ $msg = "xx00" ]]; then 
			sed 's/^.//' $f > $g
		fi
		rm $msg
		rm $f
	done
	cd $current_dir
done
#csplit -k hl7demo.AmandaMHobbs.hl7 '/MSH|/' {9999999999999}
