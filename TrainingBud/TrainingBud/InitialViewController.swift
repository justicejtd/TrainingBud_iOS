import Foundation
import UIKit
import Firebase

class InitialViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
		
		if Auth.auth().currentUser != nil {
			self.performSegue(withIdentifier: "toHomeScreen", sender: self)
		}
		else {
			self.performSegue(withIdentifier: "toMenuScreen", sender: self)
		}
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get {
            return .lightContent
        }
    }
}
