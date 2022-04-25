<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
request.setCharacterEncoding("UTF-8");
String iuId = (String)session.getAttribute("idKey");
String iuName = (String)session.getAttribute("nameKey");
String iuLevel = (String)session.getAttribute("levelKey");
int cartCnt = 0;

if (session.getAttribute("cartCntKey") != null) {
   cartCnt = (int)session.getAttribute("cartCntKey");
}

%>    
   <header id="header" class="flex-container">
            <div id="headerLogo">
                <a href="/Proj_OnedayClass/Index.jsp"><img src="/Proj_OnedayClass/img/logo.png" alt="로고"></a>
            </div>
            <!-- div#headerLogo -->
            <div id="headerRight">
                <ul class="flex-container">
       <% if (iuId != null && iuLevel.equals("3")) {  //관리자 로그인%>
                    <li><a href="/Proj_OnedayClass/adminBBS/AdminPage.jsp"><%=iuName %>님 안녕하세요.</a></li>
                    <li></li>
                    <li><a href="/Proj_OnedayClass/sign/Logout.jsp">로그아웃</a></li>
<!--                     <li><a href="/Proj_OnedayClass/adminBBS/AdminPage.jsp">관리자 페이지</a></li> -->
      <% } else if(iuId != null && iuLevel.equals("2")) { %>
                   <li><a href="/Proj_OnedayClass/sign/Member_PreMod.jsp"><%=iuName %> 선생님 환영합니다.</a></li>
                    <li></li>
                    <li><a href="/Proj_OnedayClass/sign/Logout.jsp">로그아웃</a></li>
                <!--     <li></li>
                    <li><a href="/Proj_OnedayClass/classbbs/ClassPost.jsp">클래스 생성</a></li>
                    <li></li>
                    <li><a href="/Proj_OnedayClass/sign/ClassList.jsp">클래스 관리</a></li> -->
         <% } else if(iuId != null) { %>
                   <li><a href="/Proj_OnedayClass/sign/Member_PreMod.jsp"><%=iuName %>님 환영합니다.</a></li>
                    <li></li>
                    <li><a href="/Proj_OnedayClass/sign/Logout.jsp">로그아웃</a></li>
                    <li></li>
                    <li>
                        <div id="headerCart">
                            <a href="/Proj_OnedayClass/payment/Cart.jsp"><img src="/Proj_OnedayClass/img/cart.png" alt=""><span><%=cartCnt %></span></a>
                        </div>
                    </li>
       <% } else { %>
               <li><a href="/Proj_OnedayClass/sign/Login.jsp">Sign In</a></li>
                    <li></li>
                    <li><a href="/Proj_OnedayClass/sign/Member.jsp">Sign Up</a></li>
      <%} %>
            </ul>
            </div>
            <!-- div#headerRight -->
        </header>
        <!-- header#header -->
        
        <nav id="gnb">
            <ul class="flex-container">
                <li><a href="/Proj_OnedayClass/Index.jsp" >Home</a></li>
                <li><a href="/Proj_OnedayClass/adminBBS/AdminQnaList.jsp">About</a></li>
                <li><a href="/Proj_OnedayClass/classBBS/ClassOnList.jsp">Online</a></li>
                <li><a href="/Proj_OnedayClass/classBBS/ClassOffList.jsp">Offline</a></li>
            </ul>
        </nav>