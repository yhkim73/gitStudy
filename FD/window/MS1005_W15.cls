
/**
Constructor
Do not call Function in Constructor.
*/
@class MS1005_W15(containerId)
{
	@super(containerId);

	this.QryTpCode = 1; //1 도로명, 2 지번
	
}
@extends BaseWindow;


@function MS1005_W15:onReady()
{
	@super.onReady();

	this.guidLbl1 = this.findCompById('GuidLbl1');

	this.addrTxt1 = this.findCompById('AddrTxt1');
	this.cancelBtn1 = this.findCompById("CancelBtn1");
	
	this.addrGrid = this.findCompById('AddrGrid');
	this.addrGrid.setDelegator(this);
	
};


//리스트뷰 + 항목뷰 바인드
@function MS1005_W15:bindData(item, data, listview)
{
	if(item.view.setData){
		item.view.setData(data);
	}
};

@function MS1005_W15:onCloseBtnClick(comp, info)
{
	this.close(0);
};

@function MS1005_W15:onSearchBtnClick(comp, info)
{
	if(!this.addrTxt1.getText()) return;
	
	//2018.08.06 기존 주소 찾기 주석 처리 kjk
	/*this.contiKey = null;
	this.sendSCMAQ071();*/
	
	//2018.08.06 오픈api 이용 주소찾기
	this.addrGrid.removeAllItems();
	this.contiKey = '1';
	this.searchAddrOpenAPI();
};

@function MS1005_W15:searchAddrOpenAPI()
{
	var thisObj = this;
	
	//next키가 없으면 그리드 초기화
	if(!thisObj.contiKey)
	{
		thisObj.addrGrid.removeAllItems();
	}
	
	AppManager.beginOltp();
	
	var countPerPage = '20';
 	var confmKey = 'U01TX0FVVEgyMDE4MDcyNTA5MjYxMDEwODAzMTg=';
 	var keyword = thisObj.addrTxt1.getText();
	
	var whoisApiUrl = "http://www.juso.go.kr/addrlink/addrLinkApiJsonp.do?resultType=json&currentPage="+thisObj.contiKey+"&countPerPage="+countPerPage+"&confmKey="+confmKey+"&keyword="+keyword;
 	
 	var resultPage = new XMLHttpRequest();
	resultPage.open( "GET", whoisApiUrl, false );
	resultPage.send( null );
	
	var str1 = resultPage.responseText.substring(1);
 	var jsonStr = JSON.parse(str1.substring(0,str1.length - 1));
	
	if (jsonStr.results.common.errorCode == 0) {
	
		AppManager.endOltp();
	
		// 더보기 계산	
		thisObj.MaxCurrentPage = Math.ceil(jsonStr.results.common.totalCount/countPerPage);
		thisObj.contiKey = jsonStr.results.common.currentPage;

		for( var i = 0;  i < jsonStr.results.juso.length; i++)
		{					
			var data = jsonStr.results.juso[i];					
			var addrData = [{
				"zipNo":data['zipNo']
				,"roadAddr":data['roadAddr']
				,"jibunAddr":data['jibunAddr']
			}];
 			thisObj.addrGrid.addItem('FD/view/MS1005_L03.lay', addrData, false);
		}
		afc.log('thisObj.contiKey :: ' + thisObj.contiKey);
		afc.log('MaxCurrentPage :: ' + thisObj.MaxCurrentPage);
		if (thisObj.MaxCurrentPage > thisObj.contiKey) {
			thisObj.contiKey++;
		} else {
			AToast.show('마지막 목록입니다');
		}		
	} else {
		AppManager.endOltp();
		AToast.show('주소 API 통신 오류');
	}	
};

@function MS1005_W15:onAddrGridSelect(comp, info)
{
	//2018.08.06 오픈api 이용 주소찾기
	var item =this.addrGrid.getSelectItem().view.getData();
	
	var zipCode = item[0].zipNo;
	var addr1   = item[0].roadAddr;

	this.close([zipCode, addr1]);
};

/*********   x 버튼 이벤트 ***************************/

@function MS1005_W15:onCancelBtn1Click(comp, info)
{
	this.addrTxt1.setText("");
	comp.$ele.hide();
};

/*********   x 버튼 이벤트 ***************************/

@function MS1005_W15:onAddrTxtChange(comp, info)
{
	var AddrTxt = comp.getText();
	var AddrName = comp.getComponentId();
	
	if(AddrName == "AddrTxt1") {
	
		if(AddrTxt.length == 0) {
			this.cancelBtn1.$ele.hide();
		} else {
			this.cancelBtn1.$ele.show();
		}
	}
};

@function MS1005_W15:onAddrGridScrollBottom(comp, info)
{
	if (this.MaxCurrentPage > this.contiKey)
	{
		//2018.08.06 오픈api 이용 주소찾기
		this.searchAddrOpenAPI();
	}
	else
	{	
		AToast.show('마지막 목록입니다');
	}

};
