<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" 
    import="java.util.Vector, pack_Payment.PaymentBean,
    java.util.Date, java.text.SimpleDateFormat"%>
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="pMgr" class="pack_Payment.PaymentMgr" scope="page" />
<%
String uId = (String)session.getAttribute("idKey");
int listSize = Integer.parseInt((String)request.getParameter("listSize"));
int totalPrice = Integer.parseInt((String)request.getParameter("totalPriceVal"));
int totalDeli = Integer.parseInt((String)request.getParameter("totalDeliVal"));
int totalPay = Integer.parseInt((String)request.getParameter("totalPayVal"));

String msg = "";
String msg2 = "";
PaymentBean bean = new PaymentBean();
boolean flag = false;

int execnt = pMgr.insPayList(request);

// 현재시간 불러오기
Date nowTime = new Date();
SimpleDateFormat sf = new SimpleDateFormat("yyyy년 MM월 dd일 a hh:mm:ss");

if (execnt>0) {
	
	int pNum = pMgr.findpNum();
	
	for (int i = 0; i < listSize; i++) {
		execnt=0;
		
		bean.setuId(uId);
		bean.setcNum(Integer.parseInt((String)request.getParameter("cNum"+i)));
		bean.setcUid((String)request.getParameter("cUid"+i));
		bean.setcTitle((String)request.getParameter("cTitle"+i));
		bean.setpNum(pNum);
		bean.setpQty(Integer.parseInt((String)request.getParameter("pQty"+i)));
	
		execnt = pMgr.payCompl(bean);
			
		if(execnt>0) {
			continue;
		} else {
			msg = "수강등록에 실패하였습니다.\n";
			msg2 = "관리자에게 해당정보를 보내주세요.";
			flag = true;
		}
		
		if(flag) break;
	}
	
	if(!flag) msg = "수강등록 완료!";
} else {
	msg = "수령인 정보 등록에 실패하였습니다.\n";
	msg2 = "관리자에게 해당정보를 보내주세요.";
}
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title><%=msg %></title>
	<link rel="stylesheet" href="/Proj_OnedayClass/style/member.css">

</head>
<body>
	<div id="wrap">
	<%@include file="../include/Header.jsp"%>

		<h1><%=msg %></h1>
		<h2><%=msg2 %></h2>
		
		<main id="main" class="flex-container">

        <div id="frmSide">
			<table id="recipientTbl">
				<caption><hr><h3>수령인 정보</h3></caption>
				<tbody>
					<tr>
						<td>수령인이름</td>
						<td><%=request.getParameter("rName") %></td>
					</tr>
					<tr>
						<td>전화번호</td>
						<td><%=request.getParameter("rPhone") %></td>
					</tr>                      
	            	<tr>
	            		<td>주소</td>
						<td><%=request.getParameter("rZip") %></td>
					</tr>
					<tr>
						<td></td>
						<td><%=request.getParameter("rAddr1") %></td>
					</tr>
					<tr>
						<td></td>
						<td><%=request.getParameter("rAddr2") %></td>
					</tr>
	
					<tr>
						<td>이메일</td>
						<td><%=request.getParameter("rEmail") %></td>
					</tr>
					<tr>
						<td>결제시간</td>
						<td><%=sf.format(nowTime) %></td>
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
						int cPrice = Integer.parseInt((String)request.getParameter("cPrice"+i));
						int pQty = Integer.parseInt((String)request.getParameter("pQty"+i));
						int res = Integer.parseInt((String)request.getParameter("res"+i));
				%>
				<tr>
					<td><%=cTitle %></td>
					<td><%=cPrice %>원</td>
					<td><%=pQty %></td>
					<td>
						<span id="res<%=i %>"><%=res %></span>원
					</td>
				</tr>
				<%
					}
				%>
				</tbody>							
			</table>

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
							<button id="mainBtn">메인으로</button>
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