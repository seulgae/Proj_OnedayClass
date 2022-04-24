<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="pack_ClassBBS.ClassBean" %>
<jsp:useBean id="bMgr" class="pack_ClassBBS.ClassMgr" scope="page" />
<%
request.setCharacterEncoding("UTF-8");

%>

<%
bMgr.insertBoard(request);
response.sendRedirect("ClassOnList.jsp");



//System.out.print(cOnoff);

/*
if(Off.equals(cOnoff)){
	response.sendRedirect("ClassOffList.jsp");
}
else{
	response.sendRedirect("ClassOnList.jsp");
} 
*/
%>


	