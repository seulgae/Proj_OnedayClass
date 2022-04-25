package pack_Payment;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

import pack_DBCP.DBConnectionMgr;
import pack_ClassBBS.ClassBean;

public class PaymentMgr {

	private DBConnectionMgr pool;

	public PaymentMgr() {
		try {
			pool = DBConnectionMgr.getInstance();
		} catch (Exception e) {
			System.out.println("DB 접속이슈1 : " + e.getMessage());
		}
	}

	////////////////////////////////////////////////////////////////////
	/////////////////////////// 장바구니 시작 /////////////////////////////
	////////////////////////////////////////////////////////////////////

	//////////////////// 장바구니 갯수 확인 시작 ////////////////////////////

	public int cntCart(String uId) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int totalCnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "select count(*) from cartList where uId=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);

			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				totalCnt = objRs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("SQL이슈1 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return totalCnt;
	}

	//////////////////// 장바구니 갯수 확인 끝 ////////////////////////////

	//////////////////// 장바구니 체크 시작 ////////////////////////////

	public boolean checkCart(PaymentBean bean) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;

		String sql = null;
		boolean flag = false;

		try {
			objConn = pool.getConnection();
			sql = "select cNum from cartList where uId=? AND cNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getuId());
			objPstmt.setInt(2, bean.getcNum());

			flag = objPstmt.executeQuery().next();

		} catch (Exception e) {

			System.out.println("SQL 이슈2 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return flag;
	}

	//////////////////// 장바구니 체크 끝 ////////////////////////////

	//////////////////// 장바구니 입력 시작 ////////////////////////////

	public boolean insertCart(PaymentBean bean) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;

		String sql = null;
		boolean flag = false;

		try {
			objConn = pool.getConnection();
			sql = "insert into cartList values (?, ?)";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getuId());
			objPstmt.setInt(2, bean.getcNum());

			int cnt = objPstmt.executeUpdate();

			if (cnt > 0)
				flag = true;

		} catch (Exception e) {

			System.out.println("SQL 이슈3 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return flag;
	}

	//////////////////// 장바구니 입력 끝 ////////////////////////////

	//////////////////// 장바구니 삭제 시작 ////////////////////////////

	public boolean deleteCart(PaymentBean bean) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;

		String sql = null;
		boolean flag = false;

		try {
			objConn = pool.getConnection();
			sql = "delete from cartList where uId = ? AND cNum = ?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getuId());
			objPstmt.setInt(2, bean.getcNum());

			int cnt = objPstmt.executeUpdate();

			if (cnt > 0)
				flag = true;

		} catch (Exception e) {

			System.out.println("SQL 이슈4 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return flag;
	}
	//////////////////// 장바구니 삭제 끝 ////////////////////////////

	/////////////////// 장바구니 리스트 출력 시작 /////////////////////////
	public Vector<ClassBean> getCartList(String uId) {

		Vector<ClassBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "select cartList.cNum, classBBS.cUid, classBBS.cTitle, ";
			sql += "classBBS.cPrice, classBBS.cDelivery, ";
			sql += "classBBS.cMaxStu, classBBS.cApplyStu ";
			sql += "from cartList left join classBBS ";
			sql += "on cartList.cNum = classBBS.cNum ";
			sql += "where uId=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);

			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				ClassBean bean = new ClassBean();
				bean.setcNum(objRs.getInt("cNum"));
				bean.setcTitle(objRs.getString("cTitle"));
				bean.setcUid(objRs.getString("cUid"));
				bean.setcPrice(objRs.getInt("cPrice"));
				bean.setcDelivery(objRs.getInt("cDelivery"));
				bean.setcMaxStu(objRs.getInt("cMaxStu"));
				bean.setcApplyStu(objRs.getInt("cApplyStu"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈5 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;

	}

	/////////////////// 장바구니 리스트 출력 끝 /////////////////////////

	////////////////////////////////////////////////////////////////////
	//////////////////////////// 장바구니 끝 //////////////////////////////
	////////////////////////////////////////////////////////////////////

	////////////////////////////////////////////////////////////////////
	//////////////////////////// 결제 시작 ///////////////////////////
	////////////////////////////////////////////////////////////////////

	//////////////////////// 결제완료 등록 시작 /////////////////////////
	public int insPayList(HttpServletRequest req) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		int execnt = 0;

		try {
			objConn = pool.getConnection();
			sql = "insert into paymentInfo (";
			sql += "uId, rName, rPhone, ";
			sql += "rZip, rAddr1, rAddr2, rEmail,";
			sql += "totalPrice, totalDeli, totalPay, payDate ) values ";
			sql += "(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, now())";

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, req.getParameter("uId"));
			objPstmt.setString(2, req.getParameter("rName"));
			objPstmt.setString(3, req.getParameter("rPhone"));
			objPstmt.setString(4, req.getParameter("rZip"));
			objPstmt.setString(5, req.getParameter("rAddr1"));
			objPstmt.setString(6, req.getParameter("rAddr2"));
			objPstmt.setString(7, req.getParameter("rEmail"));
			objPstmt.setString(8, req.getParameter("totalPriceVal"));
			objPstmt.setString(9, req.getParameter("totalDeliVal"));
			objPstmt.setString(10, req.getParameter("totalPayVal"));
			execnt = objPstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("SQL 이슈6 : " + e.getMessage());
		} catch (Exception e) {
			System.out.println("DB 접속이슈2 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return execnt;
	}

	public int findpNum() { // 등록한 결제번호 찾기
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int pNum = 1;

		try {
			objConn = pool.getConnection();
			sql = "select max(pNum) from paymentInfo";
			objPstmt = objConn.prepareStatement(sql);
			objRs = objPstmt.executeQuery();

			if (objRs.next())
				pNum = objRs.getInt(1);
		} catch (Exception e) {
			System.out.println("SQL 이슈7 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}
		System.out.println(pNum);
		return pNum;
	}

	public int payCompl(PaymentBean bean) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		int execnt = 0;

		try {
			objConn = pool.getConnection();
			sql = "insert into payComplete ";
			sql += "(uId, cNum, cUid, cTitle, pNum, pQty, payDate) ";
			sql += "values (?, ?, ?, ?, ?, ?, now())";

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getuId());
			objPstmt.setInt(2, bean.getcNum());
			objPstmt.setString(3, bean.getcUid());
			objPstmt.setString(4, bean.getcTitle());
			objPstmt.setInt(5, bean.getpNum());
			objPstmt.setInt(6, bean.getpQty());
			execnt = objPstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("SQL 이슈8 : " + e.getMessage());
		} catch (Exception e) {
			System.out.println("DB 접속이슈3 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return execnt;
	}
	//////////////////////// 결제완료 등록 끝 ///////////////////////////

///////////////////////////////////////////////////////////////////
///////////////  결제 리스트 작업관련(List.jsp) 시작  ///////////////
///////////////////////////////////////////////////////////////////

///////////////  결제 리스트 출력(학생) 시작    ///////////////
	public Vector<ClassBean> getStudentPayList(int start, int end, String uId) {

		Vector<ClassBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "select classBBS.cCategory, classBBS.cTitle, classBBS.cPrice, ";
			sql += "classBBS.cDelivery, payComplete.pQty, payComplete.payDate ";
			sql += "from payComplete left join classBBS ";
			sql += "on payComplete.cNum = classBBS.cNum ";
			sql += "where payComplete.uId=? ";
			sql += "order by payComplete.pNum desc limit ?, ?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);
			objPstmt.setInt(2, start);
			objPstmt.setInt(3, end);

			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				ClassBean bean = new ClassBean();
				bean.setcCategory(objRs.getString("cCategory"));
				bean.setcTitle(objRs.getString("cTitle"));
				bean.setcPrice(objRs.getInt("cPrice"));
				bean.setcDelivery(objRs.getInt("cDelivery"));
				bean.setcApplyStu(objRs.getInt("pQty"));
				bean.setcRegDate(objRs.getString("payDate"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈9 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}
///////////////  결제 리스트 출력(학생) 끝    ///////////////

///////////////  결제 리스트 출력(선생) 시작    ///////////////
	public Vector<PaymentBean> getTeacherPayList(int start, int end, String uId) {

		Vector<PaymentBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "select payComplete.cTitle, payComplete.uId, paymentInfo.rEmail, ";
			sql += "payComplete.pQty, payComplete.payDate ";
			sql += "from payComplete left join paymentInfo ";
			sql += "on payComplete.pNum = paymentInfo.pNum ";
			sql += "where payComplete.cUid = ? ";
			sql += "order by payComplete.pNum desc limit ?, ?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);
			objPstmt.setInt(2, start);
			objPstmt.setInt(3, end);

			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				PaymentBean bean = new PaymentBean();
				bean.setcTitle(objRs.getString("cTitle"));
				bean.setuId(objRs.getString("uId"));
				bean.setrEmail(objRs.getString("rEmail"));
				bean.setpQty(objRs.getInt("pQty"));
				bean.setPayDate(objRs.getString("payDate"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈10 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}
///////////////  결제 리스트 출력(List.jsp) 끝    ///////////////

//////////////////총 결제 수(선생) 시작 //////////////////
	public int getTeacherCount(String uId) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int totalCnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "select count(*) ";
			sql += "from payComplete left join classBBS ";
			sql += "on payComplete.cNum = classBBS.cNum ";
			sql += "where classBBS.cUid=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);
			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				totalCnt = objRs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("SQL이슈11 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return totalCnt;
	}
//////////////////총 결제 수(선생) 끝 //////////////////

//////////////////총 결제 수(학생) 시작 //////////////////
	public int getStudentCount(String uId) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int totalCnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "select count(*) ";
			sql += "from payComplete where uid=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);
			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				totalCnt = objRs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("SQL이슈12 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return totalCnt;
	}
//////////////////총 결제 수(학생) 끝 //////////////////

///////////////////////////////////////////////////////////////////
///////////////  결제 리스트 작업관련(List.jsp) 끝  ///////////////
///////////////////////////////////////////////////////////////////
}
