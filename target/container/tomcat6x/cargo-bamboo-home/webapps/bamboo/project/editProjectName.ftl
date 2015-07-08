[#-- @ftlvariable name="action" type="com.atlassian.bamboo.ww2.actions.project.EditProjectName" --]
[#-- @ftlvariable name="" type="com.atlassian.bamboo.ww2.actions.project.EditProjectName" --]

[@ww.form action="saveProjectName" namespace="/project/admin/config" cancelUri='/browse/${projectKey}' submitLabelKey='global.buttons.update']
    [@ww.textfield labelKey='project.name' name='projectName' required='true' /]
    [@ww.hidden name="projectKey" /]
[/@ww.form]
