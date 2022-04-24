<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>

<jsp:useBean id="rvBean" class="pack_reviewBBS.RvBoardBean" scope="session" />
<!-- Read.jsp에서 DB 에서 자료를 반환하여 session을 만들 때 세션이름을 "bean"으로,
       세션에 저장되는 값을 DB에서 반환된 자료를 setter로 저장한 BoardBean 객체를
       생성했었음 -->         
       
<jsp:useBean id="upBean" class="pack_reviewBBS.RvBoardBean" scope="page" />
<!--  Update.jsp에서 form 요소의 하위요소에 입력된 값들을 전달받아서
        초기화시키기위해 생성되는 객체 -->
<jsp:setProperty name="upBean"  property="*" />
<!-- 전달되는 form하위요소의 매개변수 name 속성값과 
       BoardBean의 필드가 동일하면 서로 짝을 매치시켜서 필드에 초기화된다. -->             
<%
// 위의 useBean 액션태그는 DB 에 저장된 실제 비번과 사용자가 Update.jsp에서
// 입력한 비번이 일치하는지 여부를 따져보기 위함.

String nowPage = request.getParameter("nowPage");

//String rUid = upBean.getrUid();
String uId = (String)session.getAttribute("idKey");
// 사용자가 Update.jsp에서 입력한 비번

// DB에서 불러온 실제 비번(세션에 저장되어 있었음)
                  
                     
//검색어 수신 시작
String keyField = request.getParameter("keyField");
String keyWord = request.getParameter("keyWord");
//검색어 수신 끝
%>
<jsp:useBean id="bMgr" class="pack_reviewBBS.RvBoardMgr" scope="page" />
<!-- id="bMgr" 유즈빈은 bMgr.updateBoard(upBean) 실행용도
       => 실제 게시글이 DB와 연동하여 수정됨 -->

<%
String newTitle = request.getParameter("rTitle");
String newContent = request.getParameter("rContent");
int newNum = Integer.parseInt(request.getParameter("rNum"));

//BoardBean board = new BoardBean();

upBean.setrTitle(newTitle);
upBean.setrContent(newContent);
upBean.setrNum(newNum);
int result = bMgr.updateBoard(upBean);

if (result > 0) {
	String url = "RvRead.jsp?nowPage="+nowPage;
			 url += "&rNum="+upBean.getrNum();
			 url += "&keyField="+keyField;
			 url += "&keyWord="+keyWord;
	
	//out.print("url : " + url);	 
	//response.sendRedirect(url);   <= 한글 전송 오류 발생
%>		
 <script>
 	location.href="<%=url%>";
 </script>
 <%		
	} else {
%>		
	<script>
		alert("수정 실패");
		history.back();
	</script>

<%
	}
%>