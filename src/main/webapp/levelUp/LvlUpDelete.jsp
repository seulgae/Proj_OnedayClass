<%@page import="pack_LevelUpBBS.BoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %> 
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bMgr" class="pack_LevelUpBBS.BoardMgr" scope="page" />

<%
String nowPage = request.getParameter("nowPage");
String s = request.getParameter("lvlNum");
int lvlNumParam = Integer.parseInt(s);


//검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
//검색어 수신 끝


String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");
String str1 = "3";
String str2 = "2";


/* if (request.getParameter("uPwParam") != null) {
	String uPwParam = request.getParameter("uPwParam");
	// 사용자가 현재 페이지에서 입력한 확인용 비번
	BoardBean bean = (BoardBean)session.getAttribute("bean");
	String uPw = bean.getuPw();    // DB 에 저장되어 있는 실제 비번
 	
	if (uPwParam.equals(uPw)) {  */  // 중첩 IF 시작
		int exeCnt = bMgr.deleteBoard(lvlNumParam);
	
		String url = "LvlUpList.jsp?nowPage="+nowPage;
				 url += "&keyField="+keyField;
				 url += "&keyWord="+keyWord;
%>	
		<script>
			alert("삭제되었습니다!");
			location.href = "<%=url%>";
		</script>
<%	
		//String url = "List.jsp";

%>		
 