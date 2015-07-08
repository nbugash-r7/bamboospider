[#-- @ftlvariable name="pluginModuleConfigurationPrefix" type="java.lang.String" --]

[#assign bucketNameHelpDialogContent]
    [@ww.text name='elastic.configure.field.bucketName.info']
        [@ww.param][@help.href pageKey="help.s3.artifact.storage.configuration"/][/@ww.param]
    [/@ww.text]
[/#assign]

[#if context.get(pluginModuleConfigurationPrefix+':showCredentialsConfiguration') == true]
    [@s.textfield key='elastic.configure.aws.field.accessKeyId' name=pluginModuleConfigurationPrefix+':accessKeyId'/]
    [@s.checkbox key='elastic.configure.aws.field.secretAccessKey.change' toggle='true' name=pluginModuleConfigurationPrefix+':awsSecretAccessKeyChange' /]
    [@ui.bambooSection dependsOn=pluginModuleConfigurationPrefix+':awsSecretAccessKeyChange' showOn='true']
        [@s.password key='elastic.configure.aws.field.secretAccessKey' name=pluginModuleConfigurationPrefix+':secretAccessKey'/]
    [/@ui.bambooSection]
    [@s.textfield key='elastic.configure.field.bucketName' name=pluginModuleConfigurationPrefix+':bucketName' cssClass="long-field"/]
    [@s.textfield key='elastic.configure.field.bucketPath' name=pluginModuleConfigurationPrefix+':bucketPath'/]
[#else]
    [@ui.bambooSection titleKey="admin.artifactstorage.s3.header" cssClass="artifact-storage-details"]
        [@ww.text name="admin.artifactstorage.s3.description"/]
    [/@ui.bambooSection]
    [#if fieldErrors.get(pluginModuleConfigurationPrefix + ':')?has_content]
        [#list fieldErrors.get(pluginModuleConfigurationPrefix + ':') as error]
            [@ui.messageBox type='warning' content=error/]
        [/#list]
    [/#if]
    [@s.textfield
        key='elastic.configure.field.bucketName'
        name=pluginModuleConfigurationPrefix+':bucketName'
        required=true
        cssClass='long-field'
        maxLength="${context.get(pluginModuleConfigurationPrefix+':bucketNameMaxLength')}"
        helpDialog=bucketNameHelpDialogContent
        helpIconCssClass='aui-iconfont-info'
    /]
[/#if]