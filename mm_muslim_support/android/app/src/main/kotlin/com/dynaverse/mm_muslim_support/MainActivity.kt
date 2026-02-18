package com.dynaverse.mm_muslim_support

import android.Manifest
import android.content.Context
import android.content.pm.PackageManager
import android.location.Location
import android.location.LocationManager
import androidx.core.app.ActivityCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import com.ryanheise.audioservice.AudioServicePlugin
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "native_location_channel"

    override fun provideFlutterEngine(context: Context): FlutterEngine? {
        return AudioServicePlugin.getFlutterEngine(context)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "getLocation") {

                if (!hasLocationPermission()) {
                    result.error(
                        "PERMISSION_DENIED",
                        "Location permission not granted",
                        null
                    )
                    return@setMethodCallHandler
                }

                try {
                    val locationManager =
                        getSystemService(Context.LOCATION_SERVICE) as LocationManager

                    if (!locationManager.isProviderEnabled(LocationManager.GPS_PROVIDER) &&
                        !locationManager.isProviderEnabled(LocationManager.NETWORK_PROVIDER)
                    ) {
                        result.error(
                            "PROVIDER_DISABLED",
                            "Location provider disabled",
                            null
                        )
                        return@setMethodCallHandler
                    }

                    val location: Location? =
                        locationManager.getLastKnownLocation(LocationManager.GPS_PROVIDER)
                            ?: locationManager.getLastKnownLocation(LocationManager.NETWORK_PROVIDER)

                    if (location != null) {
                        result.success(
                            mapOf(
                                "latitude" to location.latitude,
                                "longitude" to location.longitude
                            )
                        )
                    } else {
                        result.error(
                            "UNAVAILABLE",
                            "Location not available",
                            null
                        )
                    }

                } catch (e: SecurityException) {
                    // ✅ Explicitly handle SecurityException
                    result.error(
                        "SECURITY_EXCEPTION",
                        e.localizedMessage,
                        null
                    )
                } catch (e: Exception) {
                    result.error(
                        "ERROR",
                        e.localizedMessage,
                        null
                    )
                }

            } else {
                result.notImplemented()
            }
        }
    }

    private fun hasLocationPermission(): Boolean {
        return ActivityCompat.checkSelfPermission(
            this,
            Manifest.permission.ACCESS_FINE_LOCATION
        ) == PackageManager.PERMISSION_GRANTED ||
                ActivityCompat.checkSelfPermission(
                    this,
                    Manifest.permission.ACCESS_COARSE_LOCATION
                ) == PackageManager.PERMISSION_GRANTED
    }
}