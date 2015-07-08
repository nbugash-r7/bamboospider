[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchDetails" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.EditChainBranchDetails" --]

[#import "/lib/menus.ftl" as menu]
[#import "branchesCommon.ftl" as bc/]

<html>
<head>
    [@ui.header pageKey='branch.configuration.edit.title.long' object=immutablePlan.name title=true /]
    <meta name="tab" content="branch.details"/>
</head>
<body>

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@ui.header pageKey="branch.details.edit" headerElement='h2' /]
[#else]
    [@ui.header pageKey="branch.details.edit" descriptionKey="branch.details.edit.description" headerElement='h2' /]
[/#if]

[#assign pageContent]
    [@ww.form action="saveChainBranchDetails" namespace="/branch/admin/config" cancelUri='/browse/${immutableChain.key}/config' submitLabelKey='global.buttons.update']
        [@ww.textfield labelKey='branch.name' name='branchName' required='true' /]
        [@ww.textfield labelKey='branch.branchDescription' name='branchDescription' required='false' longField=true /]
        [@ww.checkbox labelKey='branch.enabled' name="enabled" /]
        [@ww.hidden name="returnUrl" /]
        [@ww.hidden name="planKey" /]
        [@ww.hidden name="buildKey" /]

        [#if branchDetectionCapable]
            [#assign inactiveAndRemovedBranchCleanUpPlanLevelEnabled = removedBranchCleanUpPlanLevelEnabled && inactiveBranchCleanUpPlanLevelEnabled /]
            [#if inactiveAndRemovedBranchCleanUpPlanLevelEnabled]
                [#assign branchCleanupDescription]
                    [#if removedBranchCleanUpPeriod == 0]
                        [@ww.text name='daily.removed.and.inactive.branch.removal.summary']
                            [@ww.param]${inactiveBranchCleanUpPeriod}[/@ww.param]
                        [/@ww.text]
                    [#else]
                        [@ww.text name='removed.and.inactive.branch.removal.summary']
                            [@ww.param]${removedBranchCleanUpPeriod}[/@ww.param]
                            [@ww.param]${inactiveBranchCleanUpPeriod}[/@ww.param]
                        [/@ww.text]
                    [/#if]
                [/#assign]
            [#elseif removedBranchCleanUpPlanLevelEnabled]
                [#assign branchCleanupDescription]
                    [#if removedBranchCleanUpPeriod == 0]
                        [@ww.text name='daily.removed.branch.removal.summary'/]
                    [#else]
                        [@ww.text name='removed.branch.removal.summary']
                            [@ww.param]${removedBranchCleanUpPeriod}[/@ww.param]
                        [/@ww.text]
                    [/#if]
                [/#assign]
            [#elseif inactiveBranchCleanUpPlanLevelEnabled]
                [#assign branchCleanupDescription]
                    [@ww.text name='inactive.branch.removal.summary']
                        [@ww.param]${inactiveBranchCleanUpPeriod}[/@ww.param]
                    [/@ww.text]
                [/#assign]
            [/#if]
            [@ww.checkbox labelKey='branch.cleanup.description' name='planBranchCleanUpEnabled' description=branchCleanupDescription/]
        [/#if]

        [#include "/build/common/configureTrigger.ftl"]
        [@ui.bambooSection titleKey='repository.change']
            [@ww.checkbox labelKey='branch.trigger.override' name="overrideBuildStrategy" toggle=true helpKey='branch.buildStrategy.override'/]
            [@ui.bambooSection dependsOn="overrideBuildStrategy" showOn=true]
                [@configureTrigger /]
            [/@ui.bambooSection]
        [/@ui.bambooSection]

        [#if mergeCapable]
            [@bc.showIntegrationStrategyConfiguration chain=immutableChain/]
        [#elseif defaultRepository??]
            [@bc.mergingNotAvailableMessage action.isGitRepository() defaultRepositoryDefinition defaultRepository/]
        [/#if]
    [/@ww.form]
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@menu.displayTabbedContent location="branchConfiguration.subMenu" selectedTab="branch.details" linkCssClass="jsLoadPage" historyXhrDisabled=true]
        ${pageContent}
    [/@menu.displayTabbedContent]
[#else]
    ${pageContent}
[/#if]

</body>
</html>

