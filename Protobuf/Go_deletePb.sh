
#!bin/sh
for file in ./go/*
do
    if test -f $file
        then
	if [[ $file =~ \.pb.go$ ]]
	then
		rm $file
	fi
     fi
done
