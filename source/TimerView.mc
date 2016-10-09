using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Timer as Timer;
using Toybox.Attention as Attention;


var timer;
var count;
var title_string;
var worksession_active;

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
	count -= 1;
    if (count <= 0) {
    	if (state == WORKING) {
     		onWorkComplete();
     	}
     	else {
     		onBreakComplete();
     	}
    }
    
    Ui.requestUpdate();
}

function onStartBreak()
{
  count = BREAK_DURATION;
  title_string = "Relax";
  timer.start( method(:callback), 1000, true );
  state = BREAK;
}

function onStartWork()
{
	count = WORK_DURATION;
	title_string = "Keep Working!";
	timer.start( method(:callback), 1000, true );
	state = WORKING;
}

function onWorkComplete()
{
	Attention.playTone( 2 );
    Attention.vibrate( vibrateData );
	timer.stop();
	title_string = "Take a break";
	state = WORK_COMPLETE;
}

function onBreakComplete()
{
	Attention.playTone( 1 );
    Attention.vibrate( vibrateData );
	timer.stop();
	title_string = "Start work Session!";
	state = BREAK_COMPLETE;
}

class MyWatchView extends Ui.View
{

    
    function onLayout(dc)
    {
        timer = new Timer.Timer();
        count = WORK_DURATION;
  		title_string = "Start working";
  		state = IDLE;
    }

    function onUpdate(dc)
    {
        var string;

      	dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        string = count / 60 + ":" + count % 60;
        dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 50 , Gfx.FONT_MEDIUM, title_string, Gfx.TEXT_JUSTIFY_CENTER );
        dc.drawText( (dc.getWidth() / 2), (dc.getHeight() / 2) - 20, Gfx.FONT_NUMBER_HOT, string, Gfx.TEXT_JUSTIFY_CENTER );
    }

}

class InputDelegate extends Ui.BehaviorDelegate
{
	function onSelect()
	{
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
			// Set timer to 1 to skip break
			count = 1;
		}
		else if (state == BREAK_COMPLETE) {
			onStartWork();
		}
        return true;
	}
	
    function onMenu()
    {

    }
}
