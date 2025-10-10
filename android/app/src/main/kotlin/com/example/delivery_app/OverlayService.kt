
package com.example.delivery_app

import android.app.*
import android.content.Context
import android.content.Intent
import android.location.Location
import android.os.Build
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.LocationServices
import com.google.gson.Gson
import kotlinx.coroutines.*
import tech.gusavila92.websocketclient.WebSocketClient
import java.net.URI
import kotlin.coroutines.resume
import kotlin.coroutines.resumeWithException
import kotlin.coroutines.suspendCoroutine

class OverlayService : Service() {

    companion object {
        private const val CHANNEL_ID = "overlay_foreground_channel"
        private const val NOTIFICATION_ID = 1001
        private const val WEBSOCKET_URL = "ws://host0.devices.yaantrac.com:8001/websocket"
        private const val TAG = "OverlayService"
    }

    private var webSocketClient: WebSocketClient? = null
    private lateinit var fusedLocationClient: FusedLocationProviderClient
    private val serviceScope = CoroutineScope(SupervisorJob() + Dispatchers.IO)
    private var webSocketConnected = false
    private var reconnecting = false

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForegroundService()
        startWebSocket()
        return START_STICKY
    }

    private fun startForegroundService() {
        createNotificationChannel()
        val notification = NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.mipmap.ic_launcher)
            .setContentTitle("Live Tracking")
            .setContentText("Tracking while stop the connection")
            .setOngoing(true)
            .build()
        startForeground(NOTIFICATION_ID, notification)
        fusedLocationClient = LocationServices.getFusedLocationProviderClient(this)
    }

    private fun startWebSocket() {
        if (webSocketClient != null) return

        webSocketClient = object : WebSocketClient(URI(WEBSOCKET_URL)) {
            override fun onOpen() {
                Log.d(TAG, "WebSocket connected")
                webSocketConnected = true
                reconnecting = false
            }

            override fun onTextReceived(message: String?) {}
            override fun onBinaryReceived(data: ByteArray?) {}
            override fun onPingReceived(data: ByteArray?) {}
            override fun onPongReceived(data: ByteArray?) {}

            override fun onException(e: Exception?) {
                e?.printStackTrace()
                webSocketConnected = false
                tryReconnect()
            }

            override fun onCloseReceived() {
                Log.d(TAG, "WebSocket closed")
                webSocketConnected = false
                tryReconnect()
            }
        }

        webSocketClient?.connect()

        // Start sending location every 2 seconds
        serviceScope.launch {
            while (isActive) {
                try {
                    val loc = getLastLocation() ?: continue
                    if (webSocketConnected) {
                        val json = Gson().toJson(
                            mapOf(
                                "latitude" to loc.latitude,
                                "longitude" to loc.longitude,
                                "deviceId" to "demo77",
                                "mobileId" to "demo12",
                                "tripId" to 12,
                                "timestamp" to System.currentTimeMillis()
                            )
                        )
                        try {
                            webSocketClient?.send(json)
                            Log.d(TAG, "Sent location: $json")
                        } catch (e: Exception) {
                            e.printStackTrace()
                        }
                    }
                    delay(2000)
                } catch (e: Exception) {
                    e.printStackTrace()
                }
            }
        }
    }

    private fun tryReconnect() {
        if (reconnecting) return
        reconnecting = true
        serviceScope.launch {
            delay(3000)
            Log.d(TAG, "Reconnecting WebSocket...")
            webSocketClient?.connect()
            reconnecting = false
        }
    }

    private suspend fun getLastLocation(): Location? = suspendCoroutine { cont ->
        fusedLocationClient.lastLocation
            .addOnSuccessListener { cont.resume(it) }
            .addOnFailureListener { cont.resumeWithException(it) }
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                CHANNEL_ID,
                "Overlay Foreground Service",
                NotificationManager.IMPORTANCE_LOW
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(channel)
        }
    }

    override fun onDestroy() {
        serviceScope.cancel()
        webSocketClient?.close()
        webSocketClient = null
        webSocketConnected = false
        reconnecting = false
        super.onDestroy()
    }
}

