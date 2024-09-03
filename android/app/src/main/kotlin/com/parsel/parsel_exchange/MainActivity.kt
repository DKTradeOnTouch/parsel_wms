package com.parsel.parsel_exchange

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding


class MainActivity : FlutterActivity(), FlutterPlugin {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        flutterEngine.plugins.add(SyncfusionFlutterPdfViewerPlugin())
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        super.cleanUpFlutterEngine(flutterEngine)
    }

    override fun onAttachedToEngine(binding: FlutterPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
        TODO("Not yet implemented")
    }
}

