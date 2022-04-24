<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ page import="pack_ClassBBS.ClassBean, java.util.Vector"%>
<jsp:useBean id="bMgr" class="pack_ClassBBS.ClassMgr" scope="page" />
<%
request.setCharacterEncoding("UTF-8");

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

String cCategorySel = ""; // DB의 컬럼명

String uId = (String) session.getAttribute("idKey");
String uName = (String) session.getAttribute("nameKey");
String uLevel = (String) session.getAttribute("levelKey");

if (request.getParameter("cCategorySel") != null) {
	cCategorySel = request.getParameter("cCategorySel");	
}

if (request.getParameter("nowPage") != null) {
	nowPage = Integer.parseInt(request.getParameter("nowPage"));
	start = (nowPage * numPerPage) - numPerPage;
	end = numPerPage;
	//카테고리 선택값이 있다면 해당 카테고리에 대한 게시물만 출력
}

totalRecord = bMgr.getTotalCount(cCategorySel);
//전체 데이터 수 반환

totalPage = (int) Math.ceil((double) totalRecord / numPerPage);
nowBlock = (int) Math.ceil((double) nowPage / pagePerBlock);
totalBlock = (int) Math.ceil((double) totalPage / pagePerBlock);

totalRecord = bMgr.getTotalCount(cCategorySel);

Vector<ClassBean> vList = null;
%>


<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OneDayClass</title>
<link rel="stylesheet" href="/Proj_OnedayClass/style/classBBS/classlist.css">
</head>
<body>
	<div id="wrap">
		<%@include file="../include/Header.jsp"%>

		<%
		if (uLevel.equals("3")||uLevel.equals("2")) {
		%>
		<main id="main" class="list">
			<!-- DB 데이터 가져오기 -->
			<table id="boardList">
				<h1>클래스 관리 리스트</h1>
				<%
				if(uLevel.equals("3")){
				vList = bMgr.getBoardadmin(start, end);
				listSize = vList.size();
				}else{
				vList = bMgr.getBoardTeacher(start, end);
				listSize = vList.size();	
				}
				%>

				<%
				if (vList.isEmpty()) {
				%>
				<tr>
					<td colspan="6"><%="게시물이 없습니다."%></td>
				</tr>
				<%
				} else {
				%>
				<tr>
					<th>번호</th>
					<th>닉네임</th>
					<th>강사이름</th>
					<th>종류</th>
					<th>제목</th>
					<th>작성날짜</th>
				</tr>
				<%
				for (int i = 0; i < listSize; i++) {

					ClassBean bean = vList.get(i);

					int cNum = bean.getcNum();
					String cUid = bean.getcUid();
					String cTeacher = bean.getcTeacher();
					String cCategory = bean.getcCategory();
					String cTitle = bean.getcTitle();
					String cRegDate = bean.getcRegDate();
					int cStatus = bean.getcStatus();
					
					if(uId.equals(cUid)||uLevel.equals("3")){
				%>
				<tr class="prnTr" onclick="read('<%=cNum%>', '<%=nowPage%>')">
					<td><%=cNum%></td>
					<td><%=cUid%></td>
					<td><%=cTeacher%></td>
					<td>
						<%
						if (cCategory.equals("1")) {
							cCategory = "핸드 메이드";
						} else if (cCategory.equals("2")) {
							cCategory = "쿠킹";
						} else if (cCategory.equals("3")) {
							cCategory = "드로잉";
						} else if (cCategory.equals("4")) {
							cCategory = "음악";
						} else if (cCategory.equals("5")) {
							cCategory = "요가·필라테스";
						} else if (cCategory.equals("6")) {
							cCategory = "레져·스포츠";
						} else if (cCategory.equals("7")) {
							cCategory = "반려동물";
						} else {
							cCategory = "자기계발";
						}
						%><%=cCategory%></td>
					<td><%=cTitle%></td>
					<td><%=cRegDate%></td>
					<%
					}
					}
					}
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
								 } 
								 }
								 %>
								</td>
							</tr>
			</table>
		</main>
		<!-- Main -->

		<%@include file="../include/Footer.jsp"%>
	</div>

	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/classlist.js"></script>
</body>
</html>