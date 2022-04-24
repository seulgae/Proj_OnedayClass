<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>


<jsp:useBean id="bean" class="pack_Member.MemberBean" scope="page" />
<jsp:setProperty  name="bean" property="*" />   
<!-- 위의 2줄로 MemberBean 클래스의 객체에 Setter를 사용하여 필드에 데이터 초기화 -->

<jsp:useBean id="mMgr" class="pack_Member.MemberMgr" scope="page" />
<%
boolean res = mMgr.insertMember(bean);
%>

<script>

<% if (res) { %>
	alert("회원가입을 완료!");
	location.href = "../sign/Login.jsp";
	
<% } else { %>
    let msg = "회원가입중에 오류가 발생하였습니다. 다시 시도해주십시오.\n";
         msg += "만일 오류가 계속된다면 관리자에게 연락부탁드립니다.";
	alert(msg);
	history.back();
<% } %>

</script>