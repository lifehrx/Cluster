<%@ page language="java" contentType="text/html; charset=GB2312" pageEncoding="GB2312"%>  
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">  
<%@page import="java.util.*"%>  
  
  
<html>  
  
  <head>  
  
    <title>cluster test - share session</title>  
  
 <meta http-equiv="pragma" content="no-cache">  
  
 <meta http-equiv="cache-control" content="no-cache">  
  
  </head>  
  
  <body>  
  
 <%    
  
 String sessionid = session.getId();  
  
System.out.println("当前sessionid = " + sessionid);  
  
// 如果有新的 Session 属性设置  
  
 String dataName = request.getParameter("dataName");  
  
 if (dataName != null && dataName.length() > 0) {  
  
  String dataValue = request.getParameter("dataValue");  
  
  session.setAttribute(dataName, dataValue);  
  
 }  
  
 out.println("<b>Session 列表</b><br>");  
  
 System.out.println("============================");  
  
 Enumeration e = session.getAttributeNames();  
  
 while (e.hasMoreElements()) {  
  
  String name = (String)e.nextElement();  
  
  String value = session.getAttribute(name).toString();  
  
  out.println( name + " = " + value+"<br>");  
  
  System.out.println( name + " = " + value);  
  
  }  
  
 %>  
  
 <form action="test.jsp" id="form_add" method="post">  
  
  Key：<input id="dataName" name="dataName" type="text"/>  
  
  Value：<input id="dataValue" name="dataValue" type="text"/>  
  
     <input id="subBtn" name="subBtn" type="submit" value="提交" />  
  
 </form>  
  
  </body>  
  
</html>  