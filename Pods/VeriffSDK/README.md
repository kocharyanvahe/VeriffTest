# veriff-ios-sdk

Veriff iOS SDK for iOS integration.

## Setup
Copy the Veriff.framework into your project folder. Then add it to Embedded Binaries and to Linked Frameworks and Libraries. Adding it to the Embedded Binaries usually adds it to both automatically.

## Initializing
Include Veriff into your controller:
```swift
import Veriff
```
The Veriff SDK needs to be initialised with parameters described as follows.

### Setting configuration parameters
| Parameters | Explanation |
| ------------- | ------------- |
| sessionUrl  | Determines the environment for testing: 'https://staging.veriff.me/v1/' and for production: 'https://magic.veriff.me/v1/'  |
| sessionToken  | The session Token unique for the client. It needs to be generated following https://developers.veriff.me/#sessions_post  |
| createColorSchema (optional)| Allows to set custom color and opacity styling. |
| setBackgroundImage (optional)| Allows to set a custom background image during the document selection page |

Example:
```swift
import Veriff

Veriff.configure { configuration in
            configuration.sessionUrl = "https://magic.veriff.me/v1/"
            configuration.sessionToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhdXRoX3Rva2VuIjoiMWE1ZjRlNGQtMjk1My00MWNmLTkxZTYtNzVkODM2YzA5MjFkIiwic2Vzc2lvbl9pZCI6ImJlYzFmNDc1LTk1MWItNDdmZC1iYTBiLTI1ZjJlNmQ2MGM5YSIsImlhdCI6MTUxOTMyMjEwOSwiZXhwIjoxNTE5OTI2OTA5fQ.ioXf_3FK36vxsX-ybOGmfZ_WdiRQS4DbYnPBjt-HtCc"
}

Veriff.createColorSchema { schema in
    schema.headerColor = UIColor.darkGray.withAlphaComponent(0.8)
    schema.backgroundColor = UIColor.lightGray.withAlphaComponent(0.8)
    schema.footerColor = UIColor.darkGray.withAlphaComponent(0.5)
    schema.controlsColor = UIColor.darkGray.withAlphaComponent(0.5)
    schema.hintFooterColor = UIColor.darkGray.withAlphaComponent(0.6)
}

Veriff.setBackgroundImage("AppIcon")
```
## Starting the SDK and handling return values
Veriff SDK's returns a number of return values, that need to handled.

Example:
```swift
let veriff = Veriff.sharedInstance()

veriff.setResultBlock({ (sessionUrl, result) in
                switch result.code {

    case .UNABLE_TO_ACCESS_CAMERA:
        // The user denied access to the camera.
        break
    case .UNABLE_TO_RECORD_AUDIO:
        // The user denied access to the microphone.
        break
    case .STATUS_USER_CANCELED:
        // The user canceled the verification process.
        break
    case .STATUS_SUBMITTED:
        // The user submitted the
        break
    case .STATUS_OUT_OF_BUSINESS_HOURS:
        // The feature list includes video_call and currently the call center is out of business hours.
        break
    case .STATUS_ERROR_SESSION:
        // The session token is either corrupt, or has expired. A new sessionToken needs to be generated in this case.
        break
    case .STATUS_ERROR_NETWORK:
        // Veriff's backend servers could not be reached.
        break
    case .STATUS_ERROR_NO_IDENTIFICATION_METHODS_AVAILABLE:
        // The session status is finished from clients perspective.
        break
    case .STATUS_DONE:
        // The client got declined while he was still using the SDK - this status can only occur if video_feature is used and FCM token is set.
        break
    case .STATUS_ERROR_UNKNOWN:
        // An unkown error occured.
        break
    }
})

veriff.requestViewController(completion: { (veriffVewController) in
    self.present(veriffVewController, animated:true, completion:nil)
})
```
## FCM handling
The Firecloudmessaging only has to be set up if the video_call feature will be used! For selfid FCM is not necessary!

### Passing FCM token to VeriffSDK
```swift
extension AppDelegate : MessagingDelegate {
    // [START refresh_token]
    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        Veriff.setFirebaseDeviceToken(fcmToken)
    }
    // [END refresh_token]
    // [START ios_10_data_message]

    // Receive data messages on iOS 10+ directly from FCM (bypassing APNs) when the app is in the foreground.
    // To enable direct data messages, you can set Messaging.messaging().shouldEstablishDirectChannel to true.
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print("Received data message: \(remoteMessage.appData)")
    }
    // [END ios_10_data_message]
}
```

### Delegating messages to SDK
In ApplicationDelegate implement following method to pass push device token to Veriff
```swift
application(_:didRegisterForRemoteNotificationsWithDeviceToken:)
```
and pass device token to Veriff
```swift
// With swizzling disabled you must set the APNs token here.
Messaging.messaging().apnsToken = deviceToken

if let fcmToken = Messaging.messaging().fcmToken {
    Veriff.setFirebaseDeviceToken(fcmToken)
}
```

or Firebase method if swizzling callbacks enabled
```swift
messaging(_:didRefreshRegistrationToken:)
```
And pass fcm token to Veriff
```swift
Veriff.setFirebaseDeviceToken(fcmToken)
```
When a message is received implement following method in ApplicationDelegate
```swift
application(_:didReceiveRemoteNotification:fetchCompletionHandler:)
```
and call Veriff passing user info from push message
```swift
Veriff.processPushNotification(userInfo)
```
or Firebase method if swizzling callbacks enabled
```swift
messaging(_:didReceive:)
```
and call Veriff passing appData
```swift
Veriff.processPushNotification(remoteMessage.appData)
```
In this method it’s possible to handle all kinds of push messages including the ones sent by Veriff.
Payload contains JSON where action key can have following values to be able filter out ones not for SDK:

start_video_call
defer_video_call
complete_video_call
resubmission_requested
done

The above listed push notifications need to be forwarded to the Veriff SDK as described above. Vendor application push notifications should not be passed to the Veriff SDK.


When the app has been killed and the user opens it from the notification center it starts with launch options that contains push message.

In AppDelegate didFinishLaunchingWithOptions: get notification payload from launch options passed in. It’s good if this notification can be stored on disk because Veriff SDK is not yet set up.
```swift
if let launchOptions = launchOptions {
    let userInfo = launchOptions[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any]
```

Now it is needed to do some state restoration of app UI and on Veriff side perform steps by configuring SDK, setting result block and presenting Veriff ViewController described above.
Once this is done call Veriff.processPushNotification(userInfo) by passing push notification previously got during application launch.


### Translating push message title for Notification Center:

You need to add translations for push message title that is shown in Notification Center in Localizable.strings file.

"start.video" = "Video call";
"defer.video" = "Video call ended";
"resubmit.photos" = "Resubmit photos";

### Registering FCM server key inside Veriff backoffice

Setup firebase messaging project in the Firebase console if you haven’t already (https://console.firebase.google.com) Tutorial: https://firebase.google.com/docs/android/setup#manually_add_firebase
Download a google-services.json file and copy this into your project's module folder, typically app/.

Copy the **Server key** from you project cloud messaging tab and enter it into your integration into Veriff's backoffice ( stagingoffice.veriff.me or office.veriff.me ).
If you already are using cloud messaging and do not wish to give the same Server key to Veriff then you can just create a new server key and use that one.
