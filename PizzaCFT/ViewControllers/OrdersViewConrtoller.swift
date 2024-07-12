//
//  OrdersViewConrtoller.swift
//  PizzaCFT
//
//  Created by Максим Герасимов on 06.07.2024.
//

import UIKit
import SnapKit

class OrdersViewController: UIViewController {

    private let ordersTableView = UITableView()
    private var expandedOrderIndex: IndexPath?

    private let orders = [
        Order(status: "Заказ оформлен", address: "Россия, г. Новосибирск, ул. Кирова, д. 86", items: ["Пепперони", "Сырная"], totalPrice: "1395 р"),
        Order(status: "Заказ доставлен", address: "Россия, г. Новосибирск, ул. Кирова, д. 86", items: ["Ветчина и сыр"], totalPrice: "1395 р"),
        Order(status: "Заказ отменен", address: "Россия, г. Новосибирск, ул. Кирова, д. 86", items: ["Пепперони", "Сырная"], totalPrice: "1395 р")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Заказы"
        view.backgroundColor = .white
        setupTableView()
    }

    private func setupTableView() {
        ordersTableView.dataSource = self
        ordersTableView.delegate = self
        ordersTableView.register(OrderCell.self, forCellReuseIdentifier: "OrderCell")
        ordersTableView.estimatedRowHeight = 100
        ordersTableView.rowHeight = UITableView.automaticDimension

        view.addSubview(ordersTableView)
        ordersTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    @objc private func cancelOrderButtonTapped(sender: UIButton) {
        let orderIndex = sender.tag
        // Implement cancel order functionality here
        print("Cancel order at index: \(orderIndex)")
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orders.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
        let order = orders[indexPath.row]
        let isExpanded = expandedOrderIndex == indexPath
        cell.configure(with: order, isExpanded: isExpanded)
        cell.cancelButton.tag = indexPath.row
        cell.cancelButton.addTarget(self, action: #selector(cancelOrderButtonTapped(sender:)), for: .touchUpInside)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if expandedOrderIndex == indexPath {
            expandedOrderIndex = nil
        } else {
            expandedOrderIndex = indexPath
        }
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

struct Order {
    let status: String
    let address: String
    let items: [String]
    let totalPrice: String
}

class OrderCell: UITableViewCell {

    private let statusLabel = UILabel()
    private let addressLabel = UILabel()
    private let itemsLabel = UILabel()
    private let expandButton = UIButton(type: .system)
    let cancelButton = UIButton(type: .system)

    private var isExpanded = false

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(statusLabel)
        contentView.addSubview(addressLabel)
        contentView.addSubview(itemsLabel)
        contentView.addSubview(expandButton)
        contentView.addSubview(cancelButton)

        statusLabel.font = .systemFont(ofSize: 14)
        statusLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(16)
        }

        addressLabel.font = .systemFont(ofSize: 14)
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
        }

        itemsLabel.font = .systemFont(ofSize: 14)
        itemsLabel.numberOfLines = 0
        itemsLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }

        expandButton.setTitle("Подробнее", for: .normal)
        expandButton.addTarget(self, action: #selector(expandButtonTapped), for: .touchUpInside)
        expandButton.snp.makeConstraints { make in
            make.top.equalTo(itemsLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
        }

        cancelButton.setTitle("Отменить заказ", for: .normal)
        cancelButton.backgroundColor = .orange
        cancelButton.layer.cornerRadius = 8
        cancelButton.snp.makeConstraints { make in
            make.top.equalTo(expandButton.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-16)
        }
    }

    @objc private func expandButtonTapped() {
        isExpanded.toggle()
        cancelButton.isHidden = !isExpanded
        itemsLabel.isHidden = !isExpanded
        expandButton.setTitle(isExpanded ? "Скрыть" : "Подробнее", for: .normal)
        setNeedsLayout()
    }

    func configure(with order: Order, isExpanded: Bool) {
        statusLabel.text = "Статус: \(order.status)"
        addressLabel.text = "Адрес доставки: \(order.address)"
        itemsLabel.text = "Состав заказа:\n" + order.items.joined(separator: "\n")
        cancelButton.isHidden = !isExpanded
        itemsLabel.isHidden = !isExpanded
        expandButton.setTitle(isExpanded ? "Скрыть" : "Подробнее", for: .normal)
    }
}
