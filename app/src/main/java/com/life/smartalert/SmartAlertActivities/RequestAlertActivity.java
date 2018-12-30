package com.life.smartalert.SmartAlertActivities;

import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.AsyncTask;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.life.smartalert.R;

import org.json.JSONException;
import org.json.JSONObject;


public class RequestAlertActivity extends AppCompatActivity {

    private EditText descr;
    private EditText city;

    String HttpURL = "http://35.231.156.228:10101/register";// remember to change this ip whenever you restart your server
    // "http://104.196.187.102:10101/alerts"
    // ProgressDialog progressDialog;
   // HashMap<String,String> hashMap = new HashMap<>();
    HttpParse httpParse = new HttpParse();
    String finalResult ;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


            setContentView(R.layout.activity_request_alert);


        descr = (EditText) findViewById(R.id.description);
        city = (EditText) findViewById(R.id.city);
       // emailView = (EditText) findViewById(R.id.emailid);


        Button b1 = findViewById(R.id.report_alert);

        b1.setOnClickListener(new View.OnClickListener() {
            public void onClick(View view) {
                AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(RequestAlertActivity.this);
                alertDialogBuilder.setMessage("Confirm Submission?\n(False report will be prosecuted)");
                alertDialogBuilder.setPositiveButton("yes",
                        new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface arg0, int arg1) {
                                try {
                                    // username = userView.getText().toString();
                                    sendReport("Fire",descr.getText().toString(), city.getText().toString());
                                }
                                catch(Exception e){}
                                Toast.makeText(RequestAlertActivity.this,"Submitted Successfully",Toast.LENGTH_LONG).show();
                            }
                        });

                alertDialogBuilder.setNegativeButton("No",new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        Toast.makeText(RequestAlertActivity.this,"Submission Withdrawn",Toast.LENGTH_LONG).show();

                    }
                });

                AlertDialog alertDialog = alertDialogBuilder.create();
                alertDialog.show();
            }

        });
    }

    public void sendReport(final String title, final String desc, final String city){

        class UserReportFunctionClass extends AsyncTask<String,Void,String> {



            @Override
            protected void onPostExecute(String httpResponseMsg) {

                super.onPostExecute(httpResponseMsg);


            }



            @Override
            protected String doInBackground(String... params) {

                JSONObject jsonParam = new JSONObject();;
                try {
                    jsonParam.put("title", params[0]);
                    jsonParam.put("desc", params[1]);
                    jsonParam.put("city", params[2]);
                }

                catch(JSONException j){}

                finalResult = httpParse.postRequest(jsonParam, HttpURL);

                return finalResult;
            }
        }

        UserReportFunctionClass userReportFunctionClass = new UserReportFunctionClass();

        userReportFunctionClass.execute(title,desc,city);
    }
}
