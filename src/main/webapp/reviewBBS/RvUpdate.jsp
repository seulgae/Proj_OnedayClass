<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="pack_reviewBBS.*"%>
    
<%
request.setCharacterEncoding("UTF-8");

int num = Integer.parseInt(request.getParameter("rNum"));
String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");


String nowPage = request.getParameter("nowPage");

//검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
//검색어 수신 끝


RvBoardBean bean = (RvBoardBean)session.getAttribute("rvBean");
String rTitle = bean.getrTitle();
String rUid = bean.getrUid();
String rContent = bean.getrContent();
int rNum = bean.getrNum();
%>    
    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>OnedayClass</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/ajaxBBS.css">
</head>
<body>

	 <% if (uId == null) {      %>
	 <script>
       	alert("로그인 후 사용 가능합니다."); 
		location.href="/Proj_OnedayClass/sign/Login.jsp"; 	
	</script>
	
       <% } else { // 현재 로그인 상태라면 %> 
	<div id="wrap">
	
	<jsp:include page="../include/Header.jsp" />
			<%} %>	
			
		<main id="main" class="mod">   <!-- 본문영역 html 템플릿 시작 -->
			<!--  뷰페이지 내용 출력 시작 -->
			<div id="modwrap">
			<form name="updateFrm" action="RvUpdateProc.jsp"
					method="get" id="updateFrm">
			<input type="hidden" name="rNum" value="<%=rNum%>" 
										id="hiddenrNume">
				<h2><%=rTitle %></h2>
					
				<table id="modTbl">
					<tbody id="modTblBody">
						<tr>
							<td class="req">작성자</td>
							<td>
								<input type="text" id="uId"
								name="uId" value="<%=uId %>"
									size="80"  readonly>
							</td>
						</tr>
						<tr>
							<td class="req">제목</td>
							<td>
								<input type="text" name="rTitle" value="<%=rTitle %>"
									size="80" id="rTitle">
							</td>
						</tr>
						<tr>
							<td style="vertical-align: middle;">내용</td>
							<td>
								<textarea name="rContent" id="txtArea"  cols="79" wrap="hard"><%=rContent %></textarea>
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
								<button type="button" id="modBtn">수정하기</button>
								<button type="reset">다시쓰기</button>
								<button type="button" id="backBtn">뒤 로</button>							
							</td>
						</tr>
					</tfoot>
					 
				</table>
				<input type="hidden" name="nowPage" value="<%=nowPage%>" id="nowPage">
				<input type="hidden" name="num" value="<%=num%>" id="num">
				
				<!-- 검색어전송 시작 -->
				<input type="hidden" name="keyField" id="keyField" value="<%=keyField%>">
				<input type="hidden" name="keyWord" id="keyWord" value="<%=keyWord%>">
				<!-- 검색어전송 끝 -->
		
			</form>
			<!--  뷰페이지 내용 출력 끝 -->
			
			</div>
		</main>  <!-- 본문영역 html 템플릿 끝 -->
		
		<jsp:include page="../include/Footer.jsp" />


	</div>

	<!-- div#wrap -->
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/bbs.js"></script>    
</body>
</html>