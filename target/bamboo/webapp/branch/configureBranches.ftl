[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.branch.ConfigureBranches" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.branch.ConfigureBranches" --]
[#import "../chain/edit/editChainConfigurationCommon.ftl" as eccc/]
[#import "/lib/chains.ftl" as cn]
[#import "branchesCommon.ftl" as bc/]

[#assign buttonsToolbar]
    [#if fn.hasPlanPermission('ADMINISTRATION', immutablePlan)]
        [@ww.url id='createBranchUrl' action='newPlanBranch' namespace='/chain/admin' planKey=planKey returnUrl=currentUrl /]
        [@cp.displayLinkButton buttonId='createBranch' buttonLabel='branch.create.new.title' buttonUrl=createBranchUrl/]

        <script type="text/javascript">
            BAMBOO.redirectToBranchRepositoryConfig = function (data) {
                window.location = AJS.contextPath() + data.redirectUrl;
            }
        </script>
        [@dj.simpleDialogForm triggerSelector="#createBranch" width=710 height=500 headerKey="branch.create.new.title" submitCallback="BAMBOO.redirectToBranchRepositoryConfig" /]
    [/#if]
[/#assign]

[@eccc.editChainConfigurationPage plan=immutablePlan selectedTab='chain.branch' titleKey='chain.config.branches' descriptionKey='chain.config.branches.description' tools=buttonsToolbar ]
    [#if !fn.hasPlanPermission('ADMINISTRATION', immutablePlan)]
        [@ui.messageBox type="warning" titleKey='chain.config.branches.permission.error' /]
    [#else]
        [@ww.form action='updateBranches'
            namespace='/chain/admin/config'
            showActionErrors='false'
            id='chain.branch'
            cancelUri='/browse/${immutablePlan.key}/config'
            submitLabelKey='global.buttons.update'
        ]
            [@ww.hidden name="planKey" /]
            [#if action.branchDetectionCapable]

                [#-- Subversion configuration section --]
                [#if action.isSvnRepository()]
                    [@ui.bambooSection titleKey='chain.config.branches.svnBranchesLocation' descriptionKey='chain.config.branches.svnBranchesLocation.description']
                        [@ww.checkbox labelKey='chain.config.branches.svnBranchRootOverridden' name='svnBranchRootOverridden' toggle=true /]
                        [@ui.bambooSection dependsOn='svnBranchRootOverridden' showOn=true]
                            [@ww.textfield labelKey='chain.config.branches.svnBranchRootOverride' name='svnBranchRootOverride' cssClass="long-field" required=true/]
                        [/@ui.bambooSection]
                        [@ui.bambooSection dependsOn='svnBranchRootOverridden' showOn=false]
                            [@ww.label labelKey='chain.config.branches.svnBranchRootOverride' value=svnRepositoryBranchRoot /]
                        [/@ui.bambooSection]
                    [/@ui.bambooSection]
                [/#if]

                [#-- Branch management section--]
                [@ui.bambooSection titleKey='chain.config.branches.automatic.management.title' descriptionKey='chain.config.branches.automatic.management.description']

                    [#-- Create branch section--]
                    [@ww.select
                        key='chain.config.branches.creation.title'
                        name='planBranchCreation'
                        toggle='true'
                        list=branchCreationTypes
                        i18nPrefixForValue='chain.config.branches.creation.select'
                        listValue='key'
                        listKey='key'
                        longField=true
                        helpDialogKey='chain.config.branches.creation.helpdialog'/]

                    [@ui.bambooSection dependsOn='planBranchCreation' showOn='match']
                        [@ww.textfield labelKey='chain.config.branches.creation.regular.expression' name='planBranchCreationRegularExpression' longField=true/]
                    [/@ui.bambooSection]

                    [#-- Removed branch clean up section--]
                    [@ww.select
                        key='chain.config.branches.removed.cleanup.title'
                        name='removedBranchCleanUp'
                        toggle='true'
                        list=removedBranchCleanUpTypes
                        i18nPrefixForValue='chain.config.branches.removed.cleanup.select'
                        listValue='key'
                        listKey='key'
                        longField=true
                        helpDialogKey='chain.config.branches.removed.cleanup.helpdialog'/]

                    [#assign cleanupPeriodUnits]
                        <span class="aui-form">[@ww.text name="chain.config.branches.cleanup.period.unit"/]</span>
                    [/#assign]
                    [@ui.bambooSection dependsOn='removedBranchCleanUp' showOn='periodically']
                        [#-- add
                        labelKey='chain.config.branches.removed.cleanup.period.title'
                        if we can find a short enough label.
                        --]
                        [@ww.textfield cssClass='short-field' name='removedBranchCleanUpPeriodInDays' after=cleanupPeriodUnits /]
                    [/@ui.bambooSection]

                    [#-- Inactive branch clean up section--]
                    [@ww.select
                        key='chain.config.branches.inactive.cleanup.title'
                        name='inactiveBranchCleanUp'
                        toggle='true'
                        list=inactiveBranchCleanUpTypes
                        i18nPrefixForValue='chain.config.branches.inactive.cleanup.select'
                        listValue='key'
                        listKey='key'
                        longField=true
                        helpDialogKey='chain.config.branches.inactive.cleanup.helpdialog'/]

                    [#assign cleanupPeriodUnits]
                        <span class="aui-form">[@ww.text name="chain.config.branches.cleanup.period.unit"/]</span>
                    [/#assign]
                    [@ui.bambooSection dependsOn='inactiveBranchCleanUp' showOn='periodically']
                        [#-- Add
                        labelKey='chain.config.branches.inactive.cleanup.period.title'
                        if we can find a short enough label --]
                        [@ww.textfield cssClass='short-field'  name='inactiveBranchCleanUpPeriodInDays' after=cleanupPeriodUnits /]
                    [/@ui.bambooSection]

                    [#-- Turn on Automatic Deletion when Automatic Creation gets enabled. --]
                    <script type="text/javascript">
                        AJS.$(function ($) {
                            var $branchCreationPicker = $("#chain_branch_planBranchCreation");
                            $branchCreationPicker.data("currentValue", $branchCreationPicker.val());

                            $branchCreationPicker.change(function() {
                                var newCreationValue = $branchCreationPicker.val();
                                var oldCreationValue = $branchCreationPicker.data("currentValue");
                                $branchCreationPicker.data("currentValue", newCreationValue);
                                if (newCreationValue != "disabled" && oldCreationValue == "disabled")
                                {
                                    if ($("#chain_branch_removedBranchCleanUp").val() == "disabled")
                                        $("#chain_branch_removedBranchCleanUp").val("periodically").change();
                                    if ($("#chain_branch_inactiveBranchCleanUp").val() == "disabled")
                                        $("#chain_branch_inactiveBranchCleanUp").val("periodically").change();
                                }
                            });
                        });
                    </script>
                [/@ui.bambooSection] [#-- End Automatic Branch Management Section--]

                [#if mergeCapable]
                    [@bc.showIntegrationStrategyConfiguration chain=immutableChain configuringDefaults=true titleKey="chain.config.branches.merging.edit"/]
                [#elseif defaultRepository??]
                    [@bc.mergingNotAvailableMessage action.isGitRepository() defaultRepositoryDefinition defaultRepository/]
                [/#if]

            [#else]
                [@ui.bambooPanel titleKey='chain.config.branches.automatic.management.title' description=automaticallyCreateBranches headerWeight='h3']
                    [@ui.messageBox titleKey='chain.config.branches.detection.error']
                    <p>[@ww.text name='chain.config.branches.detection.error.message' /]</p>
                    [/@ui.messageBox]
                [/@ui.bambooPanel]
            [/#if]


            [#if jiraApplicationLinkDefined]
                [@ui.bambooSection titleKey="chain.config.branches.issueLinking" descriptionKey='chain.config.branches.issueLinking.description']
                    [@ww.checkbox labelKey='chain.config.branches.issueLinkingEnabled' name='remoteJiraBranchLinkingEnabled' helpKey="branch.featureBranches"/]
                [/@ui.bambooSection]
            [/#if]

            [@ui.bambooPanel titleKey='chain.config.branches.notifications' descriptionKey='chain.config.branches.notifications.description' headerWeight='h3']
                [@ww.radio name="defaultNotificationStrategy"
                listKey="key"
                listValue="key"
                i18nPrefixForValue="chain.config.branches.notifications"
                showDescription=true
                list=notificationStrategies /]
            [/@ui.bambooPanel]

            [/@ww.form]
    [/#if]

    [#if !hideBranchesSplashScreen]
        [@ww.text name='branch.splash.description' id='branchSplashDescription' /]
        [#assign dialogContent][#rt/]
            <p>${branchSplashDescription?replace('\n', '<br>')?replace('<br><br>', '</p><p>')}</p>[#t/]
            <p>[@help.url pageKey="branch.using.plan.branches"][@ww.text name='branch.splash.learnmore' /][/@help.url]</p>[#t/]
        [/#assign][#lt/]
        <script type="text/x-template" title="dontShowCheckbox-template">
            [@ww.checkbox name='dontshow' labelKey='branch.splash.dontshowagain' /]
        </script>
        <script type="text/javascript">
            BAMBOO.BRANCHES.BranchesSplashScreen.init({ content: '${dialogContent?js_string}', templates: { dontShowCheckbox: 'dontShowCheckbox-template' } });
        </script>
    [/#if]
[/@eccc.editChainConfigurationPage]