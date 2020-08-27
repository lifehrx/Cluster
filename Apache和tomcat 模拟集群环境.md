**Apache + tomcat 模拟集群环境**

**一．下载**

1. download apache http Service

地址：<https://httpd.apache.org/>

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF82F.tmp.jpg) 

 

2. download tomcat 

地址：<http://tomcat.apache.org/>

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF83F.tmp.jpg) 

并解压2次

目录结构如下

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF860.tmp.jpg) 

 

二．启动

1. 以管理员身份打开host文件，并添加如下修改

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF870.tmp.jpg) 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF881.tmp.jpg) 

 

2. **修改配置文件**

进入：D:\Clusters\Apache24\conf\httpd.conf

1)**修改为自己实际地址**

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF8B1.tmp.jpg) 

2) **若是端口冲突可修改为其它**

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF8C1.tmp.jpg) 

 

3)**设置集群策略，开放如下注释**

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF8D2.tmp.jpg) 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF8E3.tmp.jpg) 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF8F3.tmp.jpg) 

3. 测试httpd:打开httpd.exe 不闪退

若是闪退：

情况1：端口被占用

情况2：httpd/conf 改错了

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF904.tmp.jpg) 

 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF915.tmp.jpg) 

 

三．安装集群tomcat

**1****.****分别打开解压后的tomcat D:\Clusters\apache-tomcat1-8.5.29\conf\server.xml**

**做如下修改（tomcat2同理）**

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF935.tmp.jpg) 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF945.tmp.jpg) 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF956.tmp.jpg) 

tomcat session共享

当我们需要多个tomcat集群，并且tomcat之间共享session时，需要做如下配置：

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF976.tmp.jpg) 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF987.tmp.jpg) 

2、**修改集群配置文件httpd.conf。**

修改D:\Cluster\Apache24\conf\httpd.conf

在最末尾处添加:

ProxyPass /distributed balancer://cluster01/ stickysession=JSESSIONID

ProxyPassReverse / balancer://cluster01/

<proxy balancer://cluster01>

​    BalancerMember ajp://localhost:50001/distributed loadfactor=1 route=tomcat1

​    BalancerMember ajp://localhost:50002/distributed loadfactor=1 route=tomcat2

</proxy>

 

**3.修改配置文件**

要在要将web.xml文件<web-app>元素的最后加上： <distributable/>   两个地方的web.xml，一个是应用程序的WEB-INF\web.xml，另一个是tomcatx（注：x为1或2）/conf/web.xml

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF998.tmp.jpg) 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF9A8.tmp.jpg) 

 

**4.此时目录结构**

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF9B9.tmp.jpg) 

 

四．负载均衡

**apache服务器和tomcat通过mod_jk文件来进行连接：**

 

1、**将下载好的mod_jk.so放到Apache24\modules下**

**下载地址：（根据自己所用的版本和电脑系统选择）**<https://stackoverflow.com/questions/41011820/how-to-install-mod-jk-apache-tomcat-connectors-on-windows-server>

 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF9C9.tmp.jpg) 

2、**修改Apache配置文件conf/httpd.conf 在最后一行末尾添加:**

include conf/mod_jk.conf

 

3、**在httpd.conf 同目录下新建mod_jk.conf文件，文件内容如下:**

\#Tomcat集群配置

LoadModule jk_module modules/mod_jk.so

JkWorkersFile conf/workers.properties

\#我的工人们

JkLogFile logs/mod_jk.log            

\#日志文件

JkLogLevel debug                     

\#tomcat运行模式

JkMount /*.jsp loadbalancer          

\#收到.jsp结尾的文件交给负载均衡器处理

 

4、**在http.conf同目录下新建 workers.properties文件**

**文件内容如下****：**

worker.list = loadbalancer

worker.tomcat1.host=localhost        #Tomcat tomcat1服务器

worker.tomcat1.port=50001            #Tomcat端口

worker.tomcat1.type=ajp13            #协议

worker.tomcat1.lbfactor=100            #负载平衡因数

 

worker.tomcat2.host=localhost        #Tomcat tomcat2服务器

worker.tomcat2.port=50002            #因为在一台机器上所以端口不能一样

worker.tomcat2.type=ajp13            #协议

worker.tomcat2.lbfactor=100            #设为一样代表两台机器的负载相同

 

worker.loadbalancer.type=lb

worker.loadbalancer.retries=3

worker.loadbalancer.balanced_workers=tomcat1,tomcat2

worker.loadbalancer.sticky_session=false    

worker.loadbalancer.sticky_session_force=false 

 

五．**测试**

**1.把要测试的项目分别发布到tomcat1和tomcat2**

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF9EA.tmp.jpg) 

 

 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsF9FA.tmp.jpg) 

 

**1浏览器输入项目地址并测试，刷新后看到页面跳转，可证明成功。**

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsFA0B.tmp.jpg) 

![img](file:///C:\Users\lenovo\AppData\Local\Temp\ksohtml\wpsFA1C.tmp.jpg) 

 

后记：

1.Httpd:百科

**httpd是Apache**[**超文本传输协议**](https://baike.baidu.com/item/%E8%B6%85%E6%96%87%E6%9C%AC%E4%BC%A0%E8%BE%93%E5%8D%8F%E8%AE%AE)**(HTTP)服务器的主程序。被设计为一个独立运行的后台进程，它会建立一个处理请求的子进程或线程的池**。

 

1. Apache 和 tomcat区别

**apache:侧重于http server** **tomcat:侧重于servlet引擎，如果以standalone方式运行，功能上与apache等效 ， 支持JSP，但对静态网页不太理想；** **apache是web服务器，tomcat是应用（java）服务器，它只是一个servlet(jsp也翻译成servlet)容器，可以认为是apache的扩展，但是可以独立于apache运行。****换句话说，apache是一辆卡车，上面可以装一些东西如html等。但是不能装水，要装水必须要有容器（桶），而这个桶也可以不放在卡车上。**
