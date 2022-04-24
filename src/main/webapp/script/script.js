/* eslint-disable */

$(function () {

    //    fnSlide();    // 함수의 호출 = 함수의 내부 코드가 실행된다!
    
    
        let autoSlide = setInterval(fnSlide, 5000);    
        // autoSlide 는 전역변수
        // 일정시간마다 반복
    
        function fnSlide() { // 정방향 슬라이드 함수 정의
    
            /* 슬라이드 쇼 애니메이션 코드 시작 */
            $("div#shuttleFrame").animate({
                    "margin-left": "-780px"
                },
                3000,
                function () {
                    $("#shuttleFrame>a:nth-child(1)")
                        .insertAfter("#shuttleFrame>a:nth-child(3)");
                    $("#shuttleFrame").css({
                        "margin-left": "0"
                    });
                }
            );
            /* 슬라이드 쇼 애니메이션 코드 끝 */
    
        }   // 커스텀 함수 끝
    
        function fnSlidePrev() {  // 역방향 슬라이드 함수 정의
    
            // 셔틀프레임이 오른쪽으로 이동하는 애니메이션을 구현하기 위해
            // 미리 왼쪽 -780px에서 시작해야 한다.
            // 즉 콜백함수에서 만들어야 하는 내용을 미리
            // 만들어둠(단, 역방향이어야 함)
            $("#shuttleFrame").css({"margin-left": "-780px"});
    
            // 오른쪽 마지막에 있던 이미지가 왼쪽 첫번째에 위치하여
            // 슬라이드 애니메이션을 준비하고 있어야 함.
            $("#shuttleFrame a:last-child")
                    .insertBefore("#shuttleFrame a:first-child");
    
            // 셔틀프레임 오른쪽이동 애니메이션 시작
            $("#shuttleFrame").animate(
                {"margin-left": "0"},
                3000
            );
    
        }

        // 마우스를 올리면(mouseover) 슬라이드 멈춤
        $("div#slide").mouseover(function () {
            // setInterval 중지방법
            // 1. setInterval을 변수로 지정하여 대입한다.
            //    => let autoSlide = setInterval(...);
            // 2. 지정된 변수를 clearInterval(변수);로 적용한다
            // console.log($("#shuttleFrame").queue().length);
    
            clearInterval(autoSlide);            
        });
    
        $("div#slide").mouseout(function () {
            // setInterval 재실행            
            autoSlide = setInterval(fnSlide, 5000);            
        });
    
        // 오른쪽 방향키(다음 이미지 슬라이드 next image slide)
        $("#arrowRight").click(function(){
            fnSlide();
        });
    
    
        // 왼쪽 방향키(이전 이미지 슬라이드 previous image slide)
        $("#arrowLeft").click(function(){
            fnSlidePrev();
        });
    
    });

///////////////////////////// 서브메뉴 시작 ///////////////////////////////

    $("#mainLi1").mouseover(function() {
        $(".mainLi #subMenu1").stop().slideDown(200);
    });

    $("#mainLi1").mouseout(function(){
        $(".mainLi #subMenu1").stop().slideUp(100);
    });

    $("#mainLi2").mouseover(function() {
        $(".mainLi #subMenu2").stop().slideDown(200);
    });

    $("#mainLi2").mouseout(function(){
        $(".mainLi #subMenu2").stop().slideUp(100);
    });
    
     $("#mainLi3").mouseover(function() {
        $(".mainLi #subMenu3").stop().slideDown(200);
    });

    $("#mainLi3").mouseout(function(){
        $(".mainLi #subMenu3").stop().slideUp(100);
    });

///////////////////////////// 서브메뉴 끝 ///////////////////////////////
	$("#onlineBtn").click(function() {
        // $("#detailedContent").stop().slideDown(800);
		$("#detailedContent").css({"display" : "block"});
    });
  	$("#offlineBtn").click(function() {
        // $("#detailedContent").stop().slideDown(800);
        $("#detailedContent").css({"display" : "block"});
    });
    /*$("#onlineBtn").click(function(){
        // $("#detailedContent").stop().slideUp(500);
		$("#detailedContent").css({"display" : "none"});
    });*/
    
    
//////////////////////////////ad page 메인 메뉴/////////////////////////
	$("#adMainLi").mouseover(function(){
        $(".mainAdMenu #subAdMenu").stop().slideDown(200);
    });

    $("#adMainLi").mouseout(function(){
        $(".mainAdMenu #subAdMenu").stop().slideUp(100);
    });
    
//////////////////////////////ad page 메인 메뉴 끝/////////////////////////    
function setClassName() {
			document.getElementById('ex').classList.add('active');
		}
		
/////////////////////삭제/////////////////////////////
$("#memDrop").click(function(){
     if(window.confirm("정말 삭제하시겠습니까 ? ")){
        location.href="/Proj_OnedayClass/sign/Member_Del.jsp";
        }
});