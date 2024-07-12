//
//  UserViewController.swift
//  PizzaCFT
//
//  Created by Максим Герасимов on 10.07.2024.
//

import UIKit
import SnapKit

class UserViewController: UIViewController {

    private let nameTextField = UITextField()
    private let surnameTextField = UITextField()
    private let patronymicTextField = UITextField()
    private let phoneNumberTextField = UITextField()
    private let cityTextField = UITextField()
    private let updateButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupViews()
        loadUserData()
    }

    private func setupViews() {
        let labels = ["Имя*", "Фамилия*", "Отчество*", "Номер телефона*", "Город"]
        let textFields = [nameTextField, surnameTextField, patronymicTextField, phoneNumberTextField, cityTextField]
        
        var previousView: UIView?
        
        for (index, label) in labels.enumerated() {
            let labelView = UILabel()
            labelView.text = label
            labelView.font = .boldSystemFont(ofSize: 16)
            view.addSubview(labelView)
            
            let textField = textFields[index]
            textField.borderStyle = .roundedRect
            view.addSubview(textField)
            
            labelView.snp.makeConstraints { make in
                if let previousView = previousView {
                    make.top.equalTo(previousView.snp.bottom).offset(16)
                } else {
                    make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
                }
                make.leading.trailing.equalToSuperview().inset(16)
            }
            
            textField.snp.makeConstraints { make in
                make.top.equalTo(labelView.snp.bottom).offset(8)
                make.leading.trailing.equalToSuperview().inset(16)
                make.height.equalTo(40)
            }
            
            previousView = textField
        }

        phoneNumberTextField.isEnabled = false
        
        updateButton.setTitle("Обновить данные", for: .normal)
        updateButton.backgroundColor = .orange
        updateButton.layer.cornerRadius = 8
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
        view.addSubview(updateButton)
        
        updateButton.snp.makeConstraints { make in
            make.top.equalTo(previousView!.snp.bottom).offset(32)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
        }
    }
    
    private func loadUserData() {
        let defaults = UserDefaults.standard
        nameTextField.text = defaults.string(forKey: "userName") ?? ""
        surnameTextField.text = defaults.string(forKey: "userSurname") ?? ""
        patronymicTextField.text = defaults.string(forKey: "userPatronymic") ?? ""
        phoneNumberTextField.text = defaults.string(forKey: "userPhoneNumber") ?? "+7 913 123 45 67" // Example default number
        cityTextField.text = defaults.string(forKey: "userCity") ?? ""
    }

    @objc private func updateButtonTapped() {
        let defaults = UserDefaults.standard
        defaults.set(nameTextField.text, forKey: "userName")
        defaults.set(surnameTextField.text, forKey: "userSurname")
        defaults.set(patronymicTextField.text, forKey: "userPatronymic")
        defaults.set(cityTextField.text, forKey: "userCity")
        
        let alert = UIAlertController(title: "Успех", message: "Данные обновлены", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
