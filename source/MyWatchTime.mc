using Toybox.WatchUi;
using Toybox.Application;
using Toybox.Graphics;
using Toybox.Math;
using Toybox.Time;
using Toybox.Time.Gregorian;

class MyWatchTime extends WatchUi.Drawable {

    function initialize() {
        var dictionary = { :identifier => "Time" };
        Drawable.initialize(dictionary);
    }

    function draw(dc) {
    	var clockTime = System.getClockTime();
        var center = new Point(dc.getWidth() / 2, dc.getHeight() / 2);
        var top = new Point(center.x, 0);
        var bottom = new Point(center.x, dc.getHeight());
        drawMarkings(dc, center, top, bottom);
        drawDate(dc, bottom, top);
		drawHourHand(dc, center, top, clockTime.hour, clockTime.min, clockTime.sec);
		drawMinuteHand(dc, center, top, clockTime.min, clockTime.sec);
		drawSecondHand(dc, center, top, clockTime.sec);
		drawCenter(dc, center);
    }
    
    function drawMarkings(dc, center, top, bottom) {
    	var size = center.y / 20;
    	for (var i = 1; i < 6; i++) {
    		drawRotatedLine(dc, center, top, new Point(top.x, size), Graphics.COLOR_WHITE, Math.toRadians(i * 30));
    	}
    	for (var i = 7; i < 12; i++) {
    		drawRotatedLine(dc, center, top, new Point(top.x, size), Graphics.COLOR_WHITE, Math.toRadians(i * 30));
    	}
    	dc.drawText(top.x, top.y - 6, Graphics.FONT_XTINY, "12", Graphics.TEXT_JUSTIFY_CENTER);
    	dc.drawText(bottom.x, bottom.y - Graphics.getFontHeight(Graphics.FONT_XTINY), Graphics.FONT_XTINY, "6", Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function drawDate(dc, center, bottom) {
    	var today = Gregorian.info(Time.now(), Time.FORMAT_MEDIUM);
		var dateString = Lang.format("$1$ $2$ $3$", [ today.day_of_week, today.day, today.month ]);
		dc.drawText(bottom.x, (bottom.y + center.y) / 3 * 2, Graphics.FONT_XTINY, dateString, Graphics.TEXT_JUSTIFY_CENTER);
    }
    
    function drawHourHand(dc, center, top, hour, min, sec) {
    	var radians = Math.toRadians(((hour * 3600) + (min * 60) + sec) / 120);
    	var divider = new Point(center.x, center.y / 7 * 3);
    	var end = new Point(center.x, divider.y - (center.y / 10));
    	drawRotatedPolygon(dc, center, flatHand(center, end, 4), Graphics.COLOR_BLACK, radians);												// Hand Outline
    	drawRotatedPolygon(dc, center, flatHand(center, divider, 3), Graphics.COLOR_WHITE, radians);											// Hand Stem
    	drawRotatedPolygon(dc, center, flatHand(divider, end, 3), Graphics.COLOR_ORANGE, radians);		    									// Hand Tip
    	drawRotatedLine(dc, center, new Point(divider.x - 1, divider.y), new Point(divider.x + 1, divider.y), Graphics.COLOR_BLACK, radians); 	// Hand Divider
    }
    
    function drawMinuteHand(dc, center, top, min, sec) {
    	var radians = Math.toRadians(((min * 60) + sec) / 10);
    	var divider = new Point(center.x, center.y / 10);
    	var end = new Point(center.x, divider.y - (center.y / 10));
    	drawRotatedPolygon(dc, center, flatHand(center, end, 4), Graphics.COLOR_BLACK, radians);												// Hand Outline
    	drawRotatedPolygon(dc, center, flatHand(center, divider, 3), Graphics.COLOR_WHITE, radians);											// Hand Stem
    	drawRotatedPolygon(dc, center, flatHand(divider, end, 3), Graphics.COLOR_ORANGE, radians);		    									// Hand Tip
		drawRotatedLine(dc, center, new Point(divider.x - 1, divider.y), new Point(divider.x + 1, divider.y), Graphics.COLOR_BLACK, radians); 	// Hand Divider
    }
    
    function drawSecondHand(dc, center, top, sec) {
        var radians = Math.toRadians(sec * 6);
    	var divider = new Point(center.x, center.y / 10);
    	var end = new Point(center.x, divider.y - (center.y / 10));
    	drawRotatedPolygon(dc, center, flatHand(center, end, 2), Graphics.COLOR_BLACK, radians);												// Hand Outline
    	drawRotatedPolygon(dc, center, flatHand(center, divider, 1), Graphics.COLOR_LT_GRAY, radians);											// Hand Stem
		drawRotatedPolygon(dc, center, flatHand(divider, end, 1), Graphics.COLOR_ORANGE, radians);												// Hand Tip
		drawRotatedLine(dc, center, new Point(divider.x - 1, divider.y), new Point(divider.x + 1, divider.y), Graphics.COLOR_BLACK, radians); 	// Hand Divider
    }
    
    function drawCenter(dc, center) {
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    	dc.fillCircle(center.x, center.y, 7);
    	dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
    	dc.fillCircle(center.x, center.y, 6);
    	dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_TRANSPARENT);
    	dc.fillCircle(center.x, center.y, 3);
    }
    
    function flatHand(root, tip, width) {
    	return [
    		root, 
    		new Point(root.x - width, root.y), 
    		new Point(root.x - width, tip.y), 
    		new Point(root.x + width, tip.y), 
    		new Point(root.x + width, root.y), 
    		root
    	];
    }
    
    function drawRotatedPolygon(dc, center, points, color, radians) {
    	var drawable = [];
    	for (var i = 0; i < points.size(); i++) {
    		drawable.add(points[i].rotateAround(center, radians).drawable());
		}
    	dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    	dc.fillPolygon(drawable);
    }
    
    function drawRotatedLine(dc, center, pointOne, pointTwo, color, radians) {
    	var rotatedOne = pointOne.rotateAround(center, radians);
    	var rotatedTwo = pointTwo.rotateAround(center, radians);
   		dc.setColor(color, Graphics.COLOR_TRANSPARENT);
    	dc.drawLine(rotatedOne.x, rotatedOne.y, rotatedTwo.x, rotatedTwo.y);
    }
   
}

class Point {
	
	var x;
	var y;
	
	function initialize(x, y) {
		self.x = x;
		self.y = y;
	}
	
	function rotateAround(center, radians) {
		var cos = Math.cos(radians);
		var sin = Math.sin(radians);
		return new Point(cos * (self.x - center.x) - sin * (self.y - center.y) + center.x,sin * (self.x - center.x) + cos * (self.y - center.y) + center.y);
	}
	
	function drawable() {
		return [self.x, self.y];
	}
	
}
