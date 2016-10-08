using Toybox.WatchUi as Ui;
using Toybox.Timer as Timer;

var timer;

var count = 1500;

class PomodoroView extends Ui.View {

    function initialize() {
        View.initialize();
    }
    
    function callback()
    {
        count -= 1;
        if (count == 0) {
          onBreak();
        }
        else {
          Ui.requestUpdate();
        }
    }

    function onBreak()
    {
      count = 300;
      timer.start( method(:callback), 1000, true );
    }

    //! Load your resources here
    function onLayout(dc) {
        //setLayout(Rez.Layouts.MainLayout(dc));
                
        timer = new Timer.Timer();

        timer.start( method(:callback), 1000, true );
    }

    //! Called when this View is brought to the foreground. Restore
    //! the state of this View and prepare it to be shown. This includes
    //! loading resources into memory.
    function onShow() {
    }

    //! Update the view
    function onUpdate(dc) {
        // Call the parent onUpdate function to redraw the layout
        //View.onUpdate(dc);
        var string;

        dc.setColor( Gfx.COLOR_BLACK, Gfx.COLOR_BLACK );
        dc.clear();
        dc.setColor( Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT );
        string = "Count: " + count / 60 + ":" + count % 60;
        dc.drawText( 40, (dc.getHeight() / 2), Gfx.FONT_MEDIUM, string, Gfx.TEXT_JUSTIFY_LEFT );
    }

    //! Called when this View is removed from the screen. Save the
    //! state of this View here. This includes freeing resources from
    //! memory.
    function onHide() {
    }

}
