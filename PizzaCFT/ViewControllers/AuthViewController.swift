import UIKit
import SnapKit

class AuthViewController: UIViewController {

        private let phoneTextField = UITextField()
        private let otpTextField = UITextField()
        private let sendOtpButton = UIButton()
        private let loginButton = UIButton()
        private let networkManager = NetworkManager()
        private var otpSent = false

        override func viewDidLoad() {
            super.viewDidLoad()
            setupViews()
            setupConstraints()
        }
        
        private func setupViews() {
            view.backgroundColor = .white
            
            phoneTextField.placeholder = "Введите номер телефона"
            phoneTextField.borderStyle = .roundedRect
            phoneTextField.keyboardType = .phonePad
            view.addSubview(phoneTextField)
            
            otpTextField.placeholder = "Введите OTP"
            otpTextField.borderStyle = .roundedRect
            otpTextField.keyboardType = .numberPad
            otpTextField.isHidden = true
            view.addSubview(otpTextField)
            
            sendOtpButton.setTitle("Получить OTP", for: .normal)
            sendOtpButton.backgroundColor = .orange
            sendOtpButton.layer.cornerRadius = 8
            sendOtpButton.addTarget(self, action: #selector(sendOtpButtonTapped), for: .touchUpInside)
            view.addSubview(sendOtpButton)
            
            loginButton.setTitle("Войти", for: .normal)
            loginButton.backgroundColor = .orange
            loginButton.layer.cornerRadius = 8
            loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
            loginButton.isHidden = true
            view.addSubview(loginButton)
        }
        
        private func setupConstraints() {
            phoneTextField.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide).offset(32)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(44)
            }
            
            otpTextField.snp.makeConstraints { make in
                make.top.equalTo(phoneTextField.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(44)
            }
            
            sendOtpButton.snp.makeConstraints { make in
                make.top.equalTo(otpTextField.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(44)
            }
            
            loginButton.snp.makeConstraints { make in
                make.top.equalTo(sendOtpButton.snp.bottom).offset(16)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(44)
            }
        }
        
        @objc private func sendOtpButtonTapped() {
            guard let phone = phoneTextField.text, !phone.isEmpty else {
                showAlert(message: "Введите номер телефона")
                return
            }
            
            NetworkManager.shared.createOtp(phone: phone) { [weak self] result in
                switch result {
                case .success(let success):
                    if success {
                        DispatchQueue.main.async {
                            self?.otpSent = true
                            self?.otpTextField.isHidden = false
                            self?.loginButton.isHidden = false
                            self?.sendOtpButton.setTitle("Повторно отправить OTP", for: .normal)
                        }
                    } else {
                        self?.showAlert(message: "Ошибка при отправке OTP")
                    }
                case .failure(let error):
                    self?.showAlert(message: "Ошибка: \(error.localizedDescription)")
                }
            }
        }
        
        @objc private func loginButtonTapped() {
            guard let phone = phoneTextField.text, !phone.isEmpty else {
                showAlert(message: "Введите номер телефона")
                return
            }
            
            guard let otp = otpTextField.text, !otp.isEmpty else {
                showAlert(message: "Введите OTP")
                return
            }
            
            NetworkManager.shared.signin(phone: phone, otp: otp) { [weak self] result in
                switch result {
                case .success(let user):
                    DispatchQueue.main.async {
                        // Сохранение данных пользователя и переход на главный экран
                        UserDefaults.standard.setValue(user.name, forKey: "username")
                        UserDefaults.standard.setValue(user.phone, forKey: "userphone")
                        UserDefaults.standard.setValue(user.email, forKey: "useremail")
                        UserDefaults.standard.setValue(user.address, forKey: "useraddress")
                        
                        let mainTabBarController = MainTabBarController() // или другой главный контроллер
                        let navController = UINavigationController(rootViewController: mainTabBarController)
                        navController.modalPresentationStyle = .fullScreen
                        self?.present(navController, animated: true, completion: nil)
                    }
                case .failure(let error):
                    self?.showAlert(message: "Ошибка: \(error.localizedDescription)")
                }
            }
        }
        
        private func showAlert(message: String) {
            let alertController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default))
            present(alertController, animated: true)
        }
    }

   
