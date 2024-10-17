package com.softcoresolutions.royal_dry_fruit

import io.flutter.embedding.android.FlutterActivity

import android.content.pm.PackageInfo
import android.content.pm.PackageManager
import android.os.Bundle
import android.util.Base64
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import java.security.MessageDigest
import java.security.NoSuchAlgorithmException

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.softcoresolutions.royal_dry_fruit/channel"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

//        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
//            MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
//                if (call.method == "getSha1") {
//                    val sha1 = getHash("")
//                    if (sha1 != null) {
//                        result.success(sha1)
//                    } else {
//                        result.error("UNAVAILABLE", "SHA-1 not available.", null)
//                    }
//                } else {
//                    result.notImplemented()
//                }
//            }
//        }

        MethodChannel(flutterEngine!!.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getSHA256" -> {
                    val sha256 = getSHA256()
                    if (sha256 != null) {
                        result.success(sha256)
                    } else {
                        result.error("UNAVAILABLE", "SHA-256 not available.", null)
                    }
                }
                "getSHA512" -> {
                    val sha512 = getSHA512()
                    if (sha512 != null) {
                        result.success(sha512)
                    } else {
                        result.error("UNAVAILABLE", "SHA-512 not available.", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun getSHA256(): String? {
        return getHash("SHA-256")
    }

    private fun getSHA512(): String? {
        return getHash("SHA-512")
    }


    private fun getHash(algorithm: String): String? {
        try {
            val packageInfo: PackageInfo = packageManager.getPackageInfo(packageName, PackageManager.GET_SIGNATURES)
            for (signature in packageInfo.signatures) {
                val md: MessageDigest = MessageDigest.getInstance(algorithm)
                md.update(signature.toByteArray())
                return md.digest().joinToString("") { "%02x".format(it) }
            }
        } catch (e: PackageManager.NameNotFoundException) {
            e.printStackTrace()
        } catch (e: NoSuchAlgorithmException) {
            e.printStackTrace()
        }
        return null
    }
}
