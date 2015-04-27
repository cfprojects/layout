<cfcomponent displayname="Admin Layout" extends="layout">
<cffunction name="head" access="public" output="yes"><cfargument name="title" type="string" required="yes"><cfset variables.title = arguments.title>
<cfcontent reset="yes"><!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
<head>
	<title>#arguments.title#</title>
	<script type="text/javascript" src="/all.js"></script>
</cffunction>
<cffunction name="body" access="public" output="yes">
</head>
<body class="admin">
	<p align="center">#CGI.SERVER_NAME# Administration</p>
	<div align="center">
		<cf_sebMenu width="100%" LogoutLink="/admin/logout.cfm" data="#variables.AdminMenu#">
			<cf_sebMenuItem label="Admin Home" link="/admin/" />
		</cf_sebMenu>
</cffunction>
<cffunction name="end" access="public" output="yes">
	<cfif variables.SCRIPT_NAME CONTAINS "-edit.">
		<p>&nbsp;</p>
		<p><span class="sebReq">*</span> = required field</p>
	</cfif>
		<cf_sebMenu action="end">
	</div>
</body>
</html>
</cffunction>

</cfcomponent>
