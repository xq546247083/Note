# Git

---

	1、合并某一个提交的数据：git cherry-pick +提交的id
	2、增加：git add .
	3、提交：git commit -m ""
	4、查看以前的提交日志：git log --pretty=oneline
	5、查看以后的提交日志：git reflog --pretty=oneline
	6、回滚到以前：git reset --head head~1
	7、获取某个【ID】版本：git reset --head id
	8、从版本库、缓存区的文件替换到工作区：git checkout -- test.txt
	9、本地删除文件：rm text.txt
	10、库中删除文件：git rm txt.txt 然后提交。
	11、添加远程库关联：git remote add origin https://github.com/xq546247083/Test.git
	12、获取远程分支到本地：git pull <远程库名> <远程分支名>:<本地分支名> 
	13、提交本地库到远程库：
		1)、git push -u origin master
		2)、git push <远程库名> <本地分支名>:<远程分支名>
	14、克隆远程库到本地库：git clone git@github.com:xq546247083/TestTwo.git
	15、删除远程分支：git push origin --delete br
	16、拉取远程分支信息：git remote update origin --prune

---