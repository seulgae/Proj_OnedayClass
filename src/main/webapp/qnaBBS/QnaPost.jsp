<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean id="mMgr" class="pack_Member.MemberMgr" scope="page" />
<%
//검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
//검색어 수신 끝
String nowPage = request.getParameter("nowPage");
int cNum = (int) session.getAttribute("cNumKey"); //클래스 게시판 번호

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
	<title>문의 페이지</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/ajaxBBS.css">
</head>
<body>
	<div id="wrap">
		  	
		<main id="main" class="post">   <!-- 본문영역 html 템플릿 시작 -->
		
			<h2>글쓰기</h2>
			
			<form name="postFrm" action="QnaPostProc.jsp"
			enctype="multipart/form-data" method="post" id="postFrm">
			
				<table>
					<tbody>
						<tr>
							<td class="req">아이디</td>  <!-- td.req 필수입력 -->
							<td>
								<span class=postuId><%=uId%></span>
								<input type="hidden" name="qUid" id="qUid" value="<%=uId%>">
								<input type="hidden" name="cNum" id="cNum" value="<%=cNum%>">
							</td>
						</tr>
						<tr>
							<td class="req">공개유무</td>
							<td>							
							<span class=postuId>
								공개 <input type="radio" name="qStatus"
									value="2" checked>									
								비공개 <input type="radio" name="qStatus"
									value="1">											
							</span>
							</td>
						</tr>
						<tr>
							<td class="req">문의 제목</td> <!-- td.req 필수입력 -->
							<td>
								<input type="text" name="qTitle"
								maxlength="50" size="60" id="qTitle">
							</td>
						</tr>
						<tr>
							<td class="contentTD">문의 내용</td>
							<td>
								<textarea name="qContent" id="qContent" cols="60" wrap="hard"></textarea>
							</td>
						</tr>
						<tr>
							<td>파일첨부</td>
							<td>
								<span class="spanFile">
									<input type="file" name="qFileName"
									 id="qFileName">
								</span>	
							</td>
						</tr>
						
						<!-- <tr>
							<td>
								<input type="hidden" name="contentType"
									value="HTML">									
								<input type="hidden" name="contentType"
									value="TEXT" checked>											
							</td>
						</tr> -->
						
					</tbody>
					<tfoot>
						<tr>
							<td colspan="2"><hr>	</td>							
						</tr>
						<tr>
							<td colspan="2">
								<button type="button" id="regBtn" class="butcs">등록</button>
								<button type="reset" class="butcs">다시쓰기</button>
								<button type="button" id="listBtn" class="butcs">리스트</button>
							</td>
						</tr>
					</tfoot>
				</table>
						
			</form>
		
			<input type="hidden" name="nowPage" value="<%=nowPage%>" id="nowPage">
			
			<!-- 검색어전송 시작 -->
			<input type="hidden" id="pKeyField" value="<%=keyField%>">
			<input type="hidden" id="pKeyWord" value="<%=keyWord%>">
			<!-- 검색어전송 끝 -->
		
		</main>  <!-- 본문영역 html 템플릿 끝 -->
		
	</div>
	<!-- div#wrap -->
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/qnaBBS.js"></script>        
</body>
</html>