using Toybox.Application as App;
using Toybox.Graphics as Gfx;
using Toybox.System as Sys;
using Toybox.WatchUi as Ui;

const FACTORY_COUNT_24_HOUR = 3;
const FACTORY_COUNT_12_HOUR = 4;
const MINUTE_FORMAT = "%02d";

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
        var time = values[0] + Ui.loadResource(Rez.Strings.timeSeparator) + values[2].format(MINUTE_FORMAT);
        if(values.size() == FACTORY_COUNT_12_HOUR) {
            time += " " + Ui.loadResource(values[3]);
        }
        App.getApp().setProperty("time", time);

        Ui.popView(Ui.SLIDE_IMMEDIATE);
    }
}
