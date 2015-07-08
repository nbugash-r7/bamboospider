[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.credentials.CreateSharedCredentials" --]
[@ww.form  action='updateSharedCredentials'
        method='POST'
        enctype='multipart/form-data'
        namespace="/admin"
        submitLabelKey="credentials.update.button"
        cancelUri="/admin/configureSharedCredentials.action"
        cssClass="aui"]

	<h2>
        [@ww.text name="sharedCredentials.edit" ]
            [@ww.param]${credentialsType}[/@ww.param]
        [/@ww.text] - ${credentialsName?html}
    </h2>

    <div class="aui-message warning">
         [@ww.text name="sharedCredentials.edit.warning" /]
         <span class="aui-icon icon-warning"></span>
    </div>

    [@ww.hidden name="credentialsId" value=credentialsId /]

    [@ui.bambooSection id='credentials-id']
        [@ww.textfield labelKey="credentials.name" name="credentialsName" id="credentialsName" required=true/]
    [/@ui.bambooSection]

    ${editHtml!}
[/@ww.form]