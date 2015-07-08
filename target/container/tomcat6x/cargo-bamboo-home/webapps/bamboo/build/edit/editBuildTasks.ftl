[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.task.ConfigureBuildTasks" --]
[#-- @ftlvariable name="plan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]

${webResourceManager.requireResourcesForContext("ace.editor")}

[#import "editBuildConfigurationCommon.ftl" as ebcc/]
[#import "/lib/menus.ftl" as menu]
[#import "/lib/build.ftl" as bd]

[#assign tasksTitleDescription]
    <p>[@ww.text name="tasks.config.description"]
           [@ww.param][@ww.text name="help.prefix"/][@ww.text name="tasks.configuring"/][/@ww.param]
       [/@ww.text]</p>
    <p>[@ww.text name="tasks.config.variable.info"]
           [@ww.param]${baseUrl}/build/admin/ajax/viewAvailableVariables.action?planKey=${immutablePlan.key}[/@ww.param]
       [/@ww.text]</p>
[/#assign]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    <h2>${navigationContext.currentObject.displayName}</h2>
    [@menu.displayJobsTabs
        currentPlan=navigationContext.currentObject
        selectedTab="tasks"
    /]
[/#if]

[@ebcc.editConfigurationPage description=tasksTitleDescription plan=immutablePlan selectedTab='tasks' titleKey='tasks.config.title']
    <p class="short-agent-desc">
        [@ww.action name="showAgentNumbers" namespace="/ajax" executeResult="true" /]
    </p>
    [#include "./editBuildTasksCommon.ftl"/]
[/@ebcc.editConfigurationPage]