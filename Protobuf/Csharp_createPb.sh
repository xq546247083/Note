# 进入pb文件目录
cd pb/

#!bin/sh
#if ! [ -e .././CsForClient/ ]
#then
#	mkdir .././CsForClient/
#fi

# 编译所有的proto文件
echo "Building proto files..."
for file in ./*
do
	# 检查是否是文件
	if [ -f $file ]
	then
		if [[ $file == *.proto ]]
		then
			# 如果为proto文件,则直接编译
			protoc -I=. --csharp_out=.././Csharp/ ./*.proto
		fi
	# 如果为文件夹
	elif [ -d $file ]
	then
		if ! [ -e .././Csharp/$file ]
		then
			# 不存在对应文件夹时新建
			mkdir .././Csharp/$file
		fi
		# 编译文件夹中所有的proto文件到指定文件夹
		protoc -I=. --csharp_out=.././Csharp/$file ./$file/*.proto
	fi
done
echo "Building proto files success"

read -p "是否需要拷贝文件(y/n)" yon
if [ $yon != 'y' ]
then
	exit 1
fi

# 退回基础目录
cd ..

# 执行外部的拷贝脚本
echo "Copying files..."
./copy.sh
echo "Copying files success"

# 如果有错误信息,则不退出界面
if [ $? != 0 ]
then 
	read -p "Press any key to continue"
fi