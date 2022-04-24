#drop database onedayclass;

create database onedayclassdb;
use onedayclassdb;

set sql_safe_updates=0;

create table memberList ( -- 회원가입
uId					varchar(20)	not null primary key,      -- 아이디 
uPw					varchar(20) 	not null,    	       -- 비밀번호 
uName				varchar(20) 	not null,		       -- 이름 
uPhone				varchar(20)	not null,				   -- 핸드폰번호 
uZip					varchar(20) 	not null,		   -- 우편번호 
uAddr1				varchar(90) 	not null,		       -- 주소 
uAddr2				varchar(100) 			,		       -- 상세주소 
uEmail				varchar(40) 	not null,			   -- 이메일주소 
uLevel				varchar(2)	not null default "1" , 	   -- 회원 등급 (1. 학생, 2. 강사, 3. 관리자)
sName				varchar(30)				,		       -- 상호명 
sSns					varchar(40)  					   -- SNS 
);

create table classBBS ( -- 온오프라인 클래스 테이블
cNum 					int 				auto_increment primary key, -- 클래스 게시판 번호
cCode					varchar(50) 	unique key,	                    -- 클래스 고유코드 
cTeacher				varchar(20) 	not null	 ,		            -- 강사이름
cUid						varchar(20)	not null	 ,       -- 사용자 아이디
cCategory				varchar(20) 	not null	 , 		 -- 클래스 카테고리
cTitle						varchar(50) 	not null	 ,		 -- 클래스 제목
cContent				text				not null	 ,		 -- 클래스 상세내용
cRegDate				date 			not null	 ,		 -- 클래스 날짜 
cPrice					int 				not null	 ,		 -- 클래스 가격 
cDelivery				int								 ,		 -- 배송비 
cThumbName			varchar(50)					 , 	 	 -- 썸네일 이름
cThumbSize			int								 , 	 	 -- 썸네일 크기저장
cFileName				varchar(50)					 ,	 	 -- 파일이름
cFileSize				int								 ,		 -- 크기저장
cMaxStu					int 				not null	 ,		 -- 최대 수강인원 
cApplyStu				int 				default 0	 ,		 -- 수강신청 인원
cArea					    varchar(10)				     ,		 -- 지역 null값 주면됨 
cOnoff					varchar(10)					 ,		 -- 오프라인 유무(Y/N), 온라인이면 insert할때 수강인원 지역 null값 주면됨
cStatus					int								 ,	     -- 게시물 상태(1. 비공개, 2. 공개, 3. 삭제)
cLikes					int          default 0 
);

create table classLikes ( -- 클래스 게시판 좋아요 테이블
uId               varchar(20)   not null,
cNum            int,
foreign key (uId) references memberlist (uId),
foreign key (cNum) references classbbs (cNum),
constraint primary key (uId, cNum)
);

create table qnaBBS ( -- QnA 게시판
qNum		int	auto_increment	  primary key,         -- QnA글번호
qUid			varchar(20)							not null,         -- 게시자 아이디
qTitle		varchar (50)            				not null,         -- 문의 제목
qContent	text                     					not null,         -- 문의 내용
qRegDate	date										not null,         -- 문의글 작성 날짜
qPos			int                     					not null,         -- 상대적인 위치 값
qRef			int                     					not null,         -- 부모글을 가르키는 번호
qDepth		int                     					not null,         -- 답변의 깊이
qOriUid		varchar(20)                          			,         -- 답변의 원작성자 아이디
qFileName	varchar(50)										,         -- 파일이름
qFileSize	int                                      				,         -- 크기저장
qStatus		int                      					not null,         -- 게시물 상태(1. 비공개, 2. 공개, 3. 삭제)
cNum		int										not null
);

create table reviewBBS ( -- 리뷰게시판
rUid			varchar(20)   					not null,
rNum			int    auto_increment primary key,            -- 리뷰글 번호
rTitle			varchar (50)						not null,            -- 리뷰 제목
rContent	text                     				not null,            -- 리뷰 내용
rCnt			int          default 0   			not null,            -- 조회수
rLikes		int          default 0   			not null,            -- 추천수
rRegDate	date                     			not null,            -- 리뷰 작성 날짜
rFileName	varchar(50)                             		,            -- 파일이름
rFileSize	int                                      			,            -- 크기저장
rStatus		int                      				not null,         	 -- 게시물 상태(2. 공개, 3. 삭제)
cNum		int									not null
);

create table reviewLikes ( -- 리뷰 게시판 좋아요 테이블
uId               varchar(20)   not null,
rNum            int,
foreign key (uId) references memberlist (uId),
foreign key (rNum) references reviewBBS (rNum),
constraint primary key (uId, rNum)
);

create table levelUpBBS ( -- 등업게시판
lvlNum			int 	auto_increment primary key,			-- 글번호
lvlUid			varchar(20)				not null		, 
lvlTitle			varchar (50)				not null		,			-- 제목
lvlContent		text							not null		,			-- 내용
lvlName			varchar(30)									,			-- 상호명 
lvlSns			varchar(40)  								,			-- SNS 
lvlRegDate		date							not null		,			-- 작성 날짜
lvlPos			int							not null		,			-- 상대적인 위치 값
lvlRef			int							not null		,			-- 부모글을 가르키는 번호
lvlDepth			int 							not null		,			-- 답변의 깊이
lvlFileName	varchar(50)					  				,			# 파일이름
lvlFileSize		int								  				,			# 크기저장
lvlStatus		int 							not null		,			# 게시물 상태(1. 비공개, 2. 공개, 3. 삭제)
lvlOriUid		varchar(20)
);

create table cartList ( -- 장바구니
uid				varchar(20)									,		-- 아이디 참조
cNum 			int			 									,		-- 클래스 고유코드 참조
																				-- join 클래스 제목, 대표이미지, 가격, 배송비
foreign key (uId) references memberlist (uId)	,
foreign key (cNum) references classbbs (cNum)	,
constraint primary key (uId, cNum)                                                              
);

create table paymentInfo ( -- 결제확인 리스트
pNum				int	auto_increment		primary key,
uId					varchar(20)		not null,		-- 아이디 
rName				varchar(20) 	not null,		-- 이름 
rPhone				varchar(20)		not null,		-- 핸드폰번호 
rZip					varchar(20) 	not null,		-- 우편번호 
rAddr1				varchar(90) 	not null,		-- 주소 
rAddr2				varchar(100) 				,		-- 상세주소 
rEmail				varchar(40) 	not null,		-- 이메일주소 
totalPrice			int					not null,		-- 소계
totalDeli			int					not null,		-- 총배송비
totalPay			int					not null,		-- 총 결제금액
payDate			date					not null  -- 결제날짜
);

create table payComplete (
uid					varchar(20),										-- 학생 아이디
cNum				int,												-- 수업 번호
cUid					varchar(20)					 ,					-- 강사 아이디
cTitle				varchar (50)	not null,							-- 수업명
pNum				int								 ,				    -- 결제완료 번호
pQty					int					not null,					-- 수강받는 수량
payDate			date					not null,							
foreign key (uId) references memberlist (uId),
foreign key (cNum) references classbbs (cNum),
foreign key (pNum) references paymentInfo (pNum),
constraint primary key (uId, cNum, pNum)
);

insert into memberList values (
"test1", "1234", "길태형", "null", "null", "null", null, "null", 1, null, null);

insert into memberList values (
"test2", "1234", "첫번째선생님", "null", "null", "null", null, "null", 2, null, null);

insert into memberList values (
"test3", "1234", "두번째선생님", "null", "null", "null", null, "null", 2, null, null);

insert into memberList values (
"admin", "1234", "관리자", "null", "null", "null", null, "null", 3, null, null);

#select * from qnabbs;
#select * from reviewbbs;
#select * from memberlist where uid = "test1";
#select * from classbbs;
#update classbbs set cStatus = 2;

#조회명령어
#select * from classbbs where cNum order by cLikes desc limit 0, 10;
#select * from classbbs where cCategory like 7 AND cStatus<3 order by cLikes desc limit 0, 10;
#select * from classbbs where cStatus < 3 order by cNum asc limit 1, 10;
#alter table qnaBBS add cNum int not null; -- DB 삭제안하고 컬럼 추가할때 씀
#select * from classbbs where cStatus<3 AND cOnoff = "N" order by cNum asc limit 1, 10;