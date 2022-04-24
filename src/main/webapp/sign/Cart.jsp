<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
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

						<tbody>
							<tr>
								<td>다쿠아즈</td>
								<td>30000</td>
								<td>
						<button class="btnminus">-</button>
						 <input type="text" name="p_num1" id="p_num1" size="2" maxlength="4" class="p_num" value="1">
						 <button class="btnplus">+</button>
						 </td>
								<td>30000</td>
							</tr>
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
							<td>30000</td>
							</tr>
							
							<tr>
							<td>배송 :</td>
							<td>배송비 3000 <br><br>
								주소 어쩌고 저쩌고 어쩌고
								</td>
							</tr>
							
							<tr>
							<td>총계 :</td>
							<td>33000</td>
							</tr>
							
						</tbody>
					</table>
					<button id="btnpay">결제하기</button>
				</div>
				
			</div>		
			
			
		</main>


	<%@include file="../include/Footer.jsp"%>
	</div>

	<script
		src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/script.js"></script>
</body>
</html>