<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
request.setCharacterEncoding("UTF-8");
String uId = (String)session.getAttribute("idKey");
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
 	<% if (uId != null) {      %>
	 <script>
       	alert("이미 로그인 상태입니다."); 
		location.href="/Proj_OnedayClass/Index.jsp"; 	
	</script>
	  <% } else { // 현재 로그인 상태라면 %> 
    <div id="wrap">
    <%@include file="../include/Header.jsp"%>
        <!-- 로그인시작 -->
        <div id="signin">
        <form action="LoginProc.jsp" id="loginFrm" name="loginFrm">
			<table>
				<caption><hr><h3>로그인</h3></caption>
				<tbody>
					<tr>
						<td>
							<input type="text" class="loginInput" name="uId" id="uId" autofocus size="30"
                            placeholder="아이디">
						</td>
					</tr>
					<tr>
						<td>
							<input type="password" class="loginInput" name="uPw" id="uPw" size="30"
                            placeholder="비밀번호">
						</td>
					</tr>
					<tr>
						<td colspan="2">						
							<button type="button" id="loginBtn">로그인</button>
							<button type="button" id="signUpBtn">회원가입</button>
						</td>						
					</tr>
				</tbody>
			</table>
		</form>
        </div>
        <!-- 로그인끝 -->
        
    	<%@include file="../include/Footer.jsp"%>
        <!-- footer#footer -->
    </div>
    <%} %>	
</body>
    <script src="../script/jquery-3.6.0.min.js"></script>
	<script src="/Proj_OnedayClass/script/script.js"></script>
	<script src="/Proj_OnedayClass/script/member.js"></script>
</html>