import UIKit
import SnapKit

class PizzaSelectionViewController: UIViewController {

    var pizzaName: String?
    var pizzaDescription: String?
    var pizzaImageName: String?

    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let pizzaImageView = UIImageView()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let sizeSegmentedControl = UISegmentedControl(items: ["Маленькая", "Средняя", "Большая"])
    private let addToOrderButton = UIButton()
    
    private var addOns: [Toppings] = []
//    private let networkManager = NetworkManager()

    private let addOnsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        layout.itemSize = CGSize(width: (UIScreen.main.bounds.width - 58) / 3, height: UIScreen.main.bounds.height / 4.8)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupViews()
        configureViews()
        fetchAddOns()
    }
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(pizzaImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(sizeSegmentedControl)
        contentView.addSubview(addOnsCollectionView)
        contentView.addSubview(addToOrderButton)

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview() // Ensure contentView width matches scrollView width
        }

        pizzaImageView.contentMode = .scaleAspectFit
        pizzaImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(16)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 200, height: 200))
        }
        
        nameLabel.font = .boldSystemFont(ofSize: 24)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(pizzaImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        descriptionLabel.font = .systemFont(ofSize: 16)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        sizeSegmentedControl.selectedSegmentIndex = 1
        sizeSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
        }
        
        addOnsCollectionView.dataSource = self
        addOnsCollectionView.delegate = self
        addOnsCollectionView.register(AddOnCell.self, forCellWithReuseIdentifier: "AddOnCell")
        addOnsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sizeSegmentedControl.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(0)
            make.height.equalTo(290) // Adjust this height if needed
        }
        
        addToOrderButton.setTitle("Добавить в заказ", for: .normal)
        addToOrderButton.backgroundColor = .orange
        addToOrderButton.layer.cornerRadius = 8
        addToOrderButton.addTarget(self, action: #selector(addToOrderButtonTapped), for: .touchUpInside)
        addToOrderButton.snp.makeConstraints { make in
            make.top.equalTo(addOnsCollectionView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().offset(-16) // Ensure the content size of scrollView is correct
        }
    }
    
    private func configureViews() {
        nameLabel.text = pizzaName
        descriptionLabel.text = pizzaDescription
        if let imageName = pizzaImageName {
            let baseUrlString = "https://shift-backend.onrender.com"
            let imageUrlString = baseUrlString + imageName
            pizzaImageView.loadImage(from: imageUrlString)
        }
    }
    
    private func fetchAddOns() {
        networkManager.fetch(api: .catalog, resultType: PizzaCatalogResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                if response.success {
                    self?.addOns = response.catalog[0].toppings
                    DispatchQueue.main.async {
                        self?.addOnsCollectionView.reloadData()
                    }
                } else {
                    print("Failed to fetch addons: \(response.reason ?? "Unknown error")")
                }
            case .failure(let error):
                print("Error fetching addons: \(error)")
            }
        }
    }
    
    @objc private func addToOrderButtonTapped() {
        let ordersViewController = BasketViewController()
        navigationController?.pushViewController(ordersViewController, animated: true)
    }
}

extension PizzaSelectionViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addOns.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddOnCell", for: indexPath) as! AddOnCell
        let addOn = addOns[indexPath.row]
        cell.configure(with: addOn)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let addOn = addOns[indexPath.row]
        descriptionLabel.text! += ",\(addOn.name)"
    }
}

class AddOnCell: UICollectionViewCell {

    private let containerView = UIView()
    private let imageView = UIImageView()
    private let nameLabel = UILabel()
    private let priceLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        contentView.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(priceLabel)

        containerView.layer.cornerRadius = 8
        containerView.layer.shadowColor = UIColor.black.cgColor
        containerView.layer.shadowOpacity = 0.15
        containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView.layer.shadowRadius = 5
        containerView.backgroundColor = .white
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(8)
            make.height.equalTo(imageView.snp.width)
        }

        nameLabel.font = .systemFont(ofSize: 12)
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(8)
        }

        priceLabel.font = .systemFont(ofSize: 14)
        priceLabel.textAlignment = .center
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(8)
        }
    }

    func configure(with addOn: Topping) {
        nameLabel.text = addOn.name
        priceLabel.text = "\(addOn.cost)₽"
        let baseUrlString = "https://shift-backend.onrender.com"
        let imageUrlString = baseUrlString + addOn.img
        imageView.loadImage(from: imageUrlString)
    }
}


