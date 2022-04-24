<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
session.invalidate();  // 세션으로 로그인했다면
              // invalidate( ) 메서드로 세션 소멸하는 것이 로그아웃이다.
%>    
<script>
//alert("로그아웃되셨습니다.");
location.href="/Proj_OnedayClass/Index.jsp";
</script>