# see free disk space on device
adb shell df
# capture screenshot
adb shell screencap -p | sed 's/\r$//' > screen.png
# get device ip
adb shell ls /sys/class/net
# get package name from apk
~/android-studio/sdk/build-tools/android-4.2.2/aapt dump badging apk-compass-sample.apk | grep package

.nomedia file prevents indexing media files in directory

Speed up animations:
Enable developer mode, go to Developer options:
- Window animation scale: [Animation off]
- Transition animation scale: [Animation off]
- Animator duration scale: [Animation off]

Android Studio
Ubuntu:
- Tools -> Create Desktop Entry…
Windows
- PATH: C:\Users\user\AppData\Local\Android\android-studio\sdk\platform-tools

# log text through adb
Log.d("stefan", "My string");
adb logcat -s stefan

# prepare release apk
keytool -genkey -v -keystore appname-release.keystore -alias appname-release -keyalg RSA -keysize 2048 -validity 10000
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -storepass password -keystore appname-release.keystore appname-release-unaligned.apk appname-release
jarsigner -verify myapp-release-unaligned.apk
zipalign -v 4 myapp-release-unaligned.apk myapp-release.apk

# rooting
adb reboot bootloader
fastboot devices
fastboot oem unlock
# re-enable dev options
adb reboot bootloader
fastboot flash recovery recovery-clockwork-6.0.4.7-maguro.img
# boot recovery mode
adb push cm-11-20140804-SNAPSHOT-M9-maguro.zip /sdcard/0/
adb push gapps-kk-20140606-signed.zip /sdcard/0/
# install zip: /sdcard/0/cm-11-20140804-SNAPSHOT-M9-maguro.zip

Distance units:
px: Pixels - corresponds to actual pixels on the screen.
in: Inches - based on the physical size of the screen.
mm: Millimeters - based on the physical size of the screen.
pt: Points - 1/72 of an inch based on the physical size of the screen.
dp: Density-independent Pixels - an abstract unit that is based on the physical density of the screen. These units are relative to a 160 dpi screen, so one dp is one pixel on a 160 dpi screen. The ratio of dp-to-pixel will change with the screen density, but not necessarily in direct proportion. Note: The compiler accepts both "dip" and "dp", though "dp" is more consistent with "sp".
sp: Scale-independent Pixels - this is like the dp unit, but it is also scaled by the user's font size preference. It is recommend you use this unit when specifying font sizes, so they will be adjusted for both the screen density and user's preference.
