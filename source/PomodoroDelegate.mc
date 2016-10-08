using Toybox.WatchUi as Ui;

class PomodoroDelegate extends Ui.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() {
        Ui.pushView(new Rez.Menus.MainMenu(), new PomodoroMenuDelegate(), Ui.SLIDE_UP);
        return true;
    }

}