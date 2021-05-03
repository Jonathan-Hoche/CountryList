//
//  CountryViewController.swift
//  CountryList
//
//  Created by Jonathan Hoche on 03/05/2021.
//

import UIKit

class CountryViewController: UIViewController {
    
    @IBOutlet private weak var bordersTableView: UITableView!
    
    private let viewModel: CountryViewModel
    
    init?(coder: NSCoder, viewModel: CountryViewModel) {
        self.viewModel = viewModel
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with a CountryViewModel.")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.country.name
        bordersTableView.register(cellType: CountryTableViewCell.self)
        bordersTableView.reloadData()
    }
}

extension CountryViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.borderingCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: CountryTableViewCell.self)
        cell.configure(with: viewModel.borderingCountries[indexPath.row])
        return cell
    }
}
