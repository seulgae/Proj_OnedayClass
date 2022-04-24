<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ page import="pack_reviewBBS.RvBoardBean, java.util.Vector" %>
<jsp:useBean id="bMgr" class="pack_reviewBBS.RvBoardMgr"  scope="page" />
<%
request.setCharacterEncoding("UTF-8");
String uId = (String)session.getAttribute("idKey");
String uName = (String)session.getAttribute("nameKey");
String uLevel = (String)session.getAttribute("levelKey");

///////////////////////페이징 관련 속성 값 시작///////////////////////////
// 페이징(Paging) = 페이지 나누기를 의미함
int totalRecord = 0;        // 전체 데이터 수(DB에 저장된 row 개수)
int numPerPage = 10;    // 페이지당 출력하는 데이터 수(=게시글 숫자)
int pagePerBlock = 5;   // 블럭당 표시되는 페이지 수의 개수
int totalPage = 0;           // 전체 페이지 수
int totalBlock = 0;          // 전체 블록수

 /*
totalRecord=> 200     전체레코드
numPerPage => 10
pagePerBlock => 5 
totalPage => 20
totalBlock => 4  (20/5 => 4)
*/

int nowPage = 1;          // 현재 (사용자가 보고 있는) 페이지 번호
int nowBlock = 1;         // 현재 (사용자가 보고 있는) 블럭

int start = 0;     // DB에서 데이터를 불러올 때 시작하는 인덱스 번호
int end = 10;     // 시작하는 인덱스 번호부터 반환하는(=출력하는) 데이터 개수 
                          // select * from T/N where... order by ... limit start, end;

int listSize = 0;    // 1페이지에서 보여주는 데이터 수
						//출력할 데이터의 개수 = 데이터 1개는 가로줄 1개

// 게시판 검색 관련소스
String keyField = ""; // DB의 컬럼명
String keyWord = ""; // DB의 검색어
						
if (request.getParameter("keyWord") != null) {
	keyField = request.getParameter("keyField");
	keyWord = request.getParameter("keyWord");
}


						
if (request.getParameter("nowPage") != null) {
	nowPage = Integer.parseInt(request.getParameter("nowPage"));
	start = (nowPage * numPerPage) - numPerPage;
	end = numPerPage;            
}



/*
 select * from tblBoard order by num desc limit 10, 10;
데이터가 100개   =>   num :  100  99   98    97 ... 91 |  90        1
                       start, end :   0    1    2     3....   9      10
페이지당 출력할 데이터 수 10개
현재 페이지 1페이지라면    => 1페이지의 출력결과   100 ~ 91
2페이지   90~81
3페이지    80~71
*/

totalRecord = bMgr.getTotalCount();
// 전체 데이터 수 반환

totalPage = (int)Math.ceil((double)totalRecord/numPerPage);
nowBlock = (int)Math.ceil((double)nowPage/pagePerBlock);
totalBlock = (int)Math.ceil((double)totalPage/pagePerBlock);

///////////////////////페이징 관련 속성 값 끝///////////////////////////

Vector<RvBoardBean> vList = null;


%>    
    
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
	<title>OneDayClass</title>
    <link rel="stylesheet" href="/Proj_OnedayClass/style/reviewBBS.css">
</head>
<body>

	 <% if (uId == null) {      %>
	 <script>
       	alert("로그인 후 사용 가능합니다."); 
		location.href="/Proj_OnedayClass/sign/Login.jsp"; 	
	</script>
	
       <% } else { // 현재 로그인 상태라면 %> 
	<div id="wrap">
	
	<%@include file="../include/AdHeader.jsp"%>
		
		<main id="main" class="list">   
		
		<h1>Review 게시판</h1>
			<%
				String prnType = "";
				if (keyWord.equals("null") || keyWord.equals("")) {
					prnType = "전체 게시글";
				} else {
					prnType = "검색 결과";
				}
			%>
			
									
			<table id="boardList">
				<thead>
					<tr height="50">
						<th>번호</th>						
						<th> </th>
						<th>제목</th>
						<th>작성자</th>
						<th>날짜</th>
						<th>조회수</th>
						<th>추천수</th>
					</tr>		
					<tr>
						<td colspan="7" class="spaceTd"></td>
					</tr>		
				</thead>
				<tbody>
			
	
			
			<%
			vList = bMgr.getBoardList(start, end, uId);  // DB에서 데이터 불러오기
			listSize = vList.size();			
			
				if (vList.isEmpty()) {
					// 데이터가 없을 경우 출력 시작
				%> 
					<tr>
						<td colspan="6">
						<%="게시물이 없습니다." %>
						</td>
					</tr>				
				<%
					// 데이터가 없을 경우 출력 끝
				} else {
					// 데이터가 있을 경우 출력 시작
				%>
					
							
				<%
					for (int i=0; i<numPerPage; i++) {		
						
						if(i==listSize) break;
						
						RvBoardBean bean = vList.get(i);
						
						String rUid = bean.getrUid();
						String rTitle = bean.getrTitle();
						int rNum = bean.getrNum();
						String rRegDate = bean.getrRegDate();
						String rFileName = bean.getrFileName();
						int rCnt = bean.getrCnt();
						int rLikes = bean.getrLikes();
						int rStatus = bean.getrStatus();
				%>
					<tr height="60" class="prnTr" onclick="read('<%=rNum%>', '<%=nowPage%>')">
					<%
					//int prnNum = totalRecord - ((nowPage-1) * numPerPage) - i; 
					// num와 prnNum는 전혀 관계없음
					%>
						
						<td><%=rNum %></td>
						<%
						if(rFileName==null){
							%>
							<td></td>
							<%
						}else
						{
							%>
							<td><img src="/Proj_OnedayClass/fileUpload/reviewbbs/<%=rFileName %>" width="75" height="50"/></td>
						<%} %>
						<td><%=rTitle %></td>						
						<td><%=rUid %></td>
						<td><%=rRegDate %></td>
						<td><%=rCnt %></td>
						<td><%=rLikes %></td>
					</tr>
				<%
					}	// end for
						// 데이터가 있을 경우 출력 끝
				}   // end if  	
				%>
					
					<tr>
					<!-- 페이징 시작 -->
						<td colspan="2" id="pagingTd" >
				<%
				int pageStart = (nowBlock - 1 ) * pagePerBlock + 1;
							// 26개 자료기준
							// 현재 기준 numPerPage : 5;    // 페이지당 출력 데이터 수
							//            pagePerBlock : 5;  //  블럭당 페이지 수
							//            nowBlock : 현재블럭
							//            totalBlock : 전체블럭
							//  -------------------------------------------------
							//            totalRecord : 26    totalPage : 6
							// 적용결과  nowBlock : 1  =>   pageStart : 1   pageEnd : 5
							//            nowBlock : 2  =>   pageStart : 6   pageEnd : 6( = totalPage)
							//
				int pageEnd = (nowBlock < totalBlock) ? 
												pageStart + pagePerBlock - 1 :  totalPage;
				                                        
				// 블럭당 5페이지 출력 =>        pageStart    pageEnd
				//                          1블럭        1                 5
				//                          2블럭        6                 10    		
				// 블럭마다 시작되는 첫 페이지와 마지막 페이지 관련 작업				
				if (totalPage != 0) {   //   전체 페이지가 0이 아니라면 = 게시글이 1개라도 있다면
					// #if01_totalPage   
				%>
					
					<% if (nowBlock>1) { 	   // 페이지 블럭이 2이상이면 => 2개이상의 블럭이 있어야 가능 %>
								<span class="moveBlockArea" onclick="moveBlock('<%=nowBlock-1%>', '<%=pagePerBlock%>')">
								&lt;
								</span>
					<% } else { %>
					            <span class="moveBlockArea" ></span>
					<% } %>
				
					<!-- 페이지 나누기용 페이지 번호 출력 시작  -->
					<% 
					/*
					out.print("totalRecord : " + totalRecord + "<br>");
					out.print("pagePerBlock : " + pagePerBlock + "<br>");
					out.print("numPerPage : " + numPerPage + "<br>");
					out.print("totalPage : " + totalPage + "<br>");
					out.print("pageStart : " + pageStart + "<br>");
					out.print("pageEnd : " + pageEnd + "<br>");
					out.print("nowPage : " + nowPage + "<br>");
					out.print("nowBlock : " + nowBlock + "<br>");
					out.print("totalBlock : " + totalBlock + "<br>");
					*/
					
					             // 2        <     6                     
						for (   ; pageStart<=pageEnd; pageStart++) { %>
							<% if (pageStart == nowPage) {   // 현재 사용자가 보고 있는 페이지 %>
								<span class="nowPageNum"><%=pageStart %></span>
							<% } else {                              // 현재 사용자가 보고 있지 않은 페이지 %>
							 	<span class="pageNum" onclick="movePage('<%=pageStart %>')">
									<%=pageStart %>
							 	</span>					
							<% } // End If%>		 	
					<% }  // End For%>
					<!-- 페이지 나누기용 페이지 번호 출력 끝  -->	
					
				
				<% if (totalBlock>nowBlock) { // 다음 블럭이 남아 있다면  %>
							<span  class="moveBlockArea" onclick="moveBlock('<%=nowBlock+1%>', '<%=pagePerBlock%>')">
							&gt;
							</span>
			
				<% } else { %>
				            <span class="moveBlockArea"></span>
				<% } %>
				
					
					
				<%
				}  // End if#01_totalPage
				%>						
						
						
						
						</td>
						
					<%-- 	 <td colspan="3">
						
					 	<form name="searchFrm" class="flex-container"
									id="searchFrm">
							
								<div>
									<select name="keyField" id="keyField">
										<option value="rTitle" 
												<% if(keyField.equals("rTitle")) out.print("selected"); %>>제  목</option>
										<option value="uName" 
												<% if(keyField.equals("rUid")) out.print("selected"); %>>작성자</option>
										<option value="qna_content" 
												<% if(keyField.equals("rContent")) out.print("selected"); %>>내  용</option>
									</select>
								</div>
								<div>
									<input type="text" name="keyWord" id="keyWord"
									  id="keyWord" size="20" maxlength="30" value="<%=keyWord%>">
								</div>
								<div>
									<button type="button" id="searchBtn">검색</button>
								</div>
															
							</form>
							
							<!-- 검색결과 유지용 매개변수 데이터시작 -->
							<input type="hidden" id="pKeyField" value="<%=keyField%>">
							<input type="hidden" id="pKeyWord" value="<%=keyWord%>">
							<!-- 검색결과 유지용 매개변수 데이터끝 -->
						
						</td> 
						--%>
					</tr>
					
					
				</tbody>
			</table>
		
		
		
		</main>  

  	 <%@include file="../include/Footer.jsp"%>	
	</div>       	
	
	<% } %>

	<!-- div#wrap -->
	
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
	<script src="/Proj_OnedayClass/script/adRvBBS.js"></script>      
</body>
</html>