<cfsilent>
<cfif ThisTag.ExecutionMode NEQ "Start"><cfexit></cfif>
<cfparam name="request.sLayoutTag" default="#StructNew()#">
<cfparam name="request.sLayoutTag.actions" default="">

<cfset sArgs = StructCopy(attributes)>
<cfset StructDelete(sArgs,"action")>

<cfif StructKeyExists(attributes,"switch") AND Len(attributes.switch)>
	<cfset attributes.action = "switchLayout">
	<cfset sArgs.layout = attributes.switch>
</cfif>
<cfif StructKeyExists(attributes,"include") AND Len(attributes.include)>
	<cfset attributes.action = "include">
	<cfset sArgs.Page = attributes.include>
	<cfset sArgs.VariablesScope = Caller>
</cfif>

<cfif StructKeyExists(attributes,"layout") AND NOT isObject(attributes.layout)>
	<cfset StructDelete(attributes,"layout")>
</cfif>

<!--- Find layout component --->
<cfif NOT StructKeyExists(attributes,"layout")>
	<cfif StructKeyExists(Caller,"layout") AND isObject(Caller.layout)>
		<cfset attributes.layout = Caller.layout>
	<cfelseif StructKeyExists(request,"layout") AND isObject(Caller.layout)>
		<cfset attributes.layout = request.layout>
	<cfelse>
		<cfif FileExists(ExpandPath("/layouts/Default.cfc"))>
			<!--- If the Default layout is where it is expected, go ahead and create the layout object --->
			<cfinvoke returnvariable="attributes.layout" component="layouts.Default" method="init">
				<cfinvokeargument name="CGI" value="#CGI#">
				<cfif StructKeyExists(Application,"Framework") AND StructKeyExists(Application.Framework,"Loader") AND isObject(Application.Framework.Loader)>
					<cfinvokeargument name="Factory" value="#Application.Framework.Loader#">
				</cfif>
			</cfinvoke>
			<cfset Caller.layout = attributes.layout>
			<cfset request.layout = attributes.layout>
		<cfelse>
			<!---<cfparam name="attributes.layout">--->
			<!--- Throwing an error because it isn't sufficient for the variable to exists. It also must be an object --->
			<cfthrow message="layout attribute is not defined" type="layout">
		</cfif>
	</cfif>
</cfif>

<!--- pattern <cf_layout att="value"> could indicate a method and single argument --->
<cfif
		NOT ( StructKeyExists(attributes,"action") AND Len(attributes.action) )
	AND	StructCount(sArgs) EQ 1
	AND	StructKeyExists(attributes.layout,StructKeyList(sArgs))
>
	<cfset attributes.action = StructKeyList(sArgs)><!--- Easiest way to set the action to the attribute name --->
	<cfset sFunc = getMetaData(attributes.layout[attributes.action])><!--- Need to use meta data to get the name of the first (and only) argument --->
	<cfif ArrayLen(sFunc.Parameters) EQ 1>
		<cfset sArgs = StructNew()>
		<cfset sArgs[sFunc.Parameters[1].name] = attributes[attributes.action]>
	<cfelse>
		<cfset StructDelete(attributes,"action")>
	</cfif>
</cfif>

<!--- Default action --->
<cfif NOT ( StructKeyExists(attributes,"action") AND Len(attributes.action) )>
	<cfset actions = "head,body,end">
	<cfloop list="#actions#" index="action">
		<cfif NOT ListFindNoCase(request.sLayoutTag.actions,action)>
			<cfset attributes.action = action>
			<cfbreak>
		</cfif>
	</cfloop>
</cfif>

<!--- Find title --->
<cfif attributes.action EQ "head" AND NOT StructKeyExists(attributes,"Title")>
	<cfif StructKeyExists(Caller,"Title")>
		<cfset sArgs.Title = Caller.Title>
	<cfelse>
		<cfset sArgs.Title = "">
	</cfif>
</cfif>

<!--- If a Title attribute is passed in, but no Title variable is set on the page, then set the variable from the attribute --->
<cfif StructKeyExists(attributes,"Title") AND isSimpleValue(attributes.Title) AND NOT StructKeyExists(Caller,"Title")>
	<cfset Caller["Title"] = attributes.Title>
</cfif>

</cfsilent><cfinvoke
	returnvariable="result"
	component="#attributes.layout#"
	method="#attributes.action#"
	argumentCollection="#sArgs#"
><cfset request.sLayoutTag.actions = ListAppend(request.sLayoutTag.actions,attributes.action)><cfif
		attributes.action EQ "body"
	AND	StructKeyExists(attributes,"showTitle")
	AND	attributes.showTitle IS true
	AND	StructKeyExists(Caller,"Title")
	AND	isSimpleValue(Caller.Title) AND Len(Trim(Caller.Title))
	AND	NOT ( StructKeyExists(request.sLayoutTag,"HasTitleH1Output") AND request.sLayoutTag.HasTitleH1Output IS true )
><!--- Show Title in h1 if "showTitle" attribute is true --->
	<cfoutput><h1>#Caller.Title#</h1></cfoutput>
	<cfset request.sLayoutTag.HasTitleH1Output = true>
</cfif><cfsilent>

<cfif isDefined("result") AND attributes.action EQ "switchLayout">
	<cfset attributes.layout = result>
	<cfif StructKeyExists(Caller,"layout") AND isObject(Caller.layout)>
		<cfset Caller.layout = result>
	<cfelseif StructKeyExists(request,"layout") AND isObject(Caller.layout)>
		<cfset request.layout = result>
	</cfif>
</cfif>
</cfsilent>