package com.rapid7.bamboospider;

import com.atlassian.bamboo.collections.ActionParametersMap;
import com.atlassian.bamboo.task.AbstractTaskConfigurator;
import com.atlassian.bamboo.task.TaskDefinition;
import com.atlassian.bamboo.utils.error.ErrorCollection;
import com.atlassian.struts.TextProvider;
import com.atlassian.util.concurrent.NotNull;
import com.atlassian.util.concurrent.Nullable;
import org.apache.commons.lang.StringUtils;

import java.util.*;


/**
 * Created by nbugash on 08/07/15.
 */
public class BambooSpiderScanTaskConfigurator extends AbstractTaskConfigurator {

    private TextProvider textProvider;
    /*
     * generateTaskConfig method is needed to save the configuration
     * */
    public Map<String,String> generateTaskConfigMap(@NotNull ActionParametersMap params,
                                                 @Nullable TaskDefinition previousTaskDefinition){

        Map<String,String> configMap = super.generateTaskConfigMap(params,previousTaskDefinition);
        configMap.put("restUrl",params.getString("restUrl"));
        configMap.put("login",params.getString("login"));
        configMap.put("password",params.getString("password"));
        configMap.put("scanConfig",params.getString("scanConfig"));
        configMap.put("scan",params.getString("scan"));
        return configMap;
    }

    @Override
    public void validate(@NotNull ActionParametersMap params,
                         @NotNull ErrorCollection errorCollection){
        super.validate(params, errorCollection);
        String restUrlValue = params.getString("restUrl");
        String loginValue = params.getString("login");
        String passwordValue = params.getString("password");
        String scanConfigValue = params.getString("scanConfig");

        if (StringUtils.isEmpty(restUrlValue)){
            errorCollection.addError("restUrl",textProvider.getText("com.rapid7.bamboospider.restUrl.error"));
        }else if(StringUtils.isEmpty(loginValue)){
            errorCollection.addError("login",textProvider.getText("com.rapid7.bamboospider.login.error"));
        }else if(StringUtils.isEmpty(passwordValue)){
            errorCollection.addError("password",textProvider.getText("com.rapid7.bamboospider.password.error"));
        }else if(StringUtils.isEmpty(scanConfigValue)){
            errorCollection.addError("scanConfig",textProvider.getText("com.rapid7.bamboospider.scanConfig.error"));
        }
    }
    @Override
    public void populateContextForCreate(@NotNull final Map<String,Object> context){
        super.populateContextForCreate(context);
        context.put("restUrl", "Enter the AppSpider Restful Url here");
        context.put("login", "Enter your username here");
        context.put("scanConfig", "Enter the scan configuration here");
    }

    @Override
    public void populateContextForEdit(@NotNull final Map<String,Object> context,TaskDefinition taskDefinition){
        super.populateContextForEdit(context, taskDefinition);
        context.put("restUrl", taskDefinition.getConfiguration().get("restUrl"));
        context.put("login", taskDefinition.getConfiguration().get("login"));
        context.put("scanConfig", taskDefinition.getConfiguration().get("scanConfig"));
    }
    @Override
    public void populateContextForView(@NotNull final Map<String,Object> context, TaskDefinition taskDefinition){
        super.populateContextForView(context, taskDefinition);
        context.put("restUrl", taskDefinition.getConfiguration().get("restUrl"));
        context.put("login", taskDefinition.getConfiguration().get("login"));
        context.put("scanConfig", taskDefinition.getConfiguration().get("scanConfig"));
    }
    public void setTextProvider(final TextProvider textProvider){
        this.textProvider = textProvider;
    }
}
