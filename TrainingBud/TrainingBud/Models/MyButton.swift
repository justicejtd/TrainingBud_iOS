//
//  MyButton.swift
//  TrainingBud
//
//  Created by Justice Dreischor on 10/04/2020.
//  Copyright © 2020 Duo Training Bud. All rights reserved.
//

import UIKit

public class MyButton: UIButton {
    var action: (() -> Void)?

    func whenButtonIsClicked(action: @escaping () -> Void) {
        self.action = action
        self.addTarget(self, action: #selector(MyButton.clicked), for: .touchUpInside)
    }

    // Button Event Handler:
    // I have not marked this as @IBAction because it is not intended to
    // be hooked up to Interface Builder
    @objc func clicked() {
        action?()
    }
    
}
