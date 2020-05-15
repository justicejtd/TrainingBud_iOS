//
//  PickerViewSports.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 16/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

class PickerViewSports: UIPickerView, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 10
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "test"
    }
}
