using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

class TimePicker extends Ui.Picker {

    function initialize() {
        var title = new Ui.Text({:text=>Rez.Strings.pickerTitle, :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_BOTTOM, :color=>Gfx.COLOR_WHITE});
        var separator = new Ui.Text({:text=>Rez.Strings.separator, :locX =>Ui.LAYOUT_HALIGN_CENTER, :locY=>Ui.LAYOUT_VALIGN_CENTER, :color=>Gfx.COLOR_WHITE});
        Picker.initialize({:title=>title, :pattern=>[new NumberFactory(1,90,1), separator, new NumberFactory(0,30,1,{:font=>Gfx.FONT_NUMBER_MEDIUM})]});
    }

    function onUpdate(dc) {
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();
        Picker.onUpdate(dc);
    }
}

class TimePickerDelegate extends Ui.PickerDelegate {
    function onCancel() {
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }

    function onAccept(values) {        
        var workUnit = values[0] * 60;
        var breakUnit = values[2] * 60;
        
        System.println("Work: " + workUnit);
        System.println("Break: " + breakUnit);
        
        App.getApp().setProperty("WORKUNIT_KEY", workUnit);
        App.getApp().setProperty("BREAKUNIT_KEY", breakUnit);
        App.getApp().setProperty("STARTTIME_KEY", 0);
    	App.getApp().setProperty("STATE_KEY", 0);
    	App.getApp().setProperty("TITLE_KEY", "Start work session!");
        App.getApp().setProperty("DURATION_KEY", 0);
        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
