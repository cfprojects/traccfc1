<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>trac.cfc test</title>
	<link rel="stylesheet" href="examples/example.css" type="text/css"/>
	
</head>
		
<body>
	<h2>trac-cfc</h2>
	<br />
	<a href="docs/index.html">Documentation</a><br />
	<div id="mainContent">
	The <b>trac.cfc</b> project is used for creating an interface between Coldfusion and trac (<a href="http://trac.edgewall.org/">trac.edgewall.org</a>).
	I've only implemented a handful of the methods available in trac, and I will have more done shortly.  In order to run; you will need an XML_RPC 
	enabled Trac site and a login/password with the proper rights for the method being called.  <br><br><br>
	The only files you need to run trac-cfc are the <strong>trac.cfc</strong> and <strong>xmlrpc.cfc</strong> files. 
	Here's an example of the object creation (assuming trac.cfc is in the same directory as, or is accessable from, the cfc/cfm creating the obj):<br><br>
	<div class="code">
		&lt;cfset tracObj = createObject("component","trac").init("http://trac.myserver.org/login/xmlrpc","myuser","mypass")&gt;
	</div>
	<br><br><br>
	I hope this helps anyone who is looking for an easy way to bring trac data into a Coldfusion application (and vice versa).  Here's an example of this project in action: <a href="http://www.safisystems.com/index.cfm?pageMode=tracker">http://www.safisystems.com/index.cfm?pageMode=tracker</a>
	</div>
	<br>
	<hr size="1" style="width: 750px;" align="left" />
	<br>
	<h2>Examples:</h2>
	
	<!--- Full path the the Trac xmlrpc directory --->
	<!--- Example: http://myserver/trac/myproject/login/xmlrpc --->
	<cfparam name="form.tracURL" default="">

	<!--- Trac user name and password --->
	<cfparam name="form.tracUser" default="">
	<cfparam name="form.tracPass" default="">
	
	<cfparam name="form.examplePage" default="">
	
	<cfoutput>
		<cfset pageExampleList = "Active Tickets,Milestones,Ticket Types">
		<form action="index.cfm" method="post">
			<div id="warningContent" align="left">
				<b>Enter the following fields to test some basic trac.cfc functionality.</b><br><br>
				<label for="tracURL">Trac URL:</label>
				<input type="text" id="tracURL" name="tracURL" style="width:300px;" value="#form.tracURL#">
				<br>
				<label for="tracUser">Login: </label>
				<input type="text" id="tracUser" name="tracUser" style="width:100px;" value="#form.tracUser#">
				<br>
				<label for="tracPass">Password: </label>
				<input type="password" id="tracPass" name="tracPass" style="width:100px;" value="#form.tracPass#">
				<br>
				<label for="examplePage">Example: </label>
				<select id="examplePage" name="examplePage">
					<cfloop list="#pageExampleList#" index="e">
						<option <cfif e EQ form.examplePage>selected="true"</cfif>>#e#</option>
					</cfloop>
				</select>
				<br><br>
				<input type="submit" name="Run Example">
			</div>
		</form>
	</cfoutput>	
	
	<br><br>
	
	<cfif Len(form.tracURL)>
		<cfswitch expression="#form.examplePage#">
			<cfcase value="Active Tickets">
				<cfinclude template="examples/tickets.cfm">
			</cfcase>
			<cfcase value="Ticket Types">
				<cfinclude template="examples/tickettypes.cfm">
			</cfcase>
			<cfcase value="Milestones">
				<cfinclude template="examples/milestones.cfm">
			</cfcase>
		</cfswitch>
		
		
	</cfif>
</body>

</html>