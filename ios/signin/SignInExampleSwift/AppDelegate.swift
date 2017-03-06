//
//  Copyright (c) Google Inc.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
import UIKit
import Google
import GoogleSignIn

@UIApplicationMain
// [START appdelegate_interfaces]
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

// [END appdelegate_interfaces]
  var window: UIWindow?

  // [START didfinishlaunching]
  func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      // Initialize sign-in
      var configureError: NSError?
      GGLContext.sharedInstance().configureWithError(&configureError)
      assert(configureError == nil, "Error configuring Google services: \(configureError)")

      GIDSignIn.sharedInstance().delegate = self

      return true
  }
  // [END didfinishlaunching]

  // [START openurl]
  func application(_ application: UIApplication,
    open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
      return GIDSignIn.sharedInstance().handle(url,
          sourceApplication: sourceApplication,
          annotation: annotation)
  }
  // [END openurl]

  @available(iOS 9.0, *)
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
    return GIDSignIn.sharedInstance().handle(url,
      sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
      annotation: options[UIApplicationOpenURLOptionsKey.annotation])
  }

  // [START signin_handler]
  func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
    withError error: Error!) {
      if let error = error {
        print("\(error.localizedDescription)")
        // [START_EXCLUDE silent]
        NotificationCenter.default.post(
          name: Notification.Name(rawValue: "ToggleAuthUINotification"), object: nil, userInfo: nil)
        // [END_EXCLUDE]
      } else {
        // Perform any operations on signed in user here.
        let userId = user.userID                  // For client-side use only!
        let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        let givenName = user.profile.givenName
        let familyName = user.profile.familyName
        let email = user.profile.email
        // [START_EXCLUDE]
        NotificationCenter.default.post(
          name: Notification.Name(rawValue: "ToggleAuthUINotification"),
          object: nil,
          userInfo: ["statusText": "Signed in user:\n\((fullName != nil) ? fullName! : "You")"])
        // [END_EXCLUDE]
      }
  }
  // [END signin_handler]

  // [START disconnect_handler]
  func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
    withError error: Error!) {
      // Perform any operations when the user disconnects from app here.
      // [START_EXCLUDE]
      NotificationCenter.default.post(
          name: Notification.Name(rawValue: "ToggleAuthUINotification"),
          object: nil,
          userInfo: ["statusText": "User has disconnected."])
      // [END_EXCLUDE]
  }
  // [END disconnect_handler]

}
