package pack_QnaBBS;

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
	/* private static final String SAVEFOLER = "E:/IT/Team Project (Oneday Class)/Proj_OnedayClass/src/main/webapp/fileUpload";
	 * 
	 * 
	 */
	// 수식어 static final 이 함께 사용된 필드를 상수필드라고함.
	// 상수필드는 선언과 동시에 반드시 초기화해야 함.
	// 필드명은 모두 대문자, 단어간 연결은 밑줄
	// 재초기화 안됨

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
		int qFileSize = 0;
		String qFileName = null;
		String path= req.getServletContext().getRealPath("/src/main/webapp/fileUpload/qnaBBS/");
		path = UtilMgr.replace(path, ".metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\", "");

		try {
			objConn = pool.getConnection();
			sql = "select max(qNum) from qnaBBS";
			objPstmt = objConn.prepareStatement(sql);
			objRs = objPstmt.executeQuery();

			int qRef = 1; // 답변글 작성용, 원본글의 글번호(num)와 일치
			if (objRs.next())
				qRef = objRs.getInt(1) + 1;
			// 현재 DB qna_board에 데이터가 3개(num 컬럼에 1, 2, 3)가
			// 있다고 가정하면 max(num)는 3을 반환함. 그러므로 새 글번호를
			// 참조하는 DB의 컬럼 ref는 4가 됨.

			File file = new File(path);

			if (!file.exists())
				file.mkdirs();

			multi = new MultipartRequest(req, path, maxSize, encType, new DefaultFileRenamePolicy());

			if (multi.getFilesystemName("qFileName") != null) {
				qFileName = multi.getFilesystemName("qFileName");
				System.out.println(qFileName);
				qFileSize = (int) multi.getFile("qFileName").length();
			}
			String qContent = multi.getParameter("qContent");
			String contentType = "TEXT";

			if (contentType.equalsIgnoreCase("TEXT")) {
				qContent = UtilMgr.replace(qContent, "<", "&lt;");
			}

			sql = "insert into qnaBBS (";
			sql += "qUid, qTitle, qContent, qRegDate, ";
			sql += "qRef, qPos, qDepth, ";
			sql += "qFileName, qFileSize, qStatus, cNum) values (";
			sql += "?, ?, ?,     now(), ?, 0, 0, ?, ?, ?, ?)";

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, multi.getParameter("qUid"));
			objPstmt.setString(2, multi.getParameter("qTitle"));
			objPstmt.setString(3, qContent);
			objPstmt.setInt(4, qRef);
			objPstmt.setString(5, qFileName);
			objPstmt.setInt(6, qFileSize);
			objPstmt.setInt(7, Integer.parseInt(multi.getParameter("qStatus")));
			objPstmt.setInt(8, Integer.parseInt(multi.getParameter("cNum")));
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
			if (uId.equals("admin"))  {
				if (keyWord.equals("null") || keyWord.equals("")) {
					// 검색어가 없을 경우
					sql = "select * from qnaBBS where qStatus<=3 "
							+ "order by qRef desc, qPos asc limit ?, ?";
					objPstmt = objConn.prepareStatement(sql);
					objPstmt.setInt(1, start);
					objPstmt.setInt(2, end);
				} else {
					// 검색어가 있을 경우
					sql = "select * from qnaBBS "
							+ "where " + keyField + " like ? AND qStatus<=3 "
							+ "order by qRef desc, qPos asc limit ?, ?";
					objPstmt = objConn.prepareStatement(sql);
					objPstmt.setString(1, "%" + keyWord + "%");
					objPstmt.setInt(2, start);
					objPstmt.setInt(3, end);
					}
			} else {
			if (keyWord.equals("null") || keyWord.equals("")) {
				// 검색어가 없을 경우
				sql = "select * from qnaBBS where qStatus<3 "
						+ "order by qRef desc, qPos asc limit ?, ?";
				objPstmt = objConn.prepareStatement(sql);
				objPstmt.setInt(1, start);
				objPstmt.setInt(2, end);
			} else {
				// 검색어가 있을 경우
				sql = "select * from qnaBBS "
						+ "where " + keyField + " like ? AND qStatus<3 "
						+ "order by qRef desc, qPos asc limit ?, ?";
				objPstmt = objConn.prepareStatement(sql);
				objPstmt.setString(1, "%" + keyWord + "%");
				objPstmt.setInt(2, start);
				objPstmt.setInt(3, end);
				}
			}
			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				BoardBean bean = new BoardBean();
				bean.setqNum(objRs.getInt("qNum"));
				bean.setqUid(objRs.getString("qUid"));
				bean.setqTitle(objRs.getString("qTitle"));
				bean.setqPos(objRs.getInt("qPos"));
				bean.setqRef(objRs.getInt("qRef"));
				bean.setqDepth(objRs.getInt("qDepth"));
				bean.setqOriUid(objRs.getString("qOriUid"));
				bean.setqRegDate(objRs.getString("qRegDate"));
				bean.setqStatus(objRs.getInt("qStatus"));
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
				sql = "select count(*) from qnaBBS where qStatus<3";
				objPstmt = objConn.prepareStatement(sql);
			} else {
				sql = "select count(*) from qnaBBS ";
				sql += "where " + keyField + " like ? AND qStatus<3";
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

///////////////////////////////////////////////////////////////////
///////////////  ajax 게시판 리스트 작업관련(List.jsp) 시작  ///////////////
///////////////////////////////////////////////////////////////////

///////////////  ajax 게시판 리스트 출력(List.jsp) 시작    ///////////////
public Vector<BoardBean> getAjaxBoardList(String keyField, String keyWord, int start, int end, int cNum) {

Vector<BoardBean> vList = new Vector<>();
Connection objConn = null;
PreparedStatement objPstmt = null;
ResultSet objRs = null;
String sql = null;

try {
objConn = pool.getConnection(); // DB연동

if (keyWord.equals("null") || keyWord.equals("")) {
// 검색어가 없을 경우
sql = "select * from qnaBBS where qStatus<3 AND cNum=? "
+ "order by qRef desc, qPos asc limit ?, ?";
objPstmt = objConn.prepareStatement(sql);
objPstmt.setInt(1, cNum);
objPstmt.setInt(2, start);
objPstmt.setInt(3, end);
} else {
// 검색어가 있을 경우
sql = "select * from qnaBBS "
+ "where " + keyField + " like ? AND qStatus<3 AND cNum=? "
+ "order by qRef desc, qPos asc limit ?, ?";
objPstmt = objConn.prepareStatement(sql);
objPstmt.setString(1, "%" + keyWord + "%");
objPstmt.setInt(2, cNum);
objPstmt.setInt(3, start);
objPstmt.setInt(4, end);
}

objRs = objPstmt.executeQuery();

while (objRs.next()) {
BoardBean bean = new BoardBean();
bean.setqNum(objRs.getInt("qNum"));
bean.setqUid(objRs.getString("qUid"));
bean.setqTitle(objRs.getString("qTitle"));
bean.setqPos(objRs.getInt("qPos"));
bean.setqRef(objRs.getInt("qRef"));
bean.setqDepth(objRs.getInt("qDepth"));
bean.setqOriUid(objRs.getString("qOriUid"));
bean.setqRegDate(objRs.getString("qRegDate"));
bean.setqStatus(objRs.getInt("qStatus"));
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
public int getAjaxTotalCount(String keyField, String keyWord, int cNum) {

Connection objConn = null;
PreparedStatement objPstmt = null;
ResultSet objRs = null;
String sql = null;
int totalCnt = 0;

try {
objConn = pool.getConnection(); // DB연동

if (keyWord.equals("null") || keyWord.equals("")) {
sql = "select count(*) from qnaBBS where qStatus<3 AND cNum=? ";
objPstmt = objConn.prepareStatement(sql);
objPstmt.setInt(1, cNum);
} else {
sql = "select count(*) from qnaBBS ";
sql += "where " + keyField + " like ? AND qStatus<3 AND cNum=? ";
objPstmt = objConn.prepareStatement(sql);
objPstmt.setString(1, "%" + keyWord + "%");
objPstmt.setInt(2, cNum);
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
/////////////// ajax 게시판 리스트 작업관련(List.jsp) 끝  ///////////////
///////////////////////////////////////////////////////////////////
	
	
	
////////  게시판 뷰페이지 출력(Read.jsp, 내용보기 페이지) 시작 ////////

	public BoardBean getBoard(int qNum) {
//		뷰페이지 게시글 데이터 반환 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		BoardBean bean = new BoardBean();
		try {
			objConn = pool.getConnection(); // DB연동
			sql = "select * from qnaBBS where qNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, qNum);
			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				bean.setqNum(objRs.getInt("qNum"));
				bean.setqUid(objRs.getString("qUid"));
				bean.setqTitle(objRs.getString("qTitle"));
				bean.setqContent(objRs.getString("qContent"));
				bean.setqPos(objRs.getInt("qPos"));
				bean.setqRef(objRs.getInt("qRef"));
				bean.setqDepth(objRs.getInt("qDepth"));
				bean.setqRegDate(objRs.getString("qRegDate"));
				bean.setqOriUid(objRs.getString("qOriUid"));
				bean.setqFileName(objRs.getString("qFileName"));
				bean.setqFileSize(objRs.getInt("qFileSize"));
			}

		} catch (Exception e) {
			System.out.println("SQL이슈6 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return bean;
	} // getBoard( ), 게시글 데이터 반환

	public void downLoad(HttpServletRequest req, HttpServletResponse res, JspWriter out, PageContext pageContext) {
		String qFileName = req.getParameter("qFileName"); // 다운로드할 파일 매개변수명 일치
		String path= req.getServletContext().getRealPath("/src/main/webapp/fileUpload/qnaBBS/");
		path = UtilMgr.replace(path, ".metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\", "");
		try {
			File file = new File(UtilMgr.con(path + File.separator + qFileName));

			byte[] b = new byte[(int) file.length()];
			res.setHeader("Accept-Ranges", "bytes");
			String strClient = req.getHeader("User-Agent");
			res.setContentType("application/smnet;charset=utf-8");
			res.setHeader("Content-Disposition", "attachment;fileName=" + qFileName + ";");

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
	public int deleteBoard(int qNum) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		int exeCnt = 0; // 삭제 데이터 수, DB 삭제가 실행되었는지 여부 판단

		try {
			objConn = pool.getConnection(); // DB연동

			/*
			 * //////////// 게시글의 파일 삭제 시작 /////////////// sql =
			 * "select qFileName from qnaBBS where qNum=?"; objPstmt =
			 * objConn.prepareStatement(sql); objPstmt.setInt(1, qNum); objRs =
			 * objPstmt.executeQuery();
			 * 
			 * if (objRs.next() && objRs.getString(1) != null) { if
			 * (!objRs.getString(1).equals("")) { String fName = objRs.getString(1); String
			 * fileSrc = SAVEFOLER + "/" + fName; File file = new File(fileSrc);
			 * 
			 * if (file.exists()) file.delete(); // 파일 삭제 실행
			 * 
			 * } } //////////// 게시글의 파일 삭제 끝 ///////////////
			 */

			//////////// 게시글 삭제 시작 ///////////////
			sql = "update qnaBBS set qStatus=3 where qRef=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, qNum);
			exeCnt = objPstmt.executeUpdate();
			//////////// 게시글 삭제 끝 ///////////////

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
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
			sql = "update qnaBBS set qTitle=?, qContent=?, qStatus=? where qNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getqTitle());
			objPstmt.setString(2, bean.getqContent());
			objPstmt.setInt(3, bean.getqStatus());
			objPstmt.setInt(4, bean.getqNum());
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

///////// 게시글 답변 페이지 (ReplyProc.jsp) 시작 //////////
	public int replyBoard(BoardBean bean) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int cnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			sql = "insert into qnaBBS (";
			sql += "qUid, qTitle, qContent, ";
			sql += "qRef, qPos, qDepth, ";
			sql += "qOriUid, qRegDate, qStatus, cNum";
			sql += ") values (";
			sql += "?, ?, ?, ?, ?, ?, ?, now(), ?, ?)";

			int qDepth = bean.getqDepth() + 1;
			int qPos = bean.getqPos() + 1;

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getqUid());
			objPstmt.setString(2, bean.getqTitle());
			objPstmt.setString(3, bean.getqContent());
			objPstmt.setInt(4, bean.getqRef());
			objPstmt.setInt(5, qPos);
			objPstmt.setInt(6, qDepth);
			objPstmt.setString(7, bean.getqOriUid());
			objPstmt.setInt(8, bean.getqStatus());
			objPstmt.setInt(9, bean.getcNum());
			cnt = objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈8 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return cnt; // DB에 실제 입력된 데이터 수(= Row Count) 반환
	}

/////////////// 답변글 끼어들기 메서드 시작 ///////////////
	public int replyUpBoard(int qRef, int qPos) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int cnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동

			//////////// 게시글의 파일 삭제 시작 ///////////////
			sql = "update qnaBBS set qPos = qPos + 1 ";
			sql += "where qRef = ? and qPos > ?";

			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, qRef);
			objPstmt.setInt(2, qPos);
			cnt = objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈 9: " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return cnt;
	}
/////////////// 답변글 끼어들기 메서드 끝 ///////////////

///////// 게시글 답변 페이지 (ReplyProc.jsp) 끝 //////////

}
