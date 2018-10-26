using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.Application;

class MyWatchView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() {
    
    }

    function onUpdate(dc) {
   		View.onUpdate(dc);
    }

    function onHide() {
    
    }

    function onExitSleep() {
    
    }

    function onEnterSleep() {
    
    }

}
