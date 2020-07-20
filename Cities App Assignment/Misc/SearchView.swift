import Foundation
import UIKit

class SearchView: UIView {
    
    lazy var textField: UITextField = {
        let view = UITextField()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clearButtonMode = .always
        view.returnKeyType = .done
        view.textColor = .foreground
        view.tintColor = .foreground
        view.backgroundColor = .clear
        view.isOpaque = false
        view.attributedPlaceholder = NSAttributedString(string: "Search...", attributes: [.foregroundColor: UIColor.foreground.withAlphaComponent(0.5)])
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(textField)
        
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: Metrics.searchTextInset),
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -Metrics.searchTextInset),
            textField.centerYAnchor.constraint(equalTo: centerYAnchor),
            textField.heightAnchor.constraint(equalToConstant: 35),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
