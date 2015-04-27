<!--- Create the trac integration CFC object --->
<cfset tracObj = createObject("component","base.cfcs.trac").init(tracURL, tracUser, tracPass)>

<!--- Dump the ticket types --->
<cfdump var="#tracObj.getTicketTypes()#" label="getTicketTypes()">