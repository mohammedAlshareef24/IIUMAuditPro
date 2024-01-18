import UIKit
import Flutter
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    GMSServices.provideAPIKey(AIzaSyBXPqR-g9-z502EfbDmZDX7Ysv24kmEM3k)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
