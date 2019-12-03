using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.UserProfile;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Math;

class LifeProgressView extends WatchUi.WatchFace {

	var totalDays = 365;
	var daysInMonth = [31,28,31,30,31,30,31,31,30,31,30,31]; 
	var maxAge = 80;
    
    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        var batteryView = View.findDrawableById("BatteryLabel");        
        var myStats = System.getSystemStats();
        var batteryLeft = Math.round(myStats.battery);
        var batteryLeftString = Lang.format("battery $1$%", [batteryLeft]);
        
        if (batteryLeft <= 10) {
	        batteryView.setColor(Graphics.COLOR_RED);
        	batteryView.setText(batteryLeftString);
        } else if (batteryLeft <= 20) {
	        batteryView.setColor(Graphics.COLOR_LT_GRAY);
        	batteryView.setText(batteryLeftString);
        } else if (batteryLeft <= 25) {
	        batteryView.setColor(Graphics.COLOR_DK_GRAY);
        	batteryView.setText(batteryLeftString);
        }

        var today = new Time.Moment(Time.today().value());
        var day = Gregorian.info(today, Time.FORMAT_MEDIUM);
        var dayOfWeekString = Lang.format("$1$ $2$, $3$", [day.month, day.day, day.day_of_week]);
        var dayOfWeekView = View.findDrawableById("WeekDayLabel");        
        dayOfWeekView.setText(dayOfWeekString);

		var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var timeLabelView = View.findDrawableById("TimeLabel");
        timeLabelView.setText(timeString);

        var daysInYearView = View.findDrawableById("ProgressLabel");
        if(clockTime.min == 59) {
        	daysInYearView.setText(getLifeProgress());
        } else {
        	daysInYearView.setText(getDayOfYear());
        }        

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

	function getLifeProgress(){
		var profile = UserProfile.getProfile();
		var birthYear = profile.birthYear;
        var day = Gregorian.info(new Time.Moment(Time.today().value()), Time.Time.FORMAT_MEDIUM);
		var percents = 100 * (day.year - birthYear) / maxAge;		
        return Lang.format("life $1$%", [percents]);
	}

	function getDayOfYear() {
	    var dayShort = Gregorian.info(new Time.Moment(Time.today().value()), Time.FORMAT_SHORT);
	    var daysPassed = dayShort.day;
        for(var i = 0; i < dayShort.month - 1; i += 1) {
			daysPassed = daysPassed + daysInMonth[i];
		}
		var dayOfYearPercent = Math.round(100 * daysPassed / totalDays);
        return Lang.format("year $1$%", [dayOfYearPercent]);
    }
    
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }

}
