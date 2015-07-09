package com.rapid7.appspider;

import org.apache.http.util.EntityUtils;
import org.json.JSONObject;

import javax.swing.text.html.parser.Entity;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by nbugash on 09/07/15.
 */
public class ReportManagement extends Base {

    public final static String IMPORTSTANDARDREPORT = "/Report/ImportStandardReport";
    public final static String IMPORTCHECKMARKREPORT= "/Report/ImportCheckmarkReport";
    public final static String GETREPORTALLFILES= "/Report/GetReportAllFiles";
    public final static String GETVULNERABILITIESSUMMARY= "/Report/GetVulnerabilitiesSummaryXml";
    public final static String GETCRAWLEDLINKS= "/Report/GetCrawledLinksXml";

//    public static Object getReportAllFiles(String restUrl, String authToken, String scanId){
//        String apiCall = restUrl + GETREPORTALLFILES;
//        Map<String,String> params = new HashMap<String, String>();
//        params.put("scanId",scanId);
//        Object response = get(apiCall,authToken,params);
//        response.toString();
//        switch (response.getClass()){
//            case JSONObject.class:
//                return (JSONObject)response;
//            case Object.class:
//            default:
//                throw new RuntimeException("Invalid response class");
//                break;
//        }
//
//        return null;
//    }

    /**
     * @param restUrl
     * @param authToken
     * @param scanId
     * @return
     */
    public static Object getVulnerabilitiesSummaryXml(String restUrl, String authToken, String scanId){
        String apiCall = restUrl + GETVULNERABILITIESSUMMARY;
        Map<String,String> params = new HashMap<String, String>();
        params.put("scanId",scanId);
        Object response = get(apiCall,authToken,params);
        response.toString();
        return null;
    }
}
