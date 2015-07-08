[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.repository.EditRepository" --]
[#-- @ftlvariable name="uiConfigBean" type="com.atlassian.bamboo.ww2.actions.build.admin.create.UIConfigBeanImpl" --]

<html>
<head>
    [@ui.header pageKey='branch.configuration.edit.title.long' object=immutablePlan.name title=true /]
    <meta name="tab" content="branch.repository"/>
</head>
<body>

[#import "/lib/menus.ftl" as menu]
[#import "/build/common/repositoryCommon.ftl" as rc]

[@ui.header pageKey="branch.config.repository" headerElement='h2' /]

[#assign pageContent]
    [#if repository?has_content]
        [#if defaultRepositoryTypeDifferent]
            [@ui.messageBox type="warning" titleKey='branch.config.repository.override.defaultRepositoryTypeIsDifferent' /]
        [/#if]

        [@ww.form
            action="saveChainBranchRepository"
            method='POST'
            enctype='multipart/form-data'
            namespace="/branch/admin/config"
            submitLabelKey="repository.update.button"
            cancelUri="/browse/${planKey}/config"]

            <div id="repository-selector">
                [@ww.checkbox labelKey='branch.config.repository.override' name="overrideRepository" toggle='true' /]

                [@ui.bambooSection id='repository-configuration' dependsOn="overrideRepository" showOn="true"]
                    [@ww.label labelKey="branch.config.repository.type" name="repositoryType" /]
                    [@ww.label labelKey="branch.config.repository.name" name="repositoryName" /]

                    [@ui.bambooSection id='repository-configuration']
                        ${repositoryDefinition.repository.getEditHtml(buildConfiguration, mutablePlan)!}
                        [@rc.advancedRepositoryEdit plan=mutablePlan/]
                    [/@ui.bambooSection]
                [/@ui.bambooSection]

                [@ww.hidden name="planKey" value=planKey /]
                [@ww.hidden name="repositoryId" value=repositoryId /]
                [@ww.hidden name="repositoryName" value=repositoryName/]
                [@ww.hidden id="selectedRepository" name="selectedRepository" value=selectedRepository toggle=true /]
            </div>

            <script type="text/javascript">
                require(['jquery', 'widget/repository-selector', 'util/events'], function($, RepositorySelector, events){
                    $(function () {
                        new RepositorySelector({
                            el: $('#repository-selector')
                        });

                        events.EventBus.trigger(
                            'repository:selector:change', {}, 'NEW', $('#selectedRepository').val()
                        );
                    });
                });
            </script>
        [/@ww.form]
    [#else]
        [#--This has a customised template because I don't want the "unexpected error has occured" bit.--]
        [#if action.hasActionErrors() ]
            [#if actionErrors.size() == 1 ]
                [#assign heading]${formattedActionErrors.iterator().next()}[/#assign]
                [@ui.messageBox type="error" title=heading /]
            [#else ]
                [@ui.messageBox type="error" titleKey="error.multiple"]
                <ul>
                    [#list formattedActionErrors as error]
                        <li>${error}</li>
                    [/#list]
                </ul>
                [/@ui.messageBox]
            [/#if]
        [/#if]
    [/#if]
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@menu.displayTabbedContent location="branchConfiguration.subMenu" selectedTab="branch.repository" linkCssClass="jsLoadPage" historyXhrDisabled=true]
        ${pageContent}
    [/@menu.displayTabbedContent]
[#else]
    ${pageContent}
[/#if]

</body>
</html>