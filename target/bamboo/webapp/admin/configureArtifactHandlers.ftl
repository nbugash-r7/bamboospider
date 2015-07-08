[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactHandlers" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactHandlers" --]
[#import "/templates/plugins/artifactHandler/artifactHandlerCommon.ftl" as artifactHandlerCommon]

<html>
<head>
    <title>[@s.text name='webitems.system.admin.plugins.artifactHandlers' /]</title>
    <meta name="decorator" content="adminpage">
</head>
<body>
    <h1>[@s.text name='webitems.system.admin.plugins.artifactHandlers' /]</h1>

    [@s.form action="configureArtifactHandlers!save" namespace="/admin" submitLabelKey="global.buttons.update" ]
        [@artifactHandlerCommon.displayArtifactHandlerEnableDisableTable artifactHandlerDescriptors=artifactHandlerDescriptors/]

        <h2>Handler-specific configuration</h2>

        [#list artifactHandlerDescriptors as artifactHandlerModuleDescriptor]
            [#assign editHtml = action.getEditHtml(artifactHandlerModuleDescriptor)!""/]
            [#if editHtml?has_content]
                <h3>${fn.resolveName(artifactHandlerModuleDescriptor.name, artifactHandlerModuleDescriptor.i18nNameKey)}</h3>
                <p>${fn.resolveName(artifactHandlerModuleDescriptor.description, artifactHandlerModuleDescriptor.descriptionKey)}</p>
                ${editHtml}
            [/#if]
        [/#list]
    [/@s.form]
</body>
</html>