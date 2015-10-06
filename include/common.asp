<%
function addToFavorites(cls,scheme,code,name) {
	var connStr = getConnStr("ONCALLPREFERENCES",oncall.getEnvironment());
	var userid = oncall.getUserId();
	var sql = "";
	var result;
	var obj;
	var DB;

	sql = "IF EXISTS";
	sql += " (SELECT id FROM favorites";
	sql += " WHERE oncalluserid = '" + userid + "' AND concept_class = '" + cls + "'";
	sql += " AND concept_scheme = '" + scheme + "' AND concept_code = '" + code + "')";
	sql += " UPDATE favorites"
	sql += " SET usage_count = (SELECT usage_count + 1)";
	sql += " WHERE oncalluserid = '" + userid + "' AND concept_class = '" + cls + "'";
	sql += " AND concept_scheme = '" + scheme + "' AND concept_code = '" + code + "'";
	sql += " ELSE INSERT INTO favorites";
	sql += " (oncalluserid, concept_class, concept_scheme, concept_code, concept_name, usage_count)";
	sql += " VALUES ('" + userid + "', '" + cls + "', '" + scheme + "', '" + code + "', '" + name + "', 1)";

	if (sql && hasValue(connStr)) { 
		DB = Server.CreateObject("ADODB.Connection");
		//RW("connStr",connStr)
		DB.Open(connStr);
		DB.execute(sql);
		DB.close()
		DB = null;
	} // if
	
} // function addToFavorites

function getDateOffset(date,dayoffset,format) {
	var dayofmonth;
	var retDate;
	var dt; 
	
	if (hasValue(date)) {
		dt = isValidDate(date,null,null,null,true);
		if (!format) format = "mm/dd/yyyy";
		dayofmonth = dt.getDate();
		dt.setDate(parseInt(dayofmonth) + parseInt(dayoffset));
		retDate = isValidDate(dt,null,null,format);
		//alert("date = " + date + "\ndayoffset = " + dayoffset + "\ndayofmonth = " + dayofmonth + "\nnew Date = " + retDate);
	} else retDate = "";
	return(retDate);
} // function getDateOffset

function hasValue(val,allowZero) {
	return (val != "" && val != null && val != "undefined");
} // function hasvalue

function isValidTime(value, minimum, maximum, format) { // javascript
	var match = value.match(/^\s*(\d{1,2})[: .]?(\d{2})?([: .](\d{2}))?\s*(a|p|am|pm)?\s*$/i);	
	var newValue = false;
	var timemin;
	var minutes;
	var seconds;
	var minmin;
	var maxmin;
	var format;
	var hours;
	var ampm;

	if (match) {
		hours = match[1] * 1; // so that '08' becomes '8'
		minutes = (match[2] || 0) * 1;
		seconds = (match[4] || 0) * 1; //3 is the outer parens, including ": ."; 4 is just the seconds
		ampm = match[5] || "";
		if (ampm.substr(0,1).toLowerCase() == "p") hours = ( hours == 12 ? 12 : hours + 12);
		if (!hasValue(format)) {
			format = "hh:nn";
		} // if no format passed
		if (hours < 24 && minutes < 60) {
			minmin = getMin(minimum, "0:00");
			maxmin = getMin(maximum, "23:59");
			timemin = hours * 60 + minutes;
			if (timemin >= minmin && timemin <= maxmin) {
				newValue = formatDT(format, "", "", "", hours, minutes, seconds); // year, month, day
			} // if the time is within range
		} // if valid hours & minutes
	} // if the time is in the right format
	return (newValue);
} // function isValidTime

function isValidDate(value, minimum, maximum, format, asObject) {
	var mNames = "jan,feb,mar,apr,may,jun,jul,aug,sep,oct,nov,dec".split(",");
	var months = new Array;
	var minute = 0;
	var second = 0;
	var hour = 0;
	var ok = true; // if what's passed in is valid
	var dateObj;
	var check; // validate month/day combinations, since that's not done in the regexp matching
	var match;
	var month;
	var index;
	var temp;
	var year;
	var day;
	var ret;
//	Tue Apr 24 11:19:23 EDT 2001

	if (!hasValue(format)) format = "mm/dd/yyyy";
	if (!hasValue(value)) return (false);
	
	for (index = 0; index < mNames.length; index++) {
		months[mNames[index]] = (index + 1);
	} // for each month
	
	//RW("typeof",typeof value)
	//RW("const",value.constructor.toString());
	//RW("value here",value);

	if (typeof value == "object" && value.constructor.toString().search (/function Date/) != -1) {
		year = value.getFullYear();
		month = value.getMonth() + 1;
		day = value.getDate();
		hour = value.getHours();
		minute = value.getMinutes();
		second = value.getSeconds();
	} else if (match = value.match(/^(\d{4})\-(\d{2})\-(\d{2}) (\d{2}):(\d{2}):(\d{2}).(\d{3})$/)) {
		// SQL 7 ??: yyyy-mm-dd hh:mm:ss.sss
		year = match[1];
		month = match[2];
		day = match[3];
		hour = match[4];
		minute = match[5];
		second = match[6];
	} else if (match = value.match(/^(\d{4})\/(\d{2})\/(\d{2})$/)) {
		// Oncall: yyyy/mm/dd
		year = match[1];
		month = match[2];
		day = match[3];
	} else if (match = value.match(/^(\d{4})\/(\d{2})\/(\d{2}) (\d{2}):(\d{2})$/)) {
		// PCIS: yyyy/mm/dd hh:mm PCIS
		year = match[1];
		month = match[2];
		day = match[3];
		hour = match[4];
		minute = match[5];
	} else if (match = value.match(/^(\d{4})\/(\d{2})\/(\d{2}) (\d{2}):(\d{2}):(\d{2})$/)) {
		// PCIS: yyyy/mm/dd hh:mm:ss
		year = match[1];
		month = match[2];
		day = match[3];
		hour = match[4];
		minute = match[5];
		second = match[6];
	} else if (match = value.match(/^(\d{1,2})\/(\d{1,2})\/(\d{2}|\d{4}) (\d{1,2}):(\d{2})(:(\d{2}))?$/)) {
		// mm/dd/yyyy hh:mm[:ss]
		month = match[1];
		day = match[2];
		year = match[3];
		hour = match[4];
		minute = match[5];
		second = match[7]; // 6 is outer parens with ':"
		check = true;
	} else if (match = value.match(/^(\d{1,2})\/(\d{1,2})\/(\d{4})/)) {
		// mm/dd/yyyy ignore the rest
		month = match[1];
		day = match[2];
		year = match[3];
	} else if (match = value.match(/^\w{3} (\w{3}) (\d{1,2}):(\d{2}):(\d{2}) \w{3} (\d{4})/)) {
	 	// default sql: MON mmm hh:mm:ss EST yyyy (uppercase not included in ()'s)
		month = months[match[1].substr(0,3).toLowerCase()]; // assumes proper month
		day = match[2];
		hour = match[3];
		minute = match[4];
		second = match[5];
		year = match[6];
	} else if (match = value.match(/^(\w{3})\s*(\d{1,2})\s*(\d{4})\s*(\d{1,2}):(\d{2})\s*([AP])M$/i)) {
		// SQL datetime convert to varchar: mmm dd yyyy hh:mm xx
		//Apr 10 2001 1:15PM 
		month = months[match[1].toLowerCase()];
		day = match[2];
		year = match[3];
		hour = parseInt(match[4]) + (match[6] == "P" ? 12 : 0);
		minute = match[5];
	} else if (match = value.match(/^\s*(\d{1,2}|[a-zA-Z]{3,})\W*(\d{1,2}|[a-zA-Z]{3,})\W*(\d{2}|\d{4})\s*$/)) {
		// dd-mm-yyyy or dd-mmm-yyyy or mmm-dd-yyyy
		year = match[3];
		check = true;
		if (match[2].match(/\D+/)) { //day-month-year (month is text)
			month = match[2];
			day = match[1];
		} else { // month-day-year (month is text or numeric)
			month = match[1];
			day = match[2];
		} // if day-month-year
		if (month.length > 2) {
			month = months[month.substr(0,3).toLowerCase()]; // convert to number from text
			ok = (month != null); // not a valid month name
		} // > 2 implies a month (regexp takes 2 numbers, or 3+ characters
	} else if (match = value.match(/^\s*(\d{2})(\d{2})(\d{2}|\d{4})\s*$/)) {
		// mmddyy
		day = match[1];
		month = match[2];
		year = match[3];
	} else {
		ok = false;
	} // if various date formats

	if (hasValue(year)) year = fixTwoDigitYear(year);
	
	if (ok && check) {
		dateObj = new Date(year, month - 1, day, hour, minute, second);
		ok = ((dateObj.getMonth() + 1) == month); // date() overflows into next month; if months are same, no overflow.
	} // if checking can continue

	if (ok) {
		if (asObject) ret = new Date(year, month - 1, day, hour, minute, second);
		else {
			ret = formatDT((!hasValue(format) ? "dd/mm/yyyy" : format), year, month, day, hour, minute, second);
		}
	} else {
		ret = false;
	} // if ok, or not
	return (ret);
	
} // function isValidDate

function fixTwoDigitYear(year){
	if (year.length <= 2) year = (parseInt(year) > 25 ? "19" : "20") + year;
	return (year);
} // function fixTwoDigitYear

function getDateOffset(date,dayoffset,format) {
	var dayofmonth;
	var retDate;
	var dt; 
	
	if (hasValue(date)) {
		dt = isValidDate(date,null,null,null,true);
		if (!format) format = "mm/dd/yyyy";
		dayofmonth = dt.getDate();
		dt.setDate(parseInt(dayofmonth) + parseInt(dayoffset));
		retDate = isValidDate(dt,null,null,format);
		//alert("date = " + date + "\ndayoffset = " + dayoffset + "\ndayofmonth = " + dayofmonth + "\nnew Date = " + retDate);
	} else retDate = "";
	return(retDate);
} // function getDateOffset

function isValidNAPhone(value, format) {
	var match = value.match(/^\s*(\+1|1)?\W*(\d{3})\W*(\d{3})\W*(\d{4})(.*)$/); // + comment
	var countrycode = 1;
	var ret = false;
	var areacode;
	var prefix;
	var number;
	var other;
	
	if (!hasValue(format)) format = "+cc (aaa) ppp-nnnn ooo";
	
	if (match) {
		areacode = match[2];
		prefix = match[3];
		number = match[4];
		other = match[5].replace(/^\s*/, "").replace(/\s*$/,"")
		ret = format.replace(/cc/, countrycode);
		ret = ret.replace(/aaa/, areacode);
		ret = ret.replace(/ppp/, prefix);
		ret = ret.replace(/nnnn/, number);
		ret = ret.replace(/ooo/, other)
	} // if there's a match
	return (ret);
} // function isValidNAPhone - NA = north american

function isValidNumber(value, min, max, format, type) { 
	var newValue = false;
	var testNum;
	var match;

	switch (format.toLowerCase()) {
		case "integer" :
			match = value.match(/^\s*(-?)\s*(\d+)\s*$/);
			break;
		case "real" :
			match = value.match(/^\s*(-?)\s*(\d+.?\d*|.\d+)\s*$/)
			break;			
	} // switch	
	
	if (match) testNum = match[1] + match[2];

	if (match && (!hasValue(min) || testNum >= min) && (!hasValue(max) || testNum <= max)) {
		newValue = testNum * 1;
	} // if there is a valid match

	return (newValue);
} // function isValidNumber

function formatDT(format, year, month, day, hour, minute, seconds) {
	var months = "January,February,March,April,May,June,July,August,September,October,November,December".split(",");
	var days = "Sunday,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday".split(",");
	var dt = new Date(year, month - 1, day, hour, minute, seconds);
	var mon = months[dt.getMonth()];
	var day = days[dt.getDay()];
	var hours = dt.getHours();
	var value = format;
	var ampm = "";

	if (format.match(/x{1,2}/i)) {
		ampm = (hours < 12 ? "am" : "pm");
		hours = hours % 12;
	} // if there's an a or aa or A or AA to include am/pm
	
	value = value.replace(/xx/g, ampm);
	value = value.replace(/x/g, ampm.substr(0, 1));
	value = value.replace(/XX/g, ampm.toUpperCase());
	value = value.replace(/X/g, ampm.substr(0, 1).toUpperCase());

	value = value.replace(/mmmm/g, mon);
	value = value.replace(/MMMM/g, mon.toUpperCase());
	value = value.replace(/mmm/g, mon.substr(0,3));
	value = value.replace(/MMM/g, mon.substr(0,3).toUpperCase());
	value = value.replace(/yyyy/g, dt.getFullYear());
	value = value.replace(/yy/g, ("" + dt.getFullYear()).substr(2,2));
	value = value.replace(/mm/g, rightPad(dt.getMonth() + 1, 2, 0));
	value = value.replace(/([^ae])(m)/g, dt.getMonth() + 1); // not preceeded by a letter
	value = value.replace(/dd/g, rightPad(dt.getDate(), 2, 0));
	value = value.replace(/d/g, dt.getDate()); // no 'd's in month names
	value = value.replace(/hh/g, rightPad(hours, 2, 0));
	valee = value.replace(/h/g, hours); // no 'h's in month names
	value = value.replace(/nn/g, rightPad(dt.getMinutes(), 2, 0));
	value = value.replace(/ss/g, rightPad(dt.getSeconds(), 2, 0));
	value = value.replace(/wwww/g, day);
	value = value.replace(/WWWW/g, day.toUpperCase());
	value = value.replace(/www/g, day.substr(0,3));
	value = value.replace(/WWW/g, day.substr(0,3).toUpperCase());
	return(value);
} // function dtFormat

function RQS(name, defaultValue) { // get a request QueryString value
	var value = "" + Request.Querystring(name);
	if (value == "undefined" && defaultValue != null) {
		value = defaultValue;
	} // if
	return (value);
} // function RQS

function mmddyyyy(date) {
	return(rightPad(parseInt(date.getMonth() + 1), 2, 0) + "/" + rightPad(date.getDate(), 2, 0) + "/" + date.getFullYear());
} // function mmddyyyy

function rightPad(value, length, pad) {
	var newValue = (value || "").toString();
	for ( ; newValue.length < length; newValue = pad + newValue) {};  // for
	return (newValue);
} //function rightPad

function RF(name, defaultValue, str) {  // get a request.form value - str is a comma delimited list
	if (str) {
		var obj = new Array;
		var i;
		str = str.split(",");
		for (i=0; i < str.length; i++) {
			obj[str[i]] = "" + Request.Form(str[i]);
			// Response.write("the value is " + obj[str[i]] + "<br>");
			if (obj[str[i]] == "" || obj[str[i]] == null || obj[str[i]] == "undefined" && defaultValue != null) obj[str[i]] = defaultValue;
		} // for
		return(obj);
	} // if
	else {
		var value = "" + Request.Form(name);
		if (value == "undefined" && defaultValue != null) {
			value = defaultValue;
		} // if value is undefined and there is a default value provided
		return(value);
	} // else
} // function RF

function makeRequestObj(makeNull,splitRepeats) {
	var ret = new Array;
	var obj = new Array;
	var rObj = new Array;
	var index;
	var value;
	var name;
	
	for (index=1; index<=Request.form.count; index++) {	
		name = Request.form.key(index);
		value = Request.form(index);
		if (splitRepeats && name.match(/^(.*)\|(.*)$/)) {
			pipe = name.split("|");
			if (!rObj[pipe[0]]) rObj[pipe[0]] = new Array;
			rObj[pipe[0]][pipe[1]] = value;
		} else if (value != "" || makeNull) obj[name] = value;
	} // for
	for (index=1; index<=Request.querystring.count; index++) {
		name = Request.querystring.key(index);
		value = Request.querystring(index);
		if (value != "") obj[name] = value;
	} // for
	
	if (splitRepeats) {
		ret.single = obj;
		ret.repeat = rObj;
	} // if
	else ret = obj;
	//setShowCookies(obj);
	return(ret);
} // function makeRequestObj

function log(source, description) { // subsequent params are name/value pairs 
	var forAppending = 8;
	var logFileName = Server.MapPath("/oncalldata/dex/logfile.txt");
	var logFileFSO = Server.CreateObject("Scripting.FileSystemObject");
	var args = log.arguments;
	var logFileTS;
	var index;
	
	if (logFileFSO.FileExists(logFileName)) {
		logFileTS = logFileFSO.OpenTextFile(logFileName, forAppending);
	} else {
		logFileTS = logFileFSO.CreateTextFile(logFileName);
	} // if appending or creating 
	
	if (source == "") {
		logFileTS.WriteLine((new Date) + " " + description);
	} else {
		logFileTS.WriteLine(" ");
		logFileTS.WriteLine((new Date) + " ------------------------------ ");
		for (index = 0; index < args.length; index += 2) {
			logFileTS.WriteLine("\t" + args[index] + " = " + args[index + 1]);
		} // for each pair of additional arguments 
	} // if more than two arguments 
	
	logFileTS.Close();
	logFileFSO = null;
} // function log 

function RL(info) {
	var forAppending = 8;
	var logFileName = Server.MapPath("/oncalldata/dex/logfile.txt");
	var logFileFSO = Server.CreateObject("Scripting.FileSystemObject");
	var args = RL.arguments;
	var logFileTS;
	var index;
	
	logFileName = Server.MapPath((info && info.filepath ? info.filepath : "/oncalldata/dex/logfile.txt"));
	
	if (logFileFSO.FileExists(logFileName)) {
		logFileTS = logFileFSO.OpenTextFile(logFileName, forAppending);
	} else {
		logFileTS = logFileFSO.CreateTextFile(logFileName);
	} // if appending or creating 

	logFileTS.WriteLine(" ");
	logFileTS.WriteLine((new Date) + " ------------------------------ ");
	for (index = 1; index < (args.length - 1); index += 2) {
		logFileTS.WriteLine("\t" + args[index] + " = " + args[index + 1]);
	} // for each pair of additional arguments 

	logFileTS.Close();
	logFileFSO = null;
} // RL

function openNewFile(name) {
	var path = Server.MapPath(name);
	var fileObj = Server.CreateObject("Scripting.FileSystemObject");
	var handle;
	try {
		handle = fileObj.CreateTextFile(path);
	} catch (error) {
		log("error opening file: " + path, error.description);
	} //try/catch
	return(handle);
	
} // function openNewFile

function replaceParams(original, info) { // info as assoc. array to hold funtion paramers. 3+ args hold replacement arrays
	var closeStr = (info ? (info.closeStr || "}") : "}");
	var openStr = (info ? (info.openStr || "{") : "{");
	var args = replaceParams.arguments;
	var str = "" + original; // same as "" + original
	var found = true;
	var rinitialMatch; // for repeating
	var initialMatch;
	var argIndex;
	var useParam;
	var replace;
	var match;
	var value;
	var param;
	var index;
	var data;
	var name;
	var re;
		
	if (!info) info = new Array;
	if (!info.rdata) info.rdata = new Array;
	
	if (info.allowBroadMatch) {
		initialMatch = openStr + "([^" + closeStr + "]+)(\\|\\d+)?" + closeStr;
		rinitialMatch = openStr + "([^" + closeStr + "]+)\\|([^\\d" + closeStr + "]+)" + closeStr;
	} else {
		initialMatch = openStr + "([\\w@\/]+)(\\|\\d+)?" + closeStr;
		rinitialMatch = openStr + "([\\w@\/]+)\\|([^\\d" + closeStr + "]+)" + closeStr;
	} // if else 
	
	//TA("re",new RegExp(rinitialMatch).exec(str),true);
	//RWX("wrapper",reqObj._wrapper);
	
	while ((re = (new RegExp(rinitialMatch)).exec(str)) && info.curRow && !info.useGFV) {	
		replace = openStr + re[1] + "|" + eval(re[2].replace(/@/g, info.curRow)) + closeStr; // fieldname + row-specification
		match = re[0].replace(/\//g, "\\/").replace(/\[/g,"\\[").replace(/\]/g, "\\]").replace(/\{/g, "\\{").replace(/\}/g, "\\}").replace(/\|/, "\\|");
		str = str.replace(new RegExp(match, "g"), replace);
	} // while repeating-row specifications to process

	while (found && (re = (new RegExp(initialMatch)).exec(str))) {
		param = re[0]; // whole matched string -> the text to be replaced
		name = re[1];  // text between opening and closing strings -> the name to lookup
		row = (re[2] ? re[2].substr(1) : null); // exists for replacements that use repeating rows... |number
		useParam = param.replace(/\//g, "\\/").replace(/\[/g,"\\[").replace(/\]/g, "\\]").replace(/\{/g, "\\{").replace(/\}/g, "\\}").replace(/\|/, "\\|");

//RW("name",name);
		
		found = false;
		if (info.useGFV) {
			if (info.useSingleQuote) str = str.replace(new RegExp(useParam, "g"), "' + getFieldValue(\'" + name + "\') + '");
			else str = str.replace(new RegExp(useParam, "g"), "' + getFieldValue(\\\"" + name + "\\\") + '");			
			found = true;
		} else if (re[2]) { // if there's a rowid for a repeating row
			value = (row && info.rdata[row] ? info.rdata[row][name]: null);
			if (value != null && (info.useBlanks || value != "")) {
				found = true;
				if (info.replacequotes) value = ("" + value).replace(/'/g,"&apos;"); //'			
				str = str.replace(new RegExp(useParam, "g"), value);
			} // if value is there
		} else {
			if (args[2]) {
				for (index = 2; index < args.length && !found; index++) {
					value = (args[index] ? args[index][name] : null);
//RW("value",value);
					if (value != null && (info.useBlanks || value != "")) {
						found = true;
						if (info.replacequotes) value = ("" + value).replace(/'/g,"&apos;"); //'		
//RW("str before", str);	
						str = str.replace(new RegExp(useParam, "g"), value);
//RW("str after", str);

					} // if value is there
				} // for each name/value object
			} // there are args passed in 
			if (info.allowNulls && !found) {
				str = str.replace(new RegExp(param, "g"), "");	
				found = true;
			} // if allowing nulls
		} // else
	} // if still more to process
	
	//if (info.debug) RW("end of replace params",str)

	return (found || info.useGFV ? str : "noMatch");
} // function replaceParams

function RW(name, value) { Response.write("<BR/>" + name + " = " + value + " ")}

function RWX(name, value, info) {
	if (!info) info = new Array;
	if (info.escapecdata) value = value.replace(/\<\!\[CDATA\[/gi,"CDATA[").replace(/\]\]\>/gi,"]");
	value = ("" + value).replace(/<\?xml.*\?>/,"");
	value = value.replace(/\&/g,"&amp;");
	Response.write("<br/><span style=\"background-color: honeydew; padding: 3px\">" + name + "</span><br/>");
	Response.write("<textarea style=\"width: 100%; height: " + (info.height ? info.height : "50%" ) + ";\">\n");
	Response.write(value + "\n</textarea>\n");
} // function RWX

function RWN(name, nodes, height) {
	var index
	Response.write("<br/><span style=\"background-color: honeydew; padding: 3px\">" + name + "</span><br/>");
	Response.write("<textarea style=\"width: 100%; height: " + (height ? height : "50%" ) + ";\">");
	for (index=0; index < nodes.length; index++) {
		node = nodes[index];
		Response.write("\r");
		Response.write(node.xml);
		Response.write("\r");
	} // for
	Response.write("</textarea>");
} // function RWN

function RT(name, value, height) {
	var xmlStr;
	var retStr = "";
	
	if (!value) xmlStr = xmldoc[name].xml;
	else xmlStr = value;
	xmlStr = xmlStr.replace(/<\?xml.*\?>/,"");
	retStr += "<br/><span style=\"background-color: honeydew; padding: 3px\">" + name + "</span><br/>";
	retStr += "<textarea style=\"width: 100%; height: " + (height ? height : "200px" ) + ";\">" + value + "</textarea>";
	return(retStr);
} // function RT

function TA(name, array, recurse) {
	var initial = true;
	var constructor;
	var index;
	var type;
	var item;
	
	if (recurse != 2) {
		Response.write("<DIV STYLE=\"padding: 6px; background-color: honeydew; border-top: solid black 1px\">" + name+ "</DIV>");
	} // if not a recursion
	Response.write("<TABLE BORDER=0 CELLSPACING=0 PADDING=2 STYLE=\"font-size: x-small\">");
	for (index in array) {
		Response.write("<TR><TD STYLE=\"" + (recurse != 2 || !initial ? "border-top:solid black 1px; " : "") + " padding-right:4px; vertical-align: top\">" + index + " </TD>");
		Response.write("<TD " + (recurse != 2 || !initial ? "STYLE=\"border-top:solid black 1px\"" : "") + ">");
		item = array[index];
		type = typeof item;
		try{ if (item.xml) type = "xml" } catch(e) {}
		if (type == "object") {
			constructor = (item == null ? "null" : new String(item.constructor));
			if (constructor.search(/function (String)\(\)/i) != -1) {
				type = "string";			
			} else if (constructor.search(/function (Array|Object)\(\)/i) != -1) {
				type = "object"; // for consistency
			} else if (constructor == "undefined") {
				type = "string"; // don't quite know why
			} else {
				type = constructor;
			} // if really a string, or not an array/object
		} // if it's an object
		
		if (type == "object") {
			if (recurse) TA("", item, 2); // 2 = flag for no header
			else Response.write("<i>object</i>");
		} else if (type == "xml") {
			Response.write("<i>xml dom</i>");
		} else if (type == "string" || type == "number" || type == "boolean") {
			try {Response.write("<span style=\"color: darkgreen\">" + (item == "" ? "<i>empty</i>" : item)) + "</span>";}
			catch (e){Response.write("<span style=\"color: darkgreen\"><b><i>unknown datatype</i></b></span>");}
		} else if (type == "undefined" || type == "null") {
			Response.write("<i>" + type + "</i>");
		} else {
			Response.write("type: " + typeof item + "<br>");
			Response.write("constructor: " + item.constructor + "<br>");
			Response.write("value: " + item + "<br>")
		} // if recursing & it's an object, or it's just a string, or unknown
		Response.write("</TD></TR>");
		initial = false;
	} // for each item
	Response.write("</TABLE>");
} // function TA

function unEncode(str) {
//RWX("str",str)
	str = "" + str;
	str = str.replace(/\&amp;/g,"&");
	str = str.replace(/\&lt;/g,"<");
	str = str.replace(/\&gt;/g,">");
	str = str.replace(/\&apos;/g,"'");
	str = str.replace(/\&quot;/g,"\"");
	str = str.replace(/#quot#/g,"&quot;");
	str = str.replace(/\<nbsp\W*\/\>|\<nbsp\>\<\/nbsp\>/g,"&#160;");
	str = str.replace(/&amp;/g,"&");
	return(str)
} // funciton unEncode

function XMLEncode(str) {
	str = str.replace(/\\&/g,"&amp;");
	str = str.replace(/</g,"&lt;");
	str = str.replace(/>/g,"&gt;");
	str = str.replace(/\'/g,"&apos;"); //'
	str = str.replace(/\"/g,"&quot;"); //"
	return (str);
} // function

function URLunEncode(str) {
	str = "" + str;
	str = str.replace(/\+/g," ");
	str = str.replace(/%27/g,"'");
	str = str.replace(/%21/g,"!");
	str = str.replace(/%23/g,"#");
	str = str.replace(/%24/g,"$");
	str = str.replace(/%26/g,"&");
	str = str.replace(/%28/g,"(");
	str = str.replace(/%29/g,")");
	str = str.replace(/%2F/g,"/");
	str = str.replace(/%3F/g,"?");
	str = str.replace(/%3A/g,":");
	str = str.replace(/%3B/g,";");
	str = str.replace(/%5B/g,"[");
	str = str.replace(/%5C/g,"\\");
	str = str.replace(/%2B/g,"+");
	str = str.replace(/%3C/g,"<");
	str = str.replace(/%3D/g,"=");
	str = str.replace(/%3E/g,">");
	str = str.replace(/%7B/g,"{");
	str = str.replace(/%7C/g,"|");
	str = str.replace(/%7D/g,"}");
	str = str.replace(/%5E/g,"^");
	str = str.replace(/%60/g,"`");
	str = str.replace(/%25/g,"%");
	return(str)
} // funciton unEncode 

function allFirstCap(phrase) {
	var words = ("" + phrase).split(" ");
	var str = "";
	var index;
	
	for (index=0; index < words.length; index++) {
		if (index != 0) str += " ";
		str += firstCap(words[index]);	
	} // for each word capitalize the first letter 
	return(str);
} // function allFirstCap 

function firstCap(str) {
	var length = str.length;
	var first = str.charAt(0);
	var rest = str.substr(1,length);
	rest = rest.toLowerCase();
	first = first.toUpperCase();
	return(first + rest);
} // function firstCap 

function handleCookies(list) {
	var cookiesNode = CN("cookies");
	var cookies = list.split(",");
	var cookieNode;
	var index;
	var value;
	
	for (index=0; index < cookies.length; index++) {
		name = cookies[index];
		value = getrequest(name)
		storedValue = oncall.getStateVariable(name);
		
		if (hasValue(value)) oncall.setStateVariable(name,value);
		else if (hasValue(storedValue)) value = storedValue
		
		if (hasValue(value)) {
			cookieNode = CN("cookie");
			cookieNode = addCDN(cookieNode,value);
			cookieNode.setAttribute("name",name);
			cookiesNode.appendChild(cookieNode);
		} // if
		value = null
	} // for each cookie 
	xmldoc.main.documentElement.appendChild(cookiesNode);
} // function 

%>