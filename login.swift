import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordLabel: UILabel!
    private var gradientLayer: CAGradientLayer!
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordLabel.text = ""
        // Do any additional setup after loading the view.
        
        // Disable autocorrect, copy, paste for email and password text fields
        emailTextField.autocorrectionType = .no
        emailTextField.autocapitalizationType = .none
        emailTextField.smartQuotesType = .no
        emailTextField.smartDashesType = .no
        emailTextField.smartInsertDeleteType = .no
        
        passwordTextField.autocorrectionType = .no
        passwordTextField.autocapitalizationType = .none
        passwordTextField.smartQuotesType = .no
        passwordTextField.smartDashesType = .no
        passwordTextField.smartInsertDeleteType = .no
        
        // Hide the password text
        passwordTextField.isSecureTextEntry = true
        //set up the design of the login button
        setupLoginButton()
        //set up the UI part of the page
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopGradientAnimation()
    }
    private func setupUI() {
        // Customize the login button appearance
        loginButton.backgroundColor = .systemBlue
        loginButton.layer.cornerRadius = 24
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

        // Add Fancy Animation to the login button
        let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 1.0
        pulseAnimation.toValue = 1.1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = .greatestFiniteMagnitude
        loginButton.layer.add(pulseAnimation, forKey: "pulse")

        // Add Shadow Effect to the login button
        loginButton.layer.shadowColor = UIColor.black.cgColor
        loginButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        loginButton.layer.shadowOpacity = 0.4
        loginButton.layer.shadowRadius = 4

        // Set the appearance of the errorLabel
        errorLabel.textColor = .white
        errorLabel.font = UIFont.boldSystemFont(ofSize: 18)
        errorLabel.textAlignment = .center

        // Set the placeholder text color for emailTextField and passwordTextField
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Email",
                                                                 attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password",
                                                                    attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    private func startGradientAnimation() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 0.1, green: 0.5, blue: 0.9, alpha: 1.0).cgColor,
                                UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0).cgColor]
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)

        let displayLink = CADisplayLink(target: self, selector: #selector(animateGradientColors))
        displayLink.add(to: .current, forMode: .default)
    }
    private func stopGradientAnimation() {
        gradientLayer.removeFromSuperlayer()
    }
    @objc private func animateGradientColors() {
        let color1 = UIColor(red: 0.1, green: 0.5, blue: 0.9, alpha: 1.0).cgColor
        let color2 = UIColor(red: 0.3, green: 0.7, blue: 1.0, alpha: 1.0).cgColor

        let currentTime = CACurrentMediaTime()
        let colorProgress = sin(currentTime) / 2 + 0.5

        let newColors = [
            UIColor(cgColor: color1).lerp(to: UIColor(cgColor: color2), fraction: CGFloat(colorProgress)).cgColor,
            UIColor(cgColor: color2).lerp(to: UIColor(cgColor: color1), fraction: CGFloat(colorProgress)).cgColor
        ]

        let animation = CABasicAnimation(keyPath: "colors")
        animation.duration = 0.1
        animation.fromValue = gradientLayer.colors
        animation.toValue = newColors
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        gradientLayer.colors = newColors
        gradientLayer.add(animation, forKey: nil)
    }
   
    
    
    private func setupLoginButton() {
           // Customize the login button appearance
           loginButton.backgroundColor = .systemBlue
           loginButton.layer.cornerRadius = 24
           loginButton.setTitleColor(.white, for: .normal)
           loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)

           // Add Pulse Animation to the login button
           let pulseAnimation = CABasicAnimation(keyPath: "transform.scale")
           pulseAnimation.duration = 1.0
           pulseAnimation.fromValue = 0.95
           pulseAnimation.toValue = 1.0
           pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
           pulseAnimation.autoreverses = true
           pulseAnimation.repeatCount = .greatestFiniteMagnitude
           loginButton.layer.add(pulseAnimation, forKey: "pulse")
       }
    
    @IBAction func loginClicked(_ sender: Any) {
            guard let email = emailTextField.text, !email.isEmpty else { return }
            guard let password = passwordTextField.text, !password.isEmpty else { return }

            Auth.auth().signIn(withEmail: email, password: password) { (fireBaseResult, error) in
                if let error = error as NSError?, error.code == AuthErrorCode.wrongPassword.rawValue {
                    self.passwordLabel.text="Wrong email or password. Please try again."
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else {
                    self.performSegue(withIdentifier: "goToNext", sender: self)
                }
            }
        }
   
    @IBAction func forgotPassButton_Tapped(_ sender: Any) {
        guard let email = emailTextField.text, !email.isEmpty else {
            return // Show an alert to inform the user to enter their email address first
        }

        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                print("Error sending password reset email: \(error.localizedDescription)")
            } else {
                // Show an alert to inform the user that the password reset email has been sent
            }
        }
    }
    
}
extension UIColor {
    func lerp(to color: UIColor, fraction: CGFloat) -> UIColor {
        let red = self.red + fraction * (color.red - self.red)
        let green = self.green + fraction * (color.green - self.green)
        let blue = self.blue + fraction * (color.blue - self.blue)
        let alpha = self.alpha + fraction * (color.alpha - self.alpha)

        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    var red: CGFloat {
        var value: CGFloat = 0
        getRed(&value, green: nil, blue: nil, alpha: nil)
        return value
    }

    var green: CGFloat {
        var value: CGFloat = 0
        getRed(nil, green: &value, blue: nil, alpha: nil)
        return value
    }

    var blue: CGFloat {
        var value: CGFloat = 0
        getRed(nil, green: nil, blue: &value, alpha: nil)
        return value
    }

    var alpha: CGFloat {
        var value: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &value)
        return value
    }
}
