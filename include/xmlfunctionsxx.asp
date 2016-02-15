
<%
var xmldoc = new Array;
var http = Server.CreateObject("Msxml2.ServerXMLHTTP.3.0");

http.setTimeouts(3000, 500, 15000, 60000); 

function getrequest(name,dom) {
	var value;
	if (!dom) dom = "main";
	
	value = nodeVal(dom,"/root/request/@" + name);
	if (!hasValue(value)) value = nodeVal(dom,"/root/querystring/@" + name);
	return(value);
} // function getrequest

function getcookie(name,dom) {
	var value;
	if (!dom) dom = "main";
	value = nodeVal(dom,"/root/cookies/cookie[@name='" + name + "']/text()");
	return(value);
} // function getcookie

function getRequestXML (doc,info) {
	var req = CN("request"); // make a 'request' node
	var qs = CN("querystring"); // make a query-string node
	var sv = CN("servervariables"); // make a server variable node
	var rowNode;
  	var svEnum;
	var index;
	var value;
	var parts;
	var field;
	var value;
	var data;
	var name;
	var row;
	
	if (!doc) doc = "main";
	if (!info) info = new Array;
	if (!xmldoc[doc]) loadXML(doc, "", "<root/>");

	for (index = 1; index <= Request.form.count; index++) {	
		data = String(Request.form(index));
		name = Request.form.key(index);
		value = xmldoc[doc].createCDATASection(data);
		field = CN("field");
		row = null;
		if (parts = name.match(/^(.*)\|(.*)$/)) {
			name = parts[1];
			row = parts[2];
		} // if the name has a row
		field.setAttribute("name", name);
		if (hasValue(row)) field.setAttribute("row", row);
		field.appendChild(value);
		req.appendChild(field);
		if (hasValue(row)) {
			field = CN("field");
			value = data.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
			rowNode = SSN(req, "//row[@row = '" + row + "']");
			if (!rowNode) {
				rowNode = CN("row");
				rowNode.setAttribute("row", row);
				req.appendChild(rowNode);
			} // if there's no row with that ID 
			rowNode.setAttribute(name, data);
		} else {
			req.setAttribute(name, data);
		} // if there's a row or not
	} // for each field item

	for (index = 1 ; index <= Request.querystring.count; index++) {
		name = Request.querystring.key(index);
		value = Request.querystring(index);
		qs.setAttribute((hasValue(name) ? name : "x"), value)
	} // for each query string

	if (info.servervariables) {
		svEnum = new Enumerator(Request.ServerVariables)
		for (svEnum.moveFirst() ; !svEnum.atEnd(); svEnum.moveNext() ) {
			index = String(svEnum.item());
			data = Request.ServerVariables(index);
			if (hasValue(data) && index != "ALL_HTTP" && index != "ALL_RAW") {
				name = index.toLowerCase().replace(/_/g, "");
				sv.setAttribute(name, data);
			} // if the server variable has a value
		} // for each server variable
	} // if 
	
	xmldoc[doc].documentElement.appendChild(req);
	xmldoc[doc].documentElement.appendChild(qs);
	xmldoc[doc].documentElement.appendChild(sv);
} // function getRequestXML

function loadSqlXml(sql,connStr,domName,info) {
	var DBGUID_DEFAULT = "{C8B521FB-5CF3-11CE-ADE5-00AA0044773D}";
	var DBGUID_XPATH = "{ec2a4293-e898-11d2-b1b7-00c04f680c56}"; 
	var inStream = Server.CreateObject("ADODB.Stream");
	var resultInDom;
	var ok = true;
	var rootname;
	var result;
	var conn;
	var cmd;

	if (!info) info = new Array
	if (!connStr) connStr = getActiveDatabase("sql2000");
	if (sql.search(/for XML/i) == -1 && !info.nofor) sql += " for XML auto";
	if (domName) loadXML(domName, null, "<xml/>");
	rootname = (info.rootname ? info.rootname : "root");

	try {
		conn = Server.CreateObject("ADODB.Connection");    
		conn.ConnectionTimeout = (info.connectionTimeout?info.connectionTimeout:60); // this is 1 minute
		conn.Open(connStr);
	} catch(e) { 
		result = "<error src=\"loadSqlXml function: create connection\">" + e.description + "</error>";
		ok = false;
	} // catch
	
	if (ok) try {
		cmd = Server.CreateObject("ADODB.Command");
		if (info.commandTimeout) cmd.CommandTimeout = Number(info.commandTimeout);
		if (info.xdrPath) cmd.Dialect = DBGUID_XPATH;
		else cmd.Dialect = DBGUID_DEFAULT;
	} catch(e){
		result = "<error src=\"loadSqlXml function: create command object\">" + e.description + "</error>";
		ok = false;
	} // catch
	
	if (ok) {
		inStream.open();
		inStream.LineSeparator = -1;
		cmd.activeConnection = conn;
		cmd.CommandText = sql;
		if (info.xdrPath) cmd.Properties("Mapping Schema") = Server.MapPath(info.xdrPath);
		if (domName) cmd.Properties("Output Stream") = xmldoc[domName];
		else cmd.Properties("Output Stream") = inStream;
		cmd.Properties("XML Root") = rootname;
		cmd.CommandType = 8;
		try { 
			cmd.Execute(0,0,1024) 
			inStream.Position = 0;
			if (!domName) result = inStream.ReadText(inStream.Size);
			resultInDom = true;
		} catch(e) { 
			result = "<error src=\"loadSqlXml function: create command object\">";
			result += "<description>" + e.description + "</description>";
			result += "<sql>" + sql + "</sql>";
			result += "<connectionstring>" + connStr + "</connectionstring>";
			result += "</error>";
			ok = false;
		} // catch
		
		inStream.close()
		inStream = null;
	} // if
	
	try { conn.close(); } catch(e) {}
	
	// remove the xml encoding tag
	if (!domName) result = result.replace(/<\?xml version="1\.0" encoding="utf-8" \?>/, "");

	if (result == "") result = "<" + rootname + "/>" ; // not needed if 'domName' is true
	if (domName && !resultInDom) loadXML(domName, null, result);

//	if (domName) loadXML(domName, null, result);
	return(result);
} // function loadSqlXml

function nodeVal(xml, match) { // return the value of the node, or "" if not present
	var value = "";
	var node;
	
	//RW("match",match);
	if (xml.length ? (xmldoc[xml]) : true) {
		node = SSN(xml, match);
	} // if a name & the name exists as an xmldoc, or not a string (thus a node)
	if (node) {
		value = node.text;
	} // if there's a node
	return (value);	
} // function nodeVal

function SSN(xml, match) { // assume if string: xmldoc[xml] else object
	//RW("match",match);
	if (xml.length) { // a string
		if (!xmldoc[xml]) { output("bad doc for ", xml)}
		try {
			return(xmldoc[xml].selectSingleNode(match));
		} catch (error) {
			log("", "SSN");
			log("xml", xml, "match", match, "error", error.description);
			return (null);
		} // trying a select Signle node
	} else { // the object
		return (xml.selectSingleNode(match))
	} // if xml is a name, (rather than an object)
} // function SSN

function SN(xml, match) {
	//RW("match",match);
	if (xml.length) { // a string is an index into the xmldoc array
		return(xmldoc[xml].selectNodes(match));
	} else { // the object
		return (xml.selectNodes(match))
	} // if xml is a name, (rather than an object)
} // function SN

function CN(name) {
	var doc;
	for (doc in xmldoc) break;
	if (!doc) {
		loadXML("tmp", "", "<XML></XML>");
		doc = "tmp";
	} // if no document0
	return(xmldoc[doc].createNode(1, name, ""));
} // function CN

function makeCDATANode(name, value){
	var tempNode
	if (value == 'null') value = "";
	tempNode = CN(name);
	tempNode.text = "<![CDATA[" + value + "]]>";
	return(tempNode)
} // function makeCDATANode

function addCDN(node,value) {
	var doc;
	var cdn;
	for (doc in xmldoc) break;
	if (!doc) {
		loadXML("tmp", "", "<XML></XML>");
		doc = "tmp";
	} // if no document0
	cdn = xmldoc[doc].createCDATASection(value) 
	node.appendChild(cdn);
	return(node)
} // function addCDN

function loadBrandDocument(file,brand,domname) {
	// loads a brand specific file in the templates directory or loads the default
	// puts the file into the xmldoc array by the name of the file
	// must pass in the extension of the file - xml vs. xsl
	// passing in domname will overwrite the file name
	var type = file.split(".")[1];
	var name = file.split(".")[0];
	if (!brand) brand = oncall.getBrandId();
	if (domname) name = domname;
	
	switch (type) {
		case "xml":
			loadXML(name, "/oncall/patientchart/templates/" + brand + "/" + file, false, true);
			if (!xmldoc[name].documentElement) {
				xmldoc[name] = null;
				loadXML(name, "/oncall/patientchart/templates/default/" + file, false, true);
			} // if
			break;
		case "xsl":
			loadXSL(name, "/oncall/patientchart/templates/" + brand + "/" + file, false, true);
			if (!xmldoc[name].documentElement) {
				xmldoc[name] = null;
				loadXSL(name, "/oncall/patientchart/templates/default/" + file, false, true);
			} // if
			break;
	} // switch 
} // function loadPopupTemplate

function loadXML(name, file, string, fileIsAbsolute, validate, noFreeThread) {
	//RW("name",name);
	//RWX("string",string);
	var fileExists = ((file != "") && (file != null));
	var stringExists = ((string != "") && (string != null)); 
	var docExists = (xmldoc[name] != null);
	var filename;
	
	if (!docExists) {
		//if (noFreeThread) xmldoc[name] = Server.CreateObject("MSXML2.DOMDocument");
		//else 
		xmldoc[name] = Server.CreateObject("MSXML2.DOMDocument.4.0");
		xmldoc[name].async = false;
		xmldoc[name].setProperty("NewParser",true);
		//xmldoc[name].validateOnParse = (validate ? true : false);
	} // if the document doesn't exist

	if (stringExists) {
		string = zapChar(string);
		try { xmldoc[name].loadXML(string); }
		catch (e) {
			RW("XML Load Error:",e.description);
			RWX("string",string);
			Response.end;
		} // catch
		
	}  else if (fileExists || !docExists) { // don't load if doc exists & no file/string passed
		if (!fileIsAbsolute || !fileExists) {
			filename = Server.MapPath("../xml/" + (fileExists ? file : name) + ".xml");
		} else {
			filename = Server.MapPath(file);
		} // if file is not specified absolutely, or a filename does not exists
		xmldoc[name].load(filename); // --> use zapChar
	} // if string is non-null
} // function loadXML

function loadXSL(name, file, string, fileIsAbsolute) {
	var fileExists = ((file != "") && (file != null));
	var stringExists = ((string != "") && (string != null)); 
	var docExists = (xmldoc[name] != null);
	var filename;
	var success;

	if (!docExists) {
		xmldoc[name] = Server.CreateObject("MSXML2.FreeThreadedDOMDocument.4.0");
		xmldoc[name].async = false;
		xmldoc[name].setProperty("NewParser",true);
	} // if the document doesn't exist

	if (stringExists) {
		xmldoc[name].loadXML(string);
	} else if (fileExists || !docExists) { // don't load if doc exists & no file/string passed
		if (!fileIsAbsolute || !fileExists) {
			filename = Server.MapPath("../xsl/" + (fileExists ? file : name) + ".xsl");
		} else {
			filename = Server.MapPath(file);
		} // if file is not absolute
		success = xmldoc[name].load(filename);
		if (!success) {
			log("xsl (" + name + ") load error", xmldoc[name].parseError.reason);			
		} // if
	} // if string is non-null
} // function loadXSL

function zapChar(string) {
	return (string.replace(/[\x00-\x08\x0E-\x1F\x80-\xFF\x0B]/g,""));
} // function zapChar

function parseXML(xml, xsl, objName, params, info) {
	var retXML = "<root/>";
	var processor;
	var template;
	var errXML;
	var param;
	
	if (!info) info = new Array;

	if (!xmldoc[xml] && !xmldoc[xsl]) errXML = "<error>xml or xsl document not loaded</error>";
	else {
		template = Server.CreateObject("MSXML2.XSLTemplate.4.0");
		template.stylesheet = xmldoc[xsl].documentElement;
		try { 
			processor = template.createProcessor(); 
			processor.input = xmldoc[xml];
		} catch (e) { errXML = "<error src=\"parseXML - create porcessor error\">" + e.description + "</error>"; }
		
		if (!hasValue(errXML)) {
			if (params)	for (param in params) processor.addParameter(param,params[param],"");
			try { 
			processor.transform(); 
			} 
			catch (e) { errXML = "<error src=\"parseXML - transform error\" xml=\"" + xml + "\" xsl=\"" + xsl + "\">" + e.description + "</error>"; }
		} // if ok
		
		//RWX("output",processor.output);
		if (hasValue(objName) && xmldoc[objName] == null) { // load result into dom 
			if (hasValue(errXML)) loadXML(objName, null, errXML);
			else if (info.xsloutput) loadXSL(objName, null, replaceSpecialCharacters(processor.output));
			else loadXML(objName, null, replaceSpecialCharacters(processor.output));
		} else if (hasValue(objName) && xmldoc[objName] != null) {
			errXML = "<error src=\"parseXML\">The XML object '" + objName + "' already exists in xmldoc array</error>";
		} else retXML = replaceSpecialCharacters(processor.output);
	} // else
	return (hasValue(errXML) ? errXML : retXML);
} // function parseXML 

function replaceSpecialCharacters(str) {
	str = str.replace(/#br#/g,"<br/>");
	return(str)
} // fuction replaceSpecialCharacters

function replaceXMLStr (str,dataNode) {
	var matchObj = new Array;
	var local = new Array;
	var info = new Array;
	var replaceStr = str;
	var nodeData;
	var retStr;
	var index;
	var value;
	var sel;

	info.openStr = "<";
	info.closeStr = ">";
	info.allowNulls = true;

	matchObj = str.match(/<[\w@\/]+>/g); // all nodes
	if (!matchObj) {
		matchObj = new Array;
		matchObj[0] = "<" + str + ">";
		replaceStr = matchObj[0];
	} // if there aren't any <>'s in the string, assume only one node specified	
	for (index = 0; index < matchObj.length; index++) {
		sel = "" + matchObj[index].replace(/[<>]/g, "");
		nodeData = nodeVal(dataNode,sel);
		if (sel == "DATEOFBIRTH") nodeData = isValidDate(nodeData, null, null, "mm/dd/yyyy")
		//RW(sel,nodeData);
		local[sel] = nodeData; // "" since XML is loose with missing data
	} // for each node that needs replacing		

	if ((value = replaceParams(replaceStr, info, local)) != "noMatch") retStr = value
	else retStr = "";
	return(retStr)
} // function replaceXMLStr

function addChild(base, name, url) {
	var data;
	var file;
	var http;
	var str;
	var url;
	var err;
	var msg;
	
	data = loadURL(url);

	if (data != "") {
		if (!xmldoc[base]) loadXML(base, "", "<XML></XML>");
		loadXML("acTemp", "", data);
		if (xmldoc.acTemp.xml != "") {
			SSN(base, "/XML").appendChild(SSN("acTemp", "//" + name));
		} // if there is XML
	} // if there's data
} // function addChild

function loadURL(url, params, local, info) { 
	var str;

	url = unEncode(url);
	url = constructFullUrl(url,local)
	//RWX("url in loadURL",url);
	
	try {
	 	if (params) {
			http.open("POST", url, false);
			http.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
			http.setRequestHeader("Connection", "close");
			http.send(params);
		} else {
			http.open("GET", url, false);
			http.send();
		} // if posting or getting
		str = http.responseText.replace(/[^\x00-\xFF]/g,""); // get rid of non-ascii characters
	} catch (e) {
		str = "<div>There has been an Error Loading from URL: <b>" + url + (params ? "?" + params : "") + "</b></div>"
		str += "<div style=\"color: slategray\">" + e.description + "</div>";
	} // try/catch
	return (str);
} // function url



function postXml(url, docSubmit) {
	var poster = Server.CreateObject("MSXML2.ServerXMLHTTP");
	
	url = unEncode(url);
	url = constructFullUrl(url);
	
	poster.open("POST", url, false)
	poster.setRequestHeader("CONTENT_TYPE", "text/xml")
	poster.send(docSubmit)
	var newDoc = Server.createObject("Microsoft.XMLDOM")
	newDoc.loadXML(poster.responseText);
	poster = null;
	return newDoc;
}

function constructFullUrl(strUrl,local) {
	var fullUrl = "";
	var localAddress; 
	var pathInfo;
	var isHttps;
	var port;

	if (strUrl) {
		if ((strUrl.substr(0,7).toLowerCase() == "http://" ) || (strUrl.substr(0,8).toLowerCase() == "https://" )) fullUrl = strUrl
		else {
			localAddress = String(Request.ServerVariables("HTTP_HOST"));
			pathInfo = String(Request.ServerVariables("PATH_INFO"));
			isHttps = ( String(Request.ServerVariables("HTTPS")).toUpperCase() == "ON" )
			if ( strUrl.substr(0,1) != "/" ) strUrl = pathInfo.replace(new RegExp("/\\w*\\.\\w*$"), "/") + strUrl;
			fullUrl = (isHttps ? "https://" : "http://") + localAddress + strUrl;
		} // if not a full url
	} // if
	return (fullUrl);
} // function constructFullUrl
%>