<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<% request.setCharacterEncoding("UTF-8"); %>
<jsp:useBean id="cartBean" class="pack_Payment.PaymentBean" scope="page" />    
<jsp:useBean id="pMgr" class="pack_Payment.PaymentMgr" scope="page" />
<%
String uId = (String)request.getParameter("uId");
int cNum = Integer.parseInt(request.getParameter("cNum"));
int nowPage = Integer.parseInt(request.getParameter("nowPage"));

cartBean.setuId(uId);
cartBean.setcNum(cNum);

String msg = "";

if (pMgr.checkCart(cartBean)) {	// 장바구니에 있을 때,
	if(pMgr.deleteCart(cartBean)) { // 삭제 되었을때
		msg = "장바구니 취소가 되었습니다.";	
	} else {
		msg = "오류가 생겼습니다. 다시 시도해보세요.";
	}
} else { 
	if(pMgr.insertCart(cartBean)) { // 입력 되었을때
		msg = "장바구니에 넣었습니다.";	
		} else {
		msg = "오류가 생겼습니다. 다시 시도해보세요.";
	}
}
int cartCnt = pMgr.cntCart(uId);
session.setAttribute("cartCntKey", cartCnt);
%>
<script>
	alert("<%=msg%>"); 
	
	location.href="/Proj_OnedayClass/classBBS/ClassRead.jsp?cNum=<%=cNum%>&nowPage=<%=nowPage%>"
</script>