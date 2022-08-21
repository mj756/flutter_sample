package com.flutter.sample

import android.Manifest
import android.content.pm.PackageManager
import android.os.Bundle
import androidx.annotation.NonNull
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/permission"
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
       // GeneratedPluginRegistrant.registerWith(flutterEngine);
        MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                CHANNEL
        ).setMethodCallHandler { call, result ->
            if (call.method == "permission") {

               var res=checkPermission(Manifest.permission.CAMERA,
                        101);
                result.success(res)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
    }
    private fun checkPermission(permission: String, requestCode: Int):Int {

        if (ContextCompat.checkSelfPermission(this@MainActivity, permission) == PackageManager.PERMISSION_DENIED) {
            // Requesting the permission
             ActivityCompat.requestPermissions(this@MainActivity, arrayOf(permission), requestCode)
            if(ContextCompat.checkSelfPermission(this@MainActivity, permission)== PackageManager.PERMISSION_DENIED){
                return -2;} else {
                return 0;
            }
        }else
        {
            return 0;
        }
        return -1;
    }
}
