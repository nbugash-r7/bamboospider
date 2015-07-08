package com.rapid7.bamboospider;

import com.atlassian.bamboo.build.logger.BuildLogger;
import com.atlassian.bamboo.configuration.ConfigurationMap;
import com.atlassian.bamboo.task.*;
import org.jetbrains.annotations.NotNull;

/**
 * Created by nbugash on 08/07/15.
 */
public class BambooSpiderScanTask implements TaskType {
    private String restUrl;
    private String login;
    private String password;
    private String scanConfig;
    private String scan;

    @NotNull
    @Override
    public TaskResult execute(TaskContext taskContext) throws TaskException {
        BuildLogger buildLogger = taskContext.getBuildLogger();
        ConfigurationMap configMap = taskContext.getConfigurationMap();
        this.restUrl    = configMap.get("restUrl");
        this.login      = configMap.get("login");
        this.password   = configMap.get("password");
        this.scanConfig = configMap.get("scanConfig");
        this.scan       = configMap.get("scan");

        buildLogger.addBuildLogEntry("Value for restUrl: "+ restUrl);
        buildLogger.addBuildLogEntry("Value for login: "+ login);
        buildLogger.addBuildLogEntry("Value for password: "+ password);
        buildLogger.addBuildLogEntry("Value for scan config: "+ scanConfig);
        buildLogger.addBuildLogEntry("Value for scan: "+ scan);

        final TaskResultBuilder builder = TaskResultBuilder.newBuilder(taskContext);
        if (scan.equalsIgnoreCase("true")){
            buildLogger.addBuildLogEntry("Scan was set to true");
            return builder.success().build();
        }else{
            buildLogger.addBuildLogEntry("Scan was set to false");
            return builder.failed().build();
        }
    }
}
