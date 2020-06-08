


var EverSafeManager = {};

EverSafeManager.REQUEST_SUCCESS = 0;
EverSafeManager.REQUEST_SUCCESS_TYPE3 = "0";
EverSafeManager.REQUEST_REJECT_TYPE3 = "1";
EverSafeManager.REQUEST_INTERNAL_ERROR_TYPE3 = "2";
EverSafeManager.REQUEST_TIMEOVER = 4;
EverSafeManager.curCntMgr = null;

EverSafeManager.relaunch = function()
{
	cordova.exec(null , null, "EverSafePlugin" , "relaunch", []);
};

EverSafeManager.getSessionIdAndToken = function()
{
	cordova.exec(null , null, "EverSafePlugin" , "getSessionIdAndToken", []);
};

EverSafeManager.getSessionIdAndTokenTask = function(connectManager)
{
	EverSafeManager.curCntMgr = connectManager;
	
	if(Define.EVER_SAFE) cordova.exec(null , null, "EverSafePlugin" , "getSessionIdAndTokenTask", []);
	else 
	{
		setTimeout(function()
		{
			EverSafeManager.getSessionIdAndTokenDone('KOSCOM','KOSCOM','KOSCOM');
		
		}, 300);
	}
};


//-----------------------------------------------------------------------------------------------------
//	네이티브에서 호출하는 콜백 함수
// 3세대: sessionId = "", token = value, deviceId = ""
// 1세대: sessionId = value, token = value, deviceId = value
EverSafeManager.getSessionIdAndTokenDone = function(sessionId, token, deviceId)
{
	//afc.log('★ id : ' + sessionId + '// toekn : ' + token + '// deviceId : ' + deviceId + '★');
	
	if(EverSafeManager.curCntMgr)
	{
		EverSafeManager.curCntMgr.everSafeCallback(sessionId, token, deviceId);
		EverSafeManager.curCntMgr = null;
	}
};
//------------------------------------------------------------------------------------------------------
