package com.example.caffeine_tracker

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "caffeine_tracker/widget"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Handle widget clicks when app is opened via widget
        handleWidgetIntent()
    }

    override fun onNewIntent(intent: android.content.Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        handleWidgetIntent()
    }

    private fun handleWidgetIntent() {
        val action = intent.getStringExtra("action")
        val beverageId = intent.getStringExtra("beverage_id")

        if (action == "add_beverage" && beverageId != null) {
            // Send beverage ID to Flutter through method channel
            flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                MethodChannel(messenger, CHANNEL).invokeMethod("addBeverage", beverageId)
            }
        }
    }
}
