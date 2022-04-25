package pack_Member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Vector;

import pack_DBCP.DBConnectionMgr;

public class MemberMgr {

	private DBConnectionMgr pool;

	public MemberMgr() {
		try {
			pool = DBConnectionMgr.getInstance();
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

///////////////////////////////////////////////////////////////////	
/////////////   Member.jsp ID  중복확인 시작 /////////////////////
///////////////////////////////////////////////////////////////////

	public boolean checkId(String uId) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;

		String sql = null;
		boolean flag = false;

		try {
			objConn = pool.getConnection();
			sql = "select uId from memberlist where uId=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);

			flag = objPstmt.executeQuery().next();

		} catch (Exception e) {

			System.out.println("SQL 이슈1 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return flag;
	}
///////////////////////////////////////////////////////////////////	
/////////////   Member.jsp ID  중복확인 끝 /////////////////////
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////	
///////////// MemberProc.jsp 회원가입 시작 //////////////////////
///////////////////////////////////////////////////////////////////
	public boolean insertMember(MemberBean bean) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		boolean flag = false;

		try {
			objConn = pool.getConnection();
			sql = "insert into memberlist ";
			sql += "(uId, uPw, uName, uPhone, ";
			sql += "uZip, uAddr1, uAddr2, uEmail, uLevel, sName, sSns)";
			sql += "values ";
			sql += "(?, ?, ?, ?, ?, ?, ?, ?, 1, null, null)";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getuId());
			objPstmt.setString(2, bean.getuPw());
			objPstmt.setString(3, bean.getuName());
			objPstmt.setString(4, bean.getuPhone());
			objPstmt.setString(5, bean.getuZip());
			objPstmt.setString(6, bean.getuAddr1());
			objPstmt.setString(7, bean.getuAddr2());
			objPstmt.setString(8, bean.getuEmail());

			int cnt = objPstmt.executeUpdate();
			if (cnt > 0)
				flag = true;

		} catch (Exception e) {

			System.out.println("SQL 이슈2 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return flag;
	}

///////////////////////////////////////////////////////////////////	
///////////// MemberProc.jsp 회원가입 끝 //////////////////////
///////////////////////////////////////////////////////////////////

///////////// 로그인 사용자 이름 반환(Login.jsp) 시작 //////////////////////	

	public String[] getMemberStat(String uId) {

		String[] uStat = new String[2];

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;

		String sql = null;

		try {
			objConn = pool.getConnection();
			sql = "select uName, uLevel from memberlist where uId=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);

			objRs = objPstmt.executeQuery();
			if (objRs.next()) {
				uStat[0] = objRs.getNString(1);
				uStat[1] = objRs.getNString(2);
			}

		} catch (Exception e) {

			System.out.println("SQL 이슈 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return uStat;
	}

/////////// 로그인 사용자 이름 반환(Login.jsp) 끝 //////////////////////	

///////////////////////////////////////////////////////////////////	
///////////// LoginProc.jsp 로그인 시작 //////////////////////
///////////////////////////////////////////////////////////////////

	public boolean loginMember(String uId, String uPw) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;

		String sql = null;
		boolean flag = false;

		try {
			objConn = pool.getConnection();
			sql = "select uId from memberlist where uId=? and uPw=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);
			objPstmt.setString(2, uPw);

			flag = objPstmt.executeQuery().next();

		} catch (Exception e) {

			System.out.println("SQL 이슈4 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return flag;
	}
///////////////////////////////////////////////////////////////////	
///////////// LoginProc.jsp 로그인 끝 //////////////////////
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////	
/////// Member_Mod.jsp 회원정보 수정 입력폼 시작 /////////////
///////////////////////////////////////////////////////////////////

	public Vector modifyMember(String uId) {

		Vector<MemberBean> vList = new Vector<>();

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;

		String sql = null;

		try {
			objConn = pool.getConnection();
			sql = "select * from memberlist where uId=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);

			objRs = objPstmt.executeQuery();

			if (objRs != null) {
				while (objRs.next()) {

					MemberBean memBean = new MemberBean();

					memBean.setuId(objRs.getString("uId"));
					memBean.setuPw(objRs.getString("uPw"));
					memBean.setuName(objRs.getString("uName"));
					memBean.setuPhone(objRs.getString("uPhone"));
					memBean.setuZip(objRs.getString("uZip"));
					memBean.setuAddr1(objRs.getString("uAddr1"));
					memBean.setuAddr2(objRs.getString("uAddr2"));
					memBean.setuEmail(objRs.getString("uEmail"));

					vList.add(memBean);

				}
			}

		} catch (Exception e) {

			System.out.println("SQL 이슈5 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}

///////////////////////////////////////////////////////////////////	
/////// Member_Mod.jsp 회원정보 수정 입력폼 끝 /////////////
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////	
/////// Member_ModProc.jsp 회원정보 수정 시작 /////////////
///////////////////////////////////////////////////////////////////	
	public boolean modifyMember(String uPw, String uPhone, String uZip, String uAddr1, String uAddr2, String uEmail,
			String uId) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		boolean flag = false;

		try {
			objConn = pool.getConnection();

			sql = "update memberlist set ";
			sql += "uPw=?, uPhone=?, uZip=?, ";
			sql += "uAddr1=?, uAddr2=?, uEmail=? ";
			sql += "where uId = ?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uPw);
			objPstmt.setString(2, uPhone);
			objPstmt.setString(3, uZip);
			objPstmt.setString(4, uAddr1);
			objPstmt.setString(5, uAddr2);
			objPstmt.setString(6, uEmail);
			objPstmt.setString(7, uId);

			int cnt = objPstmt.executeUpdate();
			if (cnt > 0)
				flag = true; // update가 정상실행되었음을 의미

		} catch (Exception e) {

			System.out.println("SQL 이슈6 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return flag;
	}

///////////////////////////////////////////////////////////////////	
/////// Member_ModProc.jsp 회원정보 수정 끝 /////////////
///////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////	
////////////// Member_Del.jsp 회원탈퇴 시작 ////////////////////
///////////////////////////////////////////////////////////////////	
	public boolean deleteMember(String uId) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		boolean flag = false;

		try {
			objConn = pool.getConnection();

			sql = "delete from memberlist where uId = ?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, uId);

			int cnt = objPstmt.executeUpdate();
			if (cnt > 0)
				flag = true; // update가 정상실행되었음을 의미

		} catch (Exception e) {

			System.out.println("SQL 이슈7 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return flag;
	}
///////////////////////////////////////////////////////////////////	
//////////////Member_Del.jsp 회원탈퇴 끝 ////////////////////
///////////////////////////////////////////////////////////////////

} // End of Class
