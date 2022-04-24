<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>
    
<%@ page import="pack_reviewBBS.RvBoardBean" %>
<jsp:useBean id="bMgr" class="pack_reviewBBS.RvBoardMgr"  scope="page" />
<%
request.setCharacterEncoding("UTF-8");

int numParam = Integer.parseInt(request.getParameter("rNum"));
String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");

/* // 검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
// 검색어 수신 끝 */

// 현재 페이지 돌아가기 소스 시작
String nowPage = request.getParameter("nowPage");
// 현재 페이지 돌아가기 소스 끝

bMgr.upCount(numParam);    // 조회수 증가
RvBoardBean bean = bMgr.getBoard(numParam);   
     //  List.jsp에서 클릭한 게시글의 매개변수로 전달된 글번호의 데이터 가져오기
     
int rNum =  bean.getrNum();
String rTitle	= bean.getrTitle();
String rContent	= bean.getrContent();
//content.replace("cr", "<br>");

int rCnt	= bean.getrCnt();
int rLikes	= bean.getrLikes();
String rRegDate	= bean.getrRegDate();
String rFileName	= bean.getrFileName();
double rFileSize 	= bean.getrFileSize();
int rStatus	= bean.getrStatus();

String rUid = bean.getrUid();


String fUnit = "Bytes";
if(rFileSize > 1024) {
	rFileSize /= 1024;	
	fUnit = "KBytes";
} 

//String ip	= bean.getIp();

session.setAttribute("bean", bean);
%>   	
    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>OneDayClass</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/reviewBBS.css">
</head>
<body>
 <% if (uId == null) {      %>
	 <script>
       	alert("로그인 후 사용 가능합니다."); 
		location.href="/Proj_OnedayClass/sign/Login.jsp"; 	
	</script>
	
       <% } else { // 현재 로그인 상태라면 %> 
	<div id="wrap">
	
	<%@include file="../include/AdHeader.jsp"%>
		
		<%} %>	
		
		<main id="main" class="read">   
				<h1>Review</h1>
		
			<!--  뷰페이지 내용 출력 시작 -->
		<div id="readwrap">
			<h2><%=rTitle %></h2>
				
			<table id="readTbl">
				<tbody id="readTblBody">
					<tr>
						<td>작성자</td>  <!-- td.req 필수입력 -->
						<td><%=rUid %></td>
						<td>등록일</td>  <!-- td.req 필수입력 -->
						<td><%=rRegDate %></td>
					</tr>
					<tr>
						<td>첨부파일</td> <!-- td.req 필수입력 -->
						<td colspan="1">
							<input type="hidden" name="rFileName" value="<%=rFileName%>" 
										id="hiddenFname">
						<% if (rFileName != null && !rFileName.equals("")) { %>						
							<span id="downloadFile"><%=rFileName %></span>							
							(<span><%=(int)rFileSize + " " + fUnit%></span>)
						<% } else { %>
							등록된 파일이 없습니다.
						<% } %>
						</td>
						<td>추천수</td>
						<td><%=rLikes %></td>
					</tr>
					<tr>
						<td colspan="4" id="readContentTd"><pre><%=rContent %></pre>
						<br><br><br>
							<center>
							<img src='../fileUpload/<%=rFileName %>' /></td>
							</center>
					</tr>					
				</tbody>
				 
				<tfoot id="readTblFoot">	
					<tr>
						<td colspan="4" id="footTopSpace"></td>							
					</tr>			     
				<%-- 	<tr>
						<td colspan="4" id="articleInfoTd">
							<span><%="조회수 : " + rCnt %></span>
						 			
						</td>	 --%>						
					</tr>
					<tr>
						<td colspan="4" id="hrTd"><hr></td>							
					</tr>
					<tr>
						<%
						String listBtnLabel = "";
						listBtnLabel = "글목록";
						/* if(keyWord.equals("null") || keyWord.equals("")) {
							listBtnLabel = "글목록";
						} else {
							listBtnLabel = "검색목록";
						} */
						%>
					
						<td colspan="5" id="btnAreaTd" class="read">
							<button type="button" id="listBtn" class="butcs"><%=listBtnLabel %></button>
							<%
								if(uId.equals(rUid) || uLevel.equals("3")){ 
							%>
								<button type="button" id="delBtn" class="butcs">삭 제</button>
								
							<%
								} else {	
								 %>
								 								 
								<button type="button" id="likeBtn" onClick="location.href='RvLikeAction.jsp?rNum=<%= rNum %>&uId=<%=uId%>'">추천하기</button>
							<%	 }%>														
								<!--  <img src="/Proj_OnedayClass/img/heart.png" width="50px"> -->
							
						</td>
					</tr>
				</tfoot>
				 
			</table>
			<input type="hidden" name="nowPage" value="<%=nowPage%>" id="nowPage">
			<input type="hidden" name="rNum" value="<%=rNum%>" id="rNum">
			
			<%-- <!-- 검색어전송 시작 -->
			<input type="hidden" id="pKeyField" value="<%=keyField%>">
			<input type="hidden" id="pKeyWord" value="<%=keyWord%>">
			<!-- 검색어전송 끝 --> --%>
		  
			</div>
		
			<!--  뷰페이지 내용 출력 끝 -->
		</main>  <!-- 본문영역 html 템플릿 끝 -->
	
		<%@include file="../include/Footer.jsp"%>	
	

	</div>

	<!-- div#wrap -->
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/adRvBBS.js"></script>    
</body>
</html>