<cfoutput>
<cfif rc.callback neq ''>#rc.callback#(</cfif>
{
	"count" : #serializeJSon(rc.count)#,
	"message" : #serializeJSon(rc.message)#,
	"error" : #serializeJSon(rc.error)#,
	"results" : #serializeJSon(rc.results)#
	<cfif structKeyExists(rc, 'trace')>, "trace" : #serializeJSon(rc.trace)#</cfif>
}
<cfif rc.callback neq ''>)</cfif>
</cfoutput>