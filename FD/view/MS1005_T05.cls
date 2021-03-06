
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_T05()
{
	@super();

}
@extends AView;


@function MS1005_T05:init(context, evtListener)
{
	@super.init(context, evtListener);
	this.btnView = this.findCompById('BtnView');
	this.loadView = this.findCompById('MobileView').loadView;	
};

@function MS1005_T05:onActive(reload)
{
	@super.onActive(reload);
	
	this.loadView.birthdayTxt.setReadOnly(true);
	this.loadView.resetView();
	if(reload)
	{		
		if(this.getContainerId() == 'MS1005') {
			theApp.checkCreateDatetime();
		}
	}
};

@function MS1005_T05:onBeforeBtnClick(comp, info)
{

	this.getContainer().beforeView();

};

@function MS1005_T05:onNextBtnClick(comp, info)
{
	var mView = this.loadView;
	var thisObj=this;
	
	//약관동의 완료시
	if(mView.agreeValidCheck() && mView.inputValidCheck() )
	{
		mView.confirmUser(function(success)
		{
			if(success) {
				thisObj.check_sendSACMT469();
			}
			else 
			{
				AToast.show('휴대폰 본인 확인에 실패하였습니다');
			}
		});
	}
};


//고객 인증 정보 조회
@function MS1005_T05:check_sendSACMT469(){
	var thisObj = this;
	var mView = this.loadView;
	var phoneNum = theApp.userInfo.getUserData('D1이동전화식별번호')+theApp.userInfo.getUserData("D1이동전화국번호")+theApp.userInfo.getUserData("D1이동전화일련번호");

	var carrier = mView.getTelDbx();

	QryRequest.request('SACMT469',
					   function(queryData)
					   {
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1처리구분'] = '0';
		inBlock1['D1조회구분'] = '0';
		inBlock1['D1고객번호'] = theApp.userInfo.getUserData('D1실명확인번호암호화');
		
		//queryData.printQueryData();
		queryData.putPwInfo('InBlock1', 'D1고객번호', false, AQuery.OCR);
	},
	function(queryData)
	{
		if(queryData)
		{
			var blockData = queryData.getBlockData('OutBlock1')[0];
			queryData.printQueryData();
			if(blockData['D1등록여부']=='0'||blockData['D1등록여부']=='9'){	//고객이고 정보없을경우 0, 고객아닌경우 9
				thisObj.sendSACMT469();
			}
			else{	//고객이고 정보있을경우 1
				thisObj.correct_sendSACMT469();
			}
		}
	});	//SACMT469 전송시 펑션키 5 조회시 C
};

//고객 인증 정보 등록
@function MS1005_T05:sendSACMT469(){
	var thisObj = this;
	var mView = this.loadView;
	var phoneNum = theApp.userInfo.getUserData('D1이동전화식별번호')+theApp.userInfo.getUserData("D1이동전화국번호")+theApp.userInfo.getUserData("D1이동전화일련번호");
	
	var carrier = mView.getTelDbx();

	QryRequest.request('SACMT469',
	function(queryData)
	{
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1처리구분'] = '1';
		inBlock1['D1조회구분'] = '0';
		inBlock1['D1고객번호'] = theApp.userInfo.getUserData('D1실명확인번호암호화');
		inBlock1['D1내외국인구분'] = '0'
		inBlock1['D1휴대폰번호'] = phoneNum;
		inBlock1['D1전화구분'] = carrier;
		queryData.printQueryData();
		queryData.putPwInfo('InBlock1', 'D1고객번호', false, AQuery.OCR);
	},
					   function(queryData)
					   {
		if(queryData)
		{
			var blockData = queryData.getBlockData('OutBlock1')[0];
			queryData.printQueryData();
			if(blockData['D1등록여부']=='1'){
				theApp.saveStep('3', function(){
					thisObj.getContainer().nextView();
				});
			}
		}
	}, ''/*lazyfuntion*/, '5');	//SACMT469 전송시 펑션키 5 조회시 C
};

//고객 인증 정보 정정
@function MS1005_T05:correct_sendSACMT469(){
	var thisObj = this;
	var mView = this.loadView;
	var phoneNum = theApp.userInfo.getUserData('D1이동전화식별번호')+theApp.userInfo.getUserData("D1이동전화국번호")+theApp.userInfo.getUserData("D1이동전화일련번호");
	
	var carrier = mView.getTelDbx();

	QryRequest.request('SACMT469',
	function(queryData)
	{
		var inBlock1 = queryData.getBlockData('InBlock1')[0];
		inBlock1['D1처리구분'] = '2';
		inBlock1['D1조회구분'] = '0';
		inBlock1['D1고객번호'] = theApp.userInfo.getUserData('D1실명확인번호암호화');
		inBlock1['D1내외국인구분'] = '0'
		inBlock1['D1휴대폰번호'] = phoneNum;
		inBlock1['D1전화구분'] = carrier;
		//queryData.printQueryData();
		queryData.putPwInfo('InBlock1', 'D1고객번호', false, AQuery.OCR);
	},
					   function(queryData)
					   {
		if(queryData)
		{
			var blockData = queryData.getBlockData('OutBlock1')[0];
			//queryData.printQueryData();
			theApp.saveStep('3', function(){
				thisObj.getContainer().nextView();
			});
		}
	}, ''/*lazyfuntion*/, '5');	//SACMT469 전송시 펑션키 5 조회시 C
};