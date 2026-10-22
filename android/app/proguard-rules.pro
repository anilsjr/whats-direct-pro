# Room creates generated database implementations through reflection. The older
# Room runtime pulled in by the ads SDK does not preserve their constructors
# under R8 full mode.
-keep class * extends androidx.room.RoomDatabase {
    public <init>();
}

# Pigeon's JNI bridge looks up these methods by their original JVM signatures,
# including parameter types such as kotlin.coroutines.Continuation.
-keep,includedescriptorclasses class io.flutter.plugins.sharedpreferences.** { *; }

# Kotlin helpers referenced directly by package:jni's suspend-function bridge.
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.coroutines.intrinsics.** { *; }
-keep class kotlin.Result { *; }
-keep class kotlin.Result$Failure { *; }
-keep class kotlin.Unit { *; }
