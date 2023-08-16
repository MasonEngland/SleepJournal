//
//  The View model for signing in
//  Handels all authentication
//  stores user info in a database for further reference 
//  Created by Mason England on 6/11/22.
//

import SwiftUI
import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseFirestoreSwift

class SignUpViewModel: ObservableObject {
    
    @Published var isLogin: Bool = false
    @Published var loginName: String? = ""
    
    func signUpWithGoogle() {
        
        // grabs id from the client
        guard let  clientId = FirebaseApp.app()?.options.clientID else { return }
        
        // use the client id to configure the authentication
        let config = GIDConfiguration(clientID: clientId)
        
        // calls a sign in using a view controller to show the google page
        GIDSignIn.sharedInstance.signIn(with: config, presenting: ApplicationUtility.rootViewController) {
            [self] user, err in
            
            // checks for an error
            if let error = err {
                print(error.localizedDescription)
                return
            }
            
            // grabs users authentication and grants a token
            guard
                let authentication = user?.authentication,
                let idToken = authentication.idToken
            else {return}
            
            // uses token to verify account
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
            
            // final authorization using the grabbed credential
            Auth.auth().signIn(with: credential) {result, error in
                
                // checks for errors once again
                if let err = error {
                    print(err.localizedDescription)
                    return
                }
                
                // makes sure there is a user object and stores it
                guard let user = result?.user else { return }
                
                print(user.displayName!)
                
                // stores users email in a variable for
                //futher use outside of scope
                self.loginName = user.email
                // grabs reference to database
                let docRef = db.collection("users").document("\(String(describing: user.email))")
                docRef.getDocument { (document, error) in
                    
                    // checks if the document exists for the current user
                    // if not it creates one
                    // stores that data in an array variable
                    if let document = document, document.exists {
                        let entryCoded = document.data()!["data"]
                        entries = decodeData(data: entryCoded!)
                        print("successfully grabbed data")
                        // print(entries)
                    }
                    else {
                        db.collection("users").document("\(String(describing: user.email))").setData([
                            "name": user.email!,
                            "data": encodeData(list: entries)
                        ]) { err in
                            
                            if let err = err {
                                print("there is a problem at the database: \(err)")
                            }
                            else {
                                print("Holy shit it worked!")
                            }
                        }
                    }
                }
                // grants access to the app if everything went well
                self.isLogin.toggle()
            }
        }
    }
}

