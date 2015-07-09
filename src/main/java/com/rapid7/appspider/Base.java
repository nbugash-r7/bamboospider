package com.rapid7.appspider;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.*;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.*;
/**
 * Created by nbugash on 08/07/15.
 */
public class Base {

    private final static int SUCCESS = 200;
    /**
     * @param apiCall
     * @param authToken
     * @param params
     * @return JSON Object of the Restful api call
     */
    public static JSONObject get(String apiCall, String authToken, Map<String,String> params){
        try{
            //Create HTTP Client
            HttpClient httpClient = HttpClientBuilder.create().build();

            // Create HttpGet request
            HttpGet getRequest;
            if(!params.equals(null)){
                URIBuilder uriBuilder = new URIBuilder(apiCall);
                for(Map.Entry<String,String> entry : params.entrySet()){
                    uriBuilder.addParameter(entry.getKey(), entry.getValue());
                }
                getRequest = new HttpGet(uriBuilder.build());
            }else{
                // Initialized the get request
                getRequest = new HttpGet(apiCall);
            }

            // Add the authentication token
            getRequest.addHeader("Content-Type" , "application/x-www-form-urlencoded");
            getRequest.addHeader("Authorization", "Basic " + authToken);

            // Receive the response from AppSpider
            HttpResponse getResponse = httpClient.execute(getRequest);
            int statusCode = getResponse.getStatusLine().getStatusCode();
            if (statusCode == SUCCESS){
                // Return a JSONObject of the response
                return new JSONObject(getResponse);
            }else{
                throw new RuntimeException("Failed! HTTP error code: "+ statusCode);
            }
        } catch(ClientProtocolException e){
            e.printStackTrace();
        } catch(IOException e){
            e.printStackTrace();
        } catch (URISyntaxException e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * @param apiCall
     * @param authToken
     * @return
     */
    public static JSONObject get(String apiCall, String authToken){
        try{
            //Create HTTP Client
            HttpClient httpClient = HttpClientBuilder.create().build();
            // Initialized the get request
            HttpGet getRequest = new HttpGet(apiCall);
            getRequest.addHeader("Content-Type","application/x-www-form-urlencoded");
            getRequest.addHeader("Authorization", "Basic " + authToken);

            // Receive the response from AppSpider
            HttpResponse getResponse = httpClient.execute(getRequest);
            int statusCode = getResponse.getStatusLine().getStatusCode();
            if (statusCode == SUCCESS){
                // Return a JSONObject of the response
                return new JSONObject(EntityUtils.toString(getResponse.getEntity()));
            }else{
                throw new RuntimeException("Failed! HTTP error code: "+ statusCode);
            }
        }catch(ClientProtocolException e){
            e.printStackTrace();
        }catch(IOException e){
            e.printStackTrace();
        }
        return null;
    }

    /**
     *
     * @param apiCall
     * @param username
     * @param password
     * @return Authentication Token from AppSpider
     */
    public static String post(String apiCall, String username, String password){
        try{
            //Create HTTP Client
            HttpClient httpClient = HttpClientBuilder.create().build();

            //Initialize the post request
            HttpPost postRequest = new HttpPost(apiCall);
            postRequest.addHeader("Content-Type", "application/x-www-form-urlencoded");

            ArrayList<BasicNameValuePair> params = new ArrayList<BasicNameValuePair>();
            params.add(new BasicNameValuePair("name",username));
            params.add(new BasicNameValuePair("password", password));
            postRequest.setEntity(new UrlEncodedFormEntity(params));
            // Receive the response for AppSpider
            HttpResponse postResponse = httpClient.execute(postRequest);
            int statusCode = postResponse.getStatusLine().getStatusCode();
            if (statusCode == SUCCESS){
                // Obtain the JSON Object of the response
                JSONObject jsonResponse = new JSONObject(EntityUtils.toString(postResponse.getEntity()));
                return (String)jsonResponse.get("Token");
            }else{
                throw new RuntimeException("Failed! HTTP error code: "+ statusCode);
            }

        }catch (ClientProtocolException e){
            e.printStackTrace();
        }catch (IOException e){
            e.printStackTrace();
        }catch (Exception e){
            e.printStackTrace();
        }
        return null;
    }

    /**
     * @param apiCall
     * @param authToken
     * @param params
     * @return
     */
    public static JSONObject post(String apiCall, String authToken, Map<String,String> params){
        try{
            HttpClient httpClient = HttpClientBuilder.create().build();

            HttpPost postRequest = new HttpPost(apiCall);

            postRequest.addHeader("Content-Type","application/x-www-form-urlencoded");
            postRequest.addHeader("Authorization","Basic "+ authToken);

            if(!params.equals(null)){
                ArrayList<BasicNameValuePair> urlParameters = new ArrayList<BasicNameValuePair>();
                for(Map.Entry<String,String> entry : params.entrySet()){
                    urlParameters.add(new BasicNameValuePair(entry.getKey(),entry.getValue()));
                }
                postRequest.setEntity(new UrlEncodedFormEntity(urlParameters));
            }

            HttpResponse postResponse = httpClient.execute(postRequest);
            int statusCode = postResponse.getStatusLine().getStatusCode();
            if (statusCode == SUCCESS){
                //Obtain the JSON Object response
                JSONObject jsonResponse = new JSONObject(EntityUtils.toString(postResponse.getEntity()));
                return jsonResponse;
            }else{
                throw new RuntimeException("Failed! HTTP error code: " + statusCode);
            }

        }catch(ClientProtocolException e){
            e.printStackTrace();
        }catch(IOException e){
            e.printStackTrace();
        }
        return null;
    }

}
