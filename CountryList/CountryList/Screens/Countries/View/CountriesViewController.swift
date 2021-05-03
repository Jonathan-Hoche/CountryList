//
//  CountriesViewController.swift
//  CountryList
//
//  Created by Jonathan Hoche on 03/05/2021.
//

import UIKit

class CountriesViewController: UIViewController {
    
    @IBOutlet weak private var countriesTableView: UITableView!
    @IBOutlet weak private var orderLabel: UILabel!
    @IBOutlet weak private var orderImageView: UIImageView!
    
    let viewModel = CountriesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        countriesTableView.register(cellType: CountryTableViewCell.self)
        viewModel.delegate = self
        viewModel.getCountries()
    }
    
    @IBAction private func orderByButtonPressed(_ sender: Any) {
        let actionSheet = UIAlertController(title: "Sort By", message: "Please Select an Option", preferredStyle: .actionSheet)
        CountriesViewModel.OrderBy.allCases.forEach { orderBy in
            actionSheet.addAction(UIAlertAction(title: orderBy.selectionString, style: .default , handler:{ (UIAlertAction) in
                self.viewModel.update(orderBy: orderBy)
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        
        self.present(actionSheet, animated: true)
    }
}

extension CountriesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.orderedCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CountryTableViewCell.self)
        cell.configure(with: viewModel.orderedCountries[indexPath.row])
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}

extension CountriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.countrySelected(at: indexPath.row)
    }
}

extension CountriesViewController: CountriesViewModelDelegate {
    
    func completedFetchingCountries() {
        countriesTableView.reloadData()
    }
    
    func updated(orderBy: CountriesViewModel.OrderBy) {
        orderLabel.text = orderBy.string
        orderImageView.image = UIImage(systemName: orderBy.isAscending ? "chevron.up" : "chevron.down")
        countriesTableView.reloadData()
    }
    
    func goToDetailed(country: Country, borders: [Country]) {
        guard let countryVC = storyboard?.instantiateViewController(identifier: "CountryViewController", creator: { coder in
                return CountryViewController(coder: coder, viewModel: CountryViewModel(country: country, borderingCountries: borders))
            }) else {
                fatalError("Failed to load CountryViewController from storyboard.")
        }
       
        self.navigationController?.pushViewController(countryVC, animated: true)
    }
    
    func failedFetchingCountries() {
        let alert =  UIAlertController(title: "Fetching Countries failed",
                                       message: "You may try again.",
                                       preferredStyle: .alert)
        let closeActionButton = UIAlertAction(title: "Try Again", style: .default) { _ in
            self.viewModel.getCountries()
        }
        alert.addAction(closeActionButton)
        self.present(alert, animated: true)
    }
}
