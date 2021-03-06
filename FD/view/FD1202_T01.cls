
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1202_T01()
{
	@super();	
}
@extends AView;


//초기화
@function FD1202_T01:onArrInit()
{		
};


@function FD1202_T01:init(context, evtListener)
{
	@super.init(context, evtListener);	
			
	this.accView = this.findCompById('AccView').loadView;
	this.accDbx = this.accView.accDbx;
	this.secureTxf = this.accView.secureTxf;
};


//화면이 활성화된 후 이벤트
@function FD1202_T01:onActiveDone(reload)
{
	@super.onActiveDone(reload);		
	this.accView.doInitAccInfo(0);	
};


//화면이 소멸되기 전 이벤트
@function FD1202_T01:onWillDeactive(reload)
{		
	this.onArrInit();
};
