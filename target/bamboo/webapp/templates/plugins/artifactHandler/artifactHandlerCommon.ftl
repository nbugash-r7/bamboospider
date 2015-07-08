[#macro displayArtifactHandlerEnableDisableTable artifactHandlerDescriptors]
<table class="aui">
    <thead>
    <tr>
        <th>Artifact Handler Name</th>
        <th class="checkboxCell">Enabled for Shared Artifacts</th>
        <th class="checkboxCell">Enabled for Non-Shared Artifacts</th>
    </tr>
    </thead>
<tbody>
[#list artifactHandlerDescriptors as artifactHandlerDescriptor]
    <tr>
        <td>${artifactHandlerDescriptor.name}</td>
        <td class="checkboxCell">[@s.checkbox name='${artifactHandlerDescriptor.configurationPrefix}:enabledForShared' theme='simple'/]</td>
        <td class="checkboxCell">[@s.checkbox name='${artifactHandlerDescriptor.configurationPrefix}:enabledForNonShared' theme='simple'/]</td>
    </tr>
[/#list]
</tbody>
</table>
[/#macro]