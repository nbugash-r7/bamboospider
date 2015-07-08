[#--another view of configureArtifactHandlers. Allows to enable only one storage handler per once. See BDEV-8087--]
[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactStorage" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.admin.ConfigureArtifactStorage" --]

<html>
<head>
    [@ui.header pageKey='webitems.system.admin.build.artifactStorage' title=true /]
    <meta name="decorator" content="adminpage">
    <meta name="adminCrumb" content="configureArtifactStorage">
    ${webResourceManager.requireResourcesForContext("atl.admin.artifactStorage")}
</head>
<body>
[@ui.header pageKey='webitems.system.admin.build.artifactStorage' /]
[@ui.bambooPanel]
    [@s.text name="admin.artifactstorage.description"]
        [@s.param name="value"][@help.staticUrl pageKey="help.cloud.storage.policy"][@ww.text name="admin.artifactstorage.cloud" /][/@help.staticUrl][/@s.param]
        [@s.param name="value"][@help.href pageKey="help.s3.artifact.storage.configuration"/][/@s.param]
    [/@s.text]
    [#if configurationUpdated]
        [@ui.messageBox type="success" titleKey='admin.artifactstorage.configuration.updated' /]
    [/#if]
[/@ui.bambooPanel]
[@s.form action="configureArtifactStorage!save" namespace="/admin" submitLabelKey="global.buttons.update" cancelUri="${currentUrl}"]
[@s.select labelKey='admin.artifactstorage.location'
    name='selectedArtifactStorage' id='selectedArtifactStorage'
    listKey='first' listValue='second' toggle=true
    list=artifactHandlerDescriptors
    required=true/]

    [#list artifactHandlerModuleDescriptors as moduleDescriptor]
        [#assign editHtml = action.getEditHtml(moduleDescriptor)!/]
        [#assign visible = selectedArtifactStorage==moduleDescriptor.key]
        [#if editHtml?has_content]
            [@ui.bambooSection id='storage-id-${moduleDescriptor.key}'
            dependsOn='selectedArtifactStorage' cssClass="artifact-storage-details"
            showOn=moduleDescriptor.configurationPrefix]
                ${editHtml}
            [/@ui.bambooSection]
        [/#if]
    [/#list]
[/@s.form]
</body>
</html>