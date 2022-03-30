//
//  CurrrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 25/03/22.
//

import UIKit
import VACountrySelector

class ConverterViewController: UIViewController {
    
    @IBOutlet private var converterView: ConverterView!
    private var selectedCountry:Country?
    lazy var viewModel : ConverterViewModel = {
        let viewModel = CurrencyConverterViewModel()
        return viewModel
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        bind(to: converterView)
        setupViews()
    }
    
    private func setupViews() {
        converterView.delegate = self
        initializeConverterView()
    }
    
    // MARK: - Private Methods
    
    private func bind(to viewModel: ConverterViewModel) {
        viewModel.updateView.observe(on: self) { [weak self] _ in self?.updateToCurrencyAmount(amount: 1) }
        viewModel.errorHandling.observe(on: self) { [weak self] (error) in
            //self.resetPreviousCountry()
            self?.displayErrorAlert(error)
        }
        viewModel.updateBaseView.observe(on: self) { [weak self] (country) in
            self?.updateCurrencyView(country: country)
        }
        viewModel.updateToView.observe(on: self) { [weak self] (country) in
            self?.updateCurrencyView(country: country)
        }
    }
    
    private func bind(to view: ConverterView) {
        converterView.enteredAmount.observe(on: self){ [weak self] (amount) in self?.updateToCurrencyAmount(amount: amount)
        }
    }
    
    //initialise view to default countries and currencies
    func initializeConverterView(){
        viewModel.updateSelectedRange(range: .base)
        viewModel.getUpdatedCurrency(name: DefaultSelections.BaseCountryName, code: DefaultSelections.BaseCountryCode, isUpdated: false)
        
        viewModel.updateSelectedRange(range: .to)
        viewModel.getUpdatedCurrency(name: DefaultSelections.ToCountryName, code: DefaultSelections.ToCountryCode, isUpdated: false)
    }
    
    //update to currency amount by getting the updated data from viewmodel
    private func updateToCurrencyAmount(amount:Double) {
        converterView.updateToCurrencyAmount(amount: viewModel.getToCurrencyAmount(amount: amount))
    }
    
    //display alert in case of api failure
    private func displayErrorAlert(_ error: String){
        guard !error.isEmpty else { return }
        let controller = UIAlertController(title: ConverterConstants.ErrorOccurred, message: error, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: ConverterConstants.Close, style: .cancel, handler: nil))
        self.present(controller, animated: true, completion: nil)
    }
}

/*protocol to open the countries picker
 -receive event from the view
 -open country picker
 */
extension ConverterViewController: ConverterViewProtocol {
    func openCountryList(range:CountryRange){
        let picker = ADCountryPicker(style: .grouped)
        picker.delegate = self
        picker.defaultCountryCode = DefaultSelections.BaseCountryCode
        viewModel.updateSelectedRange(range: range)
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
    }
}


/* Receive event on country selection
 - initiate API call after receiving selected values
 - Update views based on user selection
 */
extension ConverterViewController: ADCountryPickerDelegate {
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        _ = picker.navigationController?.popToRootViewController(animated: true)
        viewModel.getUpdatedCurrency(name: name, code: code, isUpdated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
   
    /*
    - Update view of base currency and to currency
    - country: the country need to update
    - range: based on the range selection
     */
    private func updateCurrencyView(country: Country?){
        guard let countryDetail = country else{
            return
        }
        if countryDetail.range == .base {
            converterView.updateBaseCountryView(model: ConverterModel(baseCountryDescription:countryDetail))
        }else{
            converterView.updateToCountryView(model: ConverterModel(toCountryDescription:countryDetail))
        }
    }
    
}



