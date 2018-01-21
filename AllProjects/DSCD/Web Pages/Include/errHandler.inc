<%
	errDesc = Replace(errDesc, """", "\""")		'This keeps ODBC errors that have quotes("")
	errDesc = Replace(errDesc, vbCrLf, "\r")	'in them from breaking the ErrHandler
	errDesc = Replace(errDesc, vblf, "\r")
%>
<script language = "JavaScript">
<!--

function Is() {
	var n = navigator;
	// string comparisons are much easier if we lowercase everything now.
	// to make indexOf() tests more compact/readable, we prepend a space
	// to the userAgent string (to get around '-1' indexOf() comparison)
	var ua = ' ' + n.userAgent.toLowerCase();
	var pl = n.platform.toLowerCase(); // not supported in NS3.0
	var an = n.appName.toLowerCase();

	// browser version
	this.version = n.appVersion;

    this.nav = ua.indexOf('mozilla') > 0;

	// 'compatible' versions of mozilla aren't navigator
	if(ua.indexOf('compatible') > 0) {
		this.nav = false;
	}

	this.opera = ua.indexOf('opera') > 0;
	this.webtv = ua.indexOf('webtv') > 0;
	this.ie = ua.indexOf('msie') > 0;
	this.aol = ua.indexOf('aol') > 0;

	this.major = parseInt( this.version );
	this.minor = parseFloat( this.version );

	// platform
	this.mac = ua.indexOf('mac') > 0;
	this.mac68k = (ua.indexOf('68k') > 0 || ua.indexOf('68000') > 0);
	this.macppc = (ua.indexOf('ppc') > 0 || ua.indexOf('powerpc') > 0);

	this.win = ua.indexOf('win') > 0;
	this.win16 = (ua.indexOf('16') > 0 && this.win > 0);
	this.win31 = this.win16;
	this.win95 = (ua.indexOf('95') > 0 && this.win > 0);
	this.win98 = (ua.indexOf('98') > 0 && this.win > 0);
	this.winnt = (ua.indexOf('nt') > 0 && this.win > 0);

	this.os2 = ua.indexOf('os/2') > 0;

	this.sun = ua.indexOf('sunos') > 0;
	this.irix = ua.indexOf('irix') > 0;
	this.hpux = ua.indexOf('hpux') > 0;
	this.aix = ua.indexOf('aix') > 0;
	this.dec = (ua.indexOf('dec') > 0 || ua.indexOf('alpha') > 0 || ua.indexOf('osf1') > 0 || ua.indexOf('ultrix') > 0);
	this.sco = (ua.indexOf('sco') > 0 || ua.indexOf('unix_sv') > 0);
	this.vms = (ua.indexOf('vax') > 0 || ua.indexOf('openvms') > 0);
	this.linux = ua.indexOf('linux') > 0;
	this.sinix = ua.indexOf('sinix') > 0;
	this.reliant = ua.indexOf('reliantunix') > 0;
	this.freebsd = ua.indexOf('freebsd') > 0;
	this.openbsd = ua.indexOf('openbsd') > 0;
	this.netbsd = ua.indexOf('netbsd') > 0;
	this.bsd = ua.indexOf('bsd') > 0;
	this.unixware = ua.indexOf('unix_system_v') > 0;
	this.mpras = ua.indexOf('ncr') > 0;

	this.unix = ua.indexOf("x11") > 0;

	// workarounds
	// - IE5 reports itself as version 4.0
	if(this.ie) {
		if(ua.indexOf("msie 5")) {
			this.major = 5;
			var actual_index = ua.indexOf("msie 5");
			var actual_major = ua.substring(actual_index + 5, actual_index + 8);
			this.minor = parseFloat(actual_major);
		}
	}

    this.nav2 = (this.nav && (this.major == 2))
    this.nav3 = (this.nav && (this.major == 3))
    this.nav4 = (this.nav && (this.major == 4))
    this.nav6 = (this.nav && (this.major == 6))
    this.navonly = (this.nav && (ua.indexOf(";nav") != -1))

    this.ie3  = (this.ie && (this.major == 2))
    this.ie4  = (this.ie && (this.major == 4))
    this.ie5  = (this.ie && (this.major == 5))

	return this;
}

var BrowserIs = new Is()

function ErrHandler(){

	if (<%=objError%> != 0) {
		var strError = "Sorry, an Error has occurred in <%=errWhere%> \r"
			strError = strError + "Error Number: <%=objError%> \r"
			strError = strError + "Error Description: <%=errDesc%> \r\r"
			strError = strError + "If you are not sure why you have received this message,\r"
			strError = strError + "please contact DSCD Admin.  Be sure to include the\r"
			strError = strError + "above information in your description of the problem.\r"
			window.alert (strError)
			window.history.back()
		//window.alert ("Sorry, an Error has occurred in <%'=vntWhere%> \r Error Number <%'=vntError%>");

		return false;
	}
	else{
		if(BrowserIs.ie){
			window.moveTo(0,0)
			window.resizeTo(screen.availWidth, screen.availHeight)
		}
		return true;
	}
}


// -->
</script>
