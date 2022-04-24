package pack_reviewBBS;

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

public class RvBoardMgr {

	private DBConnectionMgr pool;
	
	  //private static final String SAVEFOLER =
	  //"C:/Users/kmr07/OneDrive/바탕 화면/sy/silsp/1213_OnedayClassProject/src/main/webapp/fileUpload/Rvbbs/"; 
	  // 수식어 static final 이 함께 사용된 필드를 상수필드라고함. // 상수필드는 선언과 동시에 반드시 초기화해야 함.
	  //필드명은 모두 대문자, 단어간 연결은 밑줄 // 재초기화 안됨
	 
	private static String encType = "UTF-8";
	private static int maxSize = 5 * 1024 * 1024;

	public RvBoardMgr() {
		try {
			pool = DBConnectionMgr.getInstance();
		} catch (Exception e) {
			System.out.println("DB 접속이슈 : " + e.getMessage());
		}

	}

///////////////  게시판 입력(PostProc.jsp) 시작  ///////////////
	public void insertBoard(HttpServletRequest req) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		MultipartRequest multi = null;
		int rFileSize = 0;
		String rFileName = null;
		String path = req.getServletContext().getRealPath("/src/main/webapp/fileUpload/reviewbbs/");
		path = UtilMgr.replace(path, ".metadata\\.plugins\\org.eclipse.wst.server.core\\tmp0\\wtpwebapps\\", "");
	
		
		try {
			objConn = pool.getConnection();
			// sql = "select max(rNum) from reviewBBS";
			//objPstmt = objConn.prepareStatement(sql);
			//objRs = objPstmt.executeQuery();

			//int ref = 1; // 답변글 작성용, 원본글의 글번호(num)와 일치
			//if (objRs.next())
				//ref = objRs.getInt(1) + 1;
			// 현재 DB qna_board에 데이터가 3개(num 컬럼에 1, 2, 3)가
			// 있다고 가정하면 max(num)는 3을 반환함. 그러므로 새 글번호를
			// 참조하는 DB의 컬럼 ref는 4가 됨.

			File file = new File(path);

			if (!file.exists())
				file.mkdirs();

			multi = new MultipartRequest(req, path, maxSize, encType, new DefaultFileRenamePolicy());

			if (multi.getFilesystemName("rFileName") != null) {
				rFileName = multi.getFilesystemName("rFileName");
				rFileSize = (int) multi.getFile("rFileName").length();
			}
			String rContent = multi.getParameter("rContent");
	

			if (multi.getParameter("contentType").equalsIgnoreCase("TEXT")) {
				rContent = UtilMgr.replace(rContent, "<", "&lt;");
			}

			sql = "insert into reviewBBS (";
			sql += "rUid, rTitle, rContent, rCnt, rLikes,  ";
			sql += "rRegDate, rFileName, rFileSize, rStatus, cNum ) values (";
			sql += "?, ?, ?, 0, 0,     now(), ?, ?, 2, ?)";

			objPstmt = objConn.prepareStatement(sql);
			
			RvBoardBean bean = new RvBoardBean();

			objPstmt.setString(1, multi.getParameter("rUid"));
			objPstmt.setString(2, multi.getParameter("rTitle"));
			objPstmt.setString(3, rContent);
			objPstmt.setString(4, rFileName);
			objPstmt.setInt(5, rFileSize);
			objPstmt.setInt(6, Integer.parseInt(multi.getParameter("cNum")));
			


			objPstmt.executeUpdate();

		} catch (SQLException e) {
			System.out.println("SQL 이슈 : " + e.getMessage());
		} catch (Exception e) {
			System.out.println("DB 접속이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

	}
///////////////  게시판 입력(PostProc.jsp) 끝    ///////////////	

///////////////////////////////////////////////////////////////////
///////////////  게시판 리스트 작업관련(List.jsp) 시작  ///////////////
///////////////////////////////////////////////////////////////////

///////////////  게시판 리스트 출력(List.jsp) 시작    ///////////////
	public Vector<RvBoardBean> getBoardList( int start, int end, String rUid) {

		Vector<RvBoardBean> vList = new Vector<>();
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

	  try {
			objConn = pool.getConnection(); // DB연동
			
			if (rUid.equals("admin")) {
				
					// 검색어가 없을 경우
					
					sql = "select * from reviewBBS "
							+ "order by rNum limit ?, ?";
				
					objPstmt = objConn.prepareStatement(sql);
					objPstmt.setInt(1, start);
					objPstmt.setInt(2, end);					
					
			} else {
					// 검색어가 없을 경우
					
					sql = "select * from reviewBBS where rStatus=2 "
							+ "order by rNum desc limit ?, ?";
				
					objPstmt = objConn.prepareStatement(sql);
					objPstmt.setInt(1, start);
					objPstmt.setInt(2, end);
					
			}
			
			
			objRs = objPstmt.executeQuery();

			while (objRs.next()) {
				RvBoardBean bean = new RvBoardBean();
				bean.setrUid(objRs.getString("rUid"));
				bean.setrNum(objRs.getInt("rNum"));
				bean.setrTitle(objRs.getString("rTitle"));
				bean.setrContent(objRs.getString("rContent"));
				bean.setrCnt(objRs.getInt("rCnt"));
				bean.setrLikes(objRs.getInt("rLikes"));
				bean.setrRegDate(objRs.getString("rRegDate"));
				bean.setrStatus(objRs.getInt("rStatus"));
				bean.setrFileName(objRs.getString("rFileName"));
				vList.add(bean);
			}
		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return vList;
	}

///////////////  게시판 리스트 출력(List.jsp) 끝    ///////////////


//////////////////총 게시물 수(List.jsp) 시작 //////////////////
	public int getTotalCount() {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int totalCnt = 0;

		try {
			objConn = pool.getConnection(); // DB연동
			
				sql = "select count(*) from reviewBBS";
				objPstmt = objConn.prepareStatement(sql);
	
			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				totalCnt = objRs.getInt(1);
			}
			
		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return totalCnt;
	}
//////////////////총 게시물 수(List.jsp) 끝 //////////////////

///////////////////////////////////////////////////////////////////
///////////////  게시판 리스트 작업관련(List.jsp) 끝  ///////////////
///////////////////////////////////////////////////////////////////
	
///////////////  Ajax 게시판 리스트 출력(List.jsp) 시작    ///////////////
public Vector<RvBoardBean> getAjaxBoardList( int start, int end, String rUid, int cNum) {

Vector<RvBoardBean> vList = new Vector<>();
Connection objConn = null;
PreparedStatement objPstmt = null;
ResultSet objRs = null;
String sql = null;

try {
	objConn = pool.getConnection(); // DB연동
	
	if (rUid.equals("admin")) {
		
			// 검색어가 없을 경우
			
			sql = "select * from reviewBBS where cNum = ? "
					+ "order by rNum limit ?, ?";
		
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, cNum);
			objPstmt.setInt(2, start);
			objPstmt.setInt(3, end);					
			
			
	} else {
			// 검색어가 없을 경우
			
			sql = "select * from reviewBBS where rStatus=2 AND cNum = ? "
					+ "order by rNum desc limit ?, ?";
		
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, cNum);
			objPstmt.setInt(2, start);
			objPstmt.setInt(3, end);
			
	}
	
	
	objRs = objPstmt.executeQuery();

	while (objRs.next()) {
		RvBoardBean bean = new RvBoardBean();
		bean.setrUid(objRs.getString("rUid"));
		bean.setrNum(objRs.getInt("rNum"));
		bean.setrTitle(objRs.getString("rTitle"));
		bean.setrContent(objRs.getString("rContent"));
		bean.setrCnt(objRs.getInt("rCnt"));
		bean.setrLikes(objRs.getInt("rLikes"));
		bean.setrRegDate(objRs.getString("rRegDate"));
		bean.setrStatus(objRs.getInt("rStatus"));
		bean.setrFileName(objRs.getString("rFileName"));
		vList.add(bean);
	}
} catch (Exception e) {
	System.out.println("SQL이슈 : " + e.getMessage());
} finally {
	pool.freeConnection(objConn, objPstmt, objRs);
}

return vList;
}

///////////////  게시판 리스트 출력(List.jsp) 끝    ///////////////


//////////////////총 게시물 수(List.jsp) 시작 //////////////////
public int getAjaxTotalCount(int cNum) {

Connection objConn = null;
PreparedStatement objPstmt = null;
ResultSet objRs = null;
String sql = null;
int totalCnt = 0;

try {
		objConn = pool.getConnection(); // DB연동
	
		sql = "select count(*) from reviewBBS where cNum=? ";
		objPstmt = objConn.prepareStatement(sql);
		objPstmt.setInt(1, cNum);
		
	objRs = objPstmt.executeQuery();

	if (objRs.next()) {
		totalCnt = objRs.getInt(1);
	}
	
} catch (Exception e) {
	System.out.println("SQL이슈 : " + e.getMessage());
} finally {
	pool.freeConnection(objConn, objPstmt, objRs);
}

return totalCnt;
}
//////////////////총 게시물 수(List.jsp) 끝 //////////////////	


////////  게시판 뷰페이지 출력(Read.jsp, 내용보기 페이지) 시작 ////////

	public void upCount(int rNum) {
		// 조회수 증가 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동
			sql = "update reviewBBS set rCnt = rCnt+1 where rNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, rNum);
			objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

	} // upCount( ), 조회수 증가 끝

	public RvBoardBean getBoard(int rNum) {
//		뷰페이지 게시글 데이터 반환 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		RvBoardBean bean = new RvBoardBean();
		try {
			objConn = pool.getConnection(); // DB연동
			sql = "select * from reviewBBS where rNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, rNum);
			objRs = objPstmt.executeQuery();

			if (objRs.next()) {
				bean.setrUid(objRs.getString("rUid"));
				bean.setrNum(objRs.getInt("rNum"));
				bean.setrTitle(objRs.getString("rTitle"));
				bean.setrContent(objRs.getString("rContent"));
				bean.setrCnt(objRs.getInt("rCnt"));
				bean.setrLikes(objRs.getInt("rLikes"));
				bean.setrRegDate(objRs.getString("rRegDate"));
				bean.setrFileName(objRs.getString("rFileName"));
				bean.setrFileSize(objRs.getInt("rFileSize"));
				bean.setrStatus(objRs.getInt("rStatus"));
						

			}

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return bean;
	} // getBoard( ), 게시글 데이터 반환

/*	public static void main(String[] args) {
		System.out.println(len);
	}

	public static int len;
	public void downLoad(HttpServletRequest req, HttpServletResponse res, JspWriter out, PageContext pageContext) {
		String rFileName = req.getParameter("rFileName"); // 다운로드할 파일 매개변수명 일치
		
		try {
			File file = new File(UtilMgr.con(path + File.separator + rFileName));

			byte[] b = new byte[(int) file.length()];
			res.setHeader("Accept-Ranges", "bytes");
			String strClient = req.getHeader("User-Agent");
			res.setContentType("application/smnet;charset=utf-8");
			res.setHeader("Content-Disposition", "attachment;rFileName=" + rFileName + ";");

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

	}*/

//////   게시판 뷰페이지 출력(Read.jsp, 내용보기 페이지) 끝  ////////	

////////////////// 게시글 삭제(Delete.jsp) 시작 //////////////////
	public int deleteBoard(int rNum) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;

		int exeCnt = 0; // 삭제 데이터 수, DB 삭제가 실행되었는지 여부 판단

		try {
			objConn = pool.getConnection(); // DB연동

			/*/////////// 게시글의 파일 삭제 시작 ///////////////
			sql = "select rFileName from reviewBBS where rNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, rNum);
			objRs = objPstmt.executeQuery();

			if (objRs.next() && objRs.getString(1) != null) {
				if (!objRs.getString(1).equals("")) {
					String fName = objRs.getString(1);
					String fileSrc = SAVEFOLER + "/" + fName;
					File file = new File(fileSrc);

					if (file.exists())
						file.delete(); // 파일 삭제 실행

				}
			}
			//////////// 게시글의 파일 삭제 끝 //////////////*/

			//////////// 게시글 삭제 시작 ///////////////
			sql = "update reviewBBS set rStatus=3 where rNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, rNum);
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

	public int updateBoard(RvBoardBean bean) {
		// 조회수 증가 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		int exeCnt = 0;
		
		try {
			objConn = pool.getConnection(); // DB연동
			sql = "update reviewBBS set rTitle=?, rContent=? where rNum=?";
			objPstmt = objConn.prepareStatement(sql);
			//objPstmt.setString(1, bean.getrUid());
			objPstmt.setString(1, bean.getrTitle());
			objPstmt.setString(2, bean.getrContent());
			objPstmt.setInt(3, bean.getrNum());
			exeCnt = objPstmt.executeUpdate();
			// exeCnt : DB에서 실제 적용된 데이터(=row, 로우)의 개수 저장됨

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

		return exeCnt;
	}

//////게시글 수정페이지 (UpdateProc.jsp) 끝 ////////	

	
///////////// 좋아요 시작? RvLikeAction.jsp //////////////	
	public int UpdateLike(RvLikeBean rvLikeBean) {
		int result = 0;
		
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		
		try {
			objConn = pool.getConnection(); // DB연동
			sql = "insert into reviewLikes (uId, rNum) values(?,?)";
			objPstmt = objConn.prepareStatement(sql);
			//objPstmt.setString(1, bean.getrUid());
			objPstmt.setString(1, rvLikeBean.getuId());
			objPstmt.setInt(2, rvLikeBean.getrNum());
			result = objPstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}
		
		return result;
	}
		
	public int InsertLikeCnt(int rNum) {
		int result = 0;
		
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;
		
		try {
			objConn = pool.getConnection(); // DB연동
			sql = "update reviewBBS set rLikes=rLikes+1 where rNum=?;";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, rNum);
			
			result = objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}		
		
		return result;
	}
	
	
	
///////////// 좋아요 끝? RvLikeAction.jsp //////////////	
	

/*//////// 게시글 답변 페이지 (ReplyProc.jsp) 시작 //////////
	public int replyBoard(BoardBean bean) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int cnt = 0;
	

		try {
			objConn = pool.getConnection(); // DB연동

			//////////// 게시글의 파일 삭제 시작 ///////////////
			sql = "insert into reviewBBS (";
			sql += "rUid, rTitle, rContent, rCnt, rLikes,  ";
			sql += "rRegDate, rFileName, rFileSize, rStatus) values (";
			sql += "?, ?, ?, 0, 0,     now(), ?, ?, 2)";

			
			objPstmt.setString(1, bean.getrUid());
			objPstmt.setString(2, bean.getrTitle());
			objPstmt.setString(3, bean.getrContent());
			objPstmt.setString(4, bean.getrFileName());
			objPstmt.setInt(5, bean.getrFileSize());
			
			/* objPstmt = objConn.prepareStatement(sql);
			objPstmt.setString(1, bean.getuId());
			objPstmt.setString(2, bean.getQna_content());
			objPstmt.setString(3, bean.getQna_content());
			objPstmt.setInt(4, bean.getRef());
			objPstmt.setInt(5, pos);
			objPstmt.setInt(6, depth);
			objPstmt.setString(7, bean.getQna_pw());
			//objPstmt.setString(8, bean.getIp()); 
			
			cnt = objPstmt.executeUpdate();


		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		return cnt;  // DB에 실제 입력된 데이터 수(= Row Count) 반환
	}
	
	
	
	/////////////// 답변글 끼어들기 메서드 시작 ///////////////
	public int replyUpBoard(int ref, int pos) {

		Connection objConn = null;
		PreparedStatement objPstmt = null;
		ResultSet objRs = null;
		String sql = null;
		int cnt = 0;
		

		try {
			objConn = pool.getConnection(); // DB연동

			//////////// 게시글의 파일 삭제 시작 ///////////////
			sql = "update qna_board set pos = pos + 1 ";
			sql += "where ref = ? and pos > ?";
			
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, ref);
			objPstmt.setInt(2, pos);
			cnt = objPstmt.executeUpdate();


		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt, objRs);
		}

		
		return cnt;
	}	
	/////////////// 답변글 끼어들기 메서드 끝 ///////////////
	

///////// 게시글 답변 페이지 (ReplyProc.jsp) 끝 //////////*/
	
	public void LikeUpCount(int rNum) {
		// 조회수 증가 시작
		Connection objConn = null;
		PreparedStatement objPstmt = null;
		String sql = null;

		try {
			objConn = pool.getConnection(); // DB연동
			sql = "update reviewBBS set rLike = rLike+1 where rNum=?";
			objPstmt = objConn.prepareStatement(sql);
			objPstmt.setInt(1, rNum);
			objPstmt.executeUpdate();

		} catch (Exception e) {
			System.out.println("SQL이슈 : " + e.getMessage());
		} finally {
			pool.freeConnection(objConn, objPstmt);
		}

	} 

	
	
}
