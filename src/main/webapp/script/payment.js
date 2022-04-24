////////////// 우편번호 주소 확인 시작 //////////////////////
function zipCheck() {
	
	new daum.Postcode({
		 oncomplete: function(data) {
   		 // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

            // 도로명 주소의 노출 규칙에 따라 주소를 표시한다.
            // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
            var roadAddr = data.roadAddress; // 도로명 주소 변수

            // 우편번호와 주소 정보를 해당 필드에 넣는다.
            document.getElementById("rZip").value = data.zonecode;
            document.getElementById("rAddr1").value = roadAddr;
            document.getElementById("rAddr2").focus(); // 상세주소로 포커스
        }
    }).open();
	
}


////////////// 우편번호 주소 확인 끝 //////////////////////


$(function(){
	
	////////////// 우편주소 확인 시작 //////////////////////
	$("#zipBtn").click(function(){
		zipCheck();
	});
	////////////// 우편주소 확인 끝 ///////////////////////
	
	//////////////// 회원정보 불러오기 시작 ///////////////////
	$("#memInfoChk").click(function(){
		
		let Chk = $('#memInfoChk').is(':checked');
		
		if(Chk) {
			
			let uName = $("#uName").val();
			let uPhone = $("#uPhone").val();
			let uZip = $("#uZip").val();
			let uAddr1 = $("#uAddr1").val();
			let uAddr2 = $("#uAddr2").val();
			let uEmail = $("#uEmail").val();
			
			$("#rName").val(uName);
			$("#rPhone").val(uPhone);
			$("#rZip").val(uZip);
			$("#rAddr1").val(uAddr1);
			$("#rAddr2").val(uAddr2);
			$("#rEmail").val(uEmail);
		} else {
			$("#rName").val("");
			$("#rPhone").val("");
			$("#rZip").val("");
			$("#rAddr1").val("");
			$("#rAddr2").val("");
			$("#rEmail").val("");
		}
	});
	//////////////// 회원정보 불러오기 끝 /////////////////////
	
	///////////////// 카카오페이 api(iamport) 시작 ///////////////
	/*
	$("#kakaoBtn").click(function(){

		document.cookie = "AWSELB=foo; SameSite=Lax";
		document.cookie = "safeCookie1=foo;";
		document.cookie = "crossCookie=bar; SameSite=None; Secure";

		let addr = $("#rAddr1").val() + " " + $("#rAddr2").val();
		
		let IMP = window.IMP; 
		
    	IMP.init('imp58375863'); 

    	IMP.request_pay({
	    	pg : "kakaopay", 
	        pay_method : 'card',
	        merchant_uid : 'merchant_' + new Date().getTime(),
	        name : '원데이 클래스 결제',
	        amount : $("#totalPayVal").val(),
	        buyer_email : $("#rEmail").val(),
	        buyer_name : $("#rName").val(),
	        buyer_tel : $("#rPhone").val(),
	        buyer_addr : addr,
	        buyer_postcode : $("#rZip").val()
	    }, function(rsp) {
	        if ( rsp.success ) {
	            var msg = '결제가 완료되었습니다.';
	        } else {
	            var msg = '결제에 실패하였습니다.';
	            rsp.error_msg;
	        }
			alert(msg);
	    });
	});
	*/
	
	$("#kakaoBtn").click(function(){
		$("#recipientFrm").submit();
	});
	///////////////// 카카오페이 api(iamport) 끝 ///////////////
	
	/////////////////// 버튼 시작 //////////////////////////////
	$("#mainBtn").click(function(){
		location.href="/Proj_OnedayClass/Index.jsp";
	});
	/////////////////// 버튼 끝 //////////////////////////////
});
