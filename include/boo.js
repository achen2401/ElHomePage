
var categories;
var w_factor = 2;
var h_factor = 2;
var w_divider = 4;
var h_divider = 4;


function initCollapse() {
    //alert($("#collapseOne").length )
    
    if ($("#collapseOne").length > 0 ) {
        //alert("w")
        $("#collapseOne").collapse("hide");
        $("#collapseOne").on("show.bs.collapse", function() {
               //alert("s")
              //window.scrollTo(0, (document.body.scrollHeight || document.documentElement.scrollHeight) + 50);
              //this.scrollIntoView({block: "end"});
              target = $("#fbottom")
              var of = $(this).offset();
              //alert(of.left + ", " + of.top)
              
              $("#boo_content").stop().css({"scrollTop": of.top}).animate({
                scrollTop: target.offset().top
              }, 500);
              //alert("h")
              //document.body.scrollTop = document.body.scrollHeight - document.body.clientHeight;
             
              //var element = $(this)[0];
              //element.scrollIntoView();

              // var myDiv = $("#collapseOne");
              // alert((document.body.scrollHeight - document.body.clientHeight))
              // myDiv.animate({
              //     scrollTop: document.body.scrollHeight - document.body.clientHeight
              //     }, 500);
              
        });
      

       // $("#collapseOne").on("hide.bs.collapse", function() {
       //     setTimeout('$("#labMembersContainer").find(".btn:first").click().focus();', 500);
       // });
        //initCollapse();
        //clearInterval(cVar);
    }
}


function adjustLabImage(labImage) {

    //alert("here")
    if (!hasValue(labImage)) labImage = document.getElementById("labImage");
    //var w = $(labImage).width();
    //var h = $(labImage).height();
    //var w = ($(window).width() * w_factor) / w_divider;
    //var h = ($(window).height() * h_factor) / h_divider;
    //var w = ($(window).width() * w_factor)
    //var h = ($(window).height() * h_factor)
   //$(labImage).css("width", w);
    //$(labImage).css("height", h);
    //alert("w: " + w + " h: " + h)
    $(labImage).show();

    //alert("w: " + $(labImage).attr("width") + " h: " + $(labImage).attr("height"))
}

function setPopover(targetID, contentID) {
    $("#" + targetID).popover();
    $("#" + targetID).popover({
         html: true, 
         content: function() {
            return $("#" + contentID).html();
         }
     });
}


function setContentVis(obj) {
	
    $(".menu").each(function() {
        $(this).removeClass("active");
    });
    $(obj).addClass("active");

    //alert(obj.id)

    if (obj.id == "cLabMembers") {
        
        setTimeout('$("#labMembersContainer").find(".btn:first").focus();', 50);
        //setTimeout('initCollapse();', 20);
        //setTimeout('setPopover("labMembers_flink", "labMembers_fcontent");', 100);
        //setTimeout("adjustLabImage();", 20);
        //if (!init_collapse) {
        //if (!init_collapse) {
        //alert("w")
            //init_collapse = true;
        //}
            //init_collapse = true;
        //}
    }
    //if (obj.id == "cImageGallery") {
           // setTimeout('$("#image1_imgChooser").click();', 15);
    //}
    
    setTimeout('adjustHeight("boo_content");', 5);
}

function adjustHeight(id) {
    //$("#boo_content").css("height", parseInt(($(window).height() * 3) / 4) + "px");
    document.getElementById(id).style.height = parseInt((window.innerHeight * 6) / 10) + "px";
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

function setImage(wObj, resize) {
    //alert("h: " + (parseInt($(obj).attr("height")) * 2) + " w: " + (parseInt($(obj).attr("width")) * 2));
    var obj = document.getElementById(wObj.getAttribute("imgid"));
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
            var labImage = document.getElementById('labImage');
            labImage.style.display = "none";
           // $("#loadingImage").show();
           // setTimeout("var lb = document.getElementById('labImage'); lb.src= '" + obj.getAttribute('imgsrc') + "';", 0);
           // setTimeout("var lb = document.getElementById('labImage'); $(lb).show(); $('#loadingImage').hide();", 30);
            $(".labMemberImage").each(function() {
                $(this).hide();
            })
            var itemId = obj.getAttribute("itemid");
            var memberImage = document.getElementById("labImage_" + itemId);
           // var w = ($(window).width() * w_factor) /w_divider;
            //var h = ($(window).height() * h_factor) /h_divider;
            //$(memberImage).css("width", w);
            //$(memberImage).css("height", h);
            adjustLabImage(memberImage);
            $(memberImage).show();
            

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
//var mainApp = angular.module("mainApp", ["ngRoute"]);
var mainApp = angular.module("mainApp", ["ui.router"]);
var arrGalleryImages = new Array();
var arrLabMembers = new Array();


mainApp.config(function($stateProvider, $urlRouterProvider, $locationProvider) {
  //
  // For any unmatched url, redirect to /state1
  $urlRouterProvider.otherwise("/researchInterest");
  //
  // Now set up the states
  $stateProvider
    .state('researchInterest', {
      url: "/researchInterest",
      templateUrl: "partials/researchInterest.html",
      controller: "booController"
    })
    .state('publications', {
      url: "/publications",
      templateUrl: "partials/publications.html",
      controller: "booController"
    })
    .state('labMembers', {
      url: "/labMembers",
      templateUrl: "partials/labMembers.html",
      controller: "booController"
    })
    .state('imageGallery', {
      url: "/imageGallery",
      templateUrl: "partials/imageGallery.html",
      controller: "booController"
    });

    $locationProvider.html5Mode(true);

    
});


/*
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
}]);*/


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

    $http.defaults.cache = true;

    $http.get(publicationsPath).success(function (response) {
        $scope.publications = response;
    });
    $http.get(researchInterestPath).success(function (response) {
        $scope.researchInterest = response;
    });
    $http.get(labMembersPath).success(function (response) {
        $scope.labMembers = response;
        arrLabMembers = response;
    });
    $http.get(imageGalleryPath).success(function (response) {
        $scope.imageGallery = response;
        arrGalleryImages = response;
    });
    $http.get(categoriesPath).success(function (response) {
        $scope.categories = response;
        categories = response;
    });



    $scope.defaultLabImage = "./images/wholelab07052016.jpeg";
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
    contactInfo: [
    { "info": "Office: HSB Room K-072A" },
    { "info": "Office Phone: 206-616-5062" },
    { "info": "Lab: HSB Room K-084" },
    { "info": "Lab Phone: 206-616-9118" }


    ]
    };
    
    angular.element(document).ready(function () {
        adjustHeight("boo_content");
       // initCollapse();
    });
});




$(function () {
    $("#boo_dialog").dialog({ autoOpen: false, modal: true, resizable: true, autoResize: true, dialogClass:"booDialog"});
});


$(document).ready(function() {
    
    setTimeout("init();", 300);

});

function hasValue(str) {
    return String(str) != "null"  && String(str) != "undefined"  && String(str) != "";
}

function preLoadImages() {
    for (var index = 0; index < arrLabMembers.length; index++) {
        if (hasValue(arrLabMembers[index].imgsrc)) $("body").append("<img style='display:none' id='tempimg" + arrLabMembers[index].id + "' src='" + arrLabMembers[index].imgsrc + "'/>");
    }
}

function showGalleryImage(obj) {
    if (obj) {

        var containerId = obj.getAttribute("containerId");
       
        $("#imageGalleryContainer .imageGalleryMember").each(function() {
            $(this).hide();
        });

        $("#imageGalleryContainer .imgChooser").each(function() {
            $(this).css("opacity", 0.5)
        })

        //$(obj).css("text-decoration", "underline");
         $(obj).css("opacity", 1);
         $("#" + containerId).show();
    }

}

var routeLoadingIndicator = function($rootScope){
  return {
    restrict:'E',
    template:"<h1 ng-if='isRouteLoading'>Loading...</h1>",
    link:function(scope, elem, attrs){
      scope.isRouteLoading = false;

      $rootScope.$on('$routeChangeStart', function(){
        scope.isRouteLoading = true;
      });

      $rootScope.$on('$routeChangeSuccess', function(){
        scope.isRouteLoading = false;
      });
    }
  };
};




function init(){

    // Get the current page
    var currPage = window.location.href;
    //next_page = "";

    // If current page has a query string, append action to the end of the query string, else
    // create our query string
    /*if (refreshed < 0) {
        if(curr_page.indexOf("#") > -1) {
            next_page = curr_page.substring(0, curr_page.indexOf("#"));
            refreshed++;
        } else {
            next_page = curr_page;
            refreshed++;
        }
    }*/

    // Redirect to next page
    //window.location = next_page;

    

    $.ajax({
      url: "./data/categories.txt",
      async: false,
      dataType: "json"
    }).done(function(data) {
      categories = data;
      //console.log(categories.length);
    });

    if (currPage.indexOf("#") > -1) {
        var c = currPage.substring(currPage.indexOf("#") + 2);
        //alert(categories.length)
        //console.log("c: " + c)
        for (var i = 0; i < categories.length; i++) {
            var o = categories[i];
            //console.log(o.href)
            if (c == o.href) {
                $("#" + o.id).addClass("active");
                //console.log("added " + $("#" + o.id).length)
            } else $("#" + o.id).removeClass("active");
        }
    } else $("#cResearchInterest").addClass("active");
    
    
    //setTimeout("adjustLabImage();", 50);
    //setTimeout('adjustHeight("boo_content");', 50);
    //alert($("#collapseOne").length)
    //setTimeout("initCollapse()", 50);
    //setTimeout("initCollapse()", 50);

    //setTimeout("initCollapse()", 40);

    //$("#collapseOne").collapse("toggle");
    //$("#collapseOne").on("show.bs.collapse", function() {
     //   window.scrollTo(0, document.body.scrollHeight || document.documentElement.scrollHeight);
        //document.body.scrollTop = document.body.scrollHeight - document.body.clientHeight;
       
        //var element = $(this)[0];
        //element.scrollIntoView();
    //})
    //setPopover("labMembers_flink", "labMembers_fcontent");

    //setTimeout('$("#image1_imgChooser").click();', 15);


}




