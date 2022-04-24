package pack_ClassBBS;

public class ClassBean {
	
	//컬럼 18개
	private int cNum; //클래스 게시판 번호
	private String cCode; //클래스 고유코드
	private String cTeacher; //강사이름
	private String cUid;		//사용자 닉네임
	private String cCategory; //클래스 카테고리
	private String cTitle; //클래스 제목
	private String cContent; //클래스 설명
	private String cRegDate; //클래스 작성날짜
	private int cPrice; //클래스 가격
	private int cDelivery; //배송비
	private String cThumbName; //썸네일 이름
	private int cThumbSize; //썸네일 크기저장
	private String cFileName; //파일이름 
	private int cFileSize; //크기저장
	private int cMaxStu; //최대 수강인원
	private int cApplyStu; //수강신청 인원
	private String cArea; //지역 null값 주면됨
	private String cOnoff; //오프라인 유무(Y/N), 온라인이면 insert할때 수강인원 지역 null값 주면됨
	private int cStatus; //게시물 상태(1. 비공개, 2. 공개, 3. 삭제)
	private int cLikes; //좋아요
	
	public int getcNum() {
		return cNum;
	}
	public void setcNum(int cNum) {
		this.cNum = cNum;
	}
	public String getcCode() {
		return cCode;
	}
	public void setcCode(String cCode) {
		this.cCode = cCode;
	}
	public String getcTeacher() {
		return cTeacher;
	}
	public void setcTeacher(String cTeacher) {
		this.cTeacher = cTeacher;
	}
	public String getcUid() {
		return cUid;
	}
	public void setcUid(String cUid) {
		this.cUid = cUid;
	}
	public String getcCategory() {
		return cCategory;
	}
	public void setcCategory(String cCategory) {
		this.cCategory = cCategory;
	}
	public String getcTitle() {
		return cTitle;
	}
	public void setcTitle(String cTitle) {
		this.cTitle = cTitle;
	}
	public String getcContent() {
		return cContent;
	}
	public void setcContent(String cContent) {
		this.cContent = cContent;
	}
	public String getcRegDate() {
		return cRegDate;
	}
	public void setcRegDate(String cRegDate) {
		this.cRegDate = cRegDate;
	}
	public int getcPrice() {
		return cPrice;
	}
	public void setcPrice(int cPrice) {
		this.cPrice = cPrice;
	}
	public int getcDelivery() {
		return cDelivery;
	}
	public void setcDelivery(int cDelivery) {
		this.cDelivery = cDelivery;
	}
	public String getcThumbName() {
		return cThumbName;
	}
	public void setcThumbName(String cThumbName) {
		this.cThumbName = cThumbName;
	}
	public int getcThumbSize() {
		return cThumbSize;
	}
	public void setcThumbSize(int cThumbSize) {
		this.cThumbSize = cThumbSize;
	}
	public String getcFileName() {
		return cFileName;
	}
	public void setcFileName(String cFileName) {
		this.cFileName = cFileName;
	}
	public int getcFileSize() {
		return cFileSize;
	}
	public void setcFileSize(int cFileSize) {
		this.cFileSize = cFileSize;
	}
	public int getcMaxStu() {
		return cMaxStu;
	}
	public void setcMaxStu(int cMaxStu) {
		this.cMaxStu = cMaxStu;
	}
	public int getcApplyStu() {
		return cApplyStu;
	}
	public void setcApplyStu(int cApplyStu) {
		this.cApplyStu = cApplyStu;
	}
	public String getcArea() {
		return cArea;
	}
	public void setcArea(String cArea) {
		this.cArea = cArea;
	}
	
	public String getcOnoff() {
		return cOnoff;
	}
	public void setcOnoff(String cOnoff) {
		this.cOnoff = cOnoff;
	}
	
	public int getcStatus() {
		return cStatus;
	}
	public void setcStatus(int cStatus) {
		this.cStatus = cStatus;
	}
	public int getcLikes() {
		return cLikes;
	}
	public void setcLikes(int cLikes) {
		this.cLikes = cLikes;
	}

}
