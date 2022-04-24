<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="Proj_OnedayClass/bbs/ErrorProc.jsp"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="bMgr" class="pack_LevelUpBBS.BoardMgr" scope="page" />
<%
bMgr.downLoad(request, response, out, pageContext);
String[] str = {};
/* bMgr.main(str); */
%>    
    