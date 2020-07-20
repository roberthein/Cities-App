import Foundation
import UIKit

extension ListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCities
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListViewCell.reuseIdentifier, for: indexPath) as! ListViewCell
        let city = viewModel.city(for: indexPath)
        
        cell.title = city.name
        cell.subtitle = viewModel.subtitle(for: city)
        cell.country = city.country
        
        return cell
    }
}
