<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
request.setCharacterEncoding("UTF-8");
String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");
String str1 = "3";
String str2 = "2";
String str3 = "1";
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
                    <a href="#"><img src="/Proj_OnedayClass/img/blank-profile.png" alt="프로필 설정"></a>
                </li>
                <li class="myPageMenuLi">
                    <Strong id="uName"><%=uName %></Strong>
                    <button type="button" id="profileModBtn">편집</button>
                </li>
                <li class="myPageMenuLi">
                    <Strong>회원등급</Strong>
                    <span id="uGrade">회원</span>
                </li>
                <li class="myPageMenuLi">
                    <Strong>적립금</Strong>
                    <span id="c_point">0 </span>원
                </li>
                <li class="myPageMenuLi">
                    <Strong>쿠폰</Strong>
                    <span id="couponSum">0 </span>장
                </li>
            </ul>
        </div>


        <main id="main">
            <nav id="mainNav">
                <ul id="mainMenu" class="flex-container">
                    <%if(str2.equals(uLevel)){ %>
                    <li id="mainLi1" class="mainLi">
                        <a href="#">수강 결제 내역</a>
                        <div id="subMenu1"  class="subContainer">
                            <ul class="subMenu flex-container">
                                <li class="subMenuLi"><a href="#" id="onlineBtn">온라인</a></li>
                                <li class="subMenuLi"><a href="#" id="offlineBtn">오프라인</a></li>
                            </ul>
                        </div>
                    </li>
                    <%} else { %>
                     <li id="mainLi1" class="mainLi">
                      <a href="#">주문 내역</a>
                        <div id="subMenu1"  class="subContainer">
                            <ul class="subMenu flex-container">
                                <li class="subMenuLi"><a href="#" id="onlineBtn">온라인</a></li>
                                <li class="subMenuLi"><a href="#" id="offlineBtn">오프라인</a></li>
                            </ul>
                        </div>
                        <%} %>
                    <li class="mainLi">
                        <a href="#" id="deliveryChkBtn">배송 조회</a>
                    </li>
                    <li id="mainLi2" class="mainLi">                     
                        <a href="#">내 정보 관리</a>
                        <div id="subMenu2" class="subContainer">
                            <ul class="subMenu flex-container">
                     <%if (str3.equals(uLevel)) {%>
                                <li class="subMenuLi"><a href="/Proj_OnedayClass/sign/Member_Mod.jsp" id="memModBtn">회원 정보 수정</a></li>
                                <li class="subMenuLi"><a href="/Proj_OnedayClass/levelUp/LvlUpPost.jsp" id="">등업 신청</a></li>
                                <li class="subMenuLi"><a href="/Proj_OnedayClass/sign/Member_Del.jsp" id="memDrop">회원 탈퇴</a></li>
					<% } else { %>
					            <li class="subMenuLi"><a href="/Proj_OnedayClass/sign/Member_Mod.jsp" id="memModBtn">회원 정보 수정</a></li>                                
                                <li class="subMenuLi"><a href="/Proj_OnedayClass/sign/Member_Del.jsp" id="memDrop">회원 탈퇴</a></li>
                    <% } %>
                            </ul>
                        </div>
                    </li>
                </ul>
            </nav>

            <div id="detailedContent">
            	
            	<%if(str2.equals(uLevel)) {%>
				<table id="bbsTbl">
					<thead>
						<tr>
							<th><span id="title1">강의 종류</span></th>
							<th><span id="title2">클래스 이름</span></th>
							<th><span id="title3">신청자</span></th>
							<th><span id="title4">이메일</span></th>
							<th><span id="title5">신청인원</span></th>
							<th><span id="title6">결제일</span></th>
						</tr>
					</thead>
					
					<%} else { %>
					
					<table id="bbsTbl">
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
					<%} %>
					
					<tbody id="bbsContent">
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
						<tr>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
							<td></td>
						</tr>
					</tbody>
				</table>
				
            </div>
        </main>

       <%@include file="../include/Footer.jsp"%>
        <!-- footer#footer -->
    </div>

    <script src="/Proj_OnedayClass/script/jquery-3.6.0.min.js"></script>
    <script src="/Proj_OnedayClass/script/script.js"></script>
</body>
</html>
