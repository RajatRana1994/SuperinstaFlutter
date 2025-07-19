import Flutter
import UIKit
import GoogleMaps



@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      GMSServices.provideAPIKey("AIzaSyBAm6xBQn3Gu6hpjDGtcNY9Od6SMJU6Wnw")
     // GMSPlacesClient.provideAPIKey("AIzaSyBAm6xBQn3Gu6hpjDGtcNY9Od6SMJU6Wnw")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
