//
//  PizzaListViewController.swift
//  PizzaCFT
//
//  Created by Максим Герасимов on 06.07.2024.
//

import UIKit
import SnapKit

class PizzaListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    private let tableView = UITableView()
    private var pizzas: [Pizza] = []
    private let networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        view.backgroundColor = .white
        setupTableView()
        fetchPizzaCatalog()

      
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
    
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PizzaCell.self, forCellReuseIdentifier: "PizzaCell")
      
                
    }
    
    private func fetchPizzaCatalog() {
            networkManager.fetch(api: .catalog, resultType: PizzaCatalogResponse.self) { [weak self] result in
                switch result {
                case .success(let response):
                    if response.success {
                        self?.pizzas = response.catalog
                        DispatchQueue.main.async {
                            self?.tableView.reloadData()
                        }
                    } else {
                        print("Failed to fetch catalog: \(response.reason ?? "Unknown error")")
                    }
                case .failure(let error):
                    print("Error fetching catalog: \(error)")
                }
            }
        }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return pizzas.count
      }
    
   
    

      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          let cell = tableView.dequeueReusableCell(withIdentifier: "PizzaCell", for: indexPath) as! PizzaCell
          let pizza = pizzas[indexPath.row]
          cell.configure(with: pizza)
          return cell
      }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           let pizza = pizzas[indexPath.row]
           let pizzaSelectionViewController = PizzaSelectionViewController()
        pizzaSelectionViewController.pizzaName = pizza.name
        pizzaSelectionViewController.pizzaDescription = pizza.description
        pizzaSelectionViewController.pizzaImageName = pizza.img
           navigationController?.pushViewController(pizzaSelectionViewController, animated: true)
       }
    

  }

  class PizzaCell: UITableViewCell {
      
      private let pizzaImageView = UIImageView()
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
          contentView.addSubview(pizzaImageView)
          contentView.addSubview(nameLabel)
          contentView.addSubview(descriptionLabel)
          contentView.addSubview(priceLabel)
          
          pizzaImageView.contentMode = .scaleAspectFit
          pizzaImageView.snp.makeConstraints { make in
              make.size.equalTo(CGSize(width: 116, height: 116))
              make.top.equalToSuperview().inset(24)
              make.leading.equalToSuperview().inset(16)
              make.centerY.equalToSuperview()
              make.bottom.equalToSuperview().inset(5)
             
          }
          
          nameLabel.font = .boldSystemFont(ofSize: 16)
          descriptionLabel.font = .systemFont(ofSize: 14)
          descriptionLabel.numberOfLines = 0
          priceLabel.font = .boldSystemFont(ofSize: 16)
          priceLabel.numberOfLines = 0
          
          nameLabel.snp.makeConstraints { make in
              make.top.equalToSuperview().inset(24)
              make.leading.equalTo(pizzaImageView.snp.trailing).offset(24)
              make.trailing.equalToSuperview().inset(16)
          }
          
          descriptionLabel.snp.makeConstraints { make in
              make.top.equalTo(nameLabel.snp.bottom).offset(8)
              make.leading.equalTo(pizzaImageView.snp.trailing).offset(24)
              make.trailing.equalToSuperview().inset(16)
          }
          
          priceLabel.snp.makeConstraints { make in
              make.top.equalTo(descriptionLabel.snp.bottom).offset(8)
              make.leading.equalTo(pizzaImageView.snp.trailing).offset(24)
          }
      }
      
      func configure(with pizza: Pizza) {
          nameLabel.text = pizza.name
          descriptionLabel.text = pizza.description
          priceLabel.text = "от \(pizza.sizes[0].price) ₽"
         
          
          let baseUrlString = "https://shift-backend.onrender.com"
          let imageUrlString = baseUrlString + pizza.img
          pizzaImageView.loadImage(from: imageUrlString)
//          /static/images/pizza/3.webp
      }
  }
