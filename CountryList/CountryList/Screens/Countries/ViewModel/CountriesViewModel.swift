//
//  CountriesViewModel.swift
//  CountryList
//
//  Created by Jonathan Hoche on 03/05/2021.
//

import Foundation

protocol CountriesViewModelDelegate: class {
    func completedFetchingCountries()
    func updated(orderBy: CountriesViewModel.OrderBy)
    func goToDetailed(country: Country, borders: [Country])
    func failedFetchingCountries()
}

class CountriesViewModel {
    
    private var orderBy = OrderBy.name()
    weak var delegate: CountriesViewModelDelegate?
    var orderedCountries = [Country]()
    
    func getCountries() {
        let apiService = APIService()
        
        apiService.getCountries { [weak self] (countries, error) in
            if let countries = countries {
                self?.setOrderedCountries(with: countries)
                self?.delegate?.completedFetchingCountries()
            } else {
                self?.delegate?.failedFetchingCountries()
            }
        }
    }
    
    func update(orderBy: OrderBy) {
        self.orderBy = orderBy
        setOrderedCountries(with: orderedCountries)
        delegate?.updated(orderBy: orderBy)
    }
    
    func countrySelected(at index: Int) {
        guard let country = orderedCountries.element(at: index) else {
            return
        }
        delegate?.goToDetailed(country: country, borders: getBorderingCountries(to: country))
    }
    
    private func getBorderingCountries(to country: Country) -> [Country] {
        var borderingCountries = [Country]()
        
        country.borders.forEach { (alpha3Code) in
            if let country = orderedCountries.filter({ $0.alpha3Code.elementsEqual(alpha3Code) }).first {
                borderingCountries.append(country)
            }
        }
        
        return borderingCountries
    }
    
    private func setOrderedCountries(with countries: [Country]) {
        var sortedCountries: [Country]
        
        switch orderBy {
        case .name(ascending: let ascending):
            if ascending {
                sortedCountries = countries.sorted(by: { $0.name < $1.name } )
            } else {
                sortedCountries = countries.sorted(by: { $0.name > $1.name } )
            }
        case .area(ascending: let ascending):
            if ascending {
                sortedCountries = countries.sorted(by: { $0.area ?? 0 < $1.area ?? 0 } )
            } else {
                sortedCountries = countries.sorted(by: { $0.area ?? 0 > $1.area ?? 0 } )
            }
        }
        
        orderedCountries = sortedCountries
    }
}

extension CountriesViewModel {
    
    enum OrderBy {
        static var allCases: [OrderBy] {
            return [.name(ascending: true), .name(ascending: false), .area(ascending: true), .area(ascending: false)]
        }
        
        case name(ascending: Bool = true)
        case area(ascending: Bool)
        
        var string: String {
            switch self {
            case .name(_):
                return "Name"
            case .area(_):
                return "Area"
            }
        }
        
        var selectionString: String {
            return isAscending ? string + " - ascending" : string + " - descending"
        }
        
        var isAscending: Bool {
            switch self {
            case .name(ascending: let ascending), .area(ascending: let ascending):
                return ascending
            }
        }
    }
}

private extension Array {
    
    func element(at index: Int) -> Element? {
        if self.indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
