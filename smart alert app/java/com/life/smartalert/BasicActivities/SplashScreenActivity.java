package com.life.smartalert.BasicActivities;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.life.smartalert.FirebaseActivities.SignUpActivity;
import com.life.smartalert.R;

public class SplashScreenActivity extends Activity implements Animation.AnimationListener{

    TextView txtMessage,t1,t2,t4,t6,t7,t8,t9;
    ImageView imageView;
    Animation animFadein,animationo,animFadein2,animFadein3,animFadein4,animFadein5;
    ProgressBar progressBar;
    // Splash screen timer
    private static int SPLASH_TIME_OUT = 3300;
    int progressStatus = 0;
    Handler handler = new Handler();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_splash_screen);
        imageView= (ImageView) findViewById(R.id.imageView);
        progressBar=(ProgressBar)findViewById(R.id.verify_progress);

        txtMessage= (TextView) findViewById(R.id.textView21);
        t1= (TextView) findViewById(R.id.textView22);
        t2= (TextView) findViewById(R.id.textView23);
        t4= (TextView) findViewById(R.id.percent);
        t6= (TextView) findViewById(R.id.percent2);
        t7= (TextView) findViewById(R.id.percent3);
        t8= (TextView) findViewById(R.id.percent4);
        t9= (TextView) findViewById(R.id.percent5);

        animationo = AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.zoom_in);
        animationo.setAnimationListener(this);
        imageView.startAnimation(animationo);
        animFadein=AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.fade_in);
        animFadein.setAnimationListener(this);
        t4.startAnimation(animFadein);
        animFadein2=AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.fade_in);
        animFadein2.setAnimationListener(this);
        t6.startAnimation(animFadein2);
        animFadein3=AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.fade_in);
        animFadein3.setAnimationListener(this);
        t7.startAnimation(animFadein3);
        animFadein4=AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.fade_in);
        animFadein4.setAnimationListener(this);
        t8.startAnimation(animFadein4);
        animFadein5=AnimationUtils.loadAnimation(getApplicationContext(),
                R.anim.fade_in);
        animFadein5.setAnimationListener(this);
        t9.startAnimation(animFadein5);
        new Thread(new Runnable() {
            public void run() {
                while (progressStatus < 100)
                {
                    progressStatus += 5;
                    handler.post(new Runnable()
                    {
                        public void run()
                        {
                            progressBar.setProgress(progressStatus);
                            if(progressStatus==5){

                                t4.setText("Easily");

                            }else  if(progressStatus==30){
                                t6.startAnimation(animFadein2);

                                t6.setText(" Get/Send");

                            }else  if(progressStatus==60) {
                                t7.startAnimation(animFadein3);

                                t7.setText("");
                                t9.startAnimation(animFadein3);

                                t9.setText(" Emergency");
                            }
                            else  if(progressStatus==80) {
                                t8.startAnimation(animFadein4);

                                t8.setText("Alert!!");
                            }
                        }
                    });
                    try
                    {
                        Thread.sleep(200);
                    }
                    catch (InterruptedException e)
                    {
                        e.printStackTrace();
                    }
                }
                if (progressStatus==100)
                {
                    Intent i = new Intent(SplashScreenActivity.this, WelcomeActivity.class);
                    startActivity(i);
                    finish();
                }
            }
        }).start();
    }

    @Override
    public void onAnimationStart(Animation animation) {



    }

    @Override
    public void onAnimationEnd(Animation animation) {

    }

    @Override
    public void onAnimationRepeat(Animation animation) {

    }
}