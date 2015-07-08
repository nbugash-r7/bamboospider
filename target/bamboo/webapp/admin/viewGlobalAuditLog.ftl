[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.ViewGlobalAuditLogAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.ViewGlobalAuditLogAction" --]
<html>
<head>
    <title>[@ww.text name='auditlog.global.settings.change.history.heading' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
[#if enabled]
    <div class="aui-toolbar inline toolbar">
        <ul class="toolbar-group">
            <li class="toolbar-item">
                <a id="disableAuditLogs" class="toolbar-trigger requireConfirmation mutative" href="[@ww.url action='disableAllAuditLogs' namespace='/admin'/]" title="[@ww.text name='auditlog.disable'/]">[@ww.text name='auditlog.disable'/]</a>
            </li>
            <li class="toolbar-item">
                <a id="deleteGlobalAuditLog" class="toolbar-trigger requireConfirmation mutative" href="[@ww.url action='deleteGlobalAuditLog' namespace='/admin'/]" title="[@ww.text name='auditlog.delete.global'/]">[@ww.text name='auditlog.delete.global'/]</a>
            </li>
            <li class="toolbar-item">
                <a id="deleteAllAuditLogs" class="toolbar-trigger requireConfirmation mutative" href="[@ww.url action='deleteAllAuditLogs' namespace='/admin'/]" title="[@ww.text name='auditlog.delete.all.message'/]">[@ww.text name='auditlog.delete.all'/]</a>
            </li>
        </ul>
    </div>
[#else]
    <div class="aui-toolbar inline toolbar">
        <ul class="toolbar-group">
            <li class="toolbar-item">
                <a id="enableAuditLogs" class="toolbar-trigger mutative" href="[@ww.url action='enableAllAuditLogs' namespace='/admin'/]" title="[@ww.text name='auditlog.enable'/]">[@ww.text name='auditlog.enable'/]</a>
            </li>
        </ul>
    </div>
[/#if]

<h1>[@ww.text name='auditlog.global.settings.change.history.heading' /]</h1>

[#if enabled]
    [@cp.configChangeHistory pager=pager /]
[#else]
    [@ui.messageBox type="warning"]
        [@ww.text name='auditlog.global.disabled']
            [@ww.param]<a class="mutative" href="[@ww.url action='enableAllAuditLogs' namespace='/admin'/]">[/@ww.param]
            [@ww.param]</a>[/@ww.param]
        [/@ww.text]
    [/@ui.messageBox]
[/#if]
</body>
</html>