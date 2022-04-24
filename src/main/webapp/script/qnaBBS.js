///////////////////////////////////////////////////////////
////////////////////바닐라 JS 영역 시작/////////////////////
///////////////////////////////////////////////////////////
	
/////////// 뷰페이지(=내용 보기 페이지) 이동 시작 ///////////
function read(p1, p2) {
    let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	let param = "/Proj_OnedayClass/qnaBBS/QnaRead.jsp?qNum="+p1;
	     param += "&nowPage="+p2;
	     param += "&keyField="+p3;
	     param += "&keyWord="+p4 ; 
	
	$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(qnaRead){
			$("#tblArea").html(qnaRead);
		});

}	
/////////// 뷰페이지(=내용 보기 페이지) 이동 끝 ///////////

	
	
//////////////// 리스트페이지 페이징 시작 //////////////////

function movePage(p1) {    // 페이지 이동
	
    let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord

	let param = "/Proj_OnedayClass/qnaBBS/QnaList.jsp?nowPage="+p1;	    
	     param += "&keyField="+p3;
	     param += "&keyWord="+p4 ; 

	$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(qnaMovePage){
			$("#tblArea").html(qnaMovePage);
		});
}


function moveBlock(p1, p2) {    // 블럭 이동

	let pageNum = parseInt(p1);
	let pagePerBlock = parseInt(p2);	
	//alert("p1 : " + p1 + "\np2 : " + p2);
	
    let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
	let param = "/Proj_OnedayClass/qnaBBS/QnaList.jsp?nowPage="+(pagePerBlock*(pageNum-1)+1);
	     param += "&keyField="+p3;
	     param += "&keyWord="+p4 ; 
	
	$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(qnaMoveBlock){
			$("#tblArea").html(qnaMoveBlock);
		});

}

//////////////// 리스트페이지 페이징 끝 //////////////////	
	
	

///////////////////////////////////////////////////////////
////////////////////바닐라 JS 영역 끝/////////////////////
///////////////////////////////////////////////////////////
	




$(function(){
	
	
	//////////////// 게시글 등록 시작 //////////////////
	$("#postBtn").click(function(){
		// ajax 통신
		$.ajax({
		    url : "/Proj_OnedayClass/qnaBBS/QnaPost.jsp",      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(qnaPost){
			$("#tblArea").html(qnaPost);
		});
	});	
	//////////////// 게시글 등록 끝 //////////////////

	////////////////게시글 등록 시작 //////////////////
		$("#regBtn").click(function(event){
			let qTitle = $("#qTitle").val().trim();
			let p5 = $("#cNum").val().trim();
			
			if (qTitle == "") {
				alert("제목은 필수입력입니다.");
				$("#qTitle").focus();			
			} else {
				//preventDefault 는 기본으로 정의된 이벤트를 작동하지 못하게 하는 메서드이다. submit을 막음 
				event.preventDefault();          
			    // Get form         
			    let form = $('#postFrm')[0];  	    
			    // Create an FormData object          
			    let formData = new FormData(form);  	   
			    // disabled the submit button         
			    $("#regBtn").prop("disabled", true);   
			    
			    $.ajax({             
			    	type: "POST",          
			        enctype: 'multipart/form-data',  
			        url: "/Proj_OnedayClass/qnaBBS/QnaPostProc.jsp",        
			        data: formData,          
			        processData: false,    
			        contentType: false,      
			        cache: false,           
			        success: function () { 
			        	$.ajax({
						    url : "/Proj_OnedayClass/qnaBBS/QnaList.jsp",      // 컨트롤러에서 대기중인 URL 주소이다.
						    type : "GET",            // HTTP method type(GET, POST) 형식이다.
						}).done(function(qnaList){
							$("#tblArea").html(qnaList);
						}); 
			        },          
			        error: function (e) {  
			        	console.log("ERROR : ", e);     
			            $("#regBtn").prop("disabled", false);    
			            alert("다시 확인해주세요.");      
			         }     
				});
			}
		
		});	
		//////////////// 게시글 등록 끝 //////////////////
		
	//////////////// 리스트페이지 이동 시작 //////////////////
	$("#listBtn").click(function(){
		
		let p1 = $("#nowPage").val().trim();
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	     
		let param = "/Proj_OnedayClass/qnaBBS/QnaList.jsp?nowPage=" + p1;		    
		    param += "&keyField="+p3;
	     	param += "&keyWord="+p4; 
		
		$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(qnaList){
			$("#tblArea").html(qnaList);
		});
		
		
	});
	//////////////// 리스트페이지 이동 끝 //////////////////
	
//////////////// 리스트페이지 검색 시작 //////////////////
   $("button#searchBtn").click(function(event){
      fnSearch(event);
   });
   
   function fnSearch(event) {
      let keyWord = $("#keyWord").val().trim();
      if (keyWord=="") {
         alert("검색어를 입력해주세요.");
         $("#keyWord").focus();         
      } else {
         event.preventDefault();
         let p1 = $("#nowPage").val().trim();
         let keyField = $("#keyField").val();
         
         let param = "/Proj_OnedayClass/qnaBBS/QnaList.jsp?nowPage=" + p1;          
          param += "&keyField="+keyField;
           param += "&keyWord="+keyWord;

         $.ajax({
             url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
             type : "GET",            // HTTP method type(GET, POST) 형식이다.
         }).done(function(qnaList){
            $("#tblArea").html(qnaList);
         });
      }
   }
   
   // 엔터 이벤트 적용 시작
   $("input#keyWord").keyup(function(event){
      let code = event.keyCode;
      if(code == 13) fnSearch(event);
   });
   // 엔터 이벤트 적용 끝   
   //////////////// 리스트페이지 검색 끝 //////////////////
	
	
	
	
	
	
	
	//////////////// 파일다운로드(Read.jsp) 시작 //////////////////
	$("span#downloadFile").click(function(){
		let fName = $("input#hiddenFname").val().trim();
		location.href="/Proj_OnedayClass/qnaBBS/QnaDownload.jsp?qFileName=" + fName;
	});
	//////////////// 파일다운로드(Read.jsp) 끝 //////////////////
	
	
	
	//////////////// Read.jsp 에서 게시글 삭제버튼 시작 //////////////////
	$("button#delBtn").click(function(){
		if(window.confirm) {
			let nowPage = $("input#nowPage").val().trim();
			let qNum = $("input#qNum").val().trim();
					
			let p3 = $("#pKeyField").val().trim()  // p3 : keyField
		    let p4 = $("#pKeyWord").val().trim()  // p4 : keyWord
		    
			let param = "/Proj_OnedayClass/qnaBBS/QnaDelete.jsp?";
				param += "qNum="+qNum+"&nowPage="+nowPage;
				param += "&keyField="+p3;
				param += "&keyWord="+p4;
		
			$.ajax({
			    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
			    type : "GET",            // HTTP method type(GET, POST) 형식이다.
				success: function () {
					alert("삭제되었습니다!");
					
					let param2 = "/Proj_OnedayClass/qnaBBS/QnaList.jsp?nowPage=" + nowPage;
					param2 += "&keyField=" + p3;
					param2 += "&keyWord=" + p4;
					
					$.ajax({
					    url : param2,      // 컨트롤러에서 대기중인 URL 주소이다.
					    type : "GET",            // HTTP method type(GET, POST) 형식이다.
					}).done(function(qnaList){
						$("#tblArea").html(qnaList);
					});
		        },          
		        error: function (e) {  
		        	console.log("ERROR : ", e);     
		            $("#delBtn").prop("disabled", false);    
		            alert("권한이 없습니다.");
					
					let param3 = "/Proj_OnedayClass/qnaBBS/QnaRead.jsp?nowPage=" + nowPage;
					param3 += "&qNum="+qNum;
	    			param3 += "&keyField="+p3;
	 				param3 += "&keyWord="+p4;
	
					$.ajax({
					    url : param3,      // 컨트롤러에서 대기중인 URL 주소이다.
					    type : "GET",            // HTTP method type(GET, POST) 형식이다.
					}).done(function(qnaList){
						$("#tblArea").html(qnaList);
					});
		         }
			});
		}
	});
	//////////////// Read.jsp 에서 게시글 삭제버튼 끝 //////////////////
	
	
	
	//////////////// Read.jsp 에서 게시글 수정버튼 시작 //////////////////
	$("td.read>button#modBtn").click(function(){
	
		let nowPage = $("input#nowPage").val().trim();
		let qNum = $("input#qNum").val().trim();
				
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
		let param = "/Proj_OnedayClass/qnaBBS/QnaUpdate.jsp?";
			param += "qNum="+qNum;
			param += "&nowPage="+nowPage;
			param += "&keyField="+p3;
	     	param += "&keyWord="+p4; 
		
		$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(qnaMod){
			$("#tblArea").html(qnaMod);
		});
	});
	//////////////// Read.jsp 에서 게시글 수정버튼 끝 //////////////////
	
	//////////////// Read.jsp 에서 답변글 버튼 시작 //////////////////	
	
	$("td.read>button#replyBtn").click(function(){
	
		let nowPage = $("input#nowPage").val().trim();
		let qNum = $("input#qNum").val().trim();
				
		let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
		let param = "/Proj_OnedayClass/qnaBBS/QnaReply.jsp?";
			param += "qNum="+qNum;
			param += "&nowPage="+nowPage;
			param += "&keyField="+p3;
	     	param += "&keyWord="+p4; 
		
		$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(qnaReply){
			$("#tblArea").html(qnaReply);
		});
	
	});
	
	//////////////// Read.jsp 에서 답변글 버튼 끝 //////////////////
	
	
	//////////////// Reply.jsp 에서 답변글 버튼 시작 //////////////////
	$("td.reply>button#replyBtn").click(function(event){
		
		let qTitle = $("#qTitle").val().trim();
		
		if (qTitle == "") {
			alert("제목은 필수입력입니다.");
			$("#qTitle").focus();
		} else {
			event.preventDefault();    
			let formData = $('#replyFrm').serialize();  	      
		    // disabled the submit button         
		    $("#replyBtn").prop("disabled", true);   
			    
		    $.ajax({             
		    	type: "POST",
		        url: "/Proj_OnedayClass/qnaBBS/QnaReplyProc.jsp",        
		        data: formData,            
		        success: function () {
					let nowPage = $("input#nowPage").val();
							
					let keyField = $("#keyField").val();  // p3 : keyField
				    let keyWord = $("#keyWord").val();

					let param = "/Proj_OnedayClass/qnaBBS/QnaList.jsp?nowPage=" + nowPage;		    
	    			param += "&keyField="+keyField;
     				param += "&keyWord="+keyWord;

		        	$.ajax({
					    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
					    type : "GET",            // HTTP method type(GET, POST) 형식이다.
					}).done(function(qnaList){
						$("#tblArea").html(qnaList);
					}); 
		        },          
		        error: function (e) {  
		        	console.log("ERROR : ", e);     
		            $("#replyBtn").prop("disabled", false);    
		            let msg = "답변글 등록중 오류가 발생했습니다.\n";
				    msg += "다시 시도해주세요\n";
				    msg += "오류가 지속되면 관리자에게 연락바랍니다.";
					alert(msg);
		         }     
			});
			
		}
		
	});
	//////////////// Reply.jsp 에서 답변글 버튼 끝 //////////////////		
	
	//////////////// Update.jsp 에서 게시글 수정 시작 //////////////////
	$("td.update>button#modBtn").click(function(event){

		let qTitle = $("#qTitle").val().trim();
		
		if (qTitle == "") {
			alert("제목은 필수입력입니다.");
			$("#qTitle").focus();
		}  else {
		
			event.preventDefault();    
			let formData = $('#updateFrm').serialize();  	      
		    // disabled the submit button         
		    $("#modBtn").prop("disabled", true);   
			    
		    $.ajax({             
		    	type: "POST",
		        url: "/Proj_OnedayClass/qnaBBS/QnaUpdateProc.jsp",        
		        data: formData,            
		        success: function () {
					
					let nowPage = $("input#nowPage").val();
					let qNum = $("input#qNum").val();
							
					let keyField = $("#keyField").val();  // p3 : keyField
				    let keyWord = $("#keyWord").val();

					let param = "/Proj_OnedayClass/qnaBBS/QnaRead.jsp?nowPage=" + nowPage;
					param += "&qNum="+qNum;
	    			param += "&keyField="+keyField;
     				param += "&keyWord="+keyWord;

		        	$.ajax({
					    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
					    type : "GET",            // HTTP method type(GET, POST) 형식이다.
					}).done(function(qnaRead){
						$("#tblArea").html(qnaRead);
					}); 
		        },          
		        error: function (e) {  
		        	console.log("ERROR : ", e);     
		            $("#modBtn").prop("disabled", false);    
		            let msg = "글 수정중 오류가 발생했습니다.\n";
				    msg += "다시 시도해주세요\n";
				    msg += "오류가 지속되면 관리자에게 연락바랍니다.";
					alert(msg);
		         }     
			});
		}
	
	});	
	//////////////// Update.jsp 에서 게시글 수정 끝 //////////////////
	
	//////////////// Update.jsp 에서 뒤로가기 버튼 시작 //////////////////
	$("button#backBtn").click(function(){
		let nowPage = $("input#nowPage").val();
		let qNum = $("input#qNum").val();
				
		let keyField = $("#keyField").val();  // p3 : keyField
	    let keyWord = $("#keyWord").val();

		let param = "/Proj_OnedayClass/qnaBBS/QnaRead.jsp?nowPage=" + nowPage;
		param += "&qNum="+qNum;
		param += "&keyField="+keyField;
		param += "&keyWord="+keyWord;

    	$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(qnaRead){
			$("#tblArea").html(qnaRead);
		}); 
	});
	//////////////// Update.jsp 에서 뒤로가기 버튼 끝 //////////////////
	
});