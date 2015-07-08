[#-- @ftlvariable name="action" type="com.atlassian.bamboo.configuration.AdministerAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.AdministerAction" --]
[#-- @ftlvariable name="errors" type="com.atlassian.bamboo.logger.SystemErrorList" --]
<html>
<head>
    <title>[@s.text name='system.errors.title' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>

[#assign errors = webwork.bean("com.atlassian.bamboo.logger.SystemErrorList")]
[#assign numErrors = errors.systemErrors.size()]


<h1>[@s.text name='system.errors.heading' /]</h1>

[#if numErrors gt 0]
    <span class="floating-toolbar">
        <a class="aui-button mutative" id="clearAllErrors" href="[@s.url namespace="/" action='removeAllErrorsFromLog' returnUrl='${currentUrl}'/]">[@s.text name='system.errors.clear'/]</a>
    </span>
[/#if]

<p>
    [@s.text name='system.errors.description']
        [@s.param value=numErrors /]
    [/@s.text]
</p>

[#if numErrors gt 0]
    [#list errors.systemErrors?sort_by("lastOccurred")?reverse as error]
        [@cp.showSystemError error=error returnUrl=currentUrl webPanelLocation='system.errors'/]
    [/#list]
[/#if]

</body>

</html>
