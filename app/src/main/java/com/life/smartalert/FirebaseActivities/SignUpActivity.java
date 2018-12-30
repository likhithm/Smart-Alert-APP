package com.life.smartalert.FirebaseActivities;

import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.annotation.NonNull;
import android.text.TextUtils;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.widget.EditText;
import android.widget.Toast;
import android.widget.Toolbar;

import com.google.android.gms.tasks.OnCompleteListener;
import com.google.android.gms.tasks.Task;
import com.google.firebase.auth.AuthResult;
import com.google.firebase.auth.FirebaseAuth;
import com.google.firebase.auth.FirebaseUser;
import com.google.firebase.iid.FirebaseInstanceId;
import com.google.firebase.iid.InstanceIdResult;
import com.life.smartalert.BasicActivities.AboutUsActivity;
import com.life.smartalert.R;
//import com.life.smartalert.SmartAlertActivities.MainActivity;
import com.life.smartalert.SmartAlertActivities.HttpParse;
import com.life.smartalert.SmartAlertActivities.MainNavigationActivity;
import com.life.smartalert.SmartAlertActivities.NotificationActivity;

import org.json.JSONException;
import org.json.JSONObject;

public class SignUpActivity extends BaseActivity implements
        View.OnClickListener {

    private static final String TAG = "EmailPassword";

    //private TextView mStatusTextView;
    //private TextView mDetailTextView;
    private EditText mEmailField;
    private EditText mPasswordField;
    private Toolbar val;
    // [START declare_auth]
    private FirebaseAuth mAuth;
    // [END declare_auth]

    String HttpURL = "http://yourip10101/register";// remember to change this ip whenever you restart your server
    HttpParse httpParse = new HttpParse();
    String finalResult ;


    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_sign_up);

        // Views
        //mStatusTextView = findViewById(R.id.status);
        //mDetailTextView = findViewById(R.id.detail);
        mEmailField = findViewById(R.id.field_email);
        mPasswordField = findViewById(R.id.field_password);

        // Buttons
        findViewById(R.id.email_sign_in_button).setOnClickListener(this);
        findViewById(R.id.email_create_account_button).setOnClickListener(this);
        findViewById(R.id.sign_out_button).setOnClickListener(this);
        findViewById(R.id.verify_email_button).setOnClickListener(this);

        // [START initialize_auth]
        mAuth = FirebaseAuth.getInstance();
        // [END initialize_auth]
    }

    // [START on_start_check_user]
    @Override
    public void onStart() {
        super.onStart();
        // Check if user is signed in (non-null) and update UI accordingly.
        FirebaseUser currentUser = mAuth.getCurrentUser();
        updateUI(currentUser);
    }
    // [END on_start_check_user]

    private void createAccount(String email, String password) {
        Log.d(TAG, "createAccount:" + email);
        if (!validateForm()) {
            return;
        }

        showProgressDialog();

        // [START create_user_with_email]
        mAuth.createUserWithEmailAndPassword(email, password)
                .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (task.isSuccessful()) {
                            // Sign in success, update UI with the signed-in user's information
                            Log.d(TAG, "createUserWithEmail:success");
                            FirebaseUser user = mAuth.getCurrentUser();
                            updateUI(user);
                        } else {
                            // If sign in fails, display a message to the user.
                            Log.w(TAG, "createUserWithEmail:failure", task.getException());
                            Toast.makeText(SignUpActivity.this, "\t\t\t\t\t\tAuthentication failed!!\nCheck your Internet Connection or\n\t\t\t\t\t\tEnter valid credentials",
                                    Toast.LENGTH_SHORT).show();
                            updateUI(null);
                        }

                        // [START_EXCLUDE]
                        hideProgressDialog();
                        // [END_EXCLUDE]
                    }
                });
        // [END create_user_with_email]
    }

    private void signIn(String email, String password) {
        Log.d(TAG, "signIn:" + email);
        if (!validateForm()) {
            return;
        }

        // if validate form is true
        showProgressDialog();

        // [START sign_in_with_email]
        mAuth.signInWithEmailAndPassword(email, password)
                .addOnCompleteListener(this, new OnCompleteListener<AuthResult>() {
                    @Override
                    public void onComplete(@NonNull Task<AuthResult> task) {
                        if (task.isSuccessful()) {
                            // Sign in success, update UI with the signed-in user's information
                            Log.d(TAG, "signInWithEmail:success");
                            FirebaseUser user = mAuth.getCurrentUser();
                            updateUI(user);
                        } else {
                            // If sign in fails, display a message to the user.
                            Log.w(TAG, "signInWithEmail:failure", task.getException());
                            Toast.makeText(SignUpActivity.this, "\t\t\t\t\t\tAuthentication failed!!\nCheck your Internet Connection or\n\t\t\t\t\t\tEnter valid credentials",
                                    Toast.LENGTH_SHORT).show();
                            updateUI(null);
                        }

                        // [START_EXCLUDE]
                       /* if (!task.isSuccessful()) {
                            mStatusTextView.setText(R.string.auth_failed);
                        }*/
                        hideProgressDialog();
                        // [END_EXCLUDE]
                    }
                });
        // [END sign_in_with_email]
    }

    private void signOut() {
        mAuth.signOut();
        updateUI(null);
    }

    private void sendEmailVerification() {
        // Disable button
        findViewById(R.id.verify_email_button).setEnabled(false);

        // Send verification email
        // [START send_email_verification]
        final FirebaseUser user = mAuth.getCurrentUser();
        user.sendEmailVerification()
                .addOnCompleteListener(this, new OnCompleteListener<Void>() {
                    @Override
                    public void onComplete(@NonNull Task<Void> task) {
                        // [START_EXCLUDE]
                        // Re-enable button
                        findViewById(R.id.verify_email_button).setEnabled(true);

                        if (task.isSuccessful()) {
                            Toast.makeText(SignUpActivity.this,
                                    "Verification email sent to " + user.getEmail(),
                                    Toast.LENGTH_SHORT).show();
                        } else {
                            Log.e(TAG, "sendEmailVerification", task.getException());
                            Toast.makeText(SignUpActivity.this,
                                    "Failed to send verification email!! Please check your Internet",
                                    Toast.LENGTH_SHORT).show();
                        }
                        // [END_EXCLUDE]
                    }
                });
        // [END send_email_verification]
    }

    private boolean validateForm() {
        boolean valid = true;

        String email = mEmailField.getText().toString();
        if (TextUtils.isEmpty(email)) {
            mEmailField.setError("Email can't be Empty!!");
            valid = false;
        } else {
            mEmailField.setError(null);
        }

        String password = mPasswordField.getText().toString();
        if (TextUtils.isEmpty(password)) {
            mPasswordField.setError("Please enter the password");
            valid = false;
        } else {
            mPasswordField.setError(null);
        }

        return valid;
    }

    private void updateUI(FirebaseUser user) {
        hideProgressDialog();
        if (user != null) {
            // mStatusTextView.setText(getString(R.string.emailpassword_status_fmt,
            //user.getEmail(), user.isEmailVerified()));
            //mDetailTextView.setText(getString(R.string.firebase_status_fmt, user.getUid()));
            //
            if(user.isEmailVerified()){


                //***************************//
                 Intent i = new Intent(SignUpActivity.this, MainNavigationActivity.class);
                 startActivity(i);
                 finish();
              }
             else {
                findViewById(R.id.verify_email_button).setEnabled(!user.isEmailVerified());
                findViewById(R.id.email_password_buttons).setVisibility(View.GONE);
                findViewById(R.id.email_password_fields).setVisibility(View.GONE);
                findViewById(R.id.signed_in_buttons).setVisibility(View.VISIBLE);
              }
            //findViewById(R.id.verify_email_button).setEnabled(!user.isEmailVerified()); // if user is not verified,
                                                                             // it should be visible!! False->True
        } else {
           /* mStatusTextView.setText(R.string.signed_out);
            mDetailTextView.setText(null);*/

            findViewById(R.id.email_password_buttons).setVisibility(View.VISIBLE);
            findViewById(R.id.email_password_fields).setVisibility(View.VISIBLE);
            findViewById(R.id.signed_in_buttons).setVisibility(View.GONE);
        }
    }

    @Override
    public void onClick(View v) {
        int i = v.getId();
        if (i == R.id.email_create_account_button) {
            createAccount(mEmailField.getText().toString(), mPasswordField.getText().toString());
        } else if (i == R.id.email_sign_in_button) {
            signIn(mEmailField.getText().toString(), mPasswordField.getText().toString());
        } else if (i == R.id.sign_out_button) {
            signOut();
        } else if (i == R.id.verify_email_button) {

            //We are using this condition to send Registration token obtained from Firebase to our APP server
                  // and Also to Intent to main activity (MainNavigationActivity)
                   //Get token
                     FirebaseInstanceId.getInstance().getInstanceId()
                    .addOnCompleteListener(new OnCompleteListener<InstanceIdResult>() {
                        @Override
                        public void onComplete(@NonNull Task<InstanceIdResult> task) {
                            if (!task.isSuccessful()) {
                                Log.w(TAG, "getInstanceId failed", task.getException());
                                Toast.makeText(SignUpActivity.this,"getInstanceId failed", Toast.LENGTH_SHORT).show();
                                return;
                            }

                            // Get new Instance ID token
                            String token = task.getResult().getToken();
                            // Log and toast
                            String msg = getString(R.string.msg_token_fmt, token);
                            Log.d(TAG, msg);
                            //http post
                            String email = mEmailField.getText().toString();
                            sendRegistrationToServer(token,email);
                        }
                    });
               sendEmailVerification();
        }

    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_signup, menu);
        return true;
    }
    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            Intent myIntent = new Intent(SignUpActivity.this,
                    AboutUsActivity.class);
            startActivity(myIntent);
            return true;
        }

        return super.onOptionsItemSelected(item);
    }

    public void sendRegistrationToServer(final String token, String email){

        class UserReportFunctionClass extends AsyncTask<String,Void,String> {



            @Override
            protected void onPostExecute(String httpResponseMsg) {

                super.onPostExecute(httpResponseMsg);


            }

            @Override
            protected String doInBackground(String... params) {

                JSONObject jsonParam = new JSONObject();;
                try {
                    jsonParam.put("token", params[0]);
                    jsonParam.put("email", params[1]);
                }

                catch(JSONException j){}

                finalResult = httpParse.postRequest(jsonParam, HttpURL);

                return finalResult;
            }
        }

        UserReportFunctionClass userReportFunctionClass = new UserReportFunctionClass();

        userReportFunctionClass.execute(token,email);
    }

}