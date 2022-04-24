<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack_Member.MemberMgr" scope="page" />

<%
String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");
String str1 = "3";
String str2 = "2";
%>  

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>등업 페이지</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/lvlUpBBS.css">
</head>
<body>
	<div id="wrap">       
		<!--  HTML 템플릿(Template, Templet)  헤더 시작 -->
		<%@include file="../include/Header.jsp"%> 
		
		<!--  HTML 템플릿(Template, Templet)  헤더 끝 -->
		
		
		<main id="main" class="post">   <!-- 본문영역 html 템플릿 시작 -->
		<h1>등업 페이지</h1>
		<div id="postwrap">
			<h2>등업 작성</h2>
			
			<form name="postFrm" action="LvlUpPostProc.jsp"
			enctype="multipart/form-data" method="post" id="postFrm">
				<table>
					<tbody>
						<tr>
							<td class="req">아이디</td>  <!-- td.req 필수입력 -->
							<td>
								<%=uId%>
								<input type="hidden" name="lvlUid" id="lvlUid" value="<%=uId%>">
							</td>
						</tr>
						<tr>
							<td class="req">제목</td> <!-- td.req 필수입력 -->
							<td>
								<input type="text" name="lvlTitle"
								maxlength="50" id="lvlTitle">
							</td>
						</tr>
						<tr>
							<td class="contentTD">등업 내용</td>
							<td>
								<textarea name="lvlContent" id="lvlContent" cols="60" wrap="hard"></textarea>
							</td>
						</tr>
						<tr>
							<td class="req">상호명</td> <!-- td.req 필수입력 -->
							<td>
								<input type="text" name="lvlName"
								maxlength="50" id="lvlName">
							</td>
						</tr>
						<tr>
							<td>SNS</td> <!-- td.req 필수입력 -->
							<td>
								<input type="text" name="lvlSns"
								maxlength="50" id="lvlSns">
							</td>
						</tr>
						<tr>
							<td class="req">등업관련 파일첨부</td>
							<td>
								<span class="spanFile">
									<input type="file" name="lvlFileName"
									 id="lvlFileName">
								</span>	
							</td>
						</tr>
						<tr>
									<input type="hidden" name="contentType"
										value="HTML">									
									<input type="hidden" name="contentType"
										value="TEXT" checked>						
						</tr>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="2"><hr></td>							
						</tr>
						<tr>
							<td colspan="2">
								<button type="button" id="lvlRegBtn" class="butcs">등록</button>
								<button type="reset" class="butcs">다시쓰기</button>
								<button type="button" id="lvlListBtn" class="butcs">리스트</button>
							</td>
						</tr>
					</tfoot>
				</table>
			</form>
		</div>
		</main>  <!-- 본문영역 html 템플릿 끝 -->
		<%@include file="../include/Footer.jsp"%>

	</div>
	<!-- div#wrap -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/script.js"></script>
	<script src="/Proj_OnedayClass/script/lvlUpBBS.js"></script>        
</body>
</html>