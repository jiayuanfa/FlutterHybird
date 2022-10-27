package com.example.flutterhybridandroid;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;

import android.os.Bundle;
import android.widget.TextView;

import io.flutter.embedding.android.FlutterFragment;

public class MainActivity extends AppCompatActivity {

    private TextView getFlutterTv;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        getFlutterTv = findViewById(R.id.getFlutter);
        getFlutterTv.setOnClickListener(view -> {
            FragmentTransaction ft = getSupportFragmentManager().beginTransaction();
            ft.replace(R.id.frameLayout, FlutterFragment.createDefault());
            ft.commit();
        });
    }
}