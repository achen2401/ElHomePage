function setContentVis(obj) {
	var id = $(obj).attr("id");
	var containerId = "cn_" + String(id).split("_")[1];
	
	//alert("id?? " + id)
	//if (!$(obj).hasClass("link_selected")) {
		//$(obj).removeClass("link");
		//$(this).addClass("link");
		$(this).addClass("link_selected");
		$(this).removeClass("link_over");
	//}
	
	//alert($(obj).hasClass("link_selected"));
	
	//alert( $(".nav div.link").length);
	
	$(".nav div").each(function() {
		//alert($(this).attr("id"));
		if (String($(this).attr("id")) == id) {
			//alert("HERERE???");
		
			$(this).css("font-weight", "bold");
			$(this).css("text-decoration", "none");
			$(this).css("color", "blue");
			$(this).css("cursor", "default");
			
			$(this).unbind("mouseover");
			$(this).unbind("mouseout");
		} else {
			$(this).css("font-weight", "normal");
			$(this).css("text-decoration", "underline");
			$(this).css("color", "blue");
			$(this).css("cursor", "pointer");
			$(this).mouseover( function() {
				$(this).addClass("link_over");
			});
			$(this).mouseout(function() {
				$(this).removeClass("link_over");
			});
			$(this).removeClass("link_selected");
		}
	});
	
	$(".cn").each(function() {
		if ($(this).attr("id") == containerId) {
			$(this).slideDown();
			
			
		} else $(this).hide();
	});
	

}

function adjustHeight() {
	$("#boo_content").css("height", parseInt(($(window).height() * 3) / 4) + "px");

}

function initImages() {

    setInterval("rotateImages()", 5000);
}

var iCount = 0;
var imgs = ["zebrafish2.jpg", "cells.jpg", "mousie.jpg"];
function rotateImages() {
    
    if (iCount > 1) iCount = 0;
    else iCount++;
    $("#nav_images").html("<img src='./images/" + imgs[iCount] + "' width='160' height='100'/>");
    //$("#nav_images").slideDown();

}

function setImage(obj, resize) {
    //alert("h: " + (parseInt($(obj).attr("height")) * 2) + " w: " + (parseInt($(obj).attr("width")) * 2));
    var h = resize ? (parseInt($(obj).attr("height")) * 2) : $(obj).attr("height");
    var w = resize ? (parseInt($(obj).attr("width")) * 2) : $(obj).attr("width");
    $("#boo_dialog").html("<img src='" + $(obj).attr("src") + "' height='" + h + "' width='" + w + "' />");
    $("#boo_dialog").dialog("option", { "title": $(obj).attr("title"), "width": w + 80, "height": "auto" });
    $("#boo_dialog").dialog("open");
}

$(function () {
    $("#boo_dialog").dialog({ autoOpen: false, modal: true, resizable: true, autoResize: true, dialogClass:"booDialog"});
});
