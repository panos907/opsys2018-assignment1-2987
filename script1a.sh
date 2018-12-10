#!/bin/bash
#This is the first version of the first script for my University assignment in OS

function tell_if_different() {

#This function checks if the websites have been modified

local i=0
local size="$1"
local j=0
local flag=0
while [ "$i" -lt $(( size )) ] 
do	
		if [[ ${name[i]} == "$2" ]] && [[ DIFF=$(diff -q ${data[i]} $3) == 1 ]]; then
			printf "${name[i]} has been modified \n"
			flag=1 
			return 1
		fi
		i=$((i + 1))	
done 

if [ $flag -eq 0 ]
then 
echo "The website ${name[i]} has not been modified"
return 0
fi

}


function search_if_exists(){
	
	#This function checks if we need to output INIT for a website
	
	k=0 
	local size=$1
	local key=$2
	local flag=0
	while [ $k -lt $size ]
	do
		if [ "${name[k]}" == "$key" ]; then
			flag=1
			return $flag
		fi
		k=$(( k + 1 ))	
	done		
	return $flag

}

function make_database() {
	
while read url; do
    
    data[${#data[@]}]="Link$i.txt"
	urlstatus=$(curl --silent -o>${data[i]} --head --write-out '%{http_code}' "$urlstatus" "$url" )
	temp="$url"
	
	#Check if the website is downloaded for the first time
	search_if_exists "$i" "$temp"
	if [ $? -eq 1 ]
	then
	 printf "$url ΙΝΙΤ\n" 
	fi 	
    #If the URL doesn't already exist in the name matrix, we print it alongside INIT

    name[${#name[@]}]="$url"
   
    i=$(( i + 1 ))
    n=$i
    
done <"$filename"

touch Links.txt

for i in seq $(eval echo "{1..$(( n -1 ))}")
do
	printf "${name[i]}\n">>"Names.txt"
	printf "${data[i]}\n">>"Links.txt"
done
	#We save the links and respective data names for further use
	
	
}


function checkURL(){
		
	while read url; do
    
	urlstatus=$(curl -f --silent -o>tempf --head --write-out '%{http_code}' "$urlstatus" "$url" )
	temp="$url"
	
	#Check if the website is downloaded for the first time
	search_if_exists "$i" "$url"
	if [ $? -eq 1 ]
	then
	 echo "$url ΙΝΙΤ\n" 
	 cp tempf ${data[i]}
	fi 	
    #If the URL doesn't already exist in the name matrix, we print it alongside INIT
    
    
    tell_if_different "$i" "$temp" "$tempf"
    #Checks if the current url has been modified since the last time the script ran
    
    if [ $? -eq 1 ]
    then
	cp tempf ${data[i]}		
    fi
    
    data[${#data[@]}]="Link$i.txt"
    name[${#name[@]}]="$temp"
   
    i=$(( i + 1 ))
    n=$i
    rm tempf
done <"$filename"

for i in seq $(eval echo "{1..$(( n -1 ))}")
do
	printf "${name[i]}\n"
	#printf "${data[i]}\n">>"Links.txt"
done

}



i=0
declare -a name
declare -a data

filename="$1"

if [ ! -f ~/bin/Names.txt ] 
then
	make_database "$filename" 
else 
readarray name< ~/bin/Names.txt
readarray data< ~/bin/Links.txt

checkURL "$filename"   
fi

