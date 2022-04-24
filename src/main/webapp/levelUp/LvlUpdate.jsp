<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="pack_LevelUpBBS.*"%>
    
<%
request.setCharacterEncoding("UTF-8");

int lvlNum = Integer.parseInt(request.getParameter("lvlNum"));
String nowPage = request.getParameter("nowPage");

//검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
//검색어 수신 끝

BoardBean bean = (BoardBean)session.getAttribute("bean");
String lvlTitle = bean.getLvlTitle();
String lvlUid = bean.getLvlUid();
String lvlContent = bean.getLvlContent();
String lvlName = bean.getLvlName();
String lvlSns = bean.getLvlSns();

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
	<title>등업 수정페이지</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/lvlUpBBS.css">
</head>
<body>
	<div id="wrap">
		<%@include file="../include/Header.jsp"%> 
		
		<!--  HTML 템플릿(Template, Templet)  헤더 시작 -->
		<!--  HTML 템플릿(Template, Templet)  헤더 끝 -->
		
		
		<main id="main" class="mod">   <!-- 본문영역 html 템플릿 시작 -->
			<!--  뷰페이지 내용 출력 시작 -->
			<div id="modwrap">
			<h1>등업 수정</h1>
			<form name="updateFrm" action="LvlUpdateProc.jsp"
					method="get" id="updateFrm">
		
				<h2><%=lvlTitle%></h2>
					
				<table id="modTbl">
					<tbody id="modTblBody">
						<tr>
							<td class="req">작성자</td>
							<td>
								<%=lvlUid%>
								<input type="hidden" name="lvlUid" id="lvlUid" value="<%=lvlUid%>">
							</td>
						</tr>
						<tr>
							<td class="req">제목</td>
							<td>
								<input type="text" name="lvlTitle" value="<%=lvlTitle%>"
									size="50" id="lvlTitle">
							</td>
						</tr>
						<tr>
							<td class="req">상호명</td>
							<td>
								<input type="text" name="lvlName" value="<%=lvlName%>"
									size="50" id="lvlName">
							</td>
						</tr>
						<tr>
							<td class="req">SNS</td>
							<td>
								<input type="text" name="lvlSns" value="<%=lvlSns%>"
									size="50" id="lvlSns">
							</td>
						</tr>
						<tr>
							<td style="vertical-align: top;">내용</td>
							<td>
								<textarea name="lvlContent" id="txtArea"  cols="89" wrap="hard"><%=lvlContent %></textarea>
							</td>
						</tr>
					</tbody>
					 
					<tfoot>	
						<tr>
							<td colspan="2" id="footTopSpace"></td>							
						</tr>	
						<tr>
							<td colspan="2" id="hrTd"><hr></td>							
						</tr>
						<tr>
							<td colspan="2" id="btnAreaTd" class="update">
								<button type="button" id="lvleModBtn" class="butcs">수정하기</button>
								<button type="reset" class="butcs">다시쓰기</button>
								<button type="button" id="backBtn" class="butcs">뒤 로</button>							
							</td>
						</tr>
					</tfoot>
					 
				</table>
				<input type="hidden" name="nowPage" value="<%=nowPage%>" id="nowPage">
				<input type="hidden" name="lvlNum" value="<%=lvlNum%>" id="lvlNum">
				
				<!-- 검색어전송 시작 -->
				<input type="hidden" name="keyField" id="keyField" value="<%=keyField%>">
				<input type="hidden" name="keyWord" id="keyWord" value="<%=keyWord%>">
				<!-- 검색어전송 끝 -->
		
			</form>
			<!--  뷰페이지 내용 출력 끝 -->
			
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