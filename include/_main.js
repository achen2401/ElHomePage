/*! viewportSize | Author: Tyson Matanich, 2013 | License: MIT */

(function(n){n.viewportSize={},n.viewportSize.getHeight=function(){return t("Height")},n.viewportSize.getWidth=function(){return t("Width")};var t=function(t){var f,o=t.toLowerCase(),e=n.document,i=e.documentElement,r,u;return n["inner"+t]===undefined?f=i["client"+t]:n["inner"+t]!=i["client"+t]?(r=e.createElement("body"),r.id="vpw-test-b",r.style.cssText="overflow:scroll",u=e.createElement("div"),u.id="vpw-test-d",u.style.cssText="position:absolute;top:-1000px",u.innerHTML="<style>@media("+o+":"+i["client"+t]+"px){body#vpw-test-b div#vpw-test-d{"+o+":7px!important}}<\/style>",r.appendChild(u),i.insertBefore(r,e.head),f=u["offset"+t]==7?i["client"+t]:n["inner"+t],i.removeChild(r)):f=n["inner"+t],f}})(this);

/**
 * How to create a parallax scrolling website
 * Author: Petr Tichy
 * URL: www.ihatetomatoes.net
 * Article URL: http://ihatetomatoes.net/how-to-create-a-parallax-scrolling-website/
 */

( function( $ ) {
	
	// Setup variables
	$window = $(window);
	$slide = $('.homeSlide');
	$slideTall = $('.homeSlideTall');
	$slideTall2 = $('.homeSlideTall2');
	$body = $('body');


    

	
    //FadeIn all sections   
	$body.imagesLoaded( function() {
		setTimeout(function() {
		      
		      // Resize sections
		      adjustWindow();
		      
		      // Fade in sections
			  $body.removeClass('loading').addClass('loaded');
			  
		}, 1000);
	});
	
	function adjustWindow(){
		
		// Init Skrollr
		var s = skrollr.init({
			forceHeight: false,
			smoothScrolling: false,
    		mobileDeceleration: 0.004,
		    render: function(data) {
		    
		        //Debugging - Log the current scroll position.
		        //console.log(data.curTop);
		    }
		});
		
		// Get window size
	    winH = $window.height();
	    winW = $window.width();
	    
	   
	    // Keep minimum height 550
	    if(parseInt(winH) <= 570) {
	    	winH = 570;
	    	
		} 
	    
	    // Resize our slides
	    $slide.height(winH);
	    
    	$slideTall.height(winH*2);
    	$slideTall2.height(winH*3);
	    
	    
	    // Refresh Skrollr after resizing our sections
	    s.refresh($('.homeSlide'));
	    
	}

	$window.resize(function() {adjustWindow()});
		
} )( jQuery );



