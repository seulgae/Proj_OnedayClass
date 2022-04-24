///////////////////////////////////////////////////////////
////////////////////바닐라 JS 영역 시작/////////////////////
///////////////////////////////////////////////////////////


/////////// 뷰페이지(=내용 보기 페이지) 이동 시작 ///////////
function read(p1, p2) {
    /*let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord*/
	let param = "/Proj_OnedayClass/reviewBBS/RvRead.jsp?rNum="+p1;
	     param += "&nowPage="+p2;
	     /*param += "&keyField="+p3;
	     param += "&keyWord="+p4 ; */
	     
	$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(RvRead){
			$("#tblArea").html(RvRead);
		});
}	
/////////// 뷰페이지(=내용 보기 페이지) 이동 끝 ///////////
	
	
	
//////////////// 리스트페이지 페이징 시작 //////////////////

function movePage(p1) {    // 페이지 이동
	
    //let p3 = $("#pKeyField").val().trim();  // p3 : keyField
    //let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord

	let param = "/Proj_OnedayClass/reviewBBS/RvList.jsp?nowPage="+p1;	    
	   // param += "&keyField="+p3;
	   // param += "&keyWord="+p4 ; 
	
		$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(movePage){
			$("#tblArea").html(movePage);
		});
}


function moveBlock(p1, p2) {    // 블럭 이동

	let pageNum = parseInt(p1);
	let pagePerBlock = parseInt(p2);	
	//alert("p1 : " + p1 + "\np2 : " + p2);
	
  //  let p3 = $("#pKeyField").val().trim();  // p3 : keyField
  // let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
	let param = "/Proj_OnedayClass/reviewBBS/RvList.jsp?nowPage="+(pagePerBlock*(pageNum-1)+1);
	    // param += "&keyField="+p3;
	    // param += "&keyWord="+p4 ; 

	$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(moveBlock){
			$("#tblArea").html(moveBlock);
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
		    url : "/Proj_OnedayClass/reviewBBS/RvPost.jsp",      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(RvPost){
			$("#tblArea").html(RvPost);
		});
	});	
	//////////////// 게시글 등록 끝 //////////////////
		
	//////////////// 게시글 등록 시작 //////////////////
	$("#regBtn").click(function(){
		let rTitle = $("#rTitle").val().trim();
		// let uPw = $("#uPw").val().trim();
		
		if (rTitle == "") {
			alert("제목은 필수입력입니다.");
			$("#rTitle").focus();			
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
			        url: "/Proj_OnedayClass/reviewBBS/RvPostProc.jsp",        
			        data: formData,          
			        processData: false,    
			        contentType: false,      
			        cache: false,           
			        success: function () { 
			        	$.ajax({
						    url : "/Proj_OnedayClass/reviewBBS/RvList.jsp",      // 컨트롤러에서 대기중인 URL 주소이다.
						    type : "GET",            // HTTP method type(GET, POST) 형식이다.
						}).done(function(RvList){
							$("#tblArea").html(RvList);
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
		
		let param = "/Proj_OnedayClass/reviewBBS/RvList.jsp?nowPage=" + p1;
	/*	let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	    let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	     
		let url = "/Proj_OnedayClass/bbs/List.jsp?nowPage=" + param;		    
		    url += "&keyField="+p3;
	     	url += "&keyWord="+p4 ; 
		location.href=url;*/
		
		$.ajax({
		 url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		 type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(RvList){
			$("#tblArea").html(RvList);
		});
		
	});
	//////////////// 리스트페이지 이동 끝 //////////////////
	
	/*/////////////// 리스트페이지 검색 시작 //////////////////
	$("button#searchBtn").click(function(){
		let keyWord = $("#keyWord").val().trim();
		if (keyWord=="") {
			alert("검색어를 입력해주세요.");
			$("#keyWord").focus();			
		} else {
			$("#searchFrm").submit();
		}
	});	
	//////////////// 리스트페이지 검색 끝 /////////////////*/
	
	
	
	
	
	
	
	//////////////// 파일다운로드(Read.jsp) 시작 //////////////////
	$("span#downloadFile").click(function(){
		let fName = $("input#hiddenFname").val().trim();
		location.href="/Proj_OnedayClass/reviewBBS/RvDownload.jsp?rFileName=" + fName;
	});
	//////////////// 파일다운로드(Read.jsp) 끝 //////////////////
	
	
	
	//////////////// Read.jsp 에서 게시글 삭제버튼 시작 //////////////////
	$("button#delBtn").click(function(){
		if(window.confirm("정말 삭제하시겠습니까 ?")){
        let nowPage = $("input#nowPage").val().trim();
        let rNum = $("input#rNum").val().trim();

        let param = "/Proj_OnedayClass/reviewBBS/RvDelete.jsp?";
            param += "rNum="+rNum+"&nowPage="+nowPage;
         
        $.ajax({
            url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
            type : "GET",            // HTTP method type(GET, POST) 형식이다.
            success: function () {
                alert("삭제되었습니다!");

                let param2 = "/Proj_OnedayClass/reviewBBS/RvList.jsp?nowPage=" + nowPage;
              
                $.ajax({
                    url : param2,      // 컨트롤러에서 대기중인 URL 주소이다.
                    type : "GET",            // HTTP method type(GET, POST) 형식이다.
                }).done(function(RvList){
                    $("#tblArea").html(RvList);
                });
            },
            error: function (e) {
                console.log("ERROR : ", e);
                $("#delBtn").prop("disabled", false);
                alert("권한이 없습니다.");

                let param3 = "/Proj_OnedayClass/reviewBBS/RvRead.jsp?nowPage=" + nowPage;
                param3 += "&rNum="+rNum;
          

                $.ajax({
                    url : param3,      // 컨트롤러에서 대기중인 URL 주소이다.
                    type : "GET",            // HTTP method type(GET, POST) 형식이다.
                }).done(function(RvList){
                    $("#tblArea").html(RvList);
                });
             }
             
        })
        }
    });
	//////////////// Read.jsp 에서 게시글 삭제버튼 끝 //////////////////
	
	
	
	//////////////// Read.jsp 에서 게시글 수정버튼 시작 //////////////////
	$("td.read>button#modBtn").click(function(){
	
		let nowPage = $("input#nowPage").val().trim();
		let rNum = $("input#rNum").val().trim();
				
		//let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	  //  let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
		let param = "/Proj_OnedayClass/reviewBBS/RvUpdate.jsp?";
			param += "rNum="+rNum;
			param += "&nowPage="+nowPage;
		//	url += "&keyField="+p3; 
	     //	url += "&keyWord="+p4; 
	     
	    $.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(RvUpdate){
			$("#tblArea").html(RvUpdate);
		}); 
	});
	//////////////// Read.jsp 에서 게시글 수정버튼 끝 //////////////////

	//////////////// Read.jsp 에서 게시글 추천하기 시작 //////////////////
		$("button#RvlikeBtn").click(function(){
			
			let nowPage = $("input#nowPage").val().trim();
				let rNum = $("#rNum").val();
				let uId = $("#uId").val();

                    

                let param = "/Proj_OnedayClass/reviewBBS/RvRead.jsp?";
				param += "rNum="+rNum;
				param += "&uId="+uId;
				param += "&nowPage="+nowPage;
	     
	    $.ajax({
                type: "POST",
                url: "/Proj_OnedayClass/reviewBBS/RvLikeAction.jsp?rNum="+rNum+"&uId="+uId,
                success: function (url) {
						alert(url);
    					console.log(url);
                    $.ajax({
                        url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
                        type : "GET",            // HTTP method type(GET, POST) 형식이다.
                    }).done(function(RvRead){
                        $("#tblArea").html(RvRead);
                    }); 
                },
                error: function (e) {
                    console.log("ERROR : ", e);
                    $("#RvlikeBtn").prop("disabled", false);
                			alert("이미 추천함");

                 }
            });
            });
	//////////////// Read.jsp 에서 게시글 추천하기 끝 //////////////////
	
	/*/////////////// Read.jsp 에서 답변글 버튼 시작 //////////////////	
	
	$("td.read>button#replyBtn").click(function(){
	
		let nowPage = $("input#nowPage").val().trim();
		let num = $("input#num").val().trim();
				
		//let p3 = $("#pKeyField").val().trim();  // p3 : keyField
	   //let p4 = $("#pKeyWord").val().trim();  // p4 : keyWord
	
		let param = "/Proj_OnedayClass/reviewBBS/RvReply.jsp?";
			param += "num="+num;
			param += "&nowPage="+nowPage;
			//url += "&keyField="+p3;
	     	//url += "&keyWord="+p4; 
		location.href=url;
	
	});
	
	//////////////// Read.jsp 에서 답변글 버튼 끝 //////////////////
		

	/*/////////////// Delete.jsp 에서 게시글 삭제실행 시작 //////////////////
	
/*	
	$("button#delSbmBtn").click(function(){
		
		let rUid = $("input#rUid").val().trim();
		
		if(rUid == "") {
			$("input#rUid").focus();
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
	});*/
	//////////////// Delete.jsp 에서 게시글 삭제실행 끝 /////////////////*/
	
	
	
	
	//////////////// Update.jsp 에서 게시글 수정 시작 //////////////////
	$("td.update>button#modBtn").click(function(event){
	
		let rTitle = $("#rTitle").val().trim();
			
		//let keyField = $("#keyField").val().trim();
		//let keyWord = $("#keyWord").val().trim();
		
	 if (rTitle == "") {
			alert("제목은 필수입력입니다.");
			$("#rTitle").focus();
		} 	else {
		
			event.preventDefault();    
			let formData = $('#updateFrm').serialize();  	      
		    // disabled the submit button         
		    $("#modBtn").prop("disabled", true);   
			    
		    $.ajax({             
		    	type: "POST",
		        url: "/Proj_OnedayClass/reviewBBS/RvUpdateProc.jsp",        
		        data: formData,            
		        success: function () {
					
					let nowPage = $("input#nowPage").val();
					let rNum = $("input#hiddenrNume").val();
							
					let param = "/Proj_OnedayClass/reviewBBS/RvRead.jsp?nowPage=" + nowPage;
					param += "&rNum="+rNum;
	    			
		        	$.ajax({
					    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
					    type : "GET",            // HTTP method type(GET, POST) 형식이다.
					}).done(function(RvRead){
						$("#tblArea").html(RvRead);
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
		let rNum = $("input#hiddenrNume").val();
				

		let param = "/Proj_OnedayClass/reviewBBS/RvRead.jsp?nowPage=" + nowPage;
		param += "&rNum="+rNum;

    	$.ajax({
		    url : param,      // 컨트롤러에서 대기중인 URL 주소이다.
		    type : "GET",            // HTTP method type(GET, POST) 형식이다.
		}).done(function(RvRead){
			$("#tblArea").html(RvRead);
		}); 
	});
	//////////////// Update.jsp 에서 뒤로가기 버튼 끝 //////////////////
	
	
	
});

