//
//  FilterPriceTableViewCell.swift
//  Price
//
//  Created by Satyabrata Das on 01/03/24.
//

import UIKit

protocol FilterCheckBoxTableViewCellDelegate {
    
}

extension FilterCheckBoxTableViewCellDelegate {

}

protocol FilterPriceTableViewCellDelegate : NSObjectProtocol {
    
    func cgFilterPriceTableViewCellDelegatePriceChange(minSelectedValue:Int , maxSelectedValue:Int)
    
}


class FilterPriceTableViewCell: UITableViewCell  {

    @IBOutlet weak var minimumPriceView: UIView!
    @IBOutlet weak var maximumPriceView: UIView!
    @IBOutlet weak var sliderCellHeader: UILabel!
    @IBOutlet  weak var rangeSliderCurrency      : TwoRangeSlider!
    @IBOutlet  weak var txtMinPrice              : UITextField!
    @IBOutlet  weak var txtMaxPrice              : UITextField!
    @IBOutlet  weak var lblLeftCurrencySymbol    : UILabel!
    @IBOutlet  weak var lblRightCurrencySymbol   : UILabel!

    var selectedMinValue : Int = 0
    var selectedMaxValue : Int = 0
    
    
    weak var  delegate   : FilterPriceTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.minimumPriceView.layer.borderWidth = 1
        self.minimumPriceView.layer.borderColor = UIColor.lightGray.cgColor
        self.maximumPriceView.layer.borderWidth = 1
        self.maximumPriceView.layer.borderColor = UIColor.lightGray.cgColor
//        self.setupSilder()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSilder(minPrice : Int?, maxPrice : Int?){
        
        guard let minPrice = minPrice, let maxPrice = maxPrice else { return }
//        self.lblLeftCurrencySymbol.text = PARegionAPI().currencySymbol
//        self.lblRightCurrencySymbol.text = PARegionAPI().currencySymbol

        
        // currency range slider
        self.rangeSliderCurrency.delegate = self
        self.rangeSliderCurrency.hideLabels = true
        
       // self.rangeSliderCurrency.selectedMinValue = 0.0
       // self.rangeSliderCurrency.selectedMaxValue = 150.0
        //self.rangeSliderCurrency.minDistance = 20.0
        //self.rangeSliderCurrency.maxDistance = 80.0
        self.rangeSliderCurrency.handleColor = .white
        self.rangeSliderCurrency.handleBorderWidth = 1
        self.rangeSliderCurrency.handleBorderColor = .black
        self.rangeSliderCurrency.handleDiameter = 20.0
        
        self.rangeSliderCurrency.delegate = self
        self.rangeSliderCurrency.minValue = CGFloat(minPrice)
        self.rangeSliderCurrency.maxValue = CGFloat(maxPrice)
        self.rangeSliderCurrency.selectedMinValue = CGFloat(minPrice)
        self.rangeSliderCurrency.selectedMaxValue = CGFloat(maxPrice)
       
        self.rangeSliderCurrency.selectedHandleDiameterMultiplier = 1.0
        self.rangeSliderCurrency.lineHeight = 2.0
//        self.rangeSliderCurrency.refresh()

    }
    

    func setPrice(minPrice : Int?, maxPrice : Int?){
        
        guard let minPrice = minPrice, let maxPrice = maxPrice else { return }
        
        self.rangeSliderCurrency.minValue = CGFloat(minPrice)//0.0
        self.rangeSliderCurrency.maxValue = CGFloat(maxPrice)
        // self.rangeSliderCurrency.selectedMinValue = CGFloat(minPrice)
        // self.rangeSliderCurrency.selectedMaxValue = CGFloat(maxPrice)
        
        
        
        
    }
    
    func setSelectedPrice(minSelectedPrice : Int?, maxSelectedPrice : Int?){
        
        guard let minPrice = minSelectedPrice, let maxPrice = maxSelectedPrice else { return }
        
        
         self.rangeSliderCurrency.selectedMinValue = CGFloat(minPrice)
         self.rangeSliderCurrency.selectedMaxValue = CGFloat(maxPrice)
         self.selectedMinValue = Int(minPrice)
         self.selectedMaxValue = Int(maxPrice)

        
         self.txtMinPrice.text = "\(minPrice)"
         self.txtMaxPrice.text = "\(maxPrice)"
        
    }
    
    func setPriceMinValue(_ minPrice : CGFloat?){
        
        let sliderMinPrice = self.rangeSliderCurrency.minValue
        guard let minPrice , sliderMinPrice...CGFloat(self.selectedMaxValue) ~= minPrice     else {
            
            self.rangeSliderCurrency.selectedMinValue = CGFloat(self.selectedMinValue)
            self.txtMinPrice.text = "\(self.selectedMinValue)"

            return
            
        }
        self.rangeSliderCurrency.selectedMinValue = CGFloat(minPrice)
        self.rangeSliderCurrency.refresh()
        self.selectedMinValue = Int(minPrice)
        self.delegate?.cgFilterPriceTableViewCellDelegatePriceChange(minSelectedValue: self.selectedMinValue, maxSelectedValue: self.selectedMaxValue)
        self.txtMinPrice.text = "\(self.selectedMinValue)"
       
        
    }
    func setPriceMaxValue(_ maxPrice : CGFloat?) {
        
        guard let maxPrice, CGFloat(self.selectedMinValue)...(self.rangeSliderCurrency.maxValue) ~= maxPrice else {
            
            self.rangeSliderCurrency.selectedMaxValue = CGFloat(self.selectedMaxValue)
            self.txtMaxPrice.text = "\(self.selectedMaxValue)"

            return
            
        }
        self.rangeSliderCurrency.selectedMaxValue = CGFloat(maxPrice)
        self.rangeSliderCurrency.refresh()
        self.selectedMaxValue = Int(maxPrice)
        self.delegate?.cgFilterPriceTableViewCellDelegatePriceChange(minSelectedValue: self.selectedMinValue, maxSelectedValue: self.selectedMaxValue)
        self.txtMaxPrice.text = "\(self.selectedMaxValue)"
        
    }

}

extension FilterPriceTableViewCell: TwoRangeSliderDelegate {

    func rangeSeekSlider(_ slider: TwoRangeSlider, didChange minValue: CGFloat, maxValue: CGFloat) {
        
        
        
        
        print("Standard slider updated. Min Value: \(minValue) Max Value: \(maxValue)")
        
        self.selectedMinValue = Int(minValue)
        self.selectedMaxValue = Int(maxValue)
        self.txtMinPrice.text = "\(self.selectedMinValue)"
        self.txtMaxPrice.text = "\(self.selectedMaxValue)"
        

    }

    func didStartTouches(in slider: TwoRangeSlider) {
        print("did start touches")
    }

    func didEndTouches(in slider: TwoRangeSlider) {
        print("did end touches")
        self.delegate?.cgFilterPriceTableViewCellDelegatePriceChange(minSelectedValue: self.selectedMinValue, maxSelectedValue: self.selectedMaxValue)
    }
}

extension FilterPriceTableViewCell: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if((textField.textInputMode?.primaryLanguage == "emoji") || (!(((textField.textInputMode?.primaryLanguage) != nil)))){
            return false
        }
        
        guard CharacterSet(charactersIn: "0123456789").isSuperset(of: CharacterSet(charactersIn: string)) else {
            return false
        }
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        self.textFieldAssign(textField)

    }
    
    
    private func textFieldAssign(_ textField : UITextField){
        
        if textField == self.txtMinPrice {
        
            if let number = NumberFormatter().number(from: textField.text ?? "0") {
                let floatMin = CGFloat(truncating: number)
                self.setPriceMinValue(floatMin)
            }
           
            
        }else if textField == self.txtMaxPrice {
            
            if let number = NumberFormatter().number(from: textField.text ?? "0") {
                let floatMax = CGFloat(truncating: number)
                self.setPriceMaxValue(floatMax)
            }
        }
        
        
    }
    
}
