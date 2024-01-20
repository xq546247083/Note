# MacOS 禁用更新

	1、关闭「系统偏好」里的「自动更新」:
	删除 ~/Library/Preferences/com.apple.preferences.softwareupdate.plist
 
	2、修改更新服务器：
	defaults write com.apple.systempreferences AttentionPrefBundleIDs 0
	sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CatalogURL http://su.example.com:8088/index.sucatalog
	killall Dock
	
	3、恢复：
	sudo defaults delete /Library/Preferences/com.apple.SoftwareUpdate CatalogURL
	执行完成后重新打开一次更新检查就可以了。
