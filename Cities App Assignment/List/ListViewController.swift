import Foundation
import UIKit
import MapKit
import Combine

class ListViewController: UIViewController {
    
    let viewModel: ListViewModel
    
    lazy var mapView = MapView(frame: .zero)
    
    var disposal = Set<AnyCancellable>()
    
    lazy var listView: ListView = {
        let view = ListView(frame: .zero)
        view.list.dataSource = self
        view.list.delegate = self
        
        return view
    }()
    
    lazy var searchView: SearchView = {
        let view = SearchView(frame: .zero)
        view.textField.delegate = self
        
        return view
    }()
    
    lazy var searchPanel = PanelView(color: .tint)
    lazy var listPanel = PanelView(color: .backgroundPrimary)
    
    var searchPanelTop: NSLayoutConstraint?
    var listPanelTop: NSLayoutConstraint?
    
    var shouldScrollToTop: Bool = true
    var shouldGoHome: Bool = true
    
    required init(with viewModel: ListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var sharedConstraints: [NSLayoutConstraint] = []
    var portraitConstraints: [NSLayoutConstraint] = []
    var landscapeConstraints: [NSLayoutConstraint] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundSecondary
        
        view.addSubview(mapView)
        view.addSubview(searchPanel)
        view.addSubview(listPanel)
        view.addSubview(listView)
        view.addSubview(searchView)
        
        setupConstraints()
        updateLayoutMargins()
        
        listView.list.contentInset.top = Metrics.listOffset
    }
    
    func setupConstraints() {
        let portraitHeight: CGFloat = max(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        let landscapeHeight: CGFloat = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)
        
        sharedConstraints = [
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            searchView.topAnchor.constraint(equalTo: searchPanel.topAnchor),
            searchView.leftAnchor.constraint(equalTo: searchPanel.leftAnchor),
            searchView.bottomAnchor.constraint(equalTo: listPanel.topAnchor),
            searchView.rightAnchor.constraint(equalTo: searchPanel.rightAnchor),
            listPanel.leftAnchor.constraint(equalTo: view.leftAnchor),
            listPanel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: Metrics.listOffset),
            listView.leftAnchor.constraint(equalTo: view.leftAnchor),
            listView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        
        portraitConstraints = [
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchPanel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Metrics.searchPanelInset),
            searchPanel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Metrics.searchPanelInset),
            listPanel.rightAnchor.constraint(equalTo: view.rightAnchor),
            listView.heightAnchor.constraint(equalToConstant: portraitHeight / 2 + Metrics.listOffset),
            listView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ]
        
        landscapeConstraints = [
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            searchPanel.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchPanel.widthAnchor.constraint(equalToConstant: landscapeHeight),
            listPanel.widthAnchor.constraint(equalToConstant: landscapeHeight),
            listView.heightAnchor.constraint(equalToConstant: landscapeHeight + Metrics.listOffset + listView.list.safeAreaInsets.bottom - Metrics.searchHeight),
            listView.widthAnchor.constraint(equalToConstant: landscapeHeight),
        ]
        
        searchPanelTop = searchPanel.topAnchor.constraint(equalTo: listView.topAnchor, constant: -Metrics.searchHeight + Metrics.listOffset)
        searchPanelTop?.priority = .defaultHigh
        searchPanelTop?.isActive = true
        
        listPanelTop = listPanel.topAnchor.constraint(equalTo: listView.topAnchor, constant: Metrics.listOffset)
        listPanelTop?.priority = .defaultHigh
        listPanelTop?.isActive = true
        
        NSLayoutConstraint.activate(sharedConstraints)
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillChangeFrameNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue ?? .zero }
            .sink { print("rect:", $0) }
            .store(in: &disposal)
        
        listView.list.publisher(for: \.contentOffset)
            .sink { offset in
                let top = min(0, offset.y + Metrics.listOffset)
                let content = max(self.listView.list.contentSize.height, self.listView.list.frame.height - Metrics.listOffset - self.listView.list.safeAreaInsets.bottom)
                let bottom = min(0, content - offset.y - self.listView.list.bounds.height + self.view.safeAreaInsets.bottom)
                let diff = top - bottom
                
                self.listView.maskingView.transform.ty = -diff
                self.listPanelTop?.constant = -diff + Metrics.listOffset
                self.view.layoutSubviews()
                
                self.searchPanelTop?.constant = -Metrics.searchHeight - (diff / 1.4) + Metrics.listOffset
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
                    self.view.layoutSubviews()
                    self.mapView.transform.ty = -diff / 10
                }, completion: nil)
                
                self.listView.list.verticalScrollIndicatorInsets.top = Metrics.panelCornerRadius - diff + Metrics.listOffset
                self.searchView.alpha = 1 - (min(100, abs(bottom)) / 100)
            }
            .store(in: &disposal)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        updateLayoutMargins()
        
        searchPanel.layer.shadowPath = CGPath(roundedRect: searchPanel.bounds, cornerWidth: Metrics.panelCornerRadius / 2, cornerHeight: Metrics.panelCornerRadius / 2, transform: nil)
        listPanel.layer.shadowPath = CGPath(roundedRect: listPanel.bounds, cornerWidth: Metrics.panelCornerRadius / 2, cornerHeight: Metrics.panelCornerRadius / 2, transform: nil)
        
        if shouldScrollToTop {
            shouldScrollToTop = false
            listView.scrollToTop()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldGoHome {
            shouldGoHome = false
            mapView.goTo(.home, delta: 5, animated: true)
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        view.setNeedsUpdateConstraints()
    }
    
    override func updateViewConstraints() {
        let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
        
        NSLayoutConstraint.deactivate(portraitConstraints + landscapeConstraints)
        NSLayoutConstraint.activate(isPortrait ? portraitConstraints : landscapeConstraints)
        
        super.updateViewConstraints()
    }
    
    func updateLayoutMargins() {
        let isPortrait = UIApplication.shared.statusBarOrientation.isPortrait
        let landscapeHeight: CGFloat = min(UIScreen.main.bounds.height, UIScreen.main.bounds.width)

        mapView.layoutMargins.left = isPortrait ? -Metrics.mapMargin : landscapeHeight - Metrics.mapMargin
        mapView.layoutMargins.right = -Metrics.mapMargin
        mapView.layoutMargins.bottom = isPortrait ? listView.bounds.height - Metrics.listOffset : 0

        mapView.layoutMarginsDidChange()
    }
    
    func dismissKeyboard() {
        searchView.textField.resignFirstResponder()
    }
}
