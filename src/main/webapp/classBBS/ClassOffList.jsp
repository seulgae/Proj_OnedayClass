<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ page import="pack_ClassBBS.ClassBean, java.util.Vector"%>
<jsp:useBean id="bMgr" class="pack_ClassBBS.ClassMgr" scope="page" />

<%
request.setCharacterEncoding("UTF-8");
int totalRecord = 0; // 전체 데이터 수(DB에 저장된 row 개수)
int numPerPage = 9; // 페이지당 출력하는 데이터 수(=게시글 숫자)
int pagePerBlock = 5; // 블럭당 표시되는 페이지 수의 개수
int totalPage = 0; // 전체 페이지 수
int totalBlock = 0; // 전체 블록수
/*
totalRecord=> 200     전체레코드
numPerPage => 10
pagePerBlock => 5
totalPage => 20
totalBlock => 4  (20/5 => 4)
*/

int nowPage = 1; // 현재 (사용자가 보고 있는) 페이지 번호
int nowBlock = 1; // 현재 (사용자가 보고 있는) 블럭
int start = 0; // DB에서 데이터를 불러올 때 시작하는 인덱스 번호
int end = 9; // 시작하는 인덱스 번호부터 반환하는(=출력하는) 데이터 개수 
// select * from T/N where... order by ... limit start, end;
int listSize = 0; // 1페이지에서 보여주는 데이터 수
//출력할 데이터의 개수 = 데이터 1개는 가로줄 1개

String uId = (String) session.getAttribute("idKey");
String uName = (String) session.getAttribute("nameKey");
String uLevel = (String) session.getAttribute("levelKey");

String cCategorySel = ""; // DB의 카테고리
String onoff = "Y"; //온오프라인여부

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
Vector<ClassBean> vList = null;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>오프라인 클래스</title>
<link rel="stylesheet" href="/Proj_OnedayClass/style/classBBS/onoffshop.css">
 <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" /> 
  <script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

</head>
<body>
	<div id="wrap">
		<%@include file="../include/Header.jsp"%>
		
		<form id="categoryform" name="categoryform">
		<!-- 카테고리 시작-->
		<div id="category">
			<ul id="tree">
				<li class="devTagList"><span onclick="cCategorySelect('1')"> 핸드메이드</span></li>
				<!-- 1번 카테고리 전체출력.. -->
				<li class="devTagList"><span onclick="cCategorySelect('2')"> 쿠킹</span></li>
				<!-- 2번 카테고리 전체출력.. -->
				<li class="devTagList"><span onclick="cCategorySelect('3')">드로잉</span></li>
				<!-- 3번 카테고리 전체출력.. -->
				<li class="devTagList"><span onclick="cCategorySelect('4')">음악</span></li>
				<!-- 4번 카테고리 전체출력.. -->
				<li class="devTagList"><span onclick="cCategorySelect('5')">요가·필라테스</span></li>
				<!-- 5번 카테고리 전체출력.. -->
				<li class="devTagList"><span onclick="cCategorySelect('6')">레져·스포츠</span></li>
				<!-- 6번 카테고리 전체출력.. -->
				<li class="devTagList"><span onclick="cCategorySelect('7')">반려동물</span></li>
				<!-- 7번 카테고리 전체출력.. -->
				<li class="devTagList"><span onclick="cCategorySelect('8')">자기계발</span></li>
				<!-- 8번 카테고리 전체출력.. -->
				</ul>
			<input type="hidden" id="cCategorySel" name="cCategorySel" value="">
		</div>
		<!-- div#category -->
		<!-- 카테고리 종료-->
	</form>
	
		<!-- 오프라인 게시판 시작 -->
		<div id="Gallerybbs">
			
			<!--  div#goodsPart 추천리스트 시작 -->
			<div id="goodsPart" class="flex-container">
				<h2>★ 오늘의 원데이 추천 클래스 ★</h2>
				<span>HOME | Offline</span>
			</div>
			<!-- div#goodsPart 끝 -->

			<!-- main#galleryListArea 추천 게시물 시작 -->
			<main id="galleryListArea">
					<%
					vList = bMgr.getBoardLike(cCategorySel, onoff, start, end);
					listSize = vList.size();
					%>
					<div class="swiper-container">
						<%
						if (vList.isEmpty()) {
						%>
						<div>
							<div><%="게시물이 없습니다."%></div>
						</div>
						<%
						} else {
						%>
						<div class="prnTr swiper-wrapper">
						<%
						for (int i = 0; i < listSize; i++) {
							ClassBean bean = vList.get(i);
							
							int cNum = bean.getcNum();
							//게시글 넘버
							String cThumbName = bean.getcThumbName();
							//게시글 썸네일
							String cCategory = bean.getcCategory();
							//카테고리
							String cTitle = bean.getcTitle();
							//제목
							int cStatus = bean.getcStatus();
							//글 속성, 공개 비공개 여부
							String cOnoff = bean.getcOnoff();
							//클래스 on(N), off(Y) 여부
							int cLikes = bean.getcLikes();
							//좋아요
							
							if (cStatus == 2) {
						%>
							<div class="swiper-slide" onclick="read('<%=cNum%>', '<%=nowPage%>')">
							<div>
								<a href="#"> <img
									src="/Proj_OnedayClass/fileUpload/classfileupload/<%=cThumbName%>"
									alt='이미지' width='310'></a>
							</div>
							
							<div class="letter">
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
							</div>
							
							<div class="titleletter">
								<%=cTitle%>
							</div>
						</div>
						<%
						}
						}
						%>
						</div>
						
						<% 
						}
						%>
					</div>
			</main>
			<!-- main#galleryListArea 끝-->
			<!-- 추천리스트 갤러리 끝 -->

			<!-- 일반리스트 갤러리 시작 -->
			<!-- 최신순, 리뷰순 -->
			<div id="allclass" class="flex-container">
				<h3>★ 오프라인 클래스 ★</h3>
			</div>
			<!-- div#allclass 최신순, 리뷰순 끝-->

			<div id="BasicList">
				<!-- main#galleryListArea 시작 -->
				<main id="galleryListArea">
					<table class="goodsTbl">
						<%
						vList = bMgr.getBoardList(cCategorySel, onoff, start, end);
						listSize = vList.size();
						%>
						<tbody>
							<%
							if (vList.isEmpty()) {
							%>
							<tr>
								<td colspan="6"><%="게시물이 없습니다."%></td>
							</tr>
							<%
							} else {
							%>
							<%
							for (int i = 0; i < listSize; i += 3) {
							%>
							<tr>
								<%
								for (int j = 0; j < 3; j++) {
									ClassBean bean = vList.get(i + j);
									int cNum = bean.getcNum();
									//게시글 넘버
									String cThumbName = bean.getcThumbName();
									String cCategory = bean.getcCategory();
									//카테고리
									String cTitle = bean.getcTitle();
									//제목
									int cStatus = bean.getcStatus();
									//글 속성, 공개 비공개 여부
									String cOnoff = bean.getcOnoff();
									//클래스 on(N), off(Y) 여부
									
									if (cStatus == 2) {
								%>
								<td onclick="read('<%=cNum%>', '<%=nowPage%>')">
									<!-- 1 -->
									<div>
										<a href="#"> <img
											src="/Proj_OnedayClass/fileUpload/classfileupload/<%=cThumbName%>"
											alt='이미지' width='310'>
										</a>
									</div>

									<div class="letter">
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
										%>
										<%=cCategory%>
									</div>

									<div class="titleletter">
										<%=cTitle%>
									</div>
								</td>
								<%
								}
								%>
							<%
							if ((i + j) == (listSize - 1)) {
								i += j;
								break;
							}
							}
							%>
							</tr>
							<%
							}
							}
							%>
						</tbody>
					</table>
					<!-- table.goodsTbl 상품출력용 테이블 -->
					
					<table class="page">
						<tbody>
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
							</tr>
						</tbody>
					</table>
				</main>
				<!-- main#galleryListArea 끝-->
			</div>
			<!-- main#galleryListArea 종료 -->
		</div>
		<!-- div#BasicList -->
		<!-- 일반리스트 갤러리 종료 -->

		<%@include file="../include/Footer.jsp"%>
	</div>
	<script>
       const swiper = new Swiper('.swiper-container', {
        //기본 셋팅
        //방향 셋팅 vertical 수직, horizontal 수평 설정이 없으면 수평
        direction: 'horizontal',
        //한번에 보여지는 페이지 숫자
        slidesPerView: 3,
        //페이지와 페이지 사이의 간격
        spaceBetween: 30,
        //드레그 기능 true 사용가능 false 사용불가
        debugger: true,
        //마우스 휠기능 true 사용가능 false 사용불가
        mousewheel: true,
        //반복 기능 true 사용가능 false 사용불가
        loop: true,
        //선택된 슬라이드를 중심으로 true 사용가능 false 사용불가 djqt
        centeredSlides: true,
        // 페이지 전환효과 slidesPerView효과와 같이 사용 불가
        // effect: 'fade',
 
        //자동 스크를링
        autoplay: {
          //시간 1000 이 1초
          delay: 2500,
          disableOnInteraction: false,
         },
        
        //페이징
        pagination: {
          //페이지 기능
          el: '.swiper-pagination',
          //클릭 가능여부
          clickable: true,
        },
        //방향표
        navigation: {
          //다음페이지 설정
          nextEl: '.swiper-button-next',
          //이전페이지 설정
          prevEl: '.swiper-button-prev',
        },
        
      });
  </script>
	
	
	<script src="/Proj_OnedayClass/script/jquery-3.6.0.min.js"></script>
	<script src="/Proj_OnedayClass/script/classoffbbs.js"></script>
	<!-- <script src="/Proj_OnedayClass/script/onoffshop.js"></script>-->
</body>
</html>