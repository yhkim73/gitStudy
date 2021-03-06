
/**
Constructor
Do not call Function in Constructor.
*/
@class FD1204_W01(containerId)
{
	@super(containerId);

	//# Set layout url like this ...
	//this.url = 'folderName/FD4102_W01.lay';

	//TODO:edit here

}
@extends AWindow;


@function FD1204_W01:onReady()
{
	@super.onReady();

	this.button1 = this.findCompById('Button1');
	this.button2 = this.findCompById('Button2');
	this.button3 = this.findCompById('Button3');
	this.button4 = this.findCompById('Button4');
	
	this.datePicker1 = this.findCompById('DatePicker1');
	this.datePicker2 = this.findCompById('DatePicker2');
	this.label1 = this.findCompById('Label1');
	
	this.datePicker1.setValue(Utils.yyyymmdd(new Date()));
	this.datePicker2.setValue(Utils.yyyymmdd(new Date()));
	
	this.view6 = this.findCompById('View6');
	
	this.startDate = null;
	this.endDate = null;
	
	this.text1 = null;
	
	switch(this.dayType) {
		case 0:
			this.onButton1Click();
			break;
		case 1:
			this.onButton2Click();
			break;
		case 2:
			this.onButton3Click();
			break;
		case 3:
			this.onButton4Click();
			this.datePicker1.setValue(this.date[0]);
			this.datePicker2.setValue(this.date[1]);
			break;
	}
	
	//TODO:edit here

};


@function FD1204_W01:onButton1Click(comp, info)
{
	this.datePickerControl(false);
	this.button1.enable(false);
	this.button2.enable(true);
	this.button3.enable(true);
	this.button4.enable(true);
	
	this.text1 = '당일';
	
	this.startDate = Utils.yyyymmdd(new Date());
	this.endDate = Utils.yyyymmdd(new Date());
	
	this.dayType = 0;
};

@function FD1204_W01:onButton2Click(comp, info)
{
	this.datePickerControl(false);
	this.button2.enable(false);
	this.button1.enable(true);
	this.button3.enable(true);
	this.button4.enable(true);
	
	this.text1 = '1주일';
	
	var d = new Date()
	d.setMonth(d.getMonth() - 1);

	this.startDate = Utils.yyyymmdd(d);
	this.endDate = Utils.yyyymmdd(new Date());
	
	this.dayType = 1;

};

@function FD1204_W01:onButton3Click(comp, info)
{
	this.datePickerControl(false);
	this.button3.enable(false);
	this.button2.enable(true);
	this.button1.enable(true);
	this.button4.enable(true);
	
	this.text1 = '1개월';
	
	var d = new Date()
	d.setMonth(d.getMonth() - 3);

	this.startDate = Utils.yyyymmdd(d);
	this.endDate = Utils.yyyymmdd(new Date());
	
	this.dayType = 2;

};

@function FD1204_W01:onButton4Click(comp, info)
{
	this.datePickerControl(true);
	this.button4.enable(false);
	this.button2.enable(true);
	this.button3.enable(true);
	this.button1.enable(true);
	
	this.text1 = '직접입력';
	
	this.startDate = null;
	this.endDate = null;
	
	this.dayType = 3;

};

@function FD1204_W01:onOkBtnClick(comp, info)
{
	if(!this.startDate) {
		this.startDate = this.datePicker1.getValue();
		this.endDate = this.datePicker2.getValue();
	}
	this.close([this.startDate, this.endDate, this.text1, this.dayType]);
};

@function FD1204_W01:onCloseBtnClick(comp, info)
{
	this.close(-1);
};

@function FD1204_W01:datePickerControl(isTrue)
{
	if(isTrue) {
		this.datePicker1.enable(true);
		this.datePicker2.enable(true);
		
		this.datePicker1.removeClass('dis');
		this.datePicker2.removeClass('dis');	
	} else {
		this.datePicker1.enable(false);
		this.datePicker2.enable(false);
		
		this.datePicker1.addClass('dis');
		this.datePicker2.addClass('dis');
	}
};