//
//  CustomerDataViewController.swift
//  PizzaCFT
//
//  Created by Максим Герасимов on 06.07.2024.
//

import UIKit
import SnapKit

class CustomerDataViewController: UIViewController {

    private let lastNameTextField = UITextField()
    private let firstNameTextField = UITextField()
    private let phoneTextField = UITextField()
    private let emailTextField = UITextField()
    private let cityTextField = UITextField()
    private let continueButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
    }

    private func setupViews() {
        view.addSubview(lastNameTextField)
        view.addSubview(firstNameTextField)
        view.addSubview(phoneTextField)
        view.addSubview(emailTextField)
        view.addSubview(cityTextField)
        view.addSubview(continueButton)

        setupTextField(lastNameTextField, placeholder: "Фамилия")
        setupTextField(firstNameTextField, placeholder: "Имя")
        setupTextField(phoneTextField, placeholder: "Номер телефона")
        setupTextField(emailTextField, placeholder: "Email")
        setupTextField(cityTextField, placeholder: "Город")

        lastNameTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        firstNameTextField.snp.makeConstraints { make in
            make.top.equalTo(lastNameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        phoneTextField.snp.makeConstraints { make in
            make.top.equalTo(firstNameTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(phoneTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        cityTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }

        continueButton.setTitle("Продолжить", for: .normal)
        continueButton.backgroundColor = .orange
        continueButton.layer.cornerRadius = 8
        continueButton.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(24)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }

    private func setupTextField(_ textField: UITextField, placeholder: String) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.placeholder = placeholder
        textField.snp.makeConstraints { make in
            make.height.equalTo(48)
        }
    }
}
