#!/bin/bash

read -p "请输入原始用户名: " oldName
read -p "请输入新的用户名: " newName
echo ""
echo "即将使用新用户名：${newName}，更替旧用户名：${oldName}"
# 要修改的文件，它们的名称构成的数组

fileArray=(passwd shadow group gshadow)
for file in ${fileArray[*]}
do
	IFS=$'\n'
	count=0
	for line in $(cat /etc/${file})
	do
		count=$(expr ${count} + 1)
		oldLine=${line}
		newLine=${line//${oldName}/${newName}}
		if [[ ${oldLine} =~ ${oldName} ]]
		then
			lineNumber=${count}
			echo "修改：/etc/${file}：第${lineNumber}行"
			echo "原始为：${oldLine}"
			echo "更改为：${newLine}"
		fi
		echo  "${newLine}" >>/etc/${file}.bak.temp
	done
	cp /etc/${file}.bak.temp /etc/${file}
	rm -rf /etc/${file}.bak.temp
done
mv /home/${oldName} /home/${newName}
echo "更新用户主目录/home/${oldName}——>/home/${newName}"
echo ""
echo "用户名修改完毕！"