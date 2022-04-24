///////////////////////////////////////////////////////////
////////////////////바닐라 JS 영역 시작/////////////////////
///////////////////////////////////////////////////////////


/////////// 뷰페이지(=내용 보기 페이지) 이동 시작 ///////////
function lvlRead(p1, p2) {
    let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	let param = "LvlUpRead.jsp?lvlNum="+p1;
	     param += "&nowPage="+p2;
	     param += "&keyField="+p3;
	     param += "&keyWord="+p4 ; 
	location.href=param;
}	
/////////// 뷰페이지(=내용 보기 페이지) 이동 끝 ///////////
	
	
	
//////////////// 리스트페이지 페이징 시작 //////////////////

function movePage(p1) {    // 페이지 이동
	
    let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord

	let param = "LvlUpList.jsp?nowPage="+p1;	    
	     param += "&keyField="+p3;
	     param += "&keyWord="+p4 ; 
	location.href= param;
}


function moveBlock(p1, p2) {    // 블럭 이동

	let pageNum = parseInt(p1);
	let pagePerBlock = parseInt(p2);	
	//alert("p1 : " + p1 + "\np2 : " + p2);
	
    let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
	let param = "LvlList.jsp?nowPage="+(pagePerBlock*(pageNum-1)+1);
	     param += "&keyField="+p3;
	     param += "&keyWord="+p4 ; 
	location.href=param;
}



 

//////////////// 리스트페이지 페이징 끝 //////////////////	
	
	

///////////////////////////////////////////////////////////
////////////////////바닐라 JS 영역 끝/////////////////////
///////////////////////////////////////////////////////////
	




$(function(){
	
		//////////////// 로그인 메뉴 안내멘트 시작 //////////////////
	$("#header ul>li:nth-child(2)").click(function(){
		alert("작업중입니다.");
	});
	//////////////// 로그인 메뉴 안내멘트 끝 //////////////////
	
	//////////////// 게시글 등록 시작 //////////////////
	$("#lvlRegBtn").click(function(){
		
		let lvlTitle = $("#lvlTitle").val().trim();
		let lvlContent= $("#lvlContent").val().trim();
		let lvlName= $("#lvlName").val().trim();
		
		if (lvlTitle == "") {
			alert("제목은 입력해주세요.");
			$("#lvlTitle").focus();			
		} else if (lvlContent == "") {
			alert("내용을 입력해주세요.");
			$("#lvlContent").focus();
		} else if (lvlName == "") {
			alert("상호명을 입력해주세요.");
			$("#lvlName").focus();
		}  else {
		if(window.confirm("게시글 등록 하시겠습니까?")){
			$("#postFrm").submit();
			}
		}
	});	
	//////////////// 게시글 등록 끝 //////////////////
	
	
	
	
	
	//////////////// 리스트페이지 이동 시작 //////////////////
	$("#lvlListBtn").click(function(){
		location.href="/Proj_OnedayClass/levelUp/LvlUpList.jsp";		
		/*let param = $("#nowPage").val().trim();
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	     
		let url = "/Proj_OnedayClass/bbs/List.jsp?nowPage=" + param;		    
		    url += "&keyField="+p3;
	     	url += "&keyWord="+p4 ; 
		location.href=url;*/
		
	});
	//////////////// 리스트페이지 이동 끝 //////////////////
	
	//////////////// 리스트페이지 검색 시작 //////////////////
	$("button#searchBtn").click(function(){
		let keyWord = $("#keyWord").val().trim();
		if (keyWord=="") {
			alert("검색어를 입력해주세요.");
			$("#keyWord").focus();			
		} else {
			$("#searchFrm").submit();
		}
	});	
	//////////////// 리스트페이지 검색 끝 //////////////////
	
	
	
	
	
	
	
	//////////////// 파일다운로드(Read.jsp) 시작 //////////////////
	$("span#downloadFile").click(function(){
		let fName = $("input#hiddenFname").val().trim();
		location.href="/Proj_OnedayClass/levelUp/LvlUpDownload.jsp?lvlFileName=" + fName;
	});
	//////////////// 파일다운로드(Read.jsp) 끝 //////////////////
	
	
	
	//////////////// Read.jsp 에서 게시글 삭제버튼 시작 //////////////////
	$("button#delBtn").click(function(){
		 if(window.confirm("정말 삭제하시겠습니까 ? ")){
		let nowPage = $("input#nowPage").val().trim();
		let lvlNum = $("input#lvlNum").val().trim();
				
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	    
		let url = "/Proj_OnedayClass/levelUp/LvlUpDelete.jsp?";
			url += "lvlNum="+lvlNum+"&nowPage="+nowPage;
			url += "&keyField="+p3;
			url += "&keyWord="+p4;
		location.href=url;
		}
	});
	//////////////// Read.jsp 에서 게시글 삭제버튼 끝 //////////////////
	
	//////////////// Read.jsp 에서 게시글 수정버튼 시작 //////////////////
	$("button#lvlModBtn").click(function(){
		let nowPage = $("input#nowPage").val().trim();
		let lvlNum = $("input#lvlNum").val().trim();
				
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
		let url = "/Proj_OnedayClass/levelUp/LvlUpdate.jsp?";
			url += "lvlNum="+lvlNum;
			url += "&nowPage="+nowPage;
			url += "&keyField="+p3;
	     	url += "&keyWord="+p4; 
		location.href=url;
	});
	//////////////// Read.jsp 에서 게시글 수정버튼 끝 //////////////////
	
	//////////////// Read.jsp 에서 등업 수락 버튼 시작 //////////////////
	$("button#AcBtn").click(function(){
		if(window.confirm("등업 승인 하시겠습니까?")){
			$("#AcForm").submit();
		}
	});
	//////////////// Read.jsp 에서 등업 수락 버튼 끝 //////////////////
	
	
	//////////////// Read.jsp 에서 등업 거절 버튼 시작 //////////////////
	$("button#RjBtn").click(function(){
		if(window.confirm("등업 거절 하시겠습니까?")){
		let nowPage = $("input#nowPage").val().trim();
		let lvlNum = $("input#lvlNum").val().trim();
				
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
		let url = "/Proj_OnedayClass/levelUp/LvlUpReply.jsp?";
			url += "lvlNum="+lvlNum;
			url += "&nowPage="+nowPage;
			url += "&keyField="+p3;
	     	url += "&keyWord="+p4; 
		location.href=url;
		}
	});
	//////////////// Read.jsp 에서 등업 거절 버튼 끝 //////////////////
	
	
	
	
	//////////////// Reply.jsp 에서 답변글 버튼 시작 //////////////////
	$("td.reply>button#replyBtn").click(function(){
		
		let lvlUid = $("#lvlUid").val().trim();
		let lvlTitle = $("#lvlTitle").val().trim();
		
		if (lvlUid == "") {
			alert("성명은 필수입력입니다.");
			$("#lvlUid").focus(); 
		} else if (lvlTitle == "") {
			alert("제목은 필수입력입니다.");
			$("#lvlTitle").focus();
		} else {
			$("#replyFrm").submit();
		}
	
	});
	//////////////// Reply.jsp 에서 답변글 버튼 끝 //////////////////		
	

	
	//////////////// Delete.jsp 에서 게시글 삭제실행 시작 //////////////////
	
	
	$("button#delSbmBtn").click(function(){
		
		let uPw = $("input#uPw").val().trim();
		
		if(uPw == "") {
			$("input#uPw").focus();
			return;
		} else {
		
			let delChk = confirm("게시물을 삭제합니다.");
			if(delChk) {
				$("#delFrm").submit();
			} else {
				alert("삭제를 취소하셨습니다.");
				return;
			}
			
		}
		
	});
	$("button#backBtn").click(function(){
		history.back();
	});
	//////////////// Delete.jsp 에서 게시글 삭제실행 끝 //////////////////
	
	
	
	//////////////// Update.jsp 에서 게시글 수정 시작 //////////////////
	$("button#lvleModBtn").click(function(){
		let lvlUid = $("#lvlUid").val().trim();
		let lvlTitle = $("#lvlTitle").val().trim();
		let lvlName = $("#lvlName").val().trim();
		
		//let keyField = $("#keyField").val().trim();
		//let keyWord = $("#keyWord").val().trim();
		
		if (lvlUid == "") {
			alert("아이디는 필수 입력입니다.");
			$("#lvlUid").focus();
		} else if (lvlTitle == "") {
			alert("제목은 필수 입력입니다.");
			$("#lvlTitle").focus();
		} else if (lvlName == "") {
			alert("상호명은 필수 입력입니다.");
			$("#lvlTitle").focus();
		} else {
			//alert("keyField : " + keyField + "\nkeyWord : " + keyWord);
			//return;
			$("#updateFrm").submit();
		}
	
	});	
	//////////////// Update.jsp 에서 게시글 수정 끝 //////////////////
});