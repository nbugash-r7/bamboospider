[#-- @ftlvariable name="" type="com.atlassian.bamboo.configuration.credentials.CreateSharedCredentials" --]
[@ww.form  action='createSharedCredentials'
        method='POST'
        enctype='multipart/form-data'
        namespace="/admin"
        submitLabelKey="credentials.update.button"
        cancelUri="/admin/configureSharedCredentials.action"
        cssClass="aui"]

	<h2>
        [@ww.text name="sharedCredentials.add" ]
            [@ww.param]${credentialsType}[/@ww.param]
        [/@ww.text]
    </h2>

    [@ww.hidden name="credentialsId" value=credentialsId /]

    [@ui.bambooSection id='credentials-id']
        [@ww.textfield labelKey="credentials.name" name="credentialsName" id="credentialsName" required=true/]
    [/@ui.bambooSection]

    ${editHtml!}

    [@ww.hidden name="createCredentialsKey"/]
[/@ww.form]