<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
request.setCharacterEncoding("UTF-8");
String iuId = (String)session.getAttribute("idKey");
String iuName = (String)session.getAttribute("nameKey");
String iuLevel = (String)session.getAttribute("levelKey");
String istr1 = "3";
String istr2 = "2";
%>    

		<header id="header" class="flex-container">
            <div id="headerLogo">
                <a href="/Proj_OnedayClass/Index.jsp"><img src="/Proj_OnedayClass/img/logo.png" width="75%" alt="로고"></a>
            </div>
            <!-- div#headerLogo -->
            <div id="headerRight">
          
                <ul class="flex-container">
    	<% if (iuId != null && istr1.equals(iuLevel)) {  //관리자 로그인%>
                    <li><a href="/Proj_OnedayClass/adminBBS/AdminPage.jsp"><%=iuName %>님 안녕하세요.</a></li>
                    <li></li>
                    <li><a href="/Proj_OnedayClass/sign/Logout.jsp">로그아웃</a></li>
    	<% } else { %>
					<script>
					alert("관리자가 아닙니다. 홈페이지로 이동합니다.");
					location.href="/Proj_OnedayClass/Index.jsp";
					</script>
		<% } %>
				</ul>
            </div>
            <!-- div#headerRight -->
        </header>
        
        <nav id="gnb">
            <ul class="flex-container">
                <li><a href="/Proj_OnedayClass/Index.jsp" >Home</a></li>
                <li><a href="/Proj_OnedayClass/adminBBS/AdminQnaList.jsp">About</a></li>
                <li><a href="/Proj_OnedayClass/classBBS/ClassOnList.jsp">Online</a></li>
                <li><a href="/Proj_OnedayClass/classBBS/ClassOffList.jsp">Offline</a></li>
            </ul>
        </nav>