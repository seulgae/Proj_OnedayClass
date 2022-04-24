<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="pack_Member.MemberBean"%>
<%@page import="java.util.Vector"%>
<jsp:useBean id="mMgr" class="pack_Member.MemberMgr"  scope="page" />
<jsp:useBean id="pMgr" class="pack_Payment.PaymentMgr" scope="page" />
    
<%
request.setCharacterEncoding("UTF-8");

String sessionUId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");
Vector<MemberBean> vList = mMgr.modifyMember(sessionUId);
int listSize = Integer.parseInt((String)request.getParameter("listSize"));
int totalPrice = Integer.parseInt((String)request.getParameter("totalPriceVal"));
int totalDeli = Integer.parseInt((String)request.getParameter("totalDeliVal"));
int totalPay = Integer.parseInt((String)request.getParameter("totalPayVal"));
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
	<title>결제 페이지</title>
	<link rel="stylesheet" href="/Proj_OnedayClass/style/member.css">

</head>
<body>
	<div id="wrap">
	<%@include file="../include/Header.jsp"%>

		<h1>결제</h1>
		
		<main id="main" class="flex-container">

        <div id="frmSide">
			<form name="recipientFrm" id="recipientFrm" action="PaymentCompl.jsp" method="post">
				<table id="recipientTbl">
					<caption><hr><h3>수령인 정보</h3></caption>
					<tbody>
						<tr>
							<td>이름</td>
							<td>
								<input type="text" class="umem" name="rName" id="rName" size="40"
		                        placeholder="이름을 입력해주세요.">
		                        <input type="hidden" class="umem" name="uName" id="uName" size="40"
		                        value="<%=uName%>">
							</td>
						</tr>
						<tr>
							<td class="req">전화번호</td>
							<td>
						        <input type="text" class="umem" name="rPhone" id="rPhone" size="40"
						        placeholder="전화번호를 입력해주세요.">    
						        <input type="hidden" id="uPhone" value="<%=uPhone %>">
							</td>
						</tr>                      
		            	<tr>
		            		<td class="req">주소</td>
							<td>
								<input type="text" name="rZip" id="rZip" size="25" 
								readonly placeholder="우편번호">
								<input type="hidden" id="uZip" value="<%=uZip %>">
								<button type="button" id="zipBtn">우편번호찾기</button>
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input type="text" id="rAddr1" name="rAddr1" size="40"
								readonly placeholder="주소">
								<input type="hidden" id="uAddr1" value="<%=uAddr1 %>">
							</td>
						</tr>
						<tr>
							<td></td>
							<td>
								<input type="text" id="rAddr2" name="rAddr2" size="40"
								placeholder="상세주소를 입력해주세요.">
								<input type="hidden" id="uAddr2" value="<%=uAddr2 %>">
							</td>
						</tr>
		
						<tr>
							<td class="req">이메일</td>
							<td>
								<input type="text" class="umem" name="rEmail" id="rEmail" size="40"
		                     	placeholder="이메일 주소를 입력해주세요.">
		                     	<input type="hidden" id="uEmail" value="<%=uEmail %>">
							</td>
						</tr>
						<tr>
							<th colspan="2">
								<label>
		                               	<input type="checkbox" id="memInfoChk">
	                               		<span>회원정보와 동일합니다.</span>
	                           	</label>
							</th>
						</tr>
						<tr>
							<td colspan="2">
								<button type="reset">다시쓰기</button>					
							</td>
						</tr>
		       		</tbody>
				</table>
				<!-- table#recipientTbl -->
				
				<table id="goodslist">
					<thead>
						<tr>
							<th>상품명</th>
							<th>가격</th>
							<th>수량</th>
							<th>총계</th>
						</tr>
					</thead>

					<tbody>					

					<%
						for (int i = 0; i < listSize; i++) {
							
							int cNum = Integer.parseInt(request.getParameter("cNum"+i));
							String cTitle = (String)request.getParameter("cTitle"+i);
							String cUid = (String)request.getParameter("cUid"+i);
							int cPrice = Integer.parseInt((String)request.getParameter("cPrice"+i));
							int pQty = Integer.parseInt((String)request.getParameter("pQty"+i));
							int res = Integer.parseInt((String)request.getParameter("resVal"+i));
					%>
					<tr>
						<td><%=cTitle %></td>
						<td><%=cPrice %>원</td>
						<td><%=pQty %></td>
						<td>
							<span id="res<%=i %>"><%=res %></span>원
							<input type="hidden" id="cNum<%=i %>" name="cNum<%=i %>" value="<%=cNum %>">
							<input type="hidden" id="cUid<%=i %>" name="cUid<%=i %>" value="<%=cUid %>">
							<input type="hidden" id="cTitle<%=i %>" name="cTitle<%=i %>" value="<%=cTitle %>">
							<input type="hidden" id="cPrice<%=i %>" name="cPrice<%=i %>" value="<%=cPrice %>">
							<input type="hidden" id="pQty<%=i %>" name="pQty<%=i %>" value="<%=pQty %>">
							<input type="hidden" id="res<%=i %>" name="res<%=i %>" value="<%=res %>">
						</td>
					</tr>
					<%
						}
					%>
					</tbody>							
				</table>
				<input type="hidden" name="uId" id="uId" value="<%=uId%>">
				<input type="hidden" name="listSize" id="listSize" value="<%=listSize%>">
				<input type="hidden" name="totalPriceVal" id="totalPriceVal" value="<%=totalPrice %>">
				<input type="hidden" name="totalDeliVal" id="totalDeliVal" value="<%=totalDeli %>">
				<input type="hidden" name="totalPayVal" id="totalPayVal" value="<%=totalPay %>">
			</form>
			<!-- document.recipientFrm -->
        </div>
		<!-- div#frmSide -->
		
		<div id="paylist">
			<table>
				<thead>
					<tr>
						<th colspan="4">결제 합계</th>
					</tr>
				</thead>
				
				<tbody>
					<tr>
						<td>소계 :</td>
						<td>
							<span id="totalPrice"><%=totalPrice %></span>원
						</td>
					</tr>
					
					<tr>
						<td>배송 :</td>
						<td><span id="totalDeli"><%=totalDeli %></span>원</td>
					</tr>
					
					<tr>
						<td>총계 :</td>
						<td>
							<span id="totalPay"><%=totalPay %></span>원
						</td>
					</tr>
					<tr>					
						<td>
							<button id="kakaoBtn"><img src="/Proj_OnedayClass/img/payment_icon_yellow_medium.png" alt="카카오페이"></button>
						</td>
					</tr>
				</tbody>
			</table>
			
		</div>
		
		
		</main>
		 <%@include file="../include/Footer.jsp"%>
	</div>
	<!-- div#wrap -->
	
	
    <script src="/Proj_OnedayClass/script/jquery-3.6.0.min.js"></script>
	<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
	<script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.1.5.js"></script>
	<script src="/Proj_OnedayClass/script/payment.js"></script>
	
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



