<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
    
<jsp:useBean  id="mMgr"   class="pack_Member.MemberMgr"  scope="page" />

<%
request.setCharacterEncoding("UTF-8");
String uId = request.getParameter("uId");
boolean result = mMgr.checkId(uId);
%>    
    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>ID 중복체크</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/sign.css">
    <style>
	   	div#wrap{
			width: 100%;
			text-align: center;
			padding: 20px;
		}
		div#wrap h2{
			color: #ec665d;	
			font-size: 50px;
			margin-bottom: 25px;
		}
		div#wrap button{
			font-weight: bold;
			background: #fff;
			border: none;
    		color:#000;
			margin: 35px auto;
			font-size: 20px;
			opacity: 60%;
			width: 20%;
		}
		div#wrap button:hover{
			opacity: 100%;	
		}
    </style>
    <script>
    function fnClose() {    	
    	opener.regFrm.uIdBtnClickChk.value = "1";    
    	opener.regFrm.uId.focus();
    	window.close();
    }
    </script>
</head>
<body>
	<div id="wrap">
		<h2><%=uId %></h2>
		<%
		if (result) {
			out.println("<b>사용중인 아이디입니다.</b>");
		} else {
			out.println("<b>사용가능한 아이디입니다.</b>");
		}		
		%>
		<br>
	<button type="button" onclick="fnClose()">
			확인
	</button>
	</div>
	<!-- div#wrap -->
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/script.js"></script>  
</body>
</html>