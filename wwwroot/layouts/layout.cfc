<cfcomponent>

<cffunction name="init" access="public" returntype="layout" output="no">
	<cfargument name="CGI" type="struct" required="yes">
	<cfargument name="Factory" type="any" required="yes">
	
	<cfset variables.CGI = arguments.CGI>
	<cfset variables.Factory = arguments.Factory>
	
	<cfset variables.SCRIPT_NAME = variables.CGI.SCRIPT_NAME>
	<cfif Len(Trim(variables.CGI.QUERY_STRING))>
		<cfset variables.PageString = "#variables.CGI.SCRIPT_NAME#?#variables.CGI.QUERY_STRING#">
	<cfelse>
		<cfset variables.PageString = "#variables.CGI.SCRIPT_NAME#">
	</cfif>
	<cfset variables.FileName = ListLast(variables.SCRIPT_NAME,"/")>
	
	<cfset variables.me = StructNew()>
	
	<cfset importAdminMenu()>
	
	<cfreturn this>
</cffunction>

<cffunction name="switchLayout" access="public" returntype="layout" output="no">
	<cfargument name="layout" type="string" required="yes">
	
	<cfset var result = CreateObject("component",layout)>
	
	<cfset result.init(variables.CGI,variables.Factory)>
	
	<cfset result.setMe(variables.me)>
	<cfset this = result>
	
	<cfreturn result>
</cffunction>

<cffunction name="setMe" access="package" returntype="void" output="no">
	<cfargument name="me" type="struct" required="yes">
	
	<cfset variables.me = me>

</cffunction>

<cffunction name="importAdminMenu" access="private" returntype="void" output="no">
	
	<cfset var xProgram = variables.Factory.Config.getSetting('ProgramMenu')>
	<cfset var aAdminMenu = ArrayNew(1)>
	<cfset var ii = 0>
	<cfset var jj = 0>
	
	<cfif StructKeyExists(xProgram.site,"program")>
		<cfloop index="ii" from="1" to="#ArrayLen(xProgram.site.program)#" step="1">
			<cfset ArrayAppend(aAdminMenu,StructNew())>
			<cfset aAdminMenu[ArrayLen(aAdminMenu)]["Link"] = xProgram.site.program[ii].XmlAttributes["path"]>
			<cfset aAdminMenu[ArrayLen(aAdminMenu)]["Label"] = xProgram.site.program[ii].XmlAttributes["name"]>
			<cfset aAdminMenu[ArrayLen(aAdminMenu)]["pages"] = "">
			<cfset aAdminMenu[ArrayLen(aAdminMenu)]["Folder"] = xProgram.site.program[ii].XmlAttributes["path"]>
			<cfset aAdminMenu[ArrayLen(aAdminMenu)]["items"] = ArrayNew(1)>
			<cfset aAdminMenu[ArrayLen(aAdminMenu)]["inTabs"] = true>
			<cfif StructKeyExists(xProgram.site.program[ii],"link")>
				<cfloop index="jj" from="1" to="#ArrayLen(xProgram.site.program[ii].link)#" step="1">
					<cfset ArrayAppend(aAdminMenu[ArrayLen(aAdminMenu)]["items"],StructNew())>
					<cfset aAdminMenu[ArrayLen(aAdminMenu)]["items"][jj]["Link"] = xProgram.site.program[ii].link[jj].XmlAttributes["url"]>
					<cfset aAdminMenu[ArrayLen(aAdminMenu)]["items"][jj]["Label"] = xProgram.site.program[ii].link[jj].XmlAttributes["label"]>
					<cfset aAdminMenu[ArrayLen(aAdminMenu)]["items"][jj]["pages"] = "">
					<cfset aAdminMenu[ArrayLen(aAdminMenu)]["items"][jj]["folder"] = xProgram.site.program[ii].XmlAttributes["path"]>
				</cfloop>
			</cfif>
		</cfloop>
	</cfif>
	<cfset variables.AdminMenu = aAdminMenu>
	
</cffunction>

</cfcomponent>