#RainyBot随机动漫图片/音乐示例插件
#更多帮助文档，示例插件及API请访问 https://github.com/Xwdit/RainyBot-API 进行查阅


extends Plugin #默认继承插件类，请勿随意改动


#将在此插件的文件被读取时执行的操作
func _on_init():
	#设定插件相关信息(全部必填)
	#从左到右分别为插件的ID，名称，作者，版本，描述
	set_plugin_info("kkskapi","各种api", "youmingsama","1.0","各种好玩的api")


#将在此插件被完全加载后执行的操作
func _on_load():
	
	register_keyword("幽明子舔",api_tian,{},MatchMode.INCLUDE,)
	register_keyword("幽明子pixiv",api_pixiv,{},MatchMode.INCLUDE)
	register_keyword("幽明子历史上的今天",api_history,{},MatchMode.INCLUDE)
	register_keyword("幽明子壁纸",api_pic,{},MatchMode.INCLUDE,)
	register_keyword("幽明子网抑云",api_music,{},MatchMode.INCLUDE)
	register_keyword("幽明子微博热点",api_wb,{},MatchMode.INCLUDE)
	
	#注册群消息事件与好友消息事件，绑定到内置的"trigger_keyword"函数用于触发关键词
	#注意：若要直接绑定到内置函数，则必须附带双引号；仅消息事件可用于触发关键词
	register_event([GroupMessageEvent,FriendMessageEvent],"trigger_keyword",2)


#关键词 "二次元图片" 将触发此函数，关键词所绑定的函数需要接收的参数从左到右分别为：
#关键词文本，解析后的关键词文本，关键词参数(通常为原消息去掉关键词后的文本)，触发关键词的事件实例
func api_tian(keyword,parsed,arg,event):
	#发送Http Get请求到特定的随机二次元图片API，并等待返回结果(返回结果为一个HttpRequestResult类的实例)
	var _result:HttpRequestResult = await Utils.send_http_get_request("https://cloud.qqshabi.cn/api/tiangou/api.php")
	var reply = _result.get_as_text()
	
	var msg = TextMessage.init(reply)
		#将图片消息发送回触发此关键词的位置，并引用原消息(第二个参数)；且如果来自群聊，则AT原消息发送者(第三个参数)
	event.reply(msg,true,true)
			

#关键词 "二次元音乐" 将触发此函数，关键词所绑定的函数需要接收的参数从左到右分别为：
#关键词文本，解析后的关键词文本，关键词参数(通常为原消息去掉关键词后的文本)，触发关键词的事件实例	
func api_pic(keyword,parsed,arg,event):
		var msg = ImageMessage.init_url("https://cloud.qqshabi.cn/api/images/api.php")
	
		event.reply(msg,true ,true ) #将音乐分享消息发送回触发此关键词的位置
	
	
func api_music(keyword,parsed,arg,event):
	var _result:HttpRequestResult = await Utils.send_http_get_request("https://tenapi.cn/comment/")
	
	var _dic = _result.get_as_dic() #从返回结果中解析并获取字典
	if !_dic.is_empty(): #判断是否成功获取到包含数据的字典(不为空)
		var song:String = _dic["data"]["song"] #从字典中获取图片链接
		var name:String = _dic["data"]["name"]
		var content:String = _dic["data"]["content"]
		var url:String = _dic["data"]["url"]
		var msg:String = "歌曲:"+song+"\n"+"作者:"+name+"\n"+content+"\n"+url
		event.reply(msg,true,true)

func api_wb(keyword,parsed,arg,event):
	var msg:String
	var _result:HttpRequestResult = await Utils.send_http_get_request("https://tenapi.cn/resou/")
	
	var _dic = _result.get_as_dic() #从返回结果中解析并获取字典
	if !_dic.is_empty(): #判断是否成功获取到包含数据的字典(不为空)
		var data:Array = _dic["list"] #从字典中获取图片链接
		for i in range(10):
			var res:String = str(data[i]["name"])+"hot:"+str(data[i]["hot"])+"\n"
			msg = msg+res
			
		event.reply(msg,true,true)

func api_history(keyword,parsed,arg,event):
	#发送Http Get请求到特定的随机二次元图片API，并等待返回结果(返回结果为一个HttpRequestResult类的实例)
	var _result:HttpRequestResult = await Utils.send_http_get_request("https://tenapi.cn/lishi/?format=json")
	var _dic = _result.get_as_dic() #从返回结果中解析并获取字典
	if !_dic.is_empty(): #判断是否成功获取到包含数据的字典(不为空)
		var msg:String = str(_dic["content"] )#从字典中获取图片链接
		#将图片消息发送回触发此关键词的位置，并引用原消息(第二个参数)；且如果来自群聊，则AT原消息发送者(第三个参数)e
		msg=msg.replace(",","\n")
		event.reply(msg,true,true)

func api_pixiv(keyword,parsed,arg,event):
	var _result:HttpRequestResult = await Utils.send_http_get_request("https://pixiv.youmingsama.workers.dev/")
	var _dic = _result.get_as_dic() #从返回结果中解析并获取字
	
	
	if !_dic.is_empty():
		var id:String = str(_dic["id"])
		var title:String = _dic["title"]
		var url:String = _dic["url"]
		url = url.replace("pximg.net","pixiv.re")
		var res:String = "本日pixiv排行榜首的插画是:id:"+id+"\n"+"名字:"+title+"\n"+"url"+url
		var msg = MessageChain.init(ImageMessage.init_url(url)).append(TextMessage.init(res))
		event.reply(msg,true ,true )
