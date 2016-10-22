using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;
using Toybox.Time as Time;
using Toybox.Attention as Attention;
using Toybox.Application as App;

var WORK_DURATION = 1500; // 1500
var BREAK_DURATION = 300; // 300

var STARTTIME_KEY = 1;
var STATE_KEY = 2;
var TITLE_KEY = 3;

var startTime;
var timer;
var timerDuration;
var title_string;

var toneIdx = 0;
var toneNames = [ "Alarm" ];

var IDLE = 0;
var WORKING = 1;
var WORK_COMPLETE = 2;
var BREAK = 3;
var BREAK_COMPLETE = 4;
var state;

var vibrateData = [
                    new Attention.VibeProfile(  25, 100 ),
                    new Attention.VibeProfile(  50, 100 ),
                    new Attention.VibeProfile(  75, 100 ),
                    new Attention.VibeProfile( 100, 100 ),
                    new Attention.VibeProfile(  75, 100 ),
                    new Attention.VibeProfile(  50, 100 ),
                    new Attention.VibeProfile(  25, 100 )
                  ];

function callback()
{
	Ui.requestUpdate();
}

function onStartBreak()
{
	startTime = Time.now();
	timerDuration = BREAK_DURATION;
	title_string = "Relax";
	state = BREAK;
}

function onStartWork()
{
	startTime = Time.now();
	timerDuration = WORK_DURATION;
	title_string = "Keep Working!";
	state = WORKING;
}

function onWorkComplete()
{
	Attention.playTone( 2 );
    Attention.vibrate( vibrateData );
	title_string = "Take a break";
	state = WORK_COMPLETE;
}

function onBreakComplete()
{
	Attention.playTone( 1 );
    Attention.vibrate( vibrateData );
	title_string = "Start work Session!";
	state = BREAK_COMPLETE;
}

class MyWatchView extends Ui.View
{   
	// Called on Load
    function onLayout(dc)
    {      
  		timer = new Timer.Timer();
        timer.start( method(:callback), 500, true );
    }
    
    // Called when app is brought into view
    function onShow() {
     	var app = App.getApp();
 		
 		var loadedTime = app.getProperty("STARTTIME_KEY");
 		startTime = new Time.Moment(loadedTime);
 		state = app.getProperty("STATE_KEY");
 		title_string = app.getProperty("TITLE_KEY");
 		timerDuration = app.getProperty("DURATION_KEY");
 		
 		WORK_DURATION = app.getProperty("WORKUNIT_KEY");
		BREAK_DURATION = app.getProperty("BREAKUNIT_KEY");
		
		System.println("WORK " + WORK_DURATION);
		System.println("dur " + timerDuration);
 		
 		if (loadedTime == null) {
  			startTime = Time.now();
  		}
  		if (state == null) {
	  		state = IDLE;
  		}
  		if (title_string == null) {
	  		title_string = "Start work session!";
  		}
  		if (timerDuration == null) {
  			timerDuration = 0;
  		}
    }

    function onUpdate(dc)
    {
    	var timeLeft = 0;
    	if (state == WORKING || state == BREAK ) {
	    	var timeElapsed = Time.now().subtract(startTime);
	        timeLeft = timerDuration - timeElapsed.value();
		    if (timeLeft <= 0) {
		    	timeLeft = 0;
		    	if (state == WORKING) {
		     		onWorkComplete();
		     	}
		     	else {
		     		onBreakComplete();
		     	}
		    }
	    }
        
      	dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        var string;
        if ( (timeLeft / 60 / 60) >= 1 ) {
        	string = timeLeft / 60 / 60 + ":" + timeLeft / 60 % 60 + ":" + timeLeft % 60;
        }
        else {
        	string = timeLeft / 60 + ":" + timeLeft % 60;
    	}
        dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 50 , Gfx.FONT_MEDIUM, title_string, Gfx.TEXT_JUSTIFY_CENTER );
        dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 20, Gfx.FONT_NUMBER_HOT, string, Gfx.TEXT_JUSTIFY_CENTER );
    }
    
    function onHide() {
    	var app = App.getApp();
    	app.setProperty("STARTTIME_KEY", startTime.value());
    	app.setProperty("STATE_KEY", state);
    	app.setProperty("TITLE_KEY", title_string);
    	app.setProperty("DURATION_KEY", timerDuration);
    }

}

class InputDelegate extends Ui.BehaviorDelegate
{
	function onSelect()
	{
		var time = Time.now().subtract(startTime);
        System.println("Time " + time.value());
		if (state == IDLE) {
			onStartWork();
		}
		else if (state == WORKING) {
			title_string = "No slacking!";
		}
		else if (state == WORK_COMPLETE) {
			onStartBreak();
		}
		else if (state == BREAK) {
			timerDuration = 0;
		}
		else if (state == BREAK_COMPLETE) {
			onStartWork();
		}
        return true;
	}
	
    function onMenu()
    {
        Ui.pushView(new TimePicker(), new TimePickerDelegate(), Ui.SLIDE_IMMEDIATE);
        return true;
    }
    
    function onNextPage()
    {
		System.println("In Reset");
		onBreakComplete();
    }
}
