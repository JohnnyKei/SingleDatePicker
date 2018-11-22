//
//  ViewController.swift
//  SingleDatePicker
//
//  Created by SatoKei on 2018/10/01.
//  Copyright © 2018 kei.sato. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var datePicker: SingleDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()

        datePicker.dateFormat = "M月dd日 EEE"
        datePicker.locale = Locale.current

    }


}

