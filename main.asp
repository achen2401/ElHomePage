<!--#include virtual="/oncall/dex/bobo/include/common.asp"-->
<!--#include virtual="/oncall/dex/bobo/include/xmlfunctions.asp"-->
<%
Response.CacheControl = "no-cache";
Response.AddHeader("Pragma", "no-cache");
Response.Expires = -1;
%>
<html>
<head>
	<title>Eleanor Chen Research Lab</title>
	<link type="text/css" href="/oncall/dex/bobo/css/overcast/jquery-ui-1.8.13.custom.css" rel="stylesheet" />
	<link rel="stylesheet" href="/oncall/dex/bobo/css/boo.css" type="text/css"/>
	<script language="JavaScript" src="/oncall/dex/bobo/include/jquery-1.5.1.min.js"></script>
	<script language="JavaScript" src="/oncall/dex/bobo/include/jquery-ui-1.8.13.custom.min.js"></script>
	<script language="JavaScript" src="/oncall/dex/bobo/include/boo.js"></script>
</head>
<body>
<%
	
getRequestXML();

loadXML("bobo", "/oncall/dex/bobo/xml/content.xml", false, true);
loadXSL("template", "/oncall/dex/bobo/xsl/main.xsl", false, true);

Response.write(parseXML("bobo", "template"));

%>
</body>
</html>