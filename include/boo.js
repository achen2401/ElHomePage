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

function adjustHeight(id) {
    //$("#boo_content").css("height", parseInt(($(window).height() * 3) / 4) + "px");
    document.getElementById(id).style.height = parseInt((window.innerHeight * 3) / 4) + "px";
    //alert(parseInt((window.innerHeight * 3) / 4));

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

function handleClick(obj, category) {
    switch(category) {
        case "labMembers":
            document.getElementById('labImage').src= obj.getAttribute('imgsrc');
            var itemId = obj.getAttribute("itemid");
            document.getElementById("labImageArrow:" + itemId).style.display = "inline";
            var images = document.getElementsByName("labImageArrow");
            //alert(itemId)
            for (var i = 0; i < images.length; i++){
                if (images[i].getAttribute("itemid") != itemId) images[i].style.display = "none";
            }


    }

}
var mainApp = angular.module("mainApp", ["ngRoute"]);

mainApp.config(['$routeProvider', function ($routeProvider) {
    $routeProvider.

    when('/researchInterest', {
        templateUrl: 'researchInterest.htm',
        controller: 'booController'
    }).

    when('/publications', {
        templateUrl: 'publications.htm',
        controller: 'booController'
    }).

    when('/labMembers', {
         templateUrl: 'labMembers.htm',
         controller: 'booController'
    }).

     when('/imageGallery', {
         templateUrl: 'imageGallery.htm',
         controller: 'booController'
     }).
    otherwise({
        redirectTo: '/researchInterest'
    });
}]);


function getData($http, path) {
    var result;

    $http.get(path).success(function (response) {
        //alert(response)
        result = response;

    });

    return result;
}

mainApp.controller('booController', function ($scope, $http) {
    var publicationsPath = "./data/publications.txt";
    var researchInterestPath = "./data/researchInterest.txt";
    var labMembersPath = "./data/labMembers.txt";
    //var labMembersPath = "./data/data.php?method=labMembers"
    var imageGalleryPath = "./data/imageGallery.txt";
    var categoriesPath = "./data/categories.txt";


    $http.get(publicationsPath).success(function (response) {
        $scope.publications = response;
    });
    $http.get(researchInterestPath).success(function (response) {
        $scope.researchInterest = response;
    });
    $http.get(labMembersPath).success(function (response) {
        $scope.labMembers = response;
    });
    $http.get(imageGalleryPath).success(function (response) {
        $scope.imageGallery = response;
    });
    $http.get(categoriesPath).success(function (response) {
        $scope.categories = response;
    });



    $scope.defaultLabImage = "./images/wholelab-new.jpg"

    
    $scope.boo = {
    title: "Eleanor Chen, MD, PHD",
    institution: "University of Washington Medical Center",
    department: "Department of Pathology",
    subtitle: "Assistant Professor",
    email: "eleanor2@uw.edu",
    contactInfo: [{ "info": "University of Washington Medical Center" },
    { "info": "1959 NE Pacific St Box 357705" },
    { "info": "HSB Room K-072A" },
    { "info": "Lab: K-084" },
    { "info": "Office Phone: 206-616-5062" },
    { "info": "Lab Phone: 206-616-9118" }


    ]
    };
    
});


/*
$(function () {
    $("#boo_dialog").dialog({ autoOpen: false, modal: true, resizable: true, autoResize: true, dialogClass:"booDialog"});
});
*/
