<%@page import="pack_Member.MemberBean"%>
<%@page import="java.util.Vector"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<jsp:useBean  id="mMgr"   class="pack_Member.MemberMgr"  scope="page" />
    
<%
String sessionUId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");
Vector<MemberBean> vList = mMgr.modifyMember(sessionUId);
%>  

<% if (sessionUId != null) {   // 현재 로그인 상태라면  %>
<!-- ////////////////  로그인 상태 시작  ////////////////// -->

	<%
	MemberBean memBean = (MemberBean)vList.get(0);
	String uId = memBean.getuId();
	String uPw = memBean.getuPw();
	String uPhone = memBean.getuPhone();
	String uEmail = memBean.getuEmail();
	String uZip = memBean.getuZip();
	String uAddr1 = memBean.getuAddr1();
	String uAddr2 = memBean.getuAddr2();
	%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>회원정보 수정</title>
	<link rel="stylesheet" href="/Proj_OnedayClass/style/member.css">

</head>
<body>
	<div id="wrap">
	<%@include file="../include/Header.jsp"%>

        <div id="mod">
			<form name="modFrm" id="modFrm" action="Member_ModProc.jsp" method="get">
				<table>
					<caption><hr><h3>회원 정보 수정</h3></caption>
					<tbody>
				  		<tr>
							<td>아이디</td>
							<td><%=uId %></td>
						</tr>
		                <tr>
							<td class="req">패스워드</td>
							<td>
								<input type="password" class="umem" name="uPw" id="uPw" size="40"
						        value="<%=uPw %>">
						        <input type="hidden" id="uPw_bak" value="<%=uPw %>">
							</td>
						</tr>
						<tr>
							<td>패스워드 확인</td>
							<td>
								<input type="password" class="umem" id="uPw_Re" size="40"
		                    	value="<%=uPw %>">
							</td>
						</tr>
						<tr>
							<td>이름</td>
							<td><%=uName %></td>
						</tr>
						<tr>
							<td class="req">전화번호</td>
							<td>
						        <input type="text" class="umem" name="uPhone" id="uPhone" size="40"
						        value="<%=uPhone%>">    
						        <input type="hidden" id="uPhone_bak" value="<%=uPhone %>">
							</td>
						</tr>                      
		            	<tr>
		            		<td class="req">주소</td>
							<td>
								<input type="text" name="uZip" id="uZip" size="25" 
								readonly value="<%=uZip%>">
								<input type="hidden" id="uZip_bak" value="<%=uZip %>">
								<button type="button" id="zipBtn">우편번호찾기</button>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input type="text" id="uAddr1" name="uAddr1" size="40"
								readonly value="<%=uAddr1%>">
								<input type="hidden" id="uAddr1_bak" value="<%=uAddr1 %>">
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input type="text" id="uAddr2" name="uAddr2" size="40"
								value="<%=uAddr2%>">
								<input type="hidden" id="uAddr2_bak" value="<%=uAddr2 %>">
							</td>
						</tr>
		
						<tr>
							<td class="req">이메일</td>
							<td>
								<input type="text" class="umem" name="uEmail" id="uEmail" size="40"
		                     	value="<%=uEmail%>">
		                     	<input type="hidden" id="uEmail_bak" value="<%=uEmail %>">
							</td>
						</tr>
						<tr>
							<td colspan="2">
								<button type="button" id="modBtn">정보수정</button>
								<button type="reset">다시쓰기</button>
								<button type="button" id="mainBtn">메인으로</button>		
								<button type="button" id="logoutBtn">로그아웃</button>					
							</td>
						</tr>
		       		</tbody>
				</table>
			</form>
			<!-- document.modFrm -->
        </div>
		<!-- div#mod -->
		 <%@include file="../include/Footer.jsp"%>
	</div>
	<!-- div#wrap -->
	
	
    <script src="/Proj_OnedayClass/script/jquery-3.6.0.min.js"></script>
	<script src="/Proj_OnedayClass/script/script.js"></script>
	<script src="/Proj_OnedayClass/script/member.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	
</body>
</html>   

<!-- ////////////////  로그인 상태 끝  ////////////////// -->

<% } else { %>

	<script>
		alert("비정상적인 접속입니다.\n"
				 +"메인페이지로 이동합니다."); 
		           // 현재 메인페이지는 없기 때문에 로그인페이지로 이동
		location.href="../Index.jsp";
	
	</script>

<% } %>



