//
//  ViewController.swift
//  MarketCapCompare
//
//  Created by Miraç Doğan on 16.06.2024.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    var pickerView = UIPickerView()
    var coinNames = [String]()
    var filteredCoinNames = [String]()
    var selectedCoin: String?

    @IBOutlet weak var coinTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerView.delegate = self
        pickerView.dataSource = self

        coinTextField.inputView = pickerView
        coinTextField.delegate = self

        // API'den coin isimlerini almak için APICaller kullanıyoruz.
        APICaller.shared.fetchCoinNames { [weak self] names in
            DispatchQueue.main.async {
                self?.coinNames = names
                self?.filteredCoinNames = names
                self?.pickerView.reloadAllComponents()
            }
        }

        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePicker))
        toolbar.setItems([doneButton], animated: false)

        coinTextField.inputAccessoryView = toolbar
    }

    // UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return filteredCoinNames.count
    }

    // UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return filteredCoinNames[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCoin = filteredCoinNames[row]
        coinTextField.text = selectedCoin
    }

    @objc func donePicker() {
        view.endEditing(true)
    }

    // UITextFieldDelegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) ?? string
        filterCoins(with: currentText)
        return true
    }

    func filterCoins(with query: String) {
        if query.isEmpty {
            filteredCoinNames = coinNames
        } else {
            filteredCoinNames = coinNames.filter { $0.lowercased().contains(query.lowercased()) }
        }
        pickerView.reloadAllComponents()
    }
}
