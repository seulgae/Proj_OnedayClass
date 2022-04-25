<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="mMgr" class="pack_Member.MemberMgr" scope="page" /> 
  
<%
request.setCharacterEncoding("UTF-8");
String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");

if (request.getParameter("uPw") != null) {
	String uPw = request.getParameter("uPw");

	boolean res = mMgr.loginMember(uId, uPw);
 
	if (res) {
	    response.sendRedirect("/Proj_OnedayClass/sign/MyPage.jsp");
	} else {
%>

	<script>
	alert("비밀번호를 확인해주세요.");
	history.back();
	</script>

<% 
	} // 배부 IF(비밀번호 확인) 끝
} else {		// 외부 IF의 else
%>  

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/sign.css">
</head>
<body>
    <div id="wrap">
    
		<%@include file="../include/Header.jsp"%>
               
        <div id="signin">
        <form id="loginFrm" name="loginFrm">
			<table>
				<caption><hr><h3>회원정보 확인</h3></caption>
				<tbody>
					<tr>
						<th>
							<%=uId %>
							<input type="hidden" class="loginInput" name="uId" id="uId" autofocus size="30"
                            value="<%=uId %>">
						</th>
					</tr>
					<tr>
						<td>
							<input type="password" class="loginInput" name="uPw" id="uPw" size="30"
                            placeholder="비밀번호">
						</td>
					</tr>
					<tr>
						<td colspan="2">						
							<button type="button" id="loginBtn">확인</button>
						</td>						
					</tr>
				</tbody>
			</table>
		</form>
        </div>
        <!-- 로그인끝 -->
        
        <%@include file="../include/Footer.jsp"%>
    </div>
</body>
    <script src="../script/jquery-3.6.0.min.js"></script>
	<script src="/Proj_OnedayClass/script/script.js"></script>
	<script src="/Proj_OnedayClass/script/member.js"></script>
</html>

<%
} // 외부 IF 끝.
%>