<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
 
 <%@ page import="java.util.Vector, pack_ClassBBS.ClassBean, pack_Payment.PaymentBean"%>
<jsp:useBean id="pMgr" class="pack_Payment.PaymentMgr" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
String uId = (String) session.getAttribute("idKey");
String uName = (String) session.getAttribute("nameKey");
String uLevel = (String) session.getAttribute("levelKey");

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

if (request.getParameter("nowPage") != null) {
	nowPage = Integer.parseInt(request.getParameter("nowPage"));
	start = (nowPage * numPerPage) - numPerPage;
	end = numPerPage;
}

if (uLevel.equals("2")) totalRecord = pMgr.getTeacherCount(uId);
else totalRecord = pMgr.getStudentCount(uId);
// 전체 데이터 수 반환

totalPage = (int) Math.ceil((double) totalRecord / numPerPage);
nowBlock = (int) Math.ceil((double) nowPage / pagePerBlock);
totalBlock = (int) Math.ceil((double) totalPage / pagePerBlock);

///////////////////////페이징 관련 속성 값 끝///////////////////////////

Vector<ClassBean> vList = null;
Vector<PaymentBean> vList1 = null;

%>   
    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>Document</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/myPage.css">
</head>
<body>

	<div id="wrap">
		<main id="main" class="list">

			<%
			String prnType = "검색 결과";
			%>

			<div id="pageInfo" class="flex-container">
				<span><%=prnType%> : <%=totalRecord%> 개</span> <span>페이지 : <%=nowPage + " / " + totalPage%></span>
			</div>
			<table id="bbsTbl">
            	<%if(uLevel.equals("2")) {%>
					<thead>
						<tr>
							<th><span id="title1">클래스 이름</span></th>
							<th><span id="title2">신청자 아이디</span></th>
							<th><span id="title3">이메일</span></th>
							<th><span id="title4">신청인원</span></th>
							<th><span id="title5">결제일</span></th>
						</tr>
					</thead>
					<tbody>
							
					<% 
					vList1 = pMgr.getTeacherPayList(start, end, uId); // DB에서 데이터 불러오기
					listSize = vList1.size();
					
					if (vList1.isEmpty()) {
						// 데이터가 없을 경우 출력 시작
					%>
					<tr>
						<td colspan="5"><%="게시물이 없습니다."%></td>
					</tr>
					<%
					// 데이터가 없을 경우 출력 끝
					} else {
					// 데이터가 있을 경우 출력 시작
						for (int i = 0; i < numPerPage; i++) {
	
							if (i == listSize) break;
	
							PaymentBean bean = vList1.get(i);
	
							String cTitle = bean.getcTitle();
							String rUid = bean.getuId();
							String rEmail = bean.getrEmail();
							int pQty = bean.getpQty();
							String payDate = bean.getPayDate();
							%>
	
							<tr>
								<td><%=cTitle%></td>
								<td><%=rUid%></td>
								<td><%=rEmail%></td>
								<td><%=pQty%></td>
								<td><%=payDate%></td>
							</tr>
							<%
								}
							} 
					} else { %>
					<thead>
						<tr>
							<th><span id="title1">강의 종류</span></th>
							<th><span id="title2">클래스 이름</span></th>
							<th><span id="title3">비용</span></th>
							<th><span id="title4">배달비</span></th>
							<th><span id="title5">신청인원</span></th>
							<th><span id="title6">결제일</span></th>
						</tr>
					</thead>
					<tbody>
					<% 
					vList = pMgr.getStudentPayList(start, end, uId); // DB에서 데이터 불러오기
					listSize = vList.size();
					
					if (vList.isEmpty()) {
						// 데이터가 없을 경우 출력 시작
					%>
					<tr>
						<td colspan="6"><%="게시물이 없습니다."%></td>
					</tr>
					<%
					// 데이터가 없을 경우 출력 끝
					} else {
					// 데이터가 있을 경우 출력 시작

						for (int i = 0; i < numPerPage; i++) {
	
							if (i == listSize) break;
	
							ClassBean bean = vList.get(i);
	
							String cCategory = bean.getcCategory();
							String cTitle = bean.getcTitle();
							int cPrice = bean.getcPrice();
							int cDelivery = bean.getcDelivery();
							int pQty = bean.getcApplyStu();
							String payDate = bean.getcRegDate();
							%>
	
							<tr>
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
									%><%=cCategory%>
								</td>
								<td><%=cTitle%></td>
								<td><%=cPrice%>원</td>
								<td><%=cDelivery%>원</td>
								<td><%=pQty%>인</td>
								<td><%=payDate%></td>
							</tr>
							<%
								}
							} 
							%>
				
					<% } %>
							<tr>
								<!-- 페이징 시작 -->
								<td colspan="6" id="pagingTd">
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
									 %>
									</td>
								</tr>
							</tbody>
					</table>
			</main>
	</div>
	<!-- div#wrap -->
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/qnaBBS.js"></script>
</body>
</html>