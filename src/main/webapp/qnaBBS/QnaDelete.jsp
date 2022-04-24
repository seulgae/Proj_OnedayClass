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

String realDBUid = bean.getqUid();

if (uId.equals(realDBUid) || uLevel.equals("3")) { // 사용자 아이디와 작성자 아이디가 일치할경우
	int exeCnt = bMgr.deleteBoard(numParam);
} // IF 끝
%>