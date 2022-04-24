<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<%@ page import="pack_ClassBBS.ClassBean, java.util.Vector"%>

<jsp:useBean id="pMgr" class="pack_Payment.PaymentMgr" scope="page" />

<%
request.setCharacterEncoding("UTF-8");

String uId = (String) session.getAttribute("idKey");
String uName = (String) session.getAttribute("nameKey");
String uLevel = (String) session.getAttribute("levelKey");

int deliverySum = 0; // 배달료 합계

int listSize = 0;

Vector<ClassBean> vList = null;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>OnedayClass</title>
<link rel="stylesheet" href="/Proj_OnedayClass/style/cart.css">
</head>
<body>
	<div id="wrap">

		<%@include file="../include/Header.jsp"%>

		<main class="cart">
		<h1>장바구니</h1>
		
			<form action="Payment.jsp" name="cartFrm" id="cartFrm" method="post">
				<div id="cartcontent" class="flex-container">
					
					<div id="cartlist">
						<table id="goodslist">
							<thead>
								<tr>
									<th>상품명</th>
									<th>가격</th>
									<th>수량</th>
									<th>총계</th>
								</tr>
							</thead>
							
							<%
							vList = pMgr.getCartList(uId);
							listSize = vList.size();
							%>
							<tbody>
							
							<%
							if (vList.isEmpty()) {
							%>
								<tr>
									<td colspan="4">장바구니가 비었습니다.</td>
								</tr>
							<%
							} else {
								for (int i = 0; i < listSize; i++) {
	
									ClassBean bean = vList.get(i);
	
									int cNum = bean.getcNum();
									String cTitle = bean.getcTitle();
									String cUid = bean.getcUid();
									int cPrice = bean.getcPrice();
									int cDelivery = bean.getcDelivery();
									int cMaxStu = bean.getcMaxStu();
									int cApplyStu = bean.getcApplyStu();
									int availStu = cMaxStu - cApplyStu;
									
									deliverySum += cDelivery; 
							%>
								<tr>
									<td><%=cTitle %></td>
									<td><%=cPrice %>원</td>
									<td>
										<input type="hidden" id="cNum<%=i %>" name="cNum<%=i %>" value="<%=cNum %>">
										<input type="hidden" id="cUid<%=i %>" name="cUid<%=i %>" value="<%=cUid %>">
										<input type="hidden" id="cTitle<%=i %>" name="cTitle<%=i %>" value="<%=cTitle %>">
										<input type="hidden" id="cPrice<%=i %>" name="cPrice<%=i %>" value="<%=cPrice %>">
										<input type="hidden" id="availStu<%=i %>" name="availStu<%=i %>" value="<%=availStu %>">
										
										<span class="btnminus" onclick="btnMinus(<%=i%>)">-</span>
										<input type="text" name="pQty<%=i %>" id="pQty<%=i %>" size="2" 
										maxlength="4" class="pQty" value="1" max="<%=availStu%>" min="1">
										<span class="btnplus" onclick="btnPlus(<%=i%>)">+</span>
								 	</td>
									<td>
										<span id="res<%=i %>"><%=cPrice %></span>원
										<input type="hidden" name="resVal<%=i%>" id="resVal<%=i%>" value="<%=cPrice%>">
									</td>
								</tr>
							<%
								}
							}
							%>
							</tbody>							
						</table>
					</div>
					

					<div id="paylist">
						<table>
							<thead>
								<tr>
									<th colspan="4">장바구니 합계</th>
								</tr>
							</thead>
							
							<tbody>
							
								<tr>
									<td>소계 :</td>
									<td>
										<span id="totalPrice"></span>원
									</td>
								</tr>
								
								<tr>
									<td>배송 :</td>
									<td><span id="totalDeli"><%=deliverySum %></span>원</td>
								</tr>
								
								<tr>
									<td>총계 :</td>
									<td><span id="totalPay"></span>원</td>
								</tr>
								
							</tbody>
						</table>
						
						<input type="hidden" name="listSize" id="listSize" value="<%=listSize%>">
						<input type="hidden" name="totalPriceVal" id="totalPriceVal" value="0">
						<input type="hidden" name="totalDeliVal" id="totalDeliVal" value="<%=deliverySum %>">
						<input type="hidden" name="totalPayVal" id="totalPayVal" value="0">
						
						<button id="payBtn">결제하기</button>
					</div>
				
				</div>
						
			</form>
			
			
		</main>


	<%@include file="../include/Footer.jsp"%>
	</div>

	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/cart.js"></script>
</body>
</html>