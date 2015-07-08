[#include "/${parameters.templateDir}/${parameters.theme}/controlheader.ftl" /]
[#if parameters.cssClass??]
    ${tag.addParameter("cssClass", "text plan-picker ${parameters.cssClass}") }
[#else]
    ${tag.addParameter("cssClass", "text plan-picker") }
[/#if]
[#assign planPickerDataAttributes = {} /]
[#--
    The conditions:
    * parameters.nameValue?split("-")?size > 1
    * parameters.nameValue?split("-")?size < 5
    prevent PlanKeys.getPlanKey from throwing an exception due to something that doesn't look like a plan key
--]
[#if parameters.nameValue?has_content && parameters.nameValue?split("-")?size > 1 && parameters.nameValue?split("-")?size < 5]
    [#assign tmpPlan = (action.getPlan(parameters.nameValue))! /]
    [#if tmpPlan?has_content]
        [#assign planPickerDataAttributes = planPickerDataAttributes + {
            "field-text": tmpPlan.name
        } /]
    [/#if]
[/#if]
${tag.addParameter("dataAttributes", planPickerDataAttributes) }
[#include "/${parameters.templateDir}/simple/text.ftl" /]
<script type="text/javascript">
    require(['jquery', 'widget/plan-single-select'], function($, PlanSingleSelect){
        return new PlanSingleSelect({
            el: $('#${parameters.id}')
        });
    });
</script>
[#include "/${parameters.templateDir}/${parameters.theme}/controlfooter.ftl" /]