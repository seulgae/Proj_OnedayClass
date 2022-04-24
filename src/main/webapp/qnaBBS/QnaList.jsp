<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="pack_QnaBBS.BoardBean, java.util.Vector, pack_ClassBBS.ClassBean"%>
<jsp:useBean id="bMgr" class="pack_QnaBBS.BoardMgr" scope="page" />

<%
request.setCharacterEncoding("UTF-8");

///////////////////////페이징 관련 속성 값 시작///////////////////////////
// 페이징(Paging) = 페이지 나누기를 의미함
int totalRecord = 0; // 전체 데이터 수(DB에 저장된 row 개수)
int numPerPage = 10; // 페이지당 출력하는 데이터 수(=게시글 숫자)
int pagePerBlock = 5; // 블럭당 표시되는 페이지 수의 개수
int totalPage = 0; // 전체 페이지 수
int totalBlock = 0; // 전체 블록수

int nowPage = 1; // 현재 (사용자가 보고 있는) 페이지 번호
int nowBlock = 1; // 현재 (사용자가 보고 있는) 블럭

int start = 0; // DB에서 데이터를 불러올 때 시작하는 인덱스 번호
int end = 10; // 시작하는 인덱스 번호부터 반환하는(=출력하는) 데이터 개수 

int listSize = 0; // 1페이지에서 보여주는 데이터 수
//출력할 데이터의 개수 = 데이터 1개는 가로줄 1개

// 게시판 검색 관련소스
String keyField = ""; // DB의 컬럼명
String keyWord = ""; // DB의 검색어

if (request.getParameter("keyWord") != null) {
	keyField = request.getParameter("keyField");
	keyWord = request.getParameter("keyWord");
}

if (request.getParameter("nowPage") != null) {
	nowPage = Integer.parseInt(request.getParameter("nowPage"));
	start = (nowPage * numPerPage) - numPerPage;
	end = numPerPage;
}

// 클래스 번호 반환

int cNum = (int) session.getAttribute("cNumKey");

totalRecord = bMgr.getAjaxTotalCount(keyField, keyWord, cNum);
// 전체 데이터 수 반환

totalPage = (int) Math.ceil((double) totalRecord / numPerPage);
nowBlock = (int) Math.ceil((double) nowPage / pagePerBlock);
totalBlock = (int) Math.ceil((double) totalPage / pagePerBlock);

///////////////////////페이징 관련 속성 값 끝///////////////////////////

Vector<BoardBean> vList = null;

String uId = (String) session.getAttribute("idKey");
String uName = (String) session.getAttribute("nameKey");
String uLevel = (String) session.getAttribute("levelKey");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>QnA 게시판</title>
<link rel="stylesheet" href="/Proj_OnedayClass/style/ajaxBBS.css">
</head>
<body>
	<div id="wrap">
		
		<main id="main" class="list">

			<%
			String prnType = "";
			if (keyWord.equals("null") || keyWord.equals("")) {
				prnType = "전체 게시글";
			} else {
				prnType = "검색 결과";
			}
			%>

			<div id="pageInfo" class="flex-container">
				<span><%=prnType%> : <%=totalRecord%> 개</span> <span>페이지 : <%=nowPage + " / " + totalPage%></span>
			</div>
			<table id="boardList">
				<thead>
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>아이디</th>
						<th>날짜</th>
					</tr>
					<tr>
						<td colspan="4" class="spaceTd"></td>
					</tr>
				</thead>
				<tbody>

					<%
					vList = bMgr.getAjaxBoardList(keyField, keyWord, start, end, cNum); // DB에서 데이터 불러오기
					listSize = vList.size();

					if (vList.isEmpty()) {
						// 데이터가 없을 경우 출력 시작
					%>
					<tr>
						<td colspan="4"><%="게시물이 없습니다."%></td>
					</tr>
					<%
					// 데이터가 없을 경우 출력 끝
					} else {
					// 데이터가 있을 경우 출력 시작

						for (int i = 0; i < numPerPage; i++) {
	
							if (i == listSize) break;
	
							BoardBean bean = vList.get(i);
	
							int qNum = bean.getqNum();
							String qUid = bean.getqUid();
							String qTitle = bean.getqTitle();
							String qRegDate = bean.getqRegDate();
							int qDepth = bean.getqDepth();
							String qOriUid = bean.getqOriUid();
							int qStatus = bean.getqStatus();
	
							// 비밀글을 확인 할 경우 시작
							if (uId.equals(qUid) || uLevel.equals("3") || uId.equals(qOriUid) || qStatus == 2) {
					%>

					<tr class="prnTr" onclick="read('<%=qNum%>', '<%=nowPage%>')">

						<td>
								<%
								if (qDepth == 0) out.print(qNum); // 답변글이 아님을 의미함
								%>
						</td>

						<td class="subjectTd">
							<%
							if (qDepth > 0) { // 답변글을 의미함
								for (int blank = 0; blank < qDepth; blank++) {
									out.print("&nbsp;&nbsp;&nbsp;&nbsp;");
								}
							}

							out.print(qTitle);
							%>
						</td>

							<%
							// 비밀글을 확인 할 경우 끝
							} else {
							// 비밀글을 확인 못 할 경우 시작
							%>
					
					<tr class="prnTr">
						<td>
								<%
								if (qDepth == 0) out.print(qNum); // 답변글이 아님을 의미함
								%>
						</td>
						<!--  num로 변경필! -->
						<td class="subjectTd">
								<%
								if (qDepth > 0) { // 답변글을 의미함
									for (int blank = 0; blank < qDepth; blank++) {
										out.print("&nbsp;&nbsp;&nbsp;&nbsp;");
									}
								}
	
								out.print("비밀글 입니다.");
								%>
						</td>

							<%
							} // 비밀글을 확인 못 할 경우 끝
							%>

						<td><%=qUid%></td>
						<td><%=qRegDate%></td>
					</tr>
					<%
						}	// end for 데이터가 있을 경우 출력 끝
					} // end if
					%>

					<tr>
						<!-- 페이징 시작 -->
						<td colspan="2" id="pagingTd">
					<%
					int pageStart = (nowBlock - 1) * pagePerBlock + 1;
					int pageEnd = (nowBlock < totalBlock) ? pageStart + pagePerBlock - 1 : totalPage;
					
					if (totalPage != 0) { //   전체 페이지가 0이 아니라면 = 게시글이 1개라도 있다면
						// #if 01_totalPage
					
						if (nowBlock > 1) { // 페이지 블럭이 2이상이면 => 2개이상의 블럭이 있어야 가능
					%> 
 							<span class="moveBlockArea" onclick="moveBlock('<%=nowBlock - 1%>', '<%=pagePerBlock%>')"> &lt; </span>
						<%
						 } else {
						 %>
							<span class="moveBlockArea"></span>
						<%
						 }
						// 페이지 나누기용 페이지 번호 출력 시작 
						                
						 for (; pageStart <= pageEnd; pageStart++) {
						
						 	if (pageStart == nowPage) { // 현재 사용자가 보고 있는 페이지
						 %> 
 							<span class="nowPageNum"><%=pageStart%></span>
							<%
							 } else { // 현재 사용자가 보고 있지 않은 페이지
							 %>
							<span class="pageNum" onclick="movePage('<%=pageStart%>')"> <%=pageStart%></span>
						<%
						 	} // End If

 						} // End For 페이지 나누기용 페이지 번호 출력 끝
						 
						if (totalBlock > nowBlock) { // 다음 블럭이 남아 있다면
 						%>
							<span class="moveBlockArea" onclick="moveBlock('<%=nowBlock + 1%>', '<%=pagePerBlock%>')"> &gt; </span>
						<%
						 } else {
						 %>
							<span class="moveBlockArea"></span>
					<%
						 }

					 } // End if#01_totalPage
					 %>
						</td>

						<td colspan="3">

							<form name="searchFrm" class="flex-container" id="searchFrm">

								<div>
									<select name="keyField" id="keyField">
										<option value="qTitle" <%if (keyField.equals("qTitle")) out.print("selected");%>>제목</option>
										<option value="qUid" <%if (keyField.equals("qUid")) out.print("selected");%>>아이디</option>
										<option value="qContent" <%if (keyField.equals("qContent")) out.print("selected");%>>내용</option>
									</select>
								</div>

								<div>
									<input type="text" name="keyWord" id="keyWord" id="keyWord"
										size="20" maxlength="30" value="<%=keyWord%>">
								</div>
								<div>
									<button type="button" id="searchBtn">검색</button>
								</div>

							</form> 
							
							<!-- 검색결과 유지용 매개변수 데이터시작 -->
							<input type="hidden" id="nowPage" value="<%=nowPage%>">
							<input type="hidden" id="pKeyField" value="<%=keyField%>">
							<input type="hidden" id="pKeyWord" value="<%=keyWord%>">
							<!-- 검색결과 유지용 매개변수 데이터끝 -->

						</td>
					</tr>
					<tr>
						<td colspan="5" class="butcs" id="postBtn"><a href="#">글쓰기</a></td>
					</tr>
				</tbody>
			</table>


		</main>
		<!-- main#main -->

	</div>
	<!-- div#wrap -->

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/qnaBBS.js"></script>
</body>
</html>