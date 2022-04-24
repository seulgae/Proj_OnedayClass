////////////////////// 장바구니 수량 버튼 시작 /////////////////////////

function btnMinus(i) {		
	let pNum = $("#pQty" + i).val().trim();
	let availStu = $("#availStu" + i).val().trim();
	let cPrice = $("#cPrice" + i).val().trim();
	
	if(pNum > availStu - 1 || pNum <= 1) {
		alert("가능한 수량은 남은 수량보다 작거나 1보다 커야합니다.")
		$("#pQty" + i).val(1);
		$("#pQty" + i).focus();
	} else {
		$("#pQty" + i).val(Number(pNum)-1);
	}
	
	let res = cPrice * $("#pQty" + i).val().trim();
	
	$("#res" + i).text(res);
	$("#resVal"+i).val(res);
	totalPrice();
	totalPay();
}

function btnPlus(i) {		
	let pNum = $("#pQty" + i).val().trim();
	let availStu = $("#availStu" + i).val().trim();
	let cPrice = $("#cPrice" + i).val().trim();

	if(pNum > availStu - 1 || pNum < 1) {
		alert("가능한 수량은 남은 수량보다 작거나 1보다 커야합니다.")
		$("#pQty" + i).val(1);
		$("#pQty" + i).focus();
	} else {
		$("#pQty" + i).val(Number(pNum)+1);
	}
	
	let res = cPrice * $("#pQty" + i).val().trim();
	
	$("#res" + i).text(res);
	$("#resVal"+i).val(res);
	totalPrice();
	totalPay();
}


////////////////////// 장바구니 수량 버튼 끝 /////////////////////////


////////////////////// 장바구니 합계 ///////////////////////////////
function totalPrice(){
	let totalSum = 0;
	let listSize = $("#listSize").val().trim();
	
	for(let i=0; i < listSize; i++) {
		totalSum += Number($("#res" + i).text());
	}
	
	$("#totalPrice").text(totalSum);
	$("#totalPriceVal").val(totalSum);
}

function totalPay(){
	let totalPrice = Number($("#totalPrice").text());
	let totalDeli = Number($("#totalDeli").text());
	let totalPay = totalPrice+totalDeli;
	
	$("#totalPay").text(totalPay);
	$("#totalPayVal").val(totalPay);
}

$(function(){
	
	totalPrice();
	
	totalPay();
	
	$("#payBtn").click(function(){
		
		let listSize = Number($("#listSize").val().trim());
		
		if (listSize==0) {
			alert("장바구니가 비었습니다.");
		} else {
			$("#payBtn").submit();
		}
		
	});
});

