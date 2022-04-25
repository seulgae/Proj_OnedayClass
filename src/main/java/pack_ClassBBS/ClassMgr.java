package pack_ClassBBS;

import java.io.BufferedInputStream;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import pack_DBCP.DBConnectionMgr;
import pack_Util.UtilMgr;

public class ClassMgr {

	private DBConnectionMgr pool;

	private static String encType = "UTF-8";
	private static int maxSize = 10 * 1024 * 1024;
	// 파일크기 : 10MB

	public ClassMgr() {
		try {
			pool = DBConnectionMgr.getInstance();
		} catch (Exception e) {
			// 로고 창에서 나타남.
			System.out.println("DB 접속이슈 : " + e.getMessage());
		}
	}

////////////////게시판 입력(ClassPostProc.jsp) 시작  ///////////////////////
	public void insertBoard(HttpServletRequest req) { // HttpServletRequest -> req라는 자료형
		// 지역변수 선언
		Connection objConn = null;
		PreparedStatement objPstmt = null;

		String sql = null;
		// SQL문

		MultipartRequest multi = null;

		// 썸네일 : 갤러리 리스트에 출력
		int cThumbSize = 0;
		String cThumbName = null;

		// 상세정보 : 상세정보 페이지에 출력
		int cFileSize = 0;
		String cFileName = null;
		String path = req.getServletContext().getRealPath("/src/main/webapp/fileUpload/classfileupload/");
		path = UtilMgr.replace(path, ".metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\", "");

		String cCode = UUID.randomUUID().toString();

		try {
			objConn = pool.getConnection();

			// 오브젝트 생성
			File file = new File(path);

			// classfileupload 폴더에 파일이 없다면 생성하라.
			if (!file.exists())
				file.mkdirs();

			multi = new MultipartRequest(req, path, // 저장소
					maxSize, // 파일크기
					encType, new DefaultFileRenamePolicy());

			if (multi.getFilesystemName("cThumbName") != null) {

				cThumbName = multi.getFilesystemName("cThumbName");

				cThumbSize = (int) multi.getFile("cThumbName").length();
			}

			if (multi.getFilesystemName("cFileName") != null) {
				// 이름
				cFileName = multi.getFilesystemName("cFileName");
				// 용량
				cFileSize = (int) multi.getFile("cFileName").length();
			}

			// 클래스 cContent 부분
			String cContent = multi.getParameter("cContent");

			if (multi.getParameter("contentType").equalsIgnoreCase("TEXT")) {
				// equalsIgnoreCase -> 대소문자 무시함.
				cContent = UtilMgr.replace(cContent, "<", "&lt;");
				// <내용이 들어오면, lt로 바꿔줌 (HTML 형식으로 사용불가능하도록 만들어줌)
			}

			// 다중업로드
			sql = "insert into classbbs(";
			sql += "cCode, cTeacher, cUid, cCategory, cTitle, cContent, cRegDate, cPrice, cDelivery, ";
			sql += "cThumbName, cThumbSize, cFileName, cFileSize, ";
			sql += "cMaxStu, cApplyStu, cOnoff, cArea, cStatus, cLikes) values (";
			sql += " ?, ?, ?, ?, ?, ?, now(), ?, ?, ";
			sql += "?, ?, ?, ?, ";
			sql += "?, 0, ?, ?, 1, 0)";

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, cCode);
			objPstmt.setString(2, multi.getParameter("cTeacher")); 
			objPstmt.setString(3, multi.getParameter("cUid")); 
			objPstmt.setString(4, multi.getParameter("cCategory")); 
			objPstmt.setString(5, multi.getParameter("cTitle"));
			objPstmt.setString(6, cContent);
			objPstmt.setInt(7, Integer.parseInt(multi.getParameter("cPrice")));
			objPstmt.setInt(8, Integer.parseInt(multi.getParameter("cDelivery")));
			objPstmt.setString(9, cThumbName);
			objPstmt.setInt(10, cThumbSize);
			objPstmt.setString(11, cFileName);
			objPstmt.setInt(12, cFileSize);
			objPstmt.setInt(13, Integer.parseInt(multi.getParameter("cMaxStu")));
			objPstmt.setString(14, multi.getParameter("cOnoff"));
			objPstmt.setString(15, multi.getParameter("cArea"));

			objPstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("SQL 이슈 : " + e.getMessage());
		} catch (Exception e) {
			System.out.println("DB 접속이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

	}
////////////////게시판 입력(ClassPostProc.jsp) 끝  ///////////////////////
	
///////////////////////////////////////////////////////////////	
///////////////  On&off Class.jsp 추천리스트 ///////////////
//////////////////////////////////////////////////////////////
	public Vector<ClassBean> getBoardLike(String cCategorySel, String onoff, int start, int end) {

		Vector<ClassBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동

			if (cCategorySel.equals("null") || cCategorySel.equals("")) {
				// 카테고리 메뉴 선택 안했을시, desc 정렬
				sql = "select * from classbbs where cStatus<3 AND cOnoff = ? order by cLikes desc limit ?, ?";
				objPstmt = objConn.prepareStatement(sql);
				objPstmt.setString(1, onoff);
				objPstmt.setInt(2, start);
				objPstmt.setInt(3, end);
			} else {
				// 카테고리 메뉴 클릭 시
				sql = "select * from classbbs where cCategory =? AND cStatus<3 AND cOnoff = ? "
						+ "order by cLikes desc limit ?, ?";
				objPstmt = objConn.prepareStatement(sql);
				objPstmt.setString(1, cCategorySel);
				objPstmt.setString(2, onoff);
				objPstmt.setInt(3, start);
				objPstmt.setInt(4, end);
			}
			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				ClassBean bean = new ClassBean();
				bean.setcNum(objRs.getInt("cNum"));
				bean.setcUid(objRs.getString("cUid"));
				bean.setcTeacher(objRs.getString("cTeacher"));
				bean.setcThumbName(objRs.getString("cThumbName"));
				bean.setcCategory(objRs.getString("cCategory"));
				bean.setcTitle(objRs.getString("cTitle"));
				bean.setcRegDate(objRs.getString("cRegDate"));
				bean.setcStatus(objRs.getInt("cStatus"));
				bean.setcOnoff(objRs.getString("cOnoff"));
				bean.setcLikes(objRs.getInt("cLikes"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈3 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}
//////////////////////////////////////////////////////////////////
///////////////  On&off Class.jsp 추천리스트  끝///////////////
////////////////////////////////////////////////////////////////
	
	
/////////////////////////////////////////////////////////////
///////////////  ClassOnList.jsp 일반 시작///////////////
////////////////////////////////////////////////////////////
	public Vector<ClassBean> getBoardList(String cCategorySel, String onoff, int start, int end) {

		Vector<ClassBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동

			if (cCategorySel.equals("null") || cCategorySel.equals("")) {
				// 카테고리 메뉴 선택 안했을시
				sql = "select * from classbbs where cStatus<3 AND cOnoff = ? order by cNum asc limit ?, ?";
				objPstmt = objConn.prepareStatement(sql);
				objPstmt.setString(1, onoff);
				objPstmt.setInt(2, start);
				objPstmt.setInt(3, end);
			} else {
				// 카테고리 메뉴 클릭 시
				sql = "select * from classbbs where cCategory = ? AND cStatus<3 AND cOnoff = ? order by cNum asc limit ?, ?";
				objPstmt = objConn.prepareStatement(sql);
				objPstmt.setString(1, cCategorySel);
				objPstmt.setString(2, onoff);
				objPstmt.setInt(3, start);
				objPstmt.setInt(4, end);
			}
			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				ClassBean bean = new ClassBean();
				bean.setcNum(objRs.getInt("cNum"));
				bean.setcUid(objRs.getString("cUid"));
				bean.setcTeacher(objRs.getString("cTeacher"));
				bean.setcThumbName(objRs.getString("cThumbName"));
				bean.setcCategory(objRs.getString("cCategory"));
				bean.setcTitle(objRs.getString("cTitle"));
				bean.setcRegDate(objRs.getString("cRegDate"));
				bean.setcStatus(objRs.getInt("cStatus"));
				bean.setcOnoff(objRs.getString("cOnoff"));
				bean.setcLikes(objRs.getInt("cLikes"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈3 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}
	
//////////////////////////////////////////////////////////
///////////////  On&off Class.jsp 일반 끝//////////////
/////////////////////////////////////////////////////////
	
////////////////////////////////////////////////////////////////////////////
///////////////  게시판 리스트 출력(ClassList.jsp) Admin  ///////////////	
//////////////////////////////////////////////////////////////////////////
	public Vector<ClassBean> getBoardadmin(int start, int end) {

		Vector<ClassBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "select * from classbbs order by cNum asc limit ?, ?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, start);
			objPstmt.setInt(2, end);

			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				ClassBean bean = new ClassBean();
				bean.setcNum(objRs.getInt("cNum"));
				bean.setcUid(objRs.getString("cUid"));
				bean.setcTeacher(objRs.getString("cTeacher"));
				bean.setcThumbName(objRs.getString("cThumbName"));
				bean.setcCategory(objRs.getString("cCategory"));
				bean.setcTitle(objRs.getString("cTitle"));
				bean.setcRegDate(objRs.getString("cRegDate"));
				bean.setcStatus(objRs.getInt("cStatus"));
				bean.setcOnoff(objRs.getString("cOnoff"));
				bean.setcLikes(objRs.getInt("cLikes"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈3 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}
/////////////////////////////////////////////////////////////////////////
///////////////  게시판 리스트 출력(ClassList.jsp) 일반   //////////////
///////////////////////////////////////////////////////////////////////

///////////////  게시판 리스트 출력(ClassList.jsp) Teacher  ///////////////	
	public Vector<ClassBean> getBoardTeacher(int start, int end) {

		Vector<ClassBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "select * from classbbs where cStatus < 3 order by cNum asc limit ?, ?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, start);
			objPstmt.setInt(2, end);

			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				ClassBean bean = new ClassBean();
				bean.setcNum(objRs.getInt("cNum"));
				bean.setcUid(objRs.getString("cUid"));
				bean.setcTeacher(objRs.getString("cTeacher"));
				bean.setcThumbName(objRs.getString("cThumbName"));
				bean.setcCategory(objRs.getString("cCategory"));
				bean.setcTitle(objRs.getString("cTitle"));
				bean.setcRegDate(objRs.getString("cRegDate"));
				bean.setcStatus(objRs.getInt("cStatus"));
				bean.setcOnoff(objRs.getString("cOnoff"));
				bean.setcLikes(objRs.getInt("cLikes"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈3 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}

///////////////  게시판 리스트 출력(ClassList.jsp) 일반   /////////////

//////////////////총 게시물 수(List.jsp) 시작 //////////////////
	public int getTotalCount(String cCategorySel) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int totalCnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			if (cCategorySel.equals("null") || cCategorySel.equals("")) {
				sql = "select count(*) from classBbs where cStatus<3";
				objPstmt = objConn.prepareStatement(sql);
			} else {
				sql = "select count(*) from classBbs ";
				sql += "where cCategory = ? AND cStatus<3";
				objPstmt = objConn.prepareStatement(sql);
				objPstmt.setString(1, cCategorySel);
			}

			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				totalCnt = objRs.getInt(1);
			}

		} catch (Exception e) {
			System.out.println("SQL이슈4 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return totalCnt;
	}
//////////////////총 게시물 수(List.jsp) 끝 //////////////////

////////게시판 뷰페이지 출력(ClassRead.jsp, 내용보기 페이지) 시작 ////////

	public ClassBean getBoard(int cNum) {
		// 뷰페이지 게시글 데이터 반환 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		ClassBean bean = new ClassBean();

		try {
			objConn = pool.getConnection(); // DB연동
			sql = "select * from classbbs where cNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, cNum);
			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				bean.setcNum(objRs.getInt("cNum"));
				bean.setcCategory(objRs.getString("cCategory"));
				bean.setcTeacher(objRs.getString("cTeacher"));
				bean.setcUid(objRs.getString("cUid"));
				bean.setcTitle(objRs.getString("cTitle"));
				bean.setcContent(objRs.getString("cContent"));
				bean.setcRegDate(objRs.getString("cRegDate"));
				bean.setcPrice(objRs.getInt("cPrice"));
				bean.setcDelivery(objRs.getInt("cDelivery"));
				bean.setcApplyStu(objRs.getInt("cApplyStu"));
				bean.setcMaxStu(objRs.getInt("cMaxStu"));
				bean.setcThumbName(objRs.getString("cThumbName"));
				bean.setcThumbSize(objRs.getInt("cThumbSize"));
				bean.setcFileName(objRs.getString("cFileName"));
				bean.setcArea(objRs.getString("cArea"));
				bean.setcOnoff(objRs.getString("cOnoff"));
				bean.setcStatus(objRs.getInt("cStatus"));
				bean.setcLikes(objRs.getInt("cLikes"));

			}

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return bean;
	}

////////게시판 뷰페이지 출력(ClassRead.jsp, 내용보기 페이지) 끝 ////////

//////////////////게시글 승인(관리자전용)//////////////////
	public int approvalBoard(int cNum) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		int exeCnt = 0; // 삭제 데이터 수, DB 삭제가 실행되었는지 여부 판단

		try {
			objConn = pool.getConnection(); // DB연동
			// sql = "delete from classbbs where cnum=?";
			sql = "update classbbs set cStatus=2 where cNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, cNum);
			exeCnt = objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return exeCnt;
	}

//////////////////게시글 승인(관리자전용)//////////////////

//////////////////게시글 삭제(ClassDelete.jsp) 시작 //////////////////
	public int deleteBoard(int cNum) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		int exeCnt = 0; // 삭제 데이터 수, DB 삭제가 실행되었는지 여부 판단

		try {
			objConn = pool.getConnection(); // DB연동
			sql = "update classbbs set cStatus=3 where cNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, cNum);
			exeCnt = objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return exeCnt;
	}

////////////////게시글 삭제(ClassDelete.jsp) 끝 //////////////////

////////게시글 수정페이지 (ClassUpdateProc.jsp) 시작 ////////

	public int updateBoard(ClassBean bean) {
// 조회수 증가 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		int exeCnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동
			sql = "update classbbs set cTeacher=?, cCategory=?, cTitle=?, cContent=?, cPrice=?, cDelivery=?, cMaxStu=?, cOnoff=?, cArea=? where cNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getcTeacher());
			objPstmt.setString(2, bean.getcCategory());
			objPstmt.setString(3, bean.getcTitle());
			objPstmt.setString(4, bean.getcContent());
			objPstmt.setInt(5, bean.getcPrice());
			objPstmt.setInt(6, bean.getcDelivery());
			objPstmt.setInt(7, bean.getcMaxStu());
			objPstmt.setString(8, bean.getcOnoff());
			objPstmt.setString(9, bean.getcArea());
			objPstmt.setInt(10, bean.getcNum());
			

			exeCnt = objPstmt.executeUpdate();

			// exeCnt : DB에서 실제 적용된 데이터(=row, 로우)의 개수 저장됨
		} catch (Exception e) {
			System.out.println("SQL이슈7 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return exeCnt;
	}

//////게시글 수정페이지 (ClassUpdateProc.jsp) 끝 ////////

///////////// 좋아요 시작? RvLikeAction.jsp //////////////	
	public int UpdateLike(ClassLikeBean classLikeBean) {
		int result = 0;

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동
			sql = "insert into classLikes (uId, cNum) values(?,?)";
			objPstmt = objConn.prepareStatement(sql);
			// objPstmt.setString(1, bean.getrUid());
			objPstmt.setString(1, classLikeBean.getuId());
			objPstmt.setInt(2, classLikeBean.getcNum());
			result = objPstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return result;
	}

	public int InsertLikeCnt(int cNum) {
		int result = 0;

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동
			sql = "update classbbs set cLikes=cLikes+1 where cNum=?;";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, cNum);

			result = objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return result;
	}
}

///////////// 좋아요 끝? RvLikeAction.jsp //////////////	
