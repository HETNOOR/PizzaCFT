//
//  OrdersViewConrtoller.swift
//  PizzaCFT
//
//  Created by Максим Герасимов on 06.07.2024.
//

import UIKit
import SnapKit

class BasketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private let orderButton = UIButton()

    private let orders = [
        ("Двойной цыпленок", "Средняя 30 см, традиционное тесто + моцарелла, халапеньо", 620),
        ("Пепперони", "Средняя 30 см, традиционное тесто + сыр чеддер и пармезан", 620)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        setupTableView()
        setupOrderButton()
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(80)
        }

        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(BasketCell.self, forCellReuseIdentifier: "BasketCell")
    }

    private func setupOrderButton() {
        view.addSubview(orderButton)
        orderButton.setTitle("Оформить заказ", for: .normal)
        orderButton.backgroundColor = .orange
        orderButton.layer.cornerRadius = 8
        orderButton.addTarget(self, action: #selector(orderButtonTapped), for: .touchUpInside)
        orderButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.equalTo(48)
        }
    }

    @objc private func orderButtonTapped() {
        let customerDataViewController = CustomerDataViewController()
        navigationController?.pushViewController(customerDataViewController, animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasketCell", for: indexPath) as! BasketCell
        let basketOrder = orders[indexPath.row]
        cell.configure(name: basketOrder.0, description: basketOrder.1, price: basketOrder.2)
        return cell
    }
}

class BasketCell: UITableViewCell {

    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let priceLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(priceLabel)

        nameLabel.font = .boldSystemFont(ofSize: 16)
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 0
        priceLabel.font = .systemFont(ofSize: 14)

        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().inset(16)
            make.bottom.trailing.equalToSuperview().inset(12)
        }
    }

    func configure(name: String, description: String, price: Int) {
        nameLabel.text = name
        descriptionLabel.text = description
        priceLabel.text = "\(price) ₽"
    }
}
