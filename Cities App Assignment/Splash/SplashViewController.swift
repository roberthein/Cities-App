import UIKit

class SplashViewController: UIViewController {
    
    private lazy var activityIndicator = ActivityIndicator()
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.foreground.withAlphaComponent(0.7)
        view.font = .systemFont(ofSize: 12, weight: .regular)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text = "iOS assignment by:\nRobert-Hein Hooijmans"
        
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundPrimary
        view.addSubview(titleLabel)
        view.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: activityIndicator.topAnchor, constant: -20),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        Cities.load { [weak self] result in
            self?.activityIndicator.stopAnimating()
            
            switch result {
            case .success(let cities):
                self?.present(cities)
            case .failure(let error):
                error.handle()
            }
        }
    }
    
    private func present(_ cities: [City]) {
        let viewModel = ListViewModel(with: cities)
        let viewController = ListViewController(with: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
    }
}
