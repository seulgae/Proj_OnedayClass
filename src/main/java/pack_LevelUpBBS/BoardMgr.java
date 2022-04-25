package pack_LevelUpBBS;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.JspWriter;
import javax.servlet.jsp.PageContext;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import pack_DBCP.DBConnectionMgr;
import pack_Util.UtilMgr;

public class BoardMgr {

	private DBConnectionMgr pool;

	private static String encType = "UTF-8";
	private static int maxSize = 5 * 1024 * 1024;

	public BoardMgr() {
		try {
			pool = DBConnectionMgr.getInstance();
		} catch (Exception e) {
			System.out.println("DB 접속이슈1 : " + e.getMessage());
		}

	}

///////////////  게시판 입력(PostProc.jsp) 시작  ///////////////
	public void insertBoard(HttpServletRequest req) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		MultipartRequest multi = null;
		int lvlFileSize = 0;
		String lvlFileName = null;
		String path = req.getServletContext().getRealPath("/src/main/webapp/fileUpload/levelUpBBS/");
		path = UtilMgr.replace(path, ".metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\", "");
		System.out.println(path);
		try {
			objConn = pool.getConnection();
			sql = "select max(lvlNum) from levelUpBBS";
			objPstmt = objConn.prepareStatement(sql);
			objRs = objPstmt.executeQuery();

			int lvlRef = 1; // 답변글 작성용, 원본글의 글번호(num)와 일치
			if (objRs.next())
				lvlRef = objRs.getInt(1) + 1;
			// 현재 DB qna_board에 데이터가 3개(num 컬럼에 1, 2, 3)가
			// 있다고 가정하면 max(num)는 3을 반환함. 그러므로 새 글번호를
			// 참조하는 DB의 컬럼 ref는 4가 됨.

			File file = new File(path);

			if (!file.exists())
				file.mkdirs();

			multi = new MultipartRequest(req, path, maxSize, encType, new DefaultFileRenamePolicy());

			if (multi.getFilesystemName("lvlFileName") != null) {
				lvlFileName = multi.getFilesystemName("lvlFileName");
				lvlFileSize = (int) multi.getFile("lvlFileName").length();
			}
			String lvlContent = multi.getParameter("lvlContent");

			if (multi.getParameter("contentType").equalsIgnoreCase("TEXT")) {
				lvlContent = UtilMgr.replace(lvlContent, "<", "&lt;");
			}

			sql = "insert into levelUpBBS(";
			sql += "lvlUid, lvlTitle, lvlContent, lvlName, lvlSns, lvlRegDate, lvlPos, ";
			sql += "lvlRef, lvlDepth, lvlFileName, lvlFileSize, lvlStatus) values (";
			sql += "?, ?, ?, ?, ?, now(), 0, ?, 0, ?, ?, 1)";

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, multi.getParameter("lvlUid"));
			objPstmt.setString(2, multi.getParameter("lvlTitle"));
			objPstmt.setString(3, lvlContent);
			objPstmt.setString(4, multi.getParameter("lvlName"));
			objPstmt.setString(5, multi.getParameter("lvlSns"));
			objPstmt.setInt(6, lvlRef);
			objPstmt.setString(7, lvlFileName);
			objPstmt.setInt(8, lvlFileSize);
			objPstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("SQL 이슈2 : " + e.getMessage());
		} catch (Exception e) {
			System.out.println("DB 접속이슈2 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

	}
///////////////  게시판 입력(PostProc.jsp) 끝    ///////////////

///////////// levelUpPost cStatus 변환 시작 //////////////////////	

	public String getlevelUpStat(int lvlNum) {

		String lvlStat = "";

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;

		String sql = null;

		try {
			objConn = pool.getConnection();
			sql = "select lvlStatus from levelupbbs where lvlNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, lvlNum);

			objRs = objPstmt.executeQuery();
			if (objRs.next()) {
				lvlStat = objRs.getNString(1);
			}

		} catch (Exception e) {

			System.out.println("SQL 이슈 : " + e.getMessage());

		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return lvlStat;
	}

/////////// levelUpPost cStatus 변환 끝 //////////////////////

///////////////////////////////////////////////////////////////////
///////////////  게시판 리스트 작업관련(List.jsp) 시작  ///////////////
///////////////////////////////////////////////////////////////////

///////////////  게시판 리스트 출력(List.jsp) 시작    ///////////////
	public Vector<BoardBean> getBoardList(String keyField, String keyWord, int start, int end, String uId) {

		Vector<BoardBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동

			if (uId.equals("admin")) {
				if (keyWord.equals("null") || keyWord.equals("")) {
					// 검색어가 없을 경우
					sql = "select * from levelupbbs where lvlStatus<=3 "
							+ "order by lvlRef desc, lvlPos asc limit ?, ?";
					objPstmt = objConn.prepareStatement(sql);
					objPstmt.setInt(1, start);
					objPstmt.setInt(2, end);
				} else {
					// 검색어가 있을 경우
					sql = "select * from levelupbbs " + "where " + keyField + " like ? AND lvlStatus<=3 "
							+ "order by lvlRef desc, lvlPos asc limit ?, ?";
					objPstmt = objConn.prepareStatement(sql);
					objPstmt.setString(1, "%" + keyWord + "%");
					objPstmt.setInt(2, start);
					objPstmt.setInt(3, end);
				}
			} else {
				if (keyWord.equals("null") || keyWord.equals("")) {
					// 검색어가 없을 경우
					sql = "select * from levelupbbs where lvlUid = ? AND lvlStatus = 1 OR lvlOriUid = ? "
							+ "order by lvlRef desc, lvlPos asc limit ?, ?";
					objPstmt = objConn.prepareStatement(sql);
					objPstmt.setString(1, uId);
					objPstmt.setString(2, uId);
					objPstmt.setInt(3, start);
					objPstmt.setInt(4, end);
				} else {
					// 검색어가 있을 경우
					sql = "select * from levelupbbs " + "where " + keyField
							+ " like ? AND lvlUid = ? AND lvlStatus = 1 OR lvlOriUid = ? "
							+ "order by lvlRef desc, lvlPos asc limit ?, ?";
					objPstmt = objConn.prepareStatement(sql);
					objPstmt.setString(1, "%" + keyWord + "%");
					objPstmt.setString(2, uId);
					objPstmt.setInt(3, start);
					objPstmt.setInt(4, end);
				}
			}

			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				BoardBean bean = new BoardBean();
				bean.setLvlNum(objRs.getInt("lvlNum"));
				bean.setLvlUid(objRs.getString("lvlUid"));
				bean.setLvlTitle(objRs.getString("lvlTitle"));
				bean.setLvlName(objRs.getString("lvlName"));
				bean.setLvlSns(objRs.getString("lvlSns"));
				bean.setLvlPos(objRs.getInt("lvlPos"));
				bean.setLvlRef(objRs.getInt("lvlRef"));
				bean.setLvlDepth(objRs.getInt("lvlDepth"));
				bean.setLvlOriUid(objRs.getString("lvlOriUid"));
				bean.setLvlRegDate(objRs.getString("lvlRegDate"));
				bean.setLvlStatus(objRs.getInt("lvlStatus"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈3 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}

///////////////  게시판 리스트 출력(List.jsp) 끝    ///////////////

//////////////////총 게시물 수(List.jsp) 시작 //////////////////
	public int getTotalCount(String keyField, String keyWord) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int totalCnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			if (keyWord.equals("null") || keyWord.equals("")) {
				sql = "select count(*) from levelupbbs";
				objPstmt = objConn.prepareStatement(sql);
			} else {
				sql = "select count(*) from levelupbbs";
				sql += "where " + keyField + " like ?";
				objPstmt = objConn.prepareStatement(sql);
				objPstmt.setString(1, "%" + keyWord + "%");
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

///////////////////////////////////////////////////////////////////
///////////////  게시판 리스트 작업관련(List.jsp) 끝  ///////////////
///////////////////////////////////////////////////////////////////

////////  게시판 뷰페이지 출력(Read.jsp, 내용보기 페이지) 시작 ////////

	public BoardBean getBoard(int lvlNum) {
//		뷰페이지 게시글 데이터 반환 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		BoardBean bean = new BoardBean();
		try {
			objConn = pool.getConnection(); // DB연동
			sql = "select * from levelupbbs where lvlNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, lvlNum);
			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				bean.setLvlNum(objRs.getInt("lvlNum"));
				bean.setLvlUid(objRs.getString("lvlUid"));
				bean.setLvlTitle(objRs.getString("lvlTitle"));
				bean.setLvlContent(objRs.getString("lvlContent"));
				bean.setLvlName(objRs.getString("lvlName"));
				bean.setLvlSns(objRs.getString("lvlSns"));
				bean.setLvlRegDate(objRs.getString("lvlRegDate"));
				bean.setLvlPos(objRs.getInt("lvlPos"));
				bean.setLvlRef(objRs.getInt("lvlRef"));
				bean.setLvlDepth(objRs.getInt("lvlDepth"));
				bean.setLvlOriUid(objRs.getString("lvlOriUid"));
				bean.setLvlFileName(objRs.getString("lvlFileName"));
				bean.setLvlFileSize(objRs.getInt("lvlFileSize"));
			}

		} catch (Exception e) {
			System.out.println("SQL이슈6 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return bean;
	} // getBoard( ), 게시글 데이터 반환

//	public static void main(String[] args) {
//		System.out.println(len);
//	}
//
//	public static int len;
	public void downLoad(HttpServletRequest req, HttpServletResponse res, JspWriter out, PageContext pageContext) {
		String lvlFileName = req.getParameter("lvlFileName"); // 다운로드할 파일 매개변수명 일치
		String path = req.getServletContext().getRealPath("/src/main/webapp/fileUpload/levelUpBBS/");
		path = UtilMgr.replace(path, ".metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\", "");
		try {
			File file = new File(UtilMgr.con(path + File.separator + lvlFileName));
			byte[] b = new byte[(int) file.length()];
			res.setHeader("Accept-Ranges", "bytes");
			String strClient = req.getHeader("User-Agent");
			res.setContentType("application/smnet;charset=utf-8");
			res.setHeader("Content-Disposition", "attachment;fileName=" + lvlFileName + ";");

			out.clear();
			out = pageContext.pushBody();

			if (file.isFile()) {
				BufferedInputStream fIn = new BufferedInputStream(new FileInputStream(file));
				BufferedOutputStream fOuts = new BufferedOutputStream(res.getOutputStream());
				int read = 0;
				while ((read = fIn.read(b)) != -1) {
					fOuts.write(b, 0, read);
				}
				fOuts.close();
				fIn.close();

			}

		} catch (Exception e) {
			System.out.println("파일 처리 이슈 : " + e.getMessage());
		}

	}

//////   게시판 뷰페이지 출력(Read.jsp, 내용보기 페이지) 끝  ////////	

////////////////// 게시글 삭제(Delete.jsp) 시작 //////////////////
	public int deleteBoard(int lvlNum) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		int exeCnt = 0; // 삭제 데이터 수, DB 삭제가 실행되었는지 여부 판단

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "update levelupbbs set lvlStatus=3 where lvlNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, lvlNum);
			exeCnt = objPstmt.executeUpdate();
			//////////// 게시글 삭제 끝 ///////////////

		} catch (Exception e) {
			System.out.println("SQL이슈77 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return exeCnt;
	}
////////////////게시글 삭제(Delete.jsp) 끝 //////////////////

//////// 게시글 수정페이지 (UpdateProc.jsp) 시작 ////////

	public int updateBoard(BoardBean bean) {
		// 조회수 증가 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		int exeCnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "update levelupbbs set lvlTitle=?, lvlContent=?, lvlName=?, lvlSns=? where lvlNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getLvlTitle());
			objPstmt.setString(2, bean.getLvlContent());
			objPstmt.setString(3, bean.getLvlName());
			objPstmt.setString(4, bean.getLvlSns());
			objPstmt.setInt(5, bean.getLvlNum());
			exeCnt = objPstmt.executeUpdate();
			// exeCnt : DB에서 실제 적용된 데이터(=row, 로우)의 개수 저장됨

		} catch (Exception e) {
			System.out.println("SQL이슈7 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return exeCnt;
	}

//////게시글 수정페이지 (UpdateProc.jsp) 끝 ////////	

///////////// 등업 승인(LvlUpAcProc.jsp) 시작 //////////////////////	

	public boolean AcBoard(String lvlUid, String lvlName, String lvlSns) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		boolean Acres = true;

		try {
			objConn = pool.getConnection();
			sql = "update memberlist set uLevel=2, sName=?, sSns=? where uId=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, lvlName);
			objPstmt.setString(2, lvlSns);
			objPstmt.setString(3, lvlUid);
			objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈8 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return Acres;
	}

///////////  등업 승인(LvlUpAcProc.jsp) 끝  //////////////////////

///////// 게시글 답변 페이지 (ReplyProc.jsp) 시작 //////////
	public int replyBoard(BoardBean bean) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int cnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			//////////// 게시글의 파일 삭제 시작 ///////////////
			sql = "insert into levelupbbs (";
			sql += "lvlUid, lvlTitle, lvlContent, lvlName, lvlSns, ";
			sql += "lvlRef, lvlPos, lvlDepth,  ";
			sql += "lvlRegDate, lvlStatus, lvlOriUid) values (";
			sql += "?, ?, ?, ?, ?, ?, ?, ?, now(), 1, ?)";

			int lvlDepth = bean.getLvlDepth() + 1;
			int lvlPos = bean.getLvlPos() + 1;

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getLvlUid());
			objPstmt.setString(2, bean.getLvlTitle());
			objPstmt.setString(3, bean.getLvlContent());
			objPstmt.setString(4, bean.getLvlName());
			objPstmt.setString(5, bean.getLvlSns());
			objPstmt.setInt(6, bean.getLvlRef());
			objPstmt.setInt(7, lvlPos);
			objPstmt.setInt(8, lvlDepth);
			objPstmt.setString(9, bean.getLvlOriUid());
			cnt = objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈9 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return cnt; // DB에 실제 입력된 데이터 수(= Row Count) 반환
	}

/////////////// 답변글 끼어들기 메서드 시작 ///////////////
	public int replyUpBoard(int lvlRef, int lvlPos) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int cnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			//////////// 게시글의 파일 삭제 시작 ///////////////
			sql = "update levelupbbs set lvlPos = lvlPos + 1 ";
			sql += "where lvlRef = ? and lvlPos > ?";

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, lvlRef);
			objPstmt.setInt(2, lvlPos);
			cnt = objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈 10: " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return cnt;
	}
/////////////// 답변글 끼어들기 메서드 끝 ///////////////

///////// 게시글 답변 페이지 (ReplyProc.jsp) 끝 //////////

}
