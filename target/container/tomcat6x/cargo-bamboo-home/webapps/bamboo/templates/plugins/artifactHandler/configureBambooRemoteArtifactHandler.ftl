[@ui.bambooSection titleKey="admin.artifactstorage.local.header"]
${i18n.getText("admin.artifactstorage.local.description")}
[/@ui.bambooSection]
[#--this part is used in different contexts, so these fields can be not provided by action--]

[#if ctx.darkFeatureService.artifactStorageConfigurationEnabled]
    [#if context.get(pluginModuleConfigurationPrefix+':takenSpaceInGb')??]
        [#assign takenSpaceInGb = context.get(pluginModuleConfigurationPrefix+':takenSpaceInGb')]
    [#else]
        [#assign takenSpaceInGb = 0]
    [/#if]
    [#if context.get(pluginModuleConfigurationPrefix+':upperLimitInGb')??]
        [#assign upperLimitInGb = context.get(pluginModuleConfigurationPrefix+':upperLimitInGb')]
    [#else]
        [#assign upperLimitInGb = 1]
    [/#if]
    [#assign leftSpace = upperLimitInGb - takenSpaceInGb]
    [#if leftSpace < 0]
        [#assign leftSpace = 0]
    [/#if]
    [#if upperLimitInGb == 0]
        [#assign usedCapacity = 1]
    [#else]
        [#assign usedCapacity = takenSpaceInGb/upperLimitInGb]
    [/#if]

    [#if usedCapacity > 1]
        [#assign usedCapacity = 1]
    [/#if]

    <div id="storageCapacityProgress"></div>
    <table id="spaceUsage">
        <tr>
            <td width="30%">
                <div class="usedSpaceCircle [#if usedCapacity==1]error[/#if]"></div>
                <span id="usedSpace">${i18n.getText('admin.artifactstorage.local.used', [takenSpaceInGb?string['0.#']!0])}</span>
            </td>
            <td width="30%">
                <div class="leftSpaceCircle"></div>
                <span id="leftSpace">${i18n.getText('admin.artifactstorage.local.left', [leftSpace?string['0.#']!'25'])}</span>
            </td>
            <td width="40%" style="text-align: right">
                <strong>${i18n.getText('admin.artifactstorage.local.total', [upperLimitInGb?string['0.#']!'25'])}</strong>
            </td>
        </tr>
    </table>

    <script type="text/javascript">
        require(['jquery', 'widget/progress-bar', 'page/artifact-storage-config'], function($, ProgressBar, ArtifactStorageConfig) {
            new ProgressBar({
                el: "#storageCapacityProgress",
                value: +(${usedCapacity})
            });
            [#if usedCapacity == 1 && selectedArtifactStorage == 'custom.artifactHandlers.comAtlassianBambooPluginArtifactHandlerRemote:BambooRemoteArtifactHandler']
                return new ArtifactStorageConfig({
                    target: '#selectedArtifactStorage'
                });
            [/#if]
        });
    </script>
[/#if]