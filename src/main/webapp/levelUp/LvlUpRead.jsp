<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" errorPage="../error/ErrorProc.jsp"%>
    
<%@ page import="pack_LevelUpBBS.BoardBean" %>
<jsp:useBean id="bMgr" class="pack_LevelUpBBS.BoardMgr"  scope="page" />
<%

request.setCharacterEncoding("UTF-8");

int lvlNumParam = Integer.parseInt(request.getParameter("lvlNum"));

// 검색어 수신 시작 
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
// 검색어 수신 끝

// 현재 페이지 돌아가기 소스 시작s
String nowPage = request.getParameter("nowPage");
// 현재 페이지 돌아가기 소스 끝

BoardBean bean = bMgr.getBoard(lvlNumParam);   
     //  List.jsp에서 클릭한 게시글의 매개변수로 전달된 글번호의 데이터 가져오기
     
int lvlNum =  bean.getLvlNum();
String lvlUid	=	bean.getLvlUid();
String lvlTitle	= bean.getLvlTitle();
String lvlContent = bean.getLvlContent();
String lvlName = bean.getLvlName();
String lvlSns = bean.getLvlSns();
//content.replace("cr", "<br>");

String lvlRegDate	= bean.getLvlRegDate();
int lvlPos	= bean.getLvlPos();
int lvlRef	= bean.getLvlRef();
int lvlDepth	= bean.getLvlDepth();
String lvlFileName	= bean.getLvlFileName();
double lvlFileSize 	= bean.getLvlFileSize();
String fUnit = "Bytes";
if(lvlFileSize > 1024) {
	lvlFileSize /= 1024;	
	fUnit = "KBytes";
} 

session.setAttribute("bean", bean);
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
	<title>등업 내용</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/lvlUpBBS.css">
</head>
<body>
	<div id="wrap">
		 <%@include file="../include/Header.jsp"%> 
		 
		<!--  HTML 템플릿(Template, Templet)  헤더 시작 -->
		

		<!--  HTML 템플릿(Template, Templet)  헤더 끝 -->
		
		
		<main id="main" class="read">   <!-- 본문영역 html 템플릿 시작 -->
			<!--  뷰페이지 내용 출력 시작 -->
		<h1><%=lvlUid %> 등업 문의</h1>
		<div id="readwrap">
			<h2><%=lvlTitle %></h2>
				
			<table id="readTbl">
				<tbody id="readTblBody">
					<tr>
						<td>작성자</td>  <!-- td.req 필수입력 -->
						<td><%=lvlUid %></td>
						<td>등록일</td>  <!-- td.req 필수입력 -->
						<td><%=lvlRegDate %></td>
					</tr>
					<tr>
						<td>상호명</td>  <!-- td.req 필수입력 -->
						<td><%=lvlName %></td>
						<td>SNS</td>  <!-- td.req 필수입력 -->
						<td><%=lvlSns %></td>
					</tr>
					<tr>
						<td>첨부파일</td> <!-- td.req 필수입력 -->
						<td colspan="3">
							<input type="hidden" name="lvlFileName" value="<%=lvlFileName%>" 
										id="hiddenFname">
						<% if (lvlFileName != null && !lvlFileName.equals("")) { %>						
							<span id="downloadFile"><%=lvlFileName %></span>							
							(<span><%=(int)lvlFileSize + " " + fUnit%></span>)
						<% } else { %>
							등록된 파일이 없습니다.
						<% } %>
						</td>
					</tr>
					<tr>
						<td colspan="4" id="readContentTd"><pre><%=lvlContent %></pre></td>
					</tr>					
				</tbody>
				 
				<tfoot id="readTblFoot">	
					<tr>
						<td colspan="4" id="footTopSpace"></td>							
					</tr>			     
					<tr>
						<td colspan="4" id="hrTd"><hr></td>							
					</tr>
					<tr>
						<%
						String listBtnLabel = "";
						if(keyWord.equals("null") || keyWord.equals("")) {
							listBtnLabel = "리스트";
						} else {
							listBtnLabel = "검색목록";
						}
						%>
							<td colspan="4" id="btnAreaTd" class="read">
							<form name = "AcForm" id ="AcForm" action="LvlUpAcProc.jsp">
							<button type="button" id="lvlListBtn" class="butcs"><%=listBtnLabel %></button>
							<%if (str1.equals(uLevel)){%>
							<button type="button" id="AcBtn" class="butcs">등업 승인</button>
							<input type="hidden" name="lvlName" value="<%=lvlName%>">
							<input type="hidden" name="lvlSns" value="<%=lvlSns%>">
							<input type="hidden" name="lvlUid" value="<%=lvlUid%>">
							<button type="button" id="RjBtn" class="butcs">등업 거절</button>
							</form>
							<%} else {%>
							<button type="button" id="lvlModBtn" class="butcs">수 정</button>
							<%} %>
							<button type="button" id="delBtn" class="butcs">삭 제</button>	
						</td>
					</tr>
				</tfoot>
				 
			</table>
			<input type="hidden" name="nowPage" value="<%=nowPage%>" id="nowPage">
			<input type="hidden" name="lvlNum" value="<%=lvlNum%>" id="lvlNum">
			
			<!-- 검색어전송 시작 -->
			<input type="hidden" id="pKeyField" value="<%=keyField%>">
			<input type="hidden" id="pKeyWord" value="<%=keyWord%>">
			<!-- 검색어전송 끝 -->
		  
		
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