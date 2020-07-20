import Foundation
import UIKit

extension ListViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboard()
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let textFieldText = textField.text, let range = Range(range, in: textFieldText) else {
            return true
        }
        
        let query = textFieldText.replacingCharacters(in: range, with: string)
        
        viewModel.filter(query) { [weak self] time in
            guard let _self = self else { return }
            print(_self.viewModel.timeString(for: time))
            _self.listView.list.reloadData()
            _self.listView.scrollToTop()
        }
        
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        viewModel.filter("") { [weak self] time in
            guard let _self = self else { return }
            _self.listView.list.reloadData()
            _self.mapView.removeAnnotations(_self.mapView.annotations)
            _self.listView.scrollToTop()
        }
        
        return true
    }
}
