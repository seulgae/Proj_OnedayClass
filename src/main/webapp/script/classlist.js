///////////// ClassPost.jsp 시작 //////////////////
$(function(){
			////// 클래스 생성 //////
			$("#regBtn").click(function(){

				let cTeacher = $("#cTeacher").val();
				let cCategory = $("#cCategory").val();
				let cTitle = $("#cTitle").val();
				let cContent = $("#cContent").val();
				let cPrice = $("#cPrice").val();
				let cMaxStu = $("#cMaxStu").val();
				
				///// 공백 검사 /////
				if(cTeacher == "") {    
					alert("강사이름을 입력하세요.");
					$("#cTeacher").focus();
				} else if (cCategory == 0) {     
					alert("카테고리를 설정해주세요.");
					$("#cCategory").focus();
				} else if (cTitle == "") {  
					alert("클래스 제목을 입력하세요.");
					$("#cTitle").focus();
				} else if (cContent == "") {     
					alert("클래스 내용을 입력하세요.");
					$("#cContent").focus();
				} else if (cPrice == "") {     
					alert("수강료를 입력하세요.");
					$("#cPrice").focus();
				} else if (cMaxStu == "") {     
					alert("수강인원을 설정해주세요.");
					$("#cMaxStu").focus();
				}  else if (cMaxStu == "") {    
					alert("수강인원을 설정해주세요.");
					$("#cMaxStu").focus();
				}else {
					$("#regFrm").submit();
				}				
			});		
});
///////////// ClassPost.jsp 종료 //////////////////


///////////// ClassList.jsp 시작 //////////////////
function read(p1, p2){
	let param = "ClassRead.jsp?cNum="+p1;
		 param += "&nowPage="+p2;
	//? 이후의 파라미터를 보내줌 (,대신 &기호를 사용함) -> cNum이랑 nowPage 
	location.href = param;
}
///////////// ClassList.jsp 종료 //////////////////

////////// 카테고리 ////////////////
function cCategorySelect(c){
	
	$("#cCategorySel").val(c);	
	
	$("#categoryform").submit();
	
}
////////// 카테고리 ////////////////

//////////////// 리스트페이지 페이징 시작 //////////////////

function movePage(p1) {    // 페이지 이동

	let param = "ClassList.jsp?nowPage="+p1;	    
	location.href= param;
}


function moveBlock(p1, p2) {    // 블럭 이동

	let pageNum = parseInt(p1);
	let pagePerBlock = parseInt(p2);	
	//alert("p1 : " + p1 + "\np2 : " + p2);
	
	let param = "ClassList.jsp?nowPage="+(pagePerBlock*(pageNum-1)+1);
	location.href=param;

}
//////////////// 리스트페이지 페이징 끝 //////////////////	


///////////// ClassRead.jsp 버튼 기능 ////////////////
$(function(){
	/////////// 좋아요 ////////////
	/*
	$("#like").click(function(){
		let url = "";
		location.href=url;
	});
	*/
	//////// 구매하기 이동 ///////
	$("#update").click(function(){
		let url = "";
		location.href=url;
	});
	////// 클래스 승인 //////
	$("button#AdminBtn").click(function(){
	    let nowPage = $("input#nowPage").val().trim();
		let cNum = $("input#cNum").val().trim();
		
		let url ="/Proj_OnedayClass/classBBS/ClassApproval.jsp?";
		     url += "cNum="+cNum+"&nowPage="+nowPage;
		location.href = url;
	});
	
	////// 클래스 수정 //////
	$("button#modBtn").click(function(){
	    let nowPage = $("input#nowPage").val().trim();
		let cNum = $("input#cNum").val().trim();
		
		let url ="/Proj_OnedayClass/classBBS/ClassUpdate.jsp?";
		     url += "cNum="+cNum+"&nowPage="+nowPage;
		location.href = url;
	});
	
	////// 클래스 삭제 //////
	$("button#delBtn").click(function(){
		let nowPage = $("input#nowPage").val().trim();
		let cNum = $("input#cNum").val().trim();
		
		let url ="/Proj_OnedayClass/classBBS/ClassDelete.jsp?";
		     url += "cNum="+cNum+"&nowPage="+nowPage;
		location.href = url;
		
		
		
	});
///////////// ClassRead.jsp 버튼 기능 ////////////////

//////////////// Update.jsp 에서 게시글 수정 시작 //////////////////
	$("#updateBtn").click(function(){

		let cTitle = $("#cTitle").val().trim();
		let cContent = $("#cContent").val().trim();
		let cMaxStu = $("#cMaxStu").val().trim();
		let cOnoff = $("#cOnoff").val().trim();

		if (cTitle == "") {
			alert("제목을 입력하세요.");
			$("#cTitle").focus();
		}else if(cContent==""){
			alert("내용을 입력하세요");
			$("#cContent").focus();
		}else if(cMaxStu==""){
			alert("수강인원을 설정해주세요.");
			$("#cMaxStu").focus();
		}else if(cOnoff==""){
			alert("수업유형을 선택하세요");
			$("#cOnoff").focus();
		}else {
			$("#updateFrm").submit();
		}
	
	});	
//////////////// Update.jsp 에서 게시글 수정 끝 //////////////////
//////////////// 페이징기능떄문에 하나 더 만듬 //////////////////



});
