<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
request.setCharacterEncoding("UTF-8");
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
    <link rel="stylesheet" href="/Proj_OnedayClass/style/style.css">
    <link rel="stylesheet" href="/Proj_OnedayClass/style/myPage.css">
</head>
<body>  
	<div id="wrap">
     <%@include file="../include/Header.jsp"%> 
     
        <div id="pageMenu">
            <ul id="myPageMenu" class="flex-container">
                <li class="myPageMenuLi">
                    <a href="#"><img src="/Proj_OnedayClass/img/profile.png" alt="프로필 설정"></a>
                </li>
                <li class="myPageMenuLi">
                    <Strong id="uName"><%=uName %></Strong>
                    <button type="button" id="profileModBtn">편집</button>
                </li>
                <li class="myPageMenuLi">
                    <Strong>회원등급</Strong>
                    <%if(uLevel.equals("2")) { %>
                    <span id="uGrade">강사</span>
                    <%} else {%>
                    <span id="uGrade">학생</span>
                    <%} %>
                </li>
            </ul>
        </div>
        <main id="main">
            <nav id="mainNav">
                <ul id="mainMenu" class="flex-container">
        <%if (uLevel.equals("1")) {%>
                    <li id="mainLi1" class="mainLi payList">
                        <span>주문 내역</span>
                        <div id="subMenu1"  class="subContainer">
                            <ul class="subMenu flex-container">         
                                <li class="subMenuLi"><a href="#" id="onlineBtn">온라인</a></li>
                                <li class="subMenuLi"><a href="#" id="offlineBtn">오프라인</a></li>     
							</ul>
						</div>                      
         <% } else { %>
         			<li id="mainLi1" class="mainLi">
                        <span>클래스 관리</span>
                        <div id="subMenu1"  class="subContainer">
                            <ul class="subMenu flex-container">           
                                <li class="subMenuLi"><a href="/Proj_OnedayClass/classBBS/ClassPost.jsp">클래스 등록</a></li>
                                <li class="subMenuLi"><a href="/Proj_OnedayClass/classBBS/ClassList.jsp" >클래스 관리</a></li>
							</ul>
                        </div>    
                      </li>     
                      <li id="mainLi2" class="mainLi payList">
                      	<a href="#">수강 결제 내역</a>
                        <div id="subMenu2"  class="subContainer">
                            <ul class="subMenu flex-container">
                                <li class="subMenuLi"><a href="#" id="onlineBtn" id="onlineBtn">온라인</a></li>
                                <li class="subMenuLi"><a href="#" id="offlineBtn" id="offlineBtn">오프라인</a></li>
                            </ul>
                        </div>             
        <% } %>  
        			</li>                        
                    <li id="mainLi3" class="mainLi" >           
                        <a href="#" class=" subMenuLila">내 정보 관리</a>
                        <div id="subMenu3" class="subContainer">
                            <ul id="subMenuUl"class="subMenu flex-container">
                    <%if (uLevel.equals("1")) {%>
                                <li class="subMenuLi"><a href="/Proj_OnedayClass/sign/Member_Mod.jsp" id="memModBtn">회원 정보 수정</a></li>
                                <li class="subMenuLi"><a href="/Proj_OnedayClass/levelUp/LvlUpPost.jsp" id="">등업 신청</a></li>
                                <li class="subMenuLi"><a href="#" id="memDrop">회원 탈퇴</a></li>
					<% } else { %>
					            <li class="subMenuLi"><a href="/Proj_OnedayClass/sign/Member_Mod.jsp" id="memModBtn">회원 정보 수정</a></li>                                
                                <li class="subMenuLi"><a href="#" id="memDrop">회원 탈퇴</a></li>
                    <% } %>
                            </ul>
                        </div>
                    </li>
                </ul>
            </nav>
            
            <div id="detailedContent"></div>
            
        </main>

       <%@include file="../include/Footer.jsp"%>
        <!-- footer#footer -->
    </div>
    <script src="/Proj_OnedayClass/script/jquery-3.6.0.min.js"></script>
    <script src="/Proj_OnedayClass/script/script.js"></script>
    <script>
    $(".payList").click(function(){
    	$.ajax({
			url : "/Proj_OnedayClass/payment/PayList.jsp",      // 컨트롤러에서 대기중인 URL 주소이다.
			type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(payList){
			$("#detailedContent").html(payList);
		});
    });
     </script>
</body>
</html>
