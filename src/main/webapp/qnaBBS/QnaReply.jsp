<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<jsp:useBean id="qnaBean" class="pack_QnaBBS.BoardBean" scope="session" />    
    
<%
request.setCharacterEncoding("UTF-8");
int qNum = Integer.parseInt(request.getParameter("qNum"));
int cNum = (int) session.getAttribute("cNumKey"); //클래스 게시판 번호
//검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
//검색어 수신 끝

String nowPage = request.getParameter("nowPage");
String qUid = qnaBean.getqUid();
String qTitle = qnaBean.getqTitle();
String qContent = qnaBean.getqContent();
String qRef = String.valueOf(qnaBean.getqRef());
String qDepth = String.valueOf(qnaBean.getqDepth());
String qPos = String.valueOf(qnaBean.getqPos());

String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");
%>
    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/ajaxBBS.css">
</head>
<body>
	<div id="wrap">
		
		<!--  HTML 템플릿(Template, Templet)  헤더 시작 -->
		<h1>답변 작성 페이지</h1>
		<!--  HTML 템플릿(Template, Templet)  헤더 끝 -->
		
		<main id="main" class="reply">   <!-- 본문영역 html 템플릿 시작 -->
			<!--  답변페이지 내용 출력 시작 -->
		
			<form name="replyFrm" action="QnaReplyProc2.jsp"
					method="post" id="replyFrm">
		
				<h2>답변글 작성</h2>
					
				<table id="replyTbl">
					<tbody id="replyTblBody">
						<tr>
							<td class="req">작성자</td>
							<td>
								<%=uId %> 님
								<input type="hidden" name="qUid" id="qUid" value="<%=uId%>">
								<span class="ori_Txt"><b><%=qUid %></b> 님의 글</span>
								<input type="hidden" name="cNum" id="cNum" value="<%=cNum%>">
							</td>
						</tr>
						<tr>
							<td class="req">제목</td>
							<td>
								<input type="text" name="qTitle" value=""
									size="50" id="qTitle">								
								<span class="ori_Txt">원본 글제목 : <b><%=qTitle %></b></span>
							</td>
						</tr>
						<tr>
							<td>공개여부</td>
							<td>
								공개 <input type="radio" name="qStatus"
									value="2" >									
								비공개 <input type="radio" name="qStatus"
									value="1" checked>											
							</td>
						</tr>
						<tr>
							<td style="vertical-align: top;">내용</td>
							<td>
								<textarea name="qContent" id="qContent"  
								cols="89" wrap="hard"></textarea>
								
								<span id="ori_SpanTxtArea" class="ori_Txt">원본 글내용</span>
								<textarea id="ori_TxtArea"  
								cols="89" readonly><%=qContent %></textarea>
								
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
							<td colspan="2" id="btnAreaTd" class="reply">
								<button type="button" id="replyBtn" class="butcs">답변등록</button>
								<button type="reset" class="butcs">다시쓰기</button>
								<button type="button" id="backBtn" class="butcs">뒤 로</button>							
							</td>
						</tr>
					</tfoot>
					 
				</table>
				<input type="hidden" name="qNum" value="<%=qNum%>" id="qNum">				
				
				<input type="hidden" name="qRef" value="<%=qRef%>">				
				<input type="hidden" name="qDepth" value="<%=qDepth%>">				
				<input type="hidden" name="qPos" value="<%=qPos%>">
				<input type="hidden" name="qOriUid" value="<%=qUid%>">
				
				<input type="hidden" name="nowPage" value="<%=nowPage%>" id="nowPage">

				<!-- 검색어전송 시작 -->
				<input type="hidden" name="keyField" id="keyField" value="<%=keyField%>">
				<input type="hidden" name="keyWord" id="keyWord" value="<%=keyWord%>">
				<!-- 검색어전송 끝 -->
		
			</form>
			<!--  답변페이지 내용 출력 끝 -->
			
			
		</main>  <!-- 본문영역 html 템플릿 끝 -->


	</div>
	<!-- div#wrap -->
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/qnaBBS.js"></script>    
</body>
</html>