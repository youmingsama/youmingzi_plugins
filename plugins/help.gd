#RainyBot随机动漫图片/音乐示例插件
#更多帮助文档，示例插件及API请访问 https://github.com/Xwdit/RainyBot-API 进行查阅


extends Plugin #默认继承插件类，请勿随意改动


#将在此插件的文件被读取时执行的操作
func _on_init():
	#设定插件相关信息(全部必填)
	#从左到右分别为插件的ID，名称，作者，版本，描述
	set_plugin_info("help","帮助文档", "youmingsama","1.0","帮助文档")


#将在此插件被完全加载后执行的操作
func _on_load():
	
	register_keyword("幽明子帮帮我",_help,{},MatchMode.INCLUDE,)

	
	#注册群消息事件与好友消息事件，绑定到内置的"trigger_keyword"函数用于触发关键词
	#注意：若要直接绑定到内置函数，则必须附带双引号；仅消息事件可用于触发关键词
	register_event([GroupMessageEvent,FriendMessageEvent],"trigger_keyword",2)


#关键词 "二次元音乐" 将触发此函数，关键词所绑定的函数需要接收的参数从左到右分别为：
#关键词文本，解析后的关键词文本，关键词参数(通常为原消息去掉关键词后的文本)，触发关键词的事件实例	
func _help(keyword,parsed,arg,event):
	var path:String="E:\\RainyBot-Core-v2.0-beta-2-mirai\\help\\"+"help"+".png"
	var image = ImageMessage.init_path(path)
	event.reply(image)
	
	


	
