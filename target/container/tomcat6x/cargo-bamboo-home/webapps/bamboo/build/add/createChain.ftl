[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.create.CreateChain" --]
[#-- @ftlvariable name="uiConfigBean" type="com.atlassian.bamboo.ww2.actions.build.admin.create.UIConfigBeanImpl" --]

[#import "/build/common/repositoryCommon.ftl" as rc]

<html>
<head>
    <title>[@ww.text name='plan.create' /] - [@ww.text name='plan.create.new.title' /]</title>
    <meta name="tab" content="1"/>
</head>
<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey='plan.create.howtheywork'][@ww.text name='plan.create.howtheywork.title'/][/@help.url]</div>
[@ui.header pageKey="plan.create" headerElement="h2"/]
<p>[@ww.text name="plan.create.new.description" /]</p>

[#assign createAction][#if req.getRequestURI()?contains('ec2wizard')]/build/admin/create/ec2wizard/createPlanFromEc2.action[#else]createPlan[/#if][/#assign]
[@ww.form
    action=createAction
    namespace="/build/admin/create"
    method="post" enctype="multipart/form-data"
    cancelUri="start.action" submitLabelKey="plan.create.tasks.button"
]
    <div class="configSection">
        [@ui.bambooSection titleKey="project.details"]
            [#include "/fragments/project/selectCreateProject.ftl"]
            [#include "/fragments/chains/editChainKeyName.ftl"]
        [/@ui.bambooSection]

        [@ui.bambooSection id="source-repository" titleKey="repository.create.title"]
            [#assign linkedRepositories = uiConfigBean.getLinkedRepositoriesForCreate() /]
            [#assign primaryRepositories = uiConfigBean.getPrimaryRepositoriesForCreate() /]

            [#if !repositoryTypeOption?has_content && linkedRepositories?has_content]
                [#assign repositoryTypeOption = "LINKED" /]
            [#elseif !repositoryTypeOption?has_content]
                [#assign repositoryTypeOption = "NEW" /]
            [/#if]

            [@rc.repositorySelector
                primaryRepositories, uiConfigBean.getNonPrimaryRepositoriesForCreate()
                linkedRepositories, repositoryTypeOption, selectedRepository
            /]
        [/@ui.bambooSection]
    </div>
[/@ww.form]

</body>
</html>