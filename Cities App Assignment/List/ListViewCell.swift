import Foundation
import UIKit

class ListViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "ListViewCell"
    
    var title: String? {
        get { return titleLabel.text }
        set { titleLabel.text = newValue }
    }
    
    private lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .foreground
        view.font = .systemFont(ofSize: 16, weight: .light)
        
        return view
    }()
    
    var subtitle: String? {
        get { return subtitleLabel.text }
        set { subtitleLabel.text = newValue }
    }
    
    private lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.foreground.withAlphaComponent(0.8)
        view.font = .systemFont(ofSize: 12, weight: .light)
        
        return view
    }()
    
    var country: String? {
        get { return countryLabel.text }
        set { countryLabel.text = newValue }
    }
    
    private lazy var countryLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = UIColor.foreground.withAlphaComponent(0.8)
        view.font = .systemFont(ofSize: 10, weight: .regular)
        view.textAlignment = .center
        
        return view
    }()
    
    private lazy var icon: UIImageView = {
        let view = UIImageView(image: UIImage(named: "icon-location"))
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = UIColor.foreground.withAlphaComponent(0.8)
        
        return view
    }()
    
    private lazy var background: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.backgroundSecondary.withAlphaComponent(0.5)
        
        return view
    }()
    
    private lazy var separator: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.foreground.withAlphaComponent(0.1)
        
        return view
    }()
    
    private lazy var countryView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.tint
        view.layer.cornerRadius = 12
        view.layer.borderColor = UIColor.tint.cgColor
        view.layer.borderWidth = 1 / UIScreen.main.scale
        
        return view
    }()
    
    private lazy var layoutGuide = UILayoutGuide()
    private lazy var centerLayoutGuide = UILayoutGuide()
    private var layoutLeft: NSLayoutConstraint?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        backgroundView = nil
        selectedBackgroundView = background
        
        contentView.addLayoutGuide(layoutGuide)
        contentView.addLayoutGuide(centerLayoutGuide)
        contentView.addSubview(separator)
        contentView.addSubview(countryView)
        countryView.addSubview(countryLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(icon)
        contentView.addSubview(subtitleLabel)
        
        let iconSize = icon.image!.size
        
        NSLayoutConstraint.activate([
            layoutGuide.topAnchor.constraint(equalTo: contentView.topAnchor),
            layoutGuide.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            layoutGuide.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -(Metrics.searchPanelInset + Metrics.searchTextInset)),
            
            centerLayoutGuide.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
            centerLayoutGuide.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor),
            centerLayoutGuide.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
            
            separator.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
            separator.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            separator.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor),
            separator.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale),
            
            countryView.leftAnchor.constraint(equalTo: centerLayoutGuide.leftAnchor),
            countryView.centerYAnchor.constraint(equalTo: centerLayoutGuide.centerYAnchor),
            countryView.widthAnchor.constraint(equalToConstant: 24),
            countryView.heightAnchor.constraint(equalToConstant: 24),
            
            countryLabel.topAnchor.constraint(equalTo: countryView.topAnchor),
            countryLabel.leftAnchor.constraint(equalTo: countryView.leftAnchor),
            countryLabel.bottomAnchor.constraint(equalTo: countryView.bottomAnchor),
            countryLabel.rightAnchor.constraint(equalTo: countryView.rightAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: centerLayoutGuide.topAnchor),
            titleLabel.leftAnchor.constraint(equalTo: countryView.rightAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: centerLayoutGuide.rightAnchor),
            
            icon.leftAnchor.constraint(equalTo: countryView.rightAnchor, constant: 12),
            icon.bottomAnchor.constraint(equalTo: subtitleLabel.firstBaselineAnchor),
            icon.widthAnchor.constraint(equalToConstant: iconSize.width),
            icon.heightAnchor.constraint(equalToConstant: iconSize.height),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 5),
            subtitleLabel.bottomAnchor.constraint(equalTo: centerLayoutGuide.bottomAnchor),
            subtitleLabel.rightAnchor.constraint(equalTo: centerLayoutGuide.rightAnchor),
        ])
        
        layoutLeft = layoutGuide.leftAnchor.constraint(equalTo: contentView.leftAnchor)
        layoutLeft?.isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setNeedsUpdateConstraints()
    }
    
    override func updateConstraints() {
        layoutLeft?.constant = Metrics.searchPanelInset + Metrics.searchTextInset - safeAreaInsets.left
        
        super.updateConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
