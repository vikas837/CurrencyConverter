//
//  ConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 25/03/22.
//

import Foundation
import ANLoader
import VACountrySelector

protocol ConverterViewModelInput {
    func fetchCurrencies(input:ConverterInput)
    func updateSelectedRange(range:CountryRange)
    func getUpdatedCurrency(name:String, code:String, isUpdated:Bool)
}

protocol ConveterViewModelOutput {
    var updateView: Observable<Bool?> { get }
    var errorHandling: Observable<String> { get }
    var updateBaseView: Observable<Country?> { get }
    var updateToView: Observable<Country?> { get }
    func getToCurrencyAmount(amount:Double) -> Double
}

protocol ConverterViewModel: ConverterViewModelInput, ConveterViewModelOutput {}


class CurrencyConverterViewModel:ConverterViewModel{
   
    var updateView: Observable<Bool?> = Observable(false)
    var updateBaseView: Observable<Country?> = Observable(nil)
    var updateToView: Observable<Country?> = Observable(nil)
    weak var service: CurrencyServiceProtocol?
    var converterModel:Converter?
    private var countryRange:CountryRange = .base
    private var converterInput:ConverterInput?
    private var updatedCountry:Country?
    let errorHandling: Observable<String> = Observable("")
    
    init(service:CurrencyServiceProtocol = CurrencyService.shared){
        self.service = service
    }

    // MARK: - OUTPUT
    
    private func handle(error: ErrorResult) {
        var message = ""
        switch error {
        case .network:
            message = ErrorMessages.APINotSupportedError
        case .parser:
            message = ErrorMessages.ParsingError
        case .custom:
            message = ErrorMessages.OtherError
        }
        self.errorHandling.value = message
    }
    
    /*
     Extract info from locale based on the country code and the picker object
    */
    func getInfoFromCountryCode(code:String) -> (String?, UIImage?){
        guard let currencyCode =  Locale.currency[code]?.code else {
            print("failed to extract currency Code")
            return (nil, nil)
        }
        let image = ADCountryPicker().getFlag(countryCode:code)
        return(currencyCode, image)
    }
    
    //Calculate the amount locally
     func getToCurrencyAmount(amount:Double) -> Double{
        return (converterModel?.rates.first?.rate ?? 1) * amount
    }
    
    /*Generate Input to make an API call
     -based on country seletion it generates an input
     */
    private func getConverterInput(range:CountryRange, country: Country) -> ConverterInput?{
        if range == .base {
            converterInput = ConverterInput(baseCurrency:country.code ?? "", toCurrencies: converterInput?.toCurrencies ?? "")
        }else{
            converterInput = ConverterInput(baseCurrency:converterInput?.baseCurrency ?? "", toCurrencies: country.code ?? "")
        }
        return converterInput
    }
    
    //Update both view base country and to country view
    private func updateViews(country:Country?){
        guard let countryDetail = country else {
            print("Country details are not properly added to update view")
            return
        }
        if countryRange == .base{
            updateBaseView.value = countryDetail
        }else if countryRange == .to {
            updateToView.value = countryDetail
        }
    }
}


// MARK: - INPUT. View event methods

extension CurrencyConverterViewModel {
    
    func fetchCurrencies(input:ConverterInput){
        guard let service = service else {
            self.errorHandling.value = "Missing service"
            return
        }
        
            ANLoader.showLoading("", disableUI: true)
        service.fetchConverter(input: input) { (result) in
            DispatchQueue.main.async {
                ANLoader.hide()
                switch result {
                case .success(let converter):
                    self.converterModel = converter
                    self.updateView.value = true
                    self.updateViews(country: self.updatedCountry)
                case .failure(let error) :
                    self.handle(error:error)
                }
            }
        }
    }
    
    /*get updated currency
     -decide to make an API call
     */
    func getUpdatedCurrency(name: String, code: String, isUpdated:Bool = true) {
        let info = self.getInfoFromCountryCode(code: code)
        if let currency = info.0, let image = info.1 {
            let country = Country(title:name, code: currency, flag: image, range: countryRange)
            updatedCountry = country
            if !isUpdated{
                updateViews(country: updatedCountry)
            }
            if let input = getConverterInput(range: self.countryRange, country: country), !input.baseCurrency.isEmpty, !input.toCurrencies.isEmpty {
                if input.baseCurrency == input.toCurrencies {
                    self.errorHandling.value = ErrorMessages.SameCurrenciesError
                    return
                }
                self.fetchCurrencies(input:input)
            }
        }
    }
    
    //Update range of the country weather base or to country
    func updateSelectedRange(range:CountryRange){
        self.countryRange = range
    }
}
