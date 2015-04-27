<!--- Create the trac integration CFC object --->
<cfset tracObj = createObject("component","base.cfcs.trac").init(tracURL, tracUser, tracPass)>

<!--- Dump the milestones --->
<cfdump var="#tracObj.getMilestones()#" label="getMilestones()">