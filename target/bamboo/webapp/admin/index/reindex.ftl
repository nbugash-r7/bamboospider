[#-- @ftlvariable name="action" type="com.atlassian.bamboo.index.ReindexAction" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.index.ReindexAction" --]
<html>
<head>
    [@ui.header pageKey="index.title" title=true /]
        <meta name="adminCrumb" content="reindex">
</head>

<body>
[@ui.header pageKey="index.title" /]

[#assign serverStatusInfo = ctx.serverStatusInfo /]

[#if serverStatusInfo.reindexInProgress]
    [@ww.form action="reindex!default.action" submitLabelKey='index.refresh.button']
        [@ui.messageBox]
            [@ww.text name='index.in.progress' ]
                [@ww.param]${estimatedReindexCompletionTime?datetime?string}[/@ww.param]
            [/@ww.text]
        [/@ui.messageBox]
    [/@ww.form]
[#else ]
    [@ww.form action="reindex" submitLabelKey='index.button'  titleKey='index.form.title']
        <p class="description">
            [@ww.text name='index.description' ]
                [@ww.param]${prettyApproximateIndexTime}[/@ww.param]
            [/@ww.text]
        </p>
    [/@ww.form]
[/#if]
</body>
</html>
