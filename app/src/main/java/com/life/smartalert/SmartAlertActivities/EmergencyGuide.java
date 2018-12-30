package com.life.smartalert.SmartAlertActivities;

import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import com.life.smartalert.R;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import java.util.ArrayList;

public class EmergencyGuide extends AppCompatActivity {

    private static final String TAG = "EmergencyGuide";

    //vars
    private ArrayList<String> mNames = new ArrayList<>();
    private ArrayList<String> mImageUrls = new ArrayList<>();

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_emergency_guide);
        Log.d(TAG, "onCreate: started.");

        initImageBitmaps();
    }

    private void initImageBitmaps(){
        Log.d(TAG, "initImageBitmaps: preparing bitmaps.");

        mImageUrls.add("https://cdn.pixabay.com/photo/2018/02/20/13/46/earthquake-3167693__480.jpg");
        mNames.add("<b>"+"Earthquake"+"<b>");

        mImageUrls.add("https://cdn.pixabay.com/photo/2013/06/02/23/13/firefighters-115800__480.jpg");
        mNames.add("<b>"+"Fire"+"<b>");

        mImageUrls.add("https://cdn.pixabay.com/photo/2017/01/27/09/21/thieves-2012532__480.jpg");
        mNames.add("<b>"+"Robbery"+"<b>");

        mImageUrls.add("https://cdn.pixabay.com/photo/2017/01/20/20/24/car-accident-1995852__480.png");
        mNames.add("<b>"+"Accident"+"<b>");


        mImageUrls.add("https://cdn.pixabay.com/photo/2017/02/26/16/51/cyclone-2100663__480.jpg");
        mNames.add("<b>"+"Hurricane"+"<b>");

        mImageUrls.add("https://cdn.pixabay.com/photo/2016/09/16/19/12/ambulance-1674877__480.png");
        mNames.add("<b>"+"Medical"+"<b>");


        mImageUrls.add("https://cdn.pixabay.com/photo/2014/04/03/00/40/sun-309025__480.png");
        mNames.add("<b>"+"Heat Wave"+"<b>");

        mImageUrls.add("https://cdn.pixabay.com/photo/2015/09/13/14/06/new-york-938212__480.jpg");
        mNames.add("<b>"+"Storm"+"<b>");

        mImageUrls.add("https://cdn.pixabay.com/photo/2015/06/01/06/32/hand-792920__480.jpg");
        mNames.add("<b>"+"Floods/Tsunami"+"<b>");

        initRecyclerView();
    }

    private void initRecyclerView(){
        Log.d(TAG, "initRecyclerView: init recyclerview.");
        RecyclerView recyclerView = findViewById(R.id.recyclerv_view);
        RecyclerViewAdapter adapter = new RecyclerViewAdapter(this, mNames, mImageUrls);
        recyclerView.setAdapter(adapter);
        recyclerView.setLayoutManager(new LinearLayoutManager(this));
    }
}


