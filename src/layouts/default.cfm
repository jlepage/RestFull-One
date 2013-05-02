<!---
	If you have a default layout, you have to escape rest path for it
	
	Like :

	<cfif reFindNoCase('^rest', rc.action)>
		<cfoutput>#layout('common:rest', body)#</cfoutput>
	<cfelse>
		[...] Your stuff here
	</cfif>
--->