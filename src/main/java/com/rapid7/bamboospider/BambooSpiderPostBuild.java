package com.rapid7.bamboospider;

import com.atlassian.bamboo.build.CustomBuildProcessorServer;
import com.atlassian.bamboo.task.TaskDefinition;
import com.atlassian.bamboo.v2.build.BuildContext;
import com.atlassian.extras.common.log.Logger;
import org.jetbrains.annotations.NotNull;
import java.util.*;
import com.rapid7.appspider.*;

/**
 * Created by nbugash on 08/07/15.
 */
public class BambooSpiderPostBuild implements CustomBuildProcessorServer {

    private static final Logger.Log log = Logger.getInstance(BambooSpiderPostBuild.class);
    private BuildContext buildContext;
    private TaskDefinition taskDefinition;
    private String restUrl = null;
    private String login = null;
    private String password = null;
    private String scanConfig = null;
    private Boolean scan = false;


    @Override
    public void init(BuildContext buildContext) {
        log.info("Initializing BambooSpiderPostBuild!!");
        this.buildContext = buildContext;
        this.taskDefinition = buildContext.getBuildDefinition().getTaskDefinitions().get(0);
    }

    @NotNull
    @Override
    public BuildContext call() throws InterruptedException, Exception {
        log.info("Running BambooSpiderPostBuild");
        Map<String,String> customConfig = this.buildContext.getBuildDefinition().getCustomConfiguration();
        if (customConfig.equals(null)){
            log.error("Post command not set to run on the server. Skipping..");
            return buildContext;
        }

        log.info("Post command is set to run on the server");
        this.restUrl = getRestUrl(this.taskDefinition);
        this.login = getLogin(this.taskDefinition);
        this.password = getPassword(this.taskDefinition);
        this.scanConfig = getScanConfig(this.taskDefinition);
        this.scan = getScan(this.taskDefinition);
        runScan();
        return this.buildContext;
    }

    public void runScan(){
        if (scan){
            log.info("Starting scan");
        }else{
            log.info("We're not going to scan "+this.scanConfig);
        }
        log.info("Finished running scan.");
    }
    private String getRestUrl(TaskDefinition taskDefinition){
        log.info("Getting the AppSpider Rest Url");
        return taskDefinition.getConfiguration().get("restUrl");
    }

    private String getLogin(TaskDefinition taskDefinition){
        log.info("Getting the login account for " + restUrl );
        return taskDefinition.getConfiguration().get("login");
    }
    private String getPassword(TaskDefinition taskDefinition){
        log.info("Getting the password");
        return taskDefinition.getConfiguration().get("password");
    }
    private String getScanConfig(TaskDefinition taskDefinition){
        log.info("Getting the config scan");
        return taskDefinition.getConfiguration().get("scanConfig");
    }
    private Boolean getScan(TaskDefinition taskDefinition){
        log.info("Checking if we are going to scan...");
        if(taskDefinition.getConfiguration().get("scan").equals(null)) {
            log.info("Scanning is not enabled");
            return false;
        }else{
            log.info("Scanning is enabled");
            return true;
        }
    }
}
