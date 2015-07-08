[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.BambooActionSupport" --]
[#-- @ftlvariable name="decoratedPlan" type="com.atlassian.bamboo.ww2.beans.DecoratedPlan" --]
[#-- @ftlvariable name="immutablePlan" type="com.atlassian.bamboo.plan.cache.ImmutablePlan" --]

[#import "/lib/menus.ftl" as menu]
[#import "/lib/chains.ftl" as chains]
[#import "/fragments/breadCrumbs.ftl" as bc]
[#import "/fragments/decorator/decorators.ftl" as decorators/]

[#if ctx.darkFeatureService.simplifiedPlanConfigEnabled]
    [@decorators.displayHtmlHeader requireResourcesForContext=["atl.general", "bamboo.configuration", "bamboo.configuration.simplified"] /]

    [#if (navigationContext.currentObject)?? && !navigationContext.currentObject.isResult()]
        [#assign topLevelPlan=((immutablePlan.parent)!immutablePlan)/]
        [#assign decoratedPlan = navigationContext.currentObject/]

        [#if topLevelPlan.masterId > 0]
            [#assign topLevelPlan=topLevelPlan.master/]
        [/#if]

        [#assign headerImageContent]
            [@bc.showProjectIcon decoratedPlan /]
        [/#assign]

        [#assign headerMainContent]
            [@bc.showBreadcrumbs decoratedPlan true /]
        [/#assign]

        [#assign headerActionsContent]
            [#assign planI18nPrefix=fn.getPlanI18nKeyPrefix(topLevelPlan)/]

            [#assign planLevelItems]
                [#if !plan.suspendedFromBuilding]
                    [@menu.displayPlanSuspendLink topLevelPlan planI18nPrefix+'.disable'/]
                [#else]
                    [@menu.displayPlanResumeLink topLevelPlan planI18nPrefix+'.enable'/]
                [/#if]

                [@menu.displayAddPlanLabelLink topLevelPlan planI18nPrefix+'.add.label' /]
                [@menu.displayPlanDeleteLink topLevelPlan 'chain.delete' '/start.action'/]
            [/#assign]

            [#assign menuButtons]
                [@menu.displayChainRunMenu plan=topLevelPlan! /]
                [@menu.displayHeaderActions planItems=planLevelItems! /]
            [/#assign]

            ${soy.render('aui.buttons.buttons', {
                'extraClasses': 'aui-dropdown2-trigger-group',
                'content': menuButtons
            })}
        [/#assign]

        [#assign headerExtraContent]
            [#if decoratedPlan??]
                [#import "/fragments/labels/labels.ftl" as lb /]
                [@lb.showLabelEditorForPlan plan=topLevelPlan! /]
            [/#if]
        [/#assign]

        [#assign mainContent]
            <div class="content">
                <div class="container">
                    <div class="content-body jsLoadContent">
                        [#if body?has_content]
                            ${body}
                        [/#if]
                    </div>
                </div>
            </div>
            <script>
                require('page/plan-config').onReady({
                    planKey: '${decoratedPlan.masterChainKey!""}',
                    jobKey: '${(decoratedPlan.masterJobKey)!""}',
                    branchKey: '${(decoratedPlan.branchPlanKey)!""}',
                    pageKey: '${page.properties["meta.tab"]!""}'
                });
            </script>
        [/#assign]

        ${soy.render("bamboo.layout.plan", {
            "headerImageContent": headerImageContent,
            "headerMainContent": headerMainContent,
            "headerActionsContent": headerActionsContent!,
            "headerExtraContent": headerExtraContent,
            "pageItemContent": " ",
            "pageItemClass": "planconfig-sidebar",
            "contentClass": "planconfig-content",
            "pagePanelClass": "planconfig",
            "content": mainContent
        })}
    [#else]
        <section id="content" role="main">
            <div class="aui-panel">
                [@ui.messageBox type="error" title="Apologies, this page could not be properly decorated (data is missing)" /]
                ${body}
            </div>
        </section>
    [/#if]
[#else]
    [#include "configLegacyDecorator.ftl"]
[/#if]