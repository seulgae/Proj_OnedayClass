<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="bMgr" class="pack_QnaBBS.BoardMgr" scope="page" />
<jsp:useBean id="reBean" class="pack_QnaBBS.BoardBean" scope="page" />
<jsp:setProperty name="reBean" property="*" />

<%
int repUpCnt = bMgr.replyUpBoard(reBean.getqRef(), reBean.getqPos());
     // 끼어들기가 아닐경우 실행되는 소스 없음.
int repInsCnt = bMgr.replyBoard(reBean);
%>
    