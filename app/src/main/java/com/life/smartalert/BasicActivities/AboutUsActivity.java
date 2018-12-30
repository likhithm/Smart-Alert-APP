package com.life.smartalert.BasicActivities;

import android.content.Intent;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;

import com.life.smartalert.R;

public class AboutUsActivity extends AppCompatActivity {

    private Button query;

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_about_us);


        query = (Button)findViewById(R.id.query_button);

        query.setOnClickListener(new View.OnClickListener() {
            public void onClick(View arg0) {


                // Start NewActivity.class
                if (arg0.getId() == R.id.query_button) {

                    composeEmail( "life.app.developer@gmail.com","QUERY: Smart Alert App (life.app.developer@gmail.com)");

                }

            }
        });

    }

    public void composeEmail(String addresses, String subject) {
        Intent intent = new Intent(Intent.ACTION_SENDTO);
       intent.setData(Uri.parse("mailto:"));
       // only email apps should handle this
        intent.putExtra(Intent.EXTRA_EMAIL,addresses);
        intent.putExtra(Intent.EXTRA_SUBJECT, subject);
        if (intent.resolveActivity(getPackageManager()) != null) {
            startActivity(intent);
        }
    }

}
