<!--- 
	Name           : trac.cfc
	Description    : For interfacing with trac (wiki
	               : and issue tracking system)
				   : http://trac.edgewall.org/
	Author         : Eric Erickson
	               : eric.erickson@safisystems.com
	Last Updated   : 
	Notes          : This code is free of charge and 
	               : without warranty. Use at your own 
				   : risk.
				   : Apache License, Version 2.0
				   : Requires XML-RPC		 
--->



<cfcomponent displayName="trac" hint="Handles trac interactions">
	<cfset variables.xmlrpcHandler = "">
	<cfset variables.timeout = 120>
	<cfset variables.tracURL = "">
	<cfset variables.tracUsername = "">
	<cfset variables.tracPassword = "">
	
	
	<cffunction name="init" access="public" returnType="trac" output="false"
				hint="Returns an instance of the CFC initialized">
		<cfargument name="tracURL" type="String" required="true">
		<cfargument name="tracUsername" type="String" required="true">
		<cfargument name="tracPassword" type="String" required="true">
		<cfargument name="timeout" type="numeric" required="false" default="1">
		
		<cfset variables.tracURL = arguments.tracURL>
		<cfset variables.tracUsername = arguments.tracUsername>
		<cfset variables.tracPassword = arguments.tracPassword>
		<cfset variables.timeout = arguments.timeout>
		
		<!--- XML-RPC Interface to trac --->
		<cfset variables.xmlrpcHandler = createObject("component", "xmlrpc")>
		
		<cfreturn this>
	</cffunction>
	
	
	
	<!--- ---------------------------------------------------------------- --->
	<!---                Trac Basic System Attributes                      --->
	<!--- ---------------------------------------------------------------- --->
	<!---
		Function: getTracSystemAttributes
	
		Retrieves all the trac system attributes in the form of a struct (Ticket Types, Components, Resolutions, Milestones, Severities, Statuses, and Versions)
	
		Parameters:
	
	
		Returns:
			
			struct
			
	
		See Also:
		<getTicketTypes> <getComponents> <getResolutions> <getMilestones> <getSeverities> <getStatuses> <getVersions>
	--->
	<cffunction name="getTracSystemAttributes" returntype="struct" access="public">
		<cfset var tracSystem = structNew()>
		
		<cfset tracSystem.types = getTicketTypes()>
		<cfset tracSystem.components = getComponents()>
		<cfset tracSystem.resolutions = getResolutions()>
		<cfset tracSystem.milestones = getMilestones()>
		<cfset tracSystem.severities = getSeverities()>
		<cfset tracSystem.statuses = getStatuses()>
		<cfset tracSystem.versions = getVersions()>
		
		<cfreturn tracSystem>
    </cffunction>
	
	
	<!---
		Function: getTicketTypes
	
		Returns an array of Trac ticket types
	
		Parameters:
		
	
		Returns:
	
			array
	
		See Also:
	
	--->
	<cffunction name="getTicketTypes" returntype="array" access="public">
		<cfreturn ticketRPCInterface("ticket.type.getAll")>
    </cffunction>
	
	
	<!---
		Function: getComponents
	
		Returns an array of Trac ticket types
	
		Parameters:
		
	
		Returns:
	
			array
	
		See Also:
	
	--->
	<cffunction name="getComponents" returntype="array" access="public">
		<cfreturn ticketRPCInterface("ticket.component.getAll")>
    </cffunction>
	
	
	<!---
		Function: getResolutions
	
		Returns an array of Trac ticket resolutions
	
		Parameters:
		
	
		Returns:
	
			array
	
		See Also:
	
	--->	
	<cffunction name="getResolutions" returntype="array" access="public">
		<cfreturn ticketRPCInterface("ticket.resolution.getAll")>
    </cffunction>
	
	
	<!---
		Function: getMilestones
	
		Returns an array of available milestones
	
		Parameters:
		
	
		Returns:
	
			array
	
		See Also:
	
	--->
	<cffunction name="getMilestones" returntype="array" access="public">
		<cfreturn ticketRPCInterface("ticket.milestone.getAll")>
    </cffunction>
	
	
	<!---
		Function: getSeverities
	
		Returns an array of Trac ticket severities
	
		Parameters:
		
	
		Returns:
	
			array
	
		See Also:
	
	--->
	<cffunction name="getSeverities" returntype="array" access="public">
		<cfreturn ticketRPCInterface("ticket.severity.getAll")>
    </cffunction>
	
	
	<!---
		Function: getStatuses
	
		Returns an array of Trac ticket statuses
	
		Parameters:
		
	
		Returns:
	
			array
	
		See Also:
	
	--->
	<cffunction name="getStatuses" returntype="array" access="public">
		<cfreturn ticketRPCInterface("ticket.status.getAll")>
    </cffunction>
	
	
	<!---
		Function: getVersions
	
		Returns an array of available versions
	
		Parameters:
		
	
		Returns:
	
			array
	
		See Also:
	
	--->
	<cffunction name="getVersions" returntype="array" access="public">
		<cfreturn ticketRPCInterface("ticket.version.getAll")>
    </cffunction>
	
	<cffunction name="ticketRPCInterface" returntype="array" access="public">
		<cfargument name="rpcMethod" required="true" type="String">
		
		<cfset var xmlrpcArray = ArrayNew(1)>
		<cfset var returnArray = ArrayNew(1)>
		
		<cftry>
			<cfscript>
				ArrayAppend(xmlrpcArray,arguments.rpcMethod);
				returnArray = queryTrac(xmlrpcArray).params[1];
			</cfscript>
			<cfcatch type="any"></cfcatch>
		</cftry>
		
		<cfreturn returnArray>
    </cffunction>
	
	
	<!--- ---------------------------------------------------------------- --->
	<!---                        Ticket Handling                           --->
	<!--- ---------------------------------------------------------------- --->
	<!---
		Function: getTickets
	
		Returns an array of ticket structs
	
		Parameters:
	
			qry - *String*: Query for filter tickets on trac side (defaults to: "status!=closed")
	
		Returns:
	
			array
	
		See Also:
			
			<getTicketsAsQuery>
	
	--->
	<cffunction name="getTickets" returntype="array" access="public">
		<cfargument name="qry" default="status!=closed" required="false">
		
		<cfset var xmlrpcArray = arrayNew(1)>
		<cfset var ticketArray = arrayNew(1)>
		<cfset var ticketIdArray = arrayNew(1)>
		
		<cfscript>
			ArrayAppend(xmlrpcArray,"ticket.query");
			ArrayAppend(xmlrpcArray,arguments.qry);
			
			ticketIdArray = queryTrac(xmlrpcArray).PARAMS[1];
		</cfscript>
		
		<cfloop array="#ticketIdArray#" index="ticketId">
			<cfset arrayAppend(ticketArray, getTicket(ticketId))>
		</cfloop>
		
		<cfreturn ticketArray>
	</cffunction>
	
	
	<!---
		Function: getTicketsAsQuery
	
		Returns a group of tickets (high level info) as a query.
	
		Parameters:
	
			qry - *String*: Query for filter tickets on trac side (defaults to: "status!=closed")
	
		Returns:
	
			query
	
		See Also:
		
			<getTickets>
	
	--->
	<cffunction name="getTicketsAsQuery" returntype="query" access="public">
		<cfargument name="qry" default="status!=closed" required="false">
		
		<cfset var xmlrpcArray = arrayNew(1)>
		<cfset var columnList = "id,summary,component,version,milestone,type,owner,status,keywords,created">
		<cfset var ticketQuery = queryNew(columnList)>
		<cfset var ticketIdArray = arrayNew(1)>
		
		<cfscript>
			ArrayAppend(xmlrpcArray,"ticket.query");
			ArrayAppend(xmlrpcArray,arguments.qry);
			ticketIdArray = queryTrac(xmlrpcArray).PARAMS[1];
		</cfscript>
		
		
		<cfloop array="#ticketIdArray#" index="ticketId">
			<cfset tempTicket = getTicket(ticketId)>
			<cfset queryAddRow(ticketQuery)>
			
			<cfloop list="#columnList#" index="col">
				<cfset querySetCell(ticketQuery,col,tempTicket[col])>
			</cfloop>
		</cfloop>
		
		<cfreturn ticketQuery>
	</cffunction>
	
	
	<!---
		Function: getTicket
	
		Returns a ticket in the form of a struct
	
		Parameters:
	
			ticketId - *Numeric*: the ID of the ticket you wish to retrieve
	
		Returns:
	
			struct
	
		See Also:
	
	--->
	<cffunction name="getTicket" returntype="struct" access="public">
		<cfargument name="ticketId" type="Numeric" required="true">
		
		<cfset var xmlrpcArray = arrayNew(1)>
		<cfset var ticketArray = arrayNew(1)>
		<cfset var ticketStruct = structNew()>
		
		<cfscript>
			ArrayAppend(xmlrpcArray,"ticket.get");
			ArrayAppend(xmlrpcArray,arguments.ticketId);
			
			//ArrayAppend(xmlrpcArray,1);
			tempStruct = queryTrac(xmlrpcArray);
			
			if (StructKeyExists(tempStruct,"PARAMS") AND isArray(tempStruct.PARAMS) AND ArrayLen(tempStruct.PARAMS) GT 0)
			{
				ticketArray = tempStruct.PARAMS[1];
				ticketStruct = ticketArray[4];
				ticketStruct.id = ticketArray[1];
				ticketStruct.created = ticketArray[2];
				ticketStruct.changed = ticketArray[3];
			}
		</cfscript>
	
		<cfreturn ticketStruct>
	</cffunction>
	
	
	
	<!---
		Function: createTicket
	
		Create a new ticket, returning ID of the newly created ticket (returns 0 if an error is encountered)
	
		Parameters:
	
			bug_summary - *String* : The summary text
			bug_description - *String* : The description text
			milestone - *String* : Milestone
			keywords - *String* : Keywords
			component - *String* : Component
			priority - *String* : Ticket priority
			owner - *String* : Assigned ticket owner
			type - *String* : Ticket Type
			cc - *String* : Carbon copy(s)
			version - *String* : Version
	
		Returns:
	
			numeric
	
		See Also:
	
	--->
	<cffunction name="createTicket" returntype="numeric" access="public">
		<cfargument name="bug_summary" required="true" type="String">
		<cfargument name="bug_description" required="true" type="String">
		<cfargument name="milestone" required="false" type="String" default="">
		<cfargument name="keywords" required="false" type="String" default="">
		<cfargument name="component" required="false" type="String" default="">
		<cfargument name="priority" required="false" type="String" default="">
		<cfargument name="owner" required="false" type="String" default="">
		<cfargument name="severity" required="false" type="String" default="">
		<cfargument name="type" required="false" type="String" default="">
		<cfargument name="cc" required="false" type="String" default="">
		<cfargument name="version" required="false" type="String" default="">
		
		<cfset var xmlrpcArray = arrayNew(1)>
		<cfset var xmlrpcAttStruct = structNew()>
		<cfset var ticketReturn = structNew()>
		
		<cftry>
			<cfscript>
				ArrayAppend(xmlrpcArray,"ticket.create");
				
				ArrayAppend(xmlrpcArray,arguments.bug_summary);
				ArrayAppend(xmlrpcArray,arguments.bug_description);
				
				xmlrpcAttStruct.milestone = arguments.milestone;
				xmlrpcAttStruct.keywords = arguments.keywords;
				xmlrpcAttStruct.component = arguments.component;
				xmlrpcAttStruct.priority = arguments.priority;
				xmlrpcAttStruct.owner = arguments.owner;
				xmlrpcAttStruct.severity = arguments.severity;
				xmlrpcAttStruct.type = arguments.type;
				xmlrpcAttStruct.cc = arguments.cc;
				xmlrpcAttStruct.version = arguments.version;
				
				ArrayAppend(xmlrpcArray,xmlrpcAttStruct);
				
				ArrayAppend(xmlrpcArray,1);
				ticketReturn = queryTrac(xmlrpcArray);
		
			</cfscript>
			<cfreturn ticketReturn.params[1]>
			
			<cfcatch type="any">
				<cfreturn 0>
			</cfcatch>
		</cftry>
	</cffunction>
	
	
	<!---
		Function: getTicketChangeLog
	
		Returns the ticket change log in the form of a struct with the key being derived by the date of the change.
	
	
		Parameters:
	
			ticketId - *Numeric* : ID of the ticket changes to retrieve 
			when - *Numeric* : (default of 0)
	
		Returns:
	
			struct
	
		See Also:
	
	--->
	<cffunction name="getTicketChangeLog" returntype="struct" access="public">
		<cfargument name="ticketId" type="Numeric" required="true">
		<cfargument name="when" type="Numeric" required="false" default="0">
		
		<cfset var xmlrpcArray = arrayNew(1)>
		<cfset var changeArray = arrayNew(1)>
		<cfset var returnStruct = StructNew()>
		<cfset var tempStruct = StructNew()>
		
		
		<cfscript>
			ArrayAppend(xmlrpcArray,"ticket.changeLog");
			ArrayAppend(xmlrpcArray,arguments.ticketId);
			ArrayAppend(xmlrpcArray,arguments.when);
			
			//ArrayAppend(xmlrpcArray,1);
			changeArray = queryTrac(xmlrpcArray).PARAMS[1];
			
		</cfscript>
		
		<cfset tempId = "">
		<cfloop array="#changeArray#" index="change">
			<cfif tempId neq convertToId(change[1])>
				<cfset tempId = convertToId(change[1])>
				<cfset returnStruct[tempId] = arrayNew(1)>
			</cfif>
			
			<cfset tempStruct = StructNew()>
			<cfset tempStruct.changeDate = change[1]>
			<cfset tempStruct.author = change[2]>
			<cfset tempStruct.field = change[3]>
			<cfset tempStruct.oldvalue = change[4]>
			<cfset tempStruct.newvalue = change[5]>
			<cfset tempStruct.permanent = change[6]>
			
			<cfset arrayAppend(returnStruct[tempId],tempStruct)>
		</cfloop>
		

		<cfreturn returnStruct>
	</cffunction>
	
	
	
	<!--- ---------------------------------------------------------------- --->
	<!---                      XML/RCP Query Setup                         --->
	<!--- ---------------------------------------------------------------- --->
	
	<cffunction name="queryTrac" access="public" output="false">
		<cfargument name="xmlrpcArray" required="true" />
		
		<cfset var result = "">
		<cfset var output = "">
	
		<cfhttp method="post" url="#variables.tracURL#" username="#variables.tracUsername#" password="#variables.tracPassword#" 
				result="output" timeout="#variables.timeout#">
			<cfhttpparam type="XML" value="#variables.xmlrpcHandler.CFML2XMLRPC(arguments.xmlrpcArray)#">
		</cfhttp>
		
		<cfset result = variables.xmlrpcHandler.XMLRPC2CFML(output.filecontent)>
		
		<cfreturn result>
	</cffunction>
	
	
	
	<!--- ---------------------------------------------------------------- --->
	<!---                             Utils                                --->
	<!--- ---------------------------------------------------------------- --->
	<cffunction name="convertToId" access="private" output="false" returntype="String">
		<cfargument name="dateValue" required="true" type="Date">
		
		<cfset var returnIdString = "">
	
		<cfset returnIdString = "ID" & dateFormat(arguments.dateValue,"yyyymmdd") & timeFormat(arguments.dateValue,"HHmmss")>
	
		<cfreturn returnIdString>
	</cffunction>
</cfcomponent>