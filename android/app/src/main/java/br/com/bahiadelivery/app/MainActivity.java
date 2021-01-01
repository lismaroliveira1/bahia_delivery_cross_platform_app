package br.com.bahiadelivery.app;

import io.flutter.embedding.android.FlutterActivity;

import android.content.Intent;

public class MainActivity extends FlutterActivity {
    @Override  
       protected void onActivityResult(int requestCode, int resultCode, Intent data)  {  
            super.onActivityResult(requestCode, resultCode, data);
        }
        
}
