//
//  ConverterView.swift
//  CurrencyConverter
//
//  Created by Vikas Ahuja on 25/03/22.
//

import UIKit


protocol ConverterViewProtocol:AnyObject {
    func openCountryList(range:CountryRange)
}

class ConverterView: UIView {
    @IBOutlet private var contentView: UIView!
    @IBOutlet private weak var baseCountryImage: UIImageView!
    @IBOutlet private weak var baseCountryLabel: UILabel!
    @IBOutlet private weak var toCountryLabel: UILabel!
    @IBOutlet private weak var toCountryImageView: UIImageView!
    @IBOutlet private weak var baseCountryButton: UIButton!
    @IBOutlet private weak var toCountryButton: UIButton!
    @IBOutlet private weak var inputTextField: UITextField!
    @IBOutlet private weak var toAmountLabel: UILabel!
    @IBOutlet weak var baseSymbolLabel: UILabel!
    @IBOutlet weak var toSymbolLabel: UILabel!
    let enteredAmount: Observable<Double> = Observable(0.0)
    
    weak var delegate: ConverterViewProtocol?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        Bundle.main.loadNibNamed(XIBNames.ConverterView, owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        setupLabelTap()
        self.accessibilityIdentifier = AccessibilityIdentifier.ConverterView
    }
    
    func updateBaseCountryView(model:ConverterModel){
        guard let baseCountry = model.baseCountryDescription else {
            print("failed to extract base country information")
            return
        }
        baseCountryLabel.text = baseCountry.title
        baseSymbolLabel.text = baseCountry.code
        if let flagImage = baseCountry.flag {
            baseCountryImage.image = flagImage
        }
    }
    
    /*setup guestures to tap the label
     -add guesture on base country label
     - add guesture on to country label
     */
    func setupLabelTap() {
        let baseCountryLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.baseCountryLabelTapped(_:)))
        self.baseCountryLabel.isUserInteractionEnabled = true
        self.baseCountryLabel.addGestureRecognizer(baseCountryLabelTap)
        
        let toCountryLabelTap = UITapGestureRecognizer(target: self, action: #selector(self.toCountryLabelTapped(_:)))
        self.toCountryLabel.isUserInteractionEnabled = true
        self.toCountryLabel.addGestureRecognizer(toCountryLabelTap)
    }
    
    @objc func baseCountryLabelTapped(_ sender: UITapGestureRecognizer) {
        delegate?.openCountryList(range: .base)
    }
    
    @objc func toCountryLabelTapped(_ sender: UITapGestureRecognizer) {
        delegate?.openCountryList(range: .to)
    }
    
    //Update country view
    func updateToCountryView(model:ConverterModel){
        guard let toCountry = model.toCountryDescription else {
            print("failed to extract base country information")
            return
        }
        toCountryLabel.text = toCountry.title
        toSymbolLabel.text = toCountry.code
        if let flagImage = toCountry.flag {
            toCountryImageView.image = flagImage
        }
    }
    
    func updateToCurrencyAmount(amount:Double){
        toAmountLabel.text = String(format: "%.2f", amount)
    }
    
    @IBAction func openCountryList(_ sender: UIButton) {
        switch sender {
        case baseCountryButton:
            delegate?.openCountryList(range: .base)
        case toCountryButton:
            delegate?.openCountryList(range: .to)
        default:
            break
        }
    }
}

// MARK: - UITextField Delegates

extension ConverterView : UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let textFieldString = textField.text, let swtRange = Range(range, in: textFieldString) {
            
            let fullString = textFieldString.replacingCharacters(in: swtRange, with: string)
            self.enteredAmount.value = Double(fullString) ?? 0.0
        }
        return true
    }
}
