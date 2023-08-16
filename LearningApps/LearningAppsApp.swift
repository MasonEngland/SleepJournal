// Entry point of the app
// starts by calling contentView or journalView
// initializes and creates an instance of firebase
// creates a database

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseFirestore
import Firebase

let db = Firestore.firestore()

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        return true
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}


@main
struct LearningAppsApp: App {
    
    @State private var started: Int  = 0
    @State private var ents: [sleepEntry] = entries
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var signupVM: SignUpViewModel = SignUpViewModel()
    @State private var otherPopup: Bool = true
    
    var body: some Scene {
        WindowGroup {
            if signupVM.isLogin == false {
                ContentView(isRun: $started)
                    .environmentObject(signupVM)
            }
            else if started == 1 {
                journalView(ents: $ents, otherPopup: $otherPopup, switchView: $started)
                    .environmentObject(signupVM)
                    .onAppear() {
                        ents = entries
                    }
            }
            else {
                graphView(switchView: $started)
            }
        }
    }
}
