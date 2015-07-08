[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.build.admin.config.variable.ConfigurePlanVariables" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.build.admin.config.variable.ConfigurePlanVariables" --]
[#import "/fragments/variable/variables.ftl" as variables/]

<html>
<head>
    [@ui.header pageKey="plan.variables.title" title=true/]
    <meta name="tab" content="variables"/>
</head>

<body>

<div class="toolbar aui-toolbar inline">[@help.url pageKey="variables.howtheywork"][@ww.text name="variables.howtheywork.title"/][/@help.url]</div>
[@ui.header pageKey="plan.variables.heading" descriptionKey="plan.variables.description" headerElement="h2" /]

[@ww.url id="createVariableUrl" namespace="/build/admin/ajax" action="createPlanVariable" planKey=immutablePlan.key /]
[@ww.url id="deleteVariableUrl" namespace="/build/admin/ajax" action="deletePlanVariable" planKey=immutablePlan.key variableId="VARIABLE_ID"/]
[@ww.url id="updateVariableUrl" namespace="/build/admin/ajax" action="updatePlanVariable" planKey=immutablePlan.key/]

[@variables.configureVariables
    id="planVariables"
    variablesList=action.variables
    createVariableUrl=createVariableUrl
    deleteVariableUrl=deleteVariableUrl
    updateVariableUrl=updateVariableUrl
    overriddenVariablesMap=overriddenVariablesMap
    globalNotOverriddenVariables=globalNotOverriddenVariables
    tableId="plan-variable-config"/]

</body>
</html>
