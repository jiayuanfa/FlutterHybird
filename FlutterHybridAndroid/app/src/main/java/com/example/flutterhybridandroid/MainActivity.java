package com.example.flutterhybridandroid;

import androidx.appcompat.app.AppCompatActivity;
import androidx.fragment.app.FragmentTransaction;

import android.os.Bundle;
import android.view.View;
import android.widget.EditText;
import android.widget.TextView;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragment;

public class MainActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        final EditText paramInput = findViewById(R.id.paramInput);

        /// 点击跳转到通信页面
        findViewById(R.id.jump).setOnClickListener(view -> {

            String inputParams = paramInput.getText().toString().trim();
            FlutterAppActivity.start(MainActivity.this, inputParams);
//                startActivity(
//                    FlutterActivity
//                        .withNewEngine()
//                        .initialRoute("route1")
//                        .build(MainActivity.this)
//                );
        });

    }
}