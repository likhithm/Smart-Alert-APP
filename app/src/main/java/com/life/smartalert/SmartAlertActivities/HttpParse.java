package com.life.smartalert.SmartAlertActivities;

import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by Likhith on 10/18/2018
 */


public class HttpParse {

   String FinalHttpData = "";
   BufferedWriter bufferedWriter ;
   OutputStream outputStream ;
   BufferedReader bufferedReader ;
   URL url;

   public String postRequest(JSONObject Data, String HttpUrlHolder) {

       try {
           url = new URL(HttpUrlHolder);

           HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();

           httpURLConnection.setReadTimeout(14000);

           httpURLConnection.setConnectTimeout(14000);

           httpURLConnection.setRequestMethod("POST");

           httpURLConnection.setDoInput(true);

           httpURLConnection.setDoOutput(true);

           outputStream = httpURLConnection.getOutputStream();

           bufferedWriter = new BufferedWriter(
                   new OutputStreamWriter(outputStream, "UTF-8"));

           DataOutputStream os = new DataOutputStream(httpURLConnection.getOutputStream());
           //os.writeBytes(URLEncoder.encode(jsonParam.toString(), "UTF-8"));
           os.writeBytes(Data.toString());

           os.flush();  // data will be copied later from bufferedReader
           os.close();
           if (httpURLConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {

               bufferedReader = new BufferedReader(
                       new InputStreamReader(
                               httpURLConnection.getInputStream()
                       )
               );
               FinalHttpData = bufferedReader.readLine(); // read from flush-->bufferedReader
           }
           else {
               FinalHttpData = "Something Went Wrong in Http Parse";
           }
       } catch (Exception e) {
           e.printStackTrace();
       }

       return FinalHttpData;
   }


}