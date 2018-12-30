package com.life.smartalert.SmartAlertActivities;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.support.design.widget.FloatingActionButton;
import android.support.design.widget.Snackbar;
import android.support.v7.app.AlertDialog;
import android.util.Log;
import android.view.View;
import android.support.design.widget.NavigationView;
import android.support.v4.view.GravityCompat;
import android.support.v4.widget.DrawerLayout;
import android.support.v7.app.ActionBarDrawerToggle;
import android.support.v7.app.AppCompatActivity;
import android.support.v7.widget.Toolbar;
import android.view.Menu;
import android.view.MenuItem;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.LinearInterpolator;
import android.widget.ImageView;
import android.widget.Toast;

import com.life.smartalert.BasicActivities.AboutUsActivity;
import com.life.smartalert.BasicActivities.SplashScreenActivity;
import com.life.smartalert.FirebaseActivities.SignUpActivity;
import com.life.smartalert.R;

import java.io.File;

public class MainNavigationActivity extends AppCompatActivity
        implements NavigationView.OnNavigationItemSelectedListener {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main_navigation);
        Toolbar toolbar = (Toolbar) findViewById(R.id.toolbar);
        setSupportActionBar(toolbar);

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        ActionBarDrawerToggle toggle = new ActionBarDrawerToggle(
                this, drawer, toolbar, R.string.navigation_drawer_open, R.string.navigation_drawer_close);
        drawer.addDrawerListener(toggle);
        toggle.syncState();

        NavigationView navigationView = (NavigationView) findViewById(R.id.nav_view);
        navigationView.setNavigationItemSelectedListener(this);

        final ImageView img1 = (ImageView) findViewById(R.id.image1) ;

        ImageView img2 = (ImageView) findViewById(R.id.image2) ;

        final ImageView img3 = (ImageView) findViewById(R.id.image3) ;
        final MediaPlayer mp = MediaPlayer.create(this, R.raw.alert);

        final FloatingActionButton fab = (FloatingActionButton) findViewById(R.id.fab); // query
        final FloatingActionButton fab2 = (FloatingActionButton) findViewById(R.id.fab2); // notification

        img1.setOnClickListener(new View.OnClickListener() {
            public void onClick(View arg0) {

                Animation animation = new AlphaAnimation(1 ,0);
                animation.setDuration(900);
                animation.setInterpolator(new LinearInterpolator());
                //animation.setRepeatCount(Animation.INFINITE);
                //animation.setRepeatMode(Animation.REVERSE);
                img1.startAnimation(animation);
                Intent myIntent = new Intent(MainNavigationActivity.this,
                        RequestAlertActivity.class);
                startActivity(myIntent);


                // Link to MAP

                /*new Handler().postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        Uri gmmIntentUri = Uri.parse("geo:0,0?q=");
                        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
                        mapIntent.setPackage("com.google.android.apps.maps");
                        startActivity(mapIntent);
                    }
                }, 500); */
            }

        });


        img2.setOnClickListener(new View.OnClickListener() {
            public void onClick(View arg0) {

                // To bring a blink on click - we use these four lines of code (Animation Class)

                Intent myIntent = new Intent(Intent.ACTION_DIAL); //ACTION_CALL requires permission and more exception handling!!
                myIntent.setData(Uri.parse("tel:"+911));
                startActivity(myIntent);

            }

        });

        img3.setOnClickListener(new View.OnClickListener() {
            public void onClick(View arg0) {

                mp.start();

            }

        });


        // FloatingActionButton fab3 = (FloatingActionButton) findViewById(R.id.fab3); // call

        fab.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Animation animation = new AlphaAnimation(1, 0);
                animation.setDuration(1000);
                animation.setInterpolator(new LinearInterpolator());
                fab.startAnimation(animation);
                Intent myIntent = new Intent(MainNavigationActivity.this,
                        AboutUsActivity.class);
                startActivity(myIntent);
            }
        });
        fab2.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {

                Animation animation = new AlphaAnimation(1, 0);
                animation.setDuration(1000);
                animation.setInterpolator(new LinearInterpolator());
                fab2.startAnimation(animation);
                Intent myIntent = new Intent(MainNavigationActivity.this,
                        NotificationActivity.class);
                startActivity(myIntent);
            }
        });
    }

    @Override
    public void onBackPressed() {
        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        if (drawer.isDrawerOpen(GravityCompat.START)) {
            drawer.closeDrawer(GravityCompat.START);
        } else {
            super.onBackPressed();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.main_navigation, menu);
        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.logout) {

            AlertDialog.Builder alertDialogBuilder = new AlertDialog.Builder(MainNavigationActivity.this);
            alertDialogBuilder.setMessage("Are you sure you want to Sign out?");
            alertDialogBuilder.setPositiveButton("yes",
                    new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface arg0, int arg1) {
                            clearApplicationData(getApplicationContext()); // that's where refresh token is called
                            finish();
                            System.exit(0);
                            Toast.makeText(MainNavigationActivity.this,"Signed out Successfully!!",Toast.LENGTH_LONG).show();
                        }
                    });

            alertDialogBuilder.setNegativeButton("No",new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    Toast.makeText(MainNavigationActivity.this,"Enjoy our Service!!",Toast.LENGTH_LONG).show();

                }
            });

            AlertDialog alertDialog = alertDialogBuilder.create();
            alertDialog.show();
            // close app
            return true;
        }

        if (id == R.id.map) {

            /*Intent myIntent = new Intent(MainNavigationActivity.this,
                    MapsActivity.class);
            startActivity(myIntent);*/

        new Handler().postDelayed(new Runnable() {
                   @Override
                    public void run() {
                        Uri gmmIntentUri = Uri.parse("geo:0,0?q=");
                        Intent mapIntent = new Intent(Intent.ACTION_VIEW, gmmIntentUri);
                        mapIntent.setPackage("com.google.android.apps.maps");
                        startActivity(mapIntent);
                    }
                }, 400);

        }

        return super.onOptionsItemSelected(item);
    }

    @SuppressWarnings("StatementWithEmptyBody")
    @Override
    public boolean onNavigationItemSelected(MenuItem item) {
        // Handle navigation view item clicks here.
        int id = item.getItemId();

        if (id == R.id.nav_report) {
            Intent myIntent = new Intent(MainNavigationActivity.this,
                           RequestAlertActivity.class);
                    startActivity(myIntent);

        } else if (id == R.id.nav_notification) {
            Intent myIntent = new Intent(MainNavigationActivity.this,
                        NotificationActivity.class);
                startActivity(myIntent);

        } else if (id == R.id.nav_sos) {

        } else if (id == R.id.nav_guide) {
            Intent i = new Intent(MainNavigationActivity.this,
                    EmergencyGuide.class);
            startActivity(i);

        } else if (id == R.id.nav_share) {

        } else if (id == R.id.nav_send) {
            Intent myIntent = new Intent(MainNavigationActivity.this,
                        AboutUsActivity.class);
                startActivity(myIntent);

            return true;

        }

        DrawerLayout drawer = (DrawerLayout) findViewById(R.id.drawer_layout);
        drawer.closeDrawer(GravityCompat.START);
        return true;
    }

    public void clearApplicationData(Context context) {
        File cache = context.getCacheDir();
        File appDir = new File(cache.getParent());
        if (appDir.exists()) {
            String[] children = appDir.list();
            for (String s : children) {
                File f = new File(appDir, s);
                if(deleteDir(f))
                    Toast.makeText(MainNavigationActivity.this,
                            "SIGNED OUT SUCCESSFULLY!!",
                            Toast.LENGTH_SHORT).show();
            }
        }
    }
    private static boolean deleteDir(File dir) {
        if (dir != null && dir.isDirectory()) {
            String[] children = dir.list();
            for (int i = 0; i < children.length; i++) {
                boolean success = deleteDir(new File(dir, children[i]));
                if (!success) {
                    return false;
                }
            }
        }
        return dir.delete();
    }
}
