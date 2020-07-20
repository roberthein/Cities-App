import Foundation
import UIKit

class ListView: UIView {
    
    lazy var list: UITableView = {
        let view = UITableView(frame: .zero, style: .plain)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = nil
        view.isOpaque = false
        view.separatorStyle = .none
        
        view.register(ListViewCell.self, forCellReuseIdentifier: ListViewCell.reuseIdentifier)
        
        return view
    }()
    
    lazy var maskingView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.backgroundColor = .blue
        view.layer.cornerRadius = Metrics.panelCornerRadius
        
        return view
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(list)
        
        NSLayoutConstraint.activate([
            list.topAnchor.constraint(equalTo: topAnchor),
            list.leftAnchor.constraint(equalTo: leftAnchor),
            list.bottomAnchor.constraint(equalTo: bottomAnchor),
            list.rightAnchor.constraint(equalTo: rightAnchor),
        ])
        
        mask = maskingView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskingView.frame = CGRect(x: 0, y: Metrics.listOffset, width: list.bounds.width, height: list.bounds.height)
    }
    
    func scrollToTop() {
        if list.numberOfRows(inSection: 0) > 0 {
            list.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        }
    }
}
