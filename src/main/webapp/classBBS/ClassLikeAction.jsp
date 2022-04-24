<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
<jsp:useBean id="bMgr" class="pack_ClassBBS.ClassMgr"  scope="page" />
<jsp:useBean id="LikeBean" class="pack_ClassBBS.ClassLikeBean"  scope="page" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
</head>
<body>
<%

String uId = (String)session.getAttribute("idKey");
int cNum = Integer.parseInt(request.getParameter("cNum"));
//String uId = request.getParameter("uId");

%>
<h2><%=cNum %><%=uId %></h2>

<%
LikeBean.setuId(uId);
LikeBean.setcNum(cNum);
int result = bMgr.UpdateLike(LikeBean);
if(result == 0){
%>
		<script>
			alert("이미 찜하신 강의입니다.");
			history.back();
		</script>
<%	
}
else{
	
	%>
	<script>
			alert("찜완료^_^"); 
			//location.href = history.back(-1);
			<%
			
			bMgr.InsertLikeCnt(cNum);
			
			%>

			history.back();
		</script>
	<%
}

%>
</body>
</html>