package com.example.whats_direct_pro

import android.content.ContentResolver
import android.content.Intent
import android.database.Cursor
import android.net.Uri
import android.provider.OpenableColumns
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import java.io.File
import java.io.FileOutputStream
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val pdfIntentChannel = "pdf_intent_channel"
    private val pdfIntentEvents = "pdf_intent_events"
    private var eventSink: EventChannel.EventSink? = null
    private var pendingIntentData: Map<String, Any?>? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            pdfIntentChannel
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitialPdfIntent" -> {
                    result.success(extractPdfIntent(intent))
                }
                else -> result.notImplemented()
            }
        }

        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            pdfIntentEvents
        ).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    pendingIntentData?.let {
                        events?.success(it)
                        pendingIntentData = null
                    }
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                }
            }
        )
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        val data = extractPdfIntent(intent) ?: return
        if (eventSink != null) {
            eventSink?.success(data)
        } else {
            pendingIntentData = data
        }
    }

    private fun extractPdfIntent(intent: Intent?): Map<String, Any?>? {
        if (intent == null) return null
        val action = intent.action ?: return null
        val uri = when (action) {
            Intent.ACTION_VIEW -> intent.data
            Intent.ACTION_SEND -> {
                intent.getParcelableExtra(Intent.EXTRA_STREAM) as? Uri
                    ?: intent.clipData?.getItemAt(0)?.uri
            }
            else -> null
        } ?: return null

        if (!isPdfUri(intent, uri)) {
            return null
        }

        return try {
            val resolved = resolvePdfUri(uri)
            if (resolved == null) {
                mapOf("error" to "Unsupported PDF location.")
            } else {
                mapOf(
                    "path" to resolved.path,
                    "displayName" to resolved.displayName,
                    "sourceUri" to uri.toString()
                )
            }
        } catch (error: Exception) {
            mapOf(
                "error" to (error.message ?: "Unable to open PDF.")
            )
        }
    }

    private fun isPdfUri(intent: Intent, uri: Uri): Boolean {
        val type = intent.type ?: contentResolver.getType(uri)
        if (type != null && type.equals("application/pdf", ignoreCase = true)) {
            return true
        }
        val path = uri.toString().lowercase(Locale.US)
        return path.endsWith(".pdf")
    }

    private data class ResolvedPdf(val path: String, val displayName: String?)

    private fun resolvePdfUri(uri: Uri): ResolvedPdf? {
        val scheme = uri.scheme ?: return null
        return when (scheme) {
            ContentResolver.SCHEME_CONTENT -> {
                val name = queryDisplayName(uri)
                val cachedPath = copyToCache(uri, name)
                ResolvedPdf(cachedPath, name)
            }
            ContentResolver.SCHEME_FILE -> {
                val path = uri.path ?: return null
                ResolvedPdf(path, File(path).name)
            }
            else -> null
        }
    }

    private fun queryDisplayName(uri: Uri): String? {
        var cursor: Cursor? = null
        return try {
            cursor = contentResolver.query(uri, null, null, null, null)
            if (cursor != null && cursor.moveToFirst()) {
                val index = cursor.getColumnIndex(OpenableColumns.DISPLAY_NAME)
                if (index >= 0) {
                    cursor.getString(index)
                } else {
                    null
                }
            } else {
                null
            }
        } finally {
            cursor?.close()
        }
    }

    private fun copyToCache(uri: Uri, displayName: String?): String {
        val pdfCacheDir = File(cacheDir, "pdfs")
        if (!pdfCacheDir.exists()) {
            pdfCacheDir.mkdirs()
        }
        val baseName = (displayName ?: "document_${System.currentTimeMillis()}.pdf")
            .replace("/", "_")
        var outputFile = File(pdfCacheDir, baseName)
        if (outputFile.exists()) {
            val nameWithoutExt = baseName.substringBeforeLast(".")
            val extension = baseName.substringAfterLast(".", "pdf")
            outputFile = File(
                pdfCacheDir,
                "${nameWithoutExt}_${System.currentTimeMillis()}.$extension"
            )
        }
        contentResolver.openInputStream(uri)?.use { input ->
            FileOutputStream(outputFile).use { output ->
                input.copyTo(output)
            }
        } ?: throw IllegalStateException("Unable to read PDF content.")
        return outputFile.absolutePath
    }
}
