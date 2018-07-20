
#!bin/sh
for file in ./Csharp/*
do
    if test -f $file
        then
		if [[ $file == *.cs ]]
		then
			rm $file
		fi
	elif test -d $file
	then
		rm -rf $file
    fi
done

if [ -e ./CsForClient ]
then
	for file in ./CsForClient/*
	do
		if test -f $file
			then
			if [[ $file == *.cs ]]
			then
				rm $file
			fi
		elif test -d $file
		then
			rm -rf $file
		fi
	done
fi
