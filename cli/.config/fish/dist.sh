#!/bin/bash

# Determining distrib

if [[ $(uname) == Linux ]]; then
	if [[ $(uname -r | grep -E el\[0-9\]+) != "" ]]; then
		echo -n 
	elif [[ $(uname -v | grep -E \+deb\[0-9\]+u\[0-9\]+) != "" || $(uname -a | grep -i debian) != "" ]]; then
		echo -n 
	elif [[ $(uname -a | grep -i ubuntu) != "" ]]; then          # At least, Ubuntu is easy to detect
		echo -n 
	elif [[ $(uname -r | grep -E fc\[0-9\]+) != "" ]]; then
		echo -n 
	elif [[ $(uname -r | grep -i arch) != "" ]]; then
		echo -n 
	elif [[ $(uname -r | grep -i MANJARO) != "" ]]; then
		echo -n 
	else
		echo -n 
	fi
elif [[ $(uname) == Darwin ]]; then
	echo -e 
elif [[ $(uname) == FreeBSD ]]; then
	echo -e 
elif [[ $(uname | grep -i cygwin) != "" ]]; then
	echo -n 
else
	echo -ne "\ufffd"
fi

# for i in $(seq 0xF300 0xF313); do echo -n -ne "\u$(printf "%04x " $i)"; done

