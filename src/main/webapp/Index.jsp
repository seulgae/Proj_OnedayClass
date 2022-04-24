<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>원데이 클래스</title>
	<link rel="stylesheet" href="/Proj_OnedayClass/style/style.css">
	<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css" /> 
	<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>

</head>
<body>
	<div id="wrap">
		<%@include file="../include/Header.jsp"%>
			<div id="slide">
            <div class="swiper-container">
  				<!-- Additional required wrapper -->
				<div class="swiper-wrapper">
				        <!-- Slides -->
				        <div class="swiper-slide"><img src="/Proj_OnedayClass/img/slide/slide1.jpg" width="1500px" height="500px"></div>
				        <div class="swiper-slide"><img src="/Proj_OnedayClass/img/slide/slide2.jpg" width="1500px" height="500px"></div>
				        <div class="swiper-slide"><img src="/Proj_OnedayClass/img/slide/slide3.jpg" width="1500px" height="500px"></div>
				    </div>
				
				    <!-- If we need pagination 페이지 네이션을 제공-->
					<!-- <div class="swiper-pagination"></div> -->
				
				    <!-- If we need navigation buttons 버튼기능 -->
				    <div class="swiper-button-prev"></div>
				    <div class="swiper-button-next"></div>
				
				    <!-- If we need scrollbar 스크롤 기능-->
				 <div class="swiper-scrollbar"></div>
				</div>
        	</div>
            <!-- 슬라이드쇼 방향키 시작 -->
            </div>
			<%@include file="../include/Footer.jsp"%>
		 <script>
		 const swiper = new Swiper('.swiper-container', {
		  //기본 셋팅
		  //방향 셋팅 vertical 수직, horizontal 수평 설정이 없으면 수평
		  direction: 'horizontal',
		  //한번에 보여지는 페이지 숫자
		  slidesPerView: 1,
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
		    delay: 4000,
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
		/*   breakpoints: {
	            1280: {
	                slidesPerView: 1,
	                slidesPerGroup: 1,
	            },
	            720: {
	                slidesPerView: 1,
	                slidesPerGroup: 1,
	            },
	        } */
		});
  </script>
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

</body>
</html>