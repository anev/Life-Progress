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
	var batteryThreshold5 = 5;
    var batteryThreshold10 = 10;
    var batteryThreshold20 = 20;
    
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
        var batteryLeft = 3;//Math.round(myStats.battery);
        if (batteryLeft <= batteryThreshold5) {
	        var batteryView = View.findDrawableById("BatteryLabel5");
	        var batteryLeftString = Lang.format("BATTERY ~5%", []);
        	batteryView.setText(batteryLeftString);
        } else if (batteryLeft <= batteryThreshold10) {
	        var batteryView = View.findDrawableById("BatteryLabel10");
	        var batteryLeftString = Lang.format("battery ~10%", []);
        	batteryView.setText(batteryLeftString);
        } else if (batteryLeft <= batteryThreshold20) {
	        var batteryView = View.findDrawableById("BatteryLabel20");
	        var batteryLeftString = Lang.format("battery ~20%", []);
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

        var daysInYearView = View.findDrawableById("DayInYearLabel");
        var dayOfYear = getDayOfYear();
        var dayOfYearPercent = Math.round(100 * dayOfYear / totalDays);
        var dayNumber = Lang.format("year $1$%", [dayOfYearPercent]);
        daysInYearView.setText(dayNumber);
        
        var lifePercent = getLifeProgress();
        var yearsInLifeView = View.findDrawableById("YearInLifeLabel");		
        var ageProgress = Lang.format("life $1$%", [lifePercent]);
        yearsInLifeView.setText(ageProgress);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc);
    }

	function getLifeProgress(){
		var profile = UserProfile.getProfile();
		var birthYear = profile.birthYear;
        var day = Gregorian.info(new Time.Moment(Time.today().value()), Time.Time.FORMAT_MEDIUM);
		return 100 * (day.year - birthYear) / maxAge;
	}

	function getDayOfYear() {
	    var dayShort = Gregorian.info(new Time.Moment(Time.today().value()), Time.FORMAT_SHORT);
	    var result = dayShort.day;
        for(var i = 0; i < dayShort.month - 1; i += 1) {
			result = result + daysInMonth[i];
		}
    	return result;
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
