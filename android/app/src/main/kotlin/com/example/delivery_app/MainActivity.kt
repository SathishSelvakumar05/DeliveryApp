package com.example.delivery_app

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.embedding.android.FlutterFragmentActivity
import java.io.File
import com.tom_roush.pdfbox.pdmodel.PDDocument

class MainActivity : FlutterFragmentActivity() {

    // Existing config channel
//    private val CONFIG_CHANNEL = "com.enexpense.com/config"

    // New PDF password channel
    private val PDF_PASSWORD_CHANNEL = "pdf_password_channel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // New method channel for PDF password decryption
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, PDF_PASSWORD_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "decryptPdf" -> {
                        val filePath = call.argument<String>("filePath")
                        val password = call.argument<String>("password")

                        if (filePath.isNullOrEmpty() || password.isNullOrEmpty()) {
                            result.error("INVALID_ARGS", "File path or password missing", null)
                            return@setMethodCallHandler
                        }

                        try {
                            val inputFile = File(filePath)
                            val document = PDDocument.load(inputFile, password)

                            document.setAllSecurityToBeRemoved(true)

                            val outputFile = File(cacheDir, "decrypted_${System.currentTimeMillis()}.pdf")

                            document.save(outputFile)
                            document.close()

                            result.success(outputFile.absolutePath)
                        } catch (e: Exception) {
                            e.printStackTrace()
                            result.error("PDF_DECRYPT_ERROR", e.message, null)
                        }
                    }

                    else -> result.notImplemented()
                }
            }
    }
}



