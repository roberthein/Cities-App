import Foundation
import UIKit
import MapKit

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let top = min(0, scrollView.contentOffset.y + Metrics.listOffset)
        let content = max(scrollView.contentSize.height, scrollView.frame.height - Metrics.listOffset - scrollView.safeAreaInsets.bottom)
        let bottom = min(0, content - scrollView.contentOffset.y - scrollView.bounds.height + view.safeAreaInsets.bottom)
        let diff = top - bottom
        
        listView.maskingView.transform.ty = -diff
        listPanelTop?.constant = -diff + Metrics.listOffset
        view.layoutSubviews()
        
        searchPanelTop?.constant = -Metrics.searchHeight - (diff / 1.4) + Metrics.listOffset
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.curveEaseOut, .beginFromCurrentState, .allowUserInteraction], animations: {
            self.view.layoutSubviews()
            self.mapView.transform.ty = -diff / 10
        }, completion: nil)
        
        scrollView.scrollIndicatorInsets.top = Metrics.panelCornerRadius - diff + Metrics.listOffset
        searchView.alpha = 1 - (min(100, abs(bottom)) / 100)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y < -Metrics.listOffset, scrollView.panGestureRecognizer.velocity(in: scrollView.panGestureRecognizer.view).y > 500 {
            dismissKeyboard()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = viewModel.city(for: indexPath)
        let annotation = viewModel.annotation(for: city)
        
        mapView.goTo(annotation)
        dismissKeyboard()
    }
}
