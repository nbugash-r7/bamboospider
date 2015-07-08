[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]

${webResourceManager.requireResourcesForContext("bamboo.configuration")}

<html>
<head>
    <title>[@ww.text name='plan.create.clone.title' /]</title>
    <meta name="decorator" content="atl.general"/>
    <meta name="topCrumb" content="create"/>
    <meta name="bodyClass" content="aui-page-focused aui-page-focused-xlarge"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey='plan.clone.howtheywork'][@ww.text name='plan.clone.howtheywork.title'/][/@help.url]</div>
[@ui.header pageKey="plan.create.clone.title" headerElement="h2" /]
<p>[@ww.text name="plan.create.clone.description" /]</p>

[@ww.form action="performClonePlan" namespace="/build/admin/create"
          cancelUri='start.action'
          submitLabelKey='Create']

        [@ui.bambooSection titleKey="chain.clone.list"]
            [#if plansToClone?has_content]
                [@ww.select labelKey='chain.clone.list' name='planKeyToClone'
                    list='plansToClone' listKey='key' listValue='buildName' groupBy='project.name']
                [/@ww.select]
            [#else]
                [@ui.messageBox type="error" titleKey="build.clone.list.empty" /]
            [/#if]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="project.details.clone"]
            [#include "/fragments/project/selectCreateProject.ftl"]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="build.details"]

                [#include "/fragments/chains/editChainKeyName.ftl"]

            [@ww.hidden name="clonePlan" value="true"/]
        [/@ui.bambooSection]

        [@ui.bambooSection titleKey="plan.create.enable.title"]
            [@ww.checkbox labelKey="plan.create.enable.option" name='tmp.createAsEnabled' descriptionKey='plan.create.enable.description'/]
        [/@ui.bambooSection]
[/@ww.form]
<script type="text/javascript">
    AJS.$(function ($) {
        var $projectDropdown = $('#performClonePlan_existingProjectKey');
        var handlePlanSelection = function () {
            var selectedProjectKey = $(this).val().split('-')[0];
            $projectDropdown.val(selectedProjectKey);
        };
        var $planToClone = $('#performClonePlan_planKeyToClone').change(handlePlanSelection);
        if (${(!existingProjectKey?has_content)?string}) {
            handlePlanSelection.call($planToClone[0]);
        }
    });
</script>
</body>
</html>