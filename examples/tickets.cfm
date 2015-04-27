<!--- Create the trac integration CFC object --->
<cfset tracObj = createObject("component","base.cfcs.trac").init(tracURL, tracUser, tracPass)>		

<!--- Get all the active tickets and return them as a query: getTicketsAsQuery() method--->
<cfset qryTracTicketsAll = tracObj.getTicketsAsQuery()>

<cfoutput>
	<cfif qryTracTicketsAll.recordcount EQ 0>
		<h2 class="titleText"><br><br>There are currently no active tickets<br><br></h2>
	<cfelse>
    	<table id="ticketTable" width="85%">
			<tr>
				<th>Ticket</th>
				<th>Summary</th>
				<th>Component</th>
				<th>Milestone</th>
				<th>Type</th>
				<th>Status</th>
				<th>Owner</th>
				<th>Created</th>  
			</tr>
			<cfloop query="qryTracTicketsAll">
				<tr class="row#qryTracTicketsAll.currentrow MOD 2#">
					<td>###qryTracTicketsAll.ID#</td>
					<td>#qryTracTicketsAll.SUMMARY#</td>
					<td>#qryTracTicketsAll.COMPONENT#</td>
					<td>#qryTracTicketsAll.MILESTONE#</td>
					<td>#qryTracTicketsAll.TYPE#</td>
					<td>#qryTracTicketsAll.STATUS#</td>
					<td>#qryTracTicketsAll.owner#</td>
					<td>#DateFormat(qryTracTicketsAll.CREATED,"mm/dd/yyyy")#</td>
				</tr>
			</cfloop>
		</table>
	</cfif>
   </cfoutput>