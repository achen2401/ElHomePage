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

function adjustImageGalleryDV(){
    var img = document.getElementById("galleryImage");
    if (img) {
        img.style.height = (parseInt(window.innerHeight/2)) + parseInt(window.innerHeight/12)  + "px";
        img.style.width = (parseInt(window.innerWidth/2) + parseInt(window.innerWidth/4))+ "px";
    }

}

function handleClick(obj, category) {
    //alert(category)
    switch(category) {
        case "labMembers":
            document.getElementById('labImage').src= obj.getAttribute('imgsrc');
            //var itemId = obj.getAttribute("itemid");
            //document.getElementById("labImageArrow:" + itemId).style.display = "inline";
            //var images = document.getElementsByName("labImageArrow");
            //alert(itemId)
            //for (var i = 0; i < images.length; i++){
               // if (images[i].getAttribute("itemid") != itemId) images[i].style.display = "none";
            //}
            break;
        case "imageGallery":
            //alert("window innerHeight: " + window.innerHeight + " window innerWidth: " + window.innerWidth)
            var arrowId = obj.getAttribute("id");
            var img = document.getElementById("galleryImage");
            var id = img.getAttribute("itemid");
            var imgTitle = document.getElementById("galleryImageTitle");

            //adjustImageGalleryDV();
            //alert(arrowId)
            if (arrowId == "galleryLeftArrow") {
                id = parseInt(id) - 1;
                if (id > 0) {
                    //if (id != 0) {
                        img.setAttribute("itemid", id);
                        img.src = arrGalleryImages[id].imgsrc;
                        imgTitle.innerHTML = arrGalleryImages[id].title;
                        img.style.height = parseInt(window.innerHeight/2) * parseInt(arrGalleryImages[id].hfactor);
                        img.style.width = parseInt(window.innerWidth/2) * parseInt(arrGalleryImages[id].wfactor);
                        obj.style.opacity = 1;

                    //}

                } else {
                    img.setAttribute("itemid", "0");
                    img.src = arrGalleryImages[0].imgsrc;
                    imgTitle.innerHTML = arrGalleryImages[0].title;
                    img.style.height = parseInt(window.innerHeight/2) * parseInt(arrGalleryImages[0].hfactor);
                    img.style.width = parseInt(window.innerWidth/2) * parseInt(arrGalleryImages[0].wfactor);

                    obj.style.opacity = 0.7;
                    
                }

                document.getElementById("galleryRightArrow").style.opacity = 1;
            } else {
                id = parseInt(id) + 1;
                //alert(arrGalleryImages[id].title)
                if (id < (arrGalleryImages.length - 1)) {
                    //alert("h:" + parseInt(arrGalleryImages[id].hfactor) + " w: " + parseInt(arrGalleryImages[id].wfactor))
                    //if (id != 0) {
                        img.setAttribute("itemid", id);
                        img.src = arrGalleryImages[id].imgsrc;
                        imgTitle.innerHTML = arrGalleryImages[id].title;
                        obj.style.opacity = 1;
                        img.style.height = parseInt(window.innerHeight/2) * parseInt(arrGalleryImages[id].hfactor);
                        img.style.width = parseInt(window.innerWidth/2) * parseInt(arrGalleryImages[id].wfactor);

                    //}

                } else {
                    //alert("h:" + parseInt(arrGalleryImages[(arrGalleryImages.length - 1)].hfactor) + " w: " + parseInt(arrGalleryImages[(arrGalleryImages.length - 1)].wfactor))
                    img.setAttribute("itemid", (arrGalleryImages.length - 1));
                    img.src = arrGalleryImages[(arrGalleryImages.length - 1)].imgsrc;
                    imgTitle.innerHTML = arrGalleryImages[(arrGalleryImages.length - 1)].title;
                    img.style.height = parseInt(window.innerHeight/2) * parseInt(arrGalleryImages[(arrGalleryImages.length - 1)].hfactor);
                    img.style.width = parseInt(window.innerWidth/2) * parseInt(arrGalleryImages[(arrGalleryImages.length - 1)].wfactor);

                    obj.style.opacity = 0.7;
                    
                }

                document.getElementById("galleryLeftArrow").style.opacity = 1;

            }


    }

}
var mainApp = angular.module("mainApp", ["ngRoute"]);
var arrGalleryImages = new Array();

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
        arrGalleryImages = response;
    });
    $http.get(categoriesPath).success(function (response) {
        $scope.categories = response;
    });



    $scope.defaultLabImage = "./images/wholelab-new.jpg";
    $scope.defaultImageGallery = "./images/gallery1.jpg";
    $scope.defaultImageGalleryTitle = "Engrafted ERMS tumor in the cranium from transplantation";
    //$scope.adjustImageGalleryDV = function() {

       // adjustImageGalleryDV();
    //}

    $scope.defaultImageGalleryHeight = (parseInt(window.innerHeight/4)) + parseInt(window.innerHeight/16)  + "px";
    $scope.defaultImageGalleryWidth = (parseInt(window.innerWidth/4) + parseInt(window.innerWidth/9))+ "px";


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


$(function () {
    $("#boo_dialog").dialog({ autoOpen: false, modal: true, resizable: true, autoResize: true, dialogClass:"booDialog"});
})

