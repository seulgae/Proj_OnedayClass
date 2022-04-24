<%@ page import="pack_reviewBBS.RvBoardBean"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bMgr" class="pack_reviewBBS.RvBoardMgr" scope="page" />
<%
String nowPage = request.getParameter("nowPage");
String s = request.getParameter("rNum");
int numParam = Integer.parseInt(s);

String rUid = request.getParameter("rUid");

String uid = (String)session.getAttribute("idKey");

//검색어 수신 시작

//검색어 수신 끝



/* if (request.getParameter("uPwParam") != null) {
	String uPwParam = request.getParameter("uPwParam"); 
	// 사용자가 현재 페이지에서 입력한 확인용 비번
	BoardBean bean = (BoardBean)session.getAttribute("bean");
	// String uId = bean.getuId();    // DB 에 저장되어 있는 실제 비번 */ 
	
	//if (uid.equals(rUid)) {    // 중첩 IF 시작 
		int exeCnt = bMgr.deleteBoard(numParam);
			%>	
		
