//!
//! Copyright 2015 by Garmin Ltd. or its subsidiaries.
//! Subject to Garmin SDK License Agreement and Wearables
//! Application Developer Agreement.
//!

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
    	if (worksession_active) {
     		onStartBreak();
     	}
     	else {
     		onIdle();
     	}
    }
    
    Ui.requestUpdate();
}

function onBreak()
{
  // 300
  count = 300;
  title_string = "Relax";
  worksession_active = false;
  timer.start( method(:callback), 1000, true );
}

function onStart()
{
	// 1500
	count = 1500;
	title_string = "Keep Working!";
	worksession_active = true;
	timer.start( method(:callback), 1000, true );
}

function onStartBreak()
{
	Attention.playTone( 2 );
    Attention.vibrate( vibrateData );
	timer.stop();
	title_string = "Take a break";
}

function onIdle()
{
	Attention.playTone( 1 );
    Attention.vibrate( vibrateData );
	timer.stop();
	title_string = "Start work Session!";
}

class MyWatchView extends Ui.View
{

    
    function onLayout(dc)
    {
        timer = new Timer.Timer();
		onStart();
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
		if (worksession_active == true) {
			if (count > 0) {
				title_string = "No slacking!";
			}
			else {
				onBreak();
			}
    	}
    	else {
    		if (count > 0) {
    			count = 1;
    		}
    		else {
        		onStart();
        	}
        }
        return true;
	}
	
    function onMenu()
    {

    }
}
