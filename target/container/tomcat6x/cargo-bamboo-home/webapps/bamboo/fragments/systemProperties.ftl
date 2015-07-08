[@ui.bambooSection titleKey='config.instance' ]
    [@ww.textfield name='instanceName' labelKey='config.instance.name' /]
[/@ui.bambooSection]

[#if featureManager.changeBaseUrlAllowed]
    [@ui.bambooSection titleKey='config.server']
        [#assign baseUrlDescription]
            [@ww.text name='config.server.baseUrl.description' ]
                [@ww.param]${defaultBaseUrl}[/@ww.param]
            [/@ww.text]
        [/#assign]
        [@ww.textfield labelKey='config.server.baseUrl' name="baseUrl" required="true" description=baseUrlDescription value=baseUrl! size=40 /]
    [/@ui.bambooSection]
[/#if]
[@ui.bambooSection titleKey='config.options']
    [#if featureManager.gzipCompressionSupported]
        [@ww.checkbox id='gzipCompression_id' labelKey='config.options.gzip' descriptionKey='config.options.gzip.description' name='gzipCompression' value=gzipCompression  /]
    [/#if]

    [#assign apiDescription]
        [@ww.text name='config.options.api.description']
            [@ww.param]${actualBaseUrl?html}[/@ww.param]
        [/@ww.text]
    [/#assign]
    [#--[@ww.checkbox id='acceptRemoteApiCalls_id' labelKey='config.options.api' description=apiDescription name="acceptRemoteApiCalls" value=acceptRemoteApiCalls /]--]
    [@ww.checkbox id='enableGravatar_id' labelKey='config.options.gravatar' name="enableGravatar" /]
[/@ui.bambooSection]

