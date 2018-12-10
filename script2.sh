#!/bin/bash

#This is the second assigngment script for my university project in OS.

function testFiles() {
	grep "$path/dataA.txt" test.txt >/dev/null
	if [ "$?" != "0" ]; then
		echo 0
		return
	fi
	grep "$path/more/dataB.txt" test.txt >/dev/null
	if [ "$?" != "0" ]; then
		echo 0
		return
	fi
	grep "$path/more/dataC.txt" test.txt >/dev/null
	if [ "$?" != "0" ]; then
		echo 0
		return
	fi
	echo 1
}


rm -rf ~/bin/assignments >/dev/null
mkdir ~/bin/assignments >/dev/null

rm -rf ~/bin/files_to_read >/dev/null
mkdir ~/bin/files_to_read >/dev/null
tar -xf $1.tar.gz -C ~/bin/files_to_read 
cd ~/bin/files_to_read


ls *.txt | while read f 
do 
	flag=0
	while read -r line
	do
	if [ "${line:0:5}" == "https" ] && [ "$flag" -eq 0 ] 
	then
		flag=1
		temp_name=${line##*/}
		name=${temp_name%.git}
		mkdir ~/bin/assignments/"$name"	

		git clone "$line" ~/bin/assignments/$name	>/dev/null
		echo "$line :Cloning OK"
		fi
	done <"${f}"
done

cd ..


for i in $(ls assignments)
do
	path=assignments/$i
	ok=1
	echo "$i:"
	
	S=$(find $path -not -path '*/\.*' -type d | wc -l)
	((S-=1))
	echo "Number of directories: " $S
	if [ "$S" != 1 ]
	then 
		ok=0
	fi
		
	S=$(find $path -not -path '*/\.*' -type f -name "*.txt" | wc -l)
	echo "Number of txt files: " $S
	if [ "$S" != 3 ]
	then 
		ok=0
	fi
	
	S=$(find $path -not -path '*/\.*' -type f -not -name "*.txt" | wc -l)
	echo "Number of other files: " $S
	if [ "$S" != 0 ]
	then 
		ok=0
	fi
	
	if [ "$ok" != 0 ]
	then
		find $path > test.txt
		ok=$(testFiles $path)
	fi
	
	if [ "$ok" != 1 ]
	then 
		echo "Directory structure is NOT OK"
	else
		echo "Directory structure is OK"
	fi
	
done







