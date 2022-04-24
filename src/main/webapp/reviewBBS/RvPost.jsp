<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack_Member.MemberMgr" scope="page" />
<%
String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");

int cNum = (int) session.getAttribute("cNumKey");
String nowPage = request.getParameter("nowPage");
%>  

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>OneDayClass</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/ajaxBBS.css">
</head>
<body>
 <% if (uId == null) {      %>
	 <script>
       	alert("로그인 후 사용 가능합니다."); 
		location.href="/Proj_OnedayClass/sign/Login.jsp"; 	
	</script>
	
      <%} %>	
	<div id="wrap">
	
	<%-- <jsp:include page="../include/Header.jsp" /> --%>
		
		
		
		
		<main id="main" class="post">   <!-- 본문영역 html 템플릿 시작 -->
		<div id="postwrap">
			<h2>글쓰기</h2>
			
			<form name="postFrm" action="RvPostProc.jsp"
			enctype="multipart/form-data" method="post" id="postFrm">
			
				<table>
					<tbody>
						<tr>
							<td class="req">작성자</td>  <!-- td.req 필수입력 -->
							<td>
								<span class=postuId><%=uId%></span>
								<input type="hidden" name="rUid" id="rUid" value="<%=uId%>">
								<input type="hidden" name="cNum" id="cNum" value="<%=cNum%>">
							</td>
						</tr>
						<tr>
							<td class="req">제목</td> <!-- td.req 필수입력 -->
							<td>
								<input type="text" name="rTitle"
								maxlength="50" size="60" id="rTitle">
							</td>
						</tr>
						<tr>
							<td class="contentTD">내용</td>
							<td>
								<textarea name="rContent" id="rContent" rows="10" cols="59"  wrap="hard"></textarea>
							</td>
						</tr>
						<tr>
							<td>파일첨부</td>
							<td>
								<span class="spanFile">
									<input type="file" name="rFileName"
									 id="rFileName">
								</span>	
							</td>
						</tr>
						<tr>
							<td>
									<input type="hidden" name="contentType"
										value="HTML">									
									<input type="hidden" name="contentType"
										value="TEXT" checked>													
							</td>
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="2"><hr>	</td>							
						</tr>
						<tr>
							<td colspan="2">
								<button type="button" id="regBtn" class="butcs">등록</button>
								<button type="reset" class="butcs">다시쓰기</button>
								<button type="button" id="listBtn" class="butcs">글목록</button>
							</td>
						</tr>
					</tfoot>
				</table>		
			
			</form>	
		</div>
		
			<input type="hidden" name="nowPage" value="<%=nowPage%>" id="nowPage">
		</main>  <!-- 본문영역 html 템플릿 끝 -->
		
		<%-- 	<jsp:include page="../include/Footer.jsp" /> --%>
	
	</div>
	<!-- div#wrap -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/script.js"></script>
	<script src="/Proj_OnedayClass/script/bbs.js"></script>        
</body>
</html>