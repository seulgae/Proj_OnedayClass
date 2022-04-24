<%@page import="pack_QnaBBS.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bMgr" class="pack_QnaBBS.BoardMgr" scope="page" />

<%
String nowPage = request.getParameter("nowPage");
String s = request.getParameter("qNum");
int numParam = Integer.parseInt(s);

//검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
//검색어 수신 끝
String uId = (String)session.getAttribute("idKey");
String uLevel = (String) session.getAttribute("levelKey");
BoardBean bean = (BoardBean) session.getAttribute("qnaBean");

int exeCnt = bMgr.deleteBoard(numParam);
	String url = "AdminQnaList.jsp?nowPage="+nowPage;
url += "&keyField="+keyField;
url += "&keyWord="+keyWord;
%>	
<script>
alert("삭제되었습니다!"); 
location.href = "<%=url%>";
</script>
