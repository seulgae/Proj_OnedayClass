<%@page import="pack_ClassBBS.ClassBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bMgr" class="pack_ClassBBS.ClassMgr" scope="page" />
<%
String uId = (String)session.getAttribute("idKey");
String uLevel = (String)session.getAttribute("levelKey");

String nowPage = request.getParameter("nowPage");
String s = request.getParameter("cNum");
int numParam = Integer.parseInt(s);

ClassBean bean = (ClassBean)session.getAttribute("bean"); 
String realDBUid = bean.getcUid(); //ClassBean cUid 가져옴


if(uId.equals(realDBUid)||uLevel.equals("3")) {    // cUid와 uid가 일치한다면.
	int exeCnt = bMgr.approvalBoard(numParam);
	String url = "ClassList.jsp?cNum="+nowPage;
%>
	<script>
		alert("승인완료!");
		location.href ="<%=url%>";
	</script>
<% 
	} else {
%>		
	<script>
		alert("당신의 게시글이 아닙니다.");
		history.back();
	</script>
<%		
}
%>
