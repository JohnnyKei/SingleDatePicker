//
//  SingleDatePicker.swift
//  SingleDatePicker
//
//  Created by SatoKei on 2018/10/01.
//  Copyright © 2018 kei.sato. All rights reserved.
//

import UIKit

@IBDesignable
class SingleDatePicker: UIView {

    var calendar: Calendar = Calendar(identifier: .gregorian) {
        didSet {
            needsReload = true
            setNeedsDisplay()
        }
    }

    var date: Date {
        get { return _date }
        set { setDate(newValue, animated: false) }
    }

    var locale: Locale? = Locale(identifier: "ja_JP") {
        didSet {
            needsReload = true
            setNeedsDisplay()
        }
    }

    var timeZone: TimeZone? {
        didSet {
            needsReload = true
            setNeedsDisplay()
        }
    }

    var maximumDate: Date {
        didSet {
            needsReload = true
            setNeedsDisplay()
        }
    }

    var minimumDate: Date {
        didSet {
            needsReload = true
            setNeedsDisplay()
        }
    }

    var dateFormat: String? = "M月dd日 EEE"{
        didSet {
            needsReload = true
            setNeedsDisplay()
        }
    }

    private var _date: Date
    private let rowHeight: CGFloat = 34.0
    private let pickerView = UIPickerView()
    private var dateStrings: [String] = []
    private var dates: [Date] = []
    private var needsReload: Bool = true

    override init(frame: CGRect) {
        let now = Date()
        _date = calendar.startOfDay(for: now)
        minimumDate = calendar.date(byAdding: .month, value: -1, to: now)!
        maximumDate = calendar.date(byAdding: .month, value: 1, to: now)!
        super.init(frame: frame)
        initSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        let now = Date()
        _date = calendar.startOfDay(for: now)
        minimumDate = calendar.date(byAdding: .month, value: -1, to: now)!
        maximumDate = calendar.date(byAdding: .month, value: 1, to: now)!
        super.init(coder: aDecoder)
        initSubviews()
    }

    private func initSubviews() {
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.delegate = self
        pickerView.dataSource = self
        addSubview(pickerView)
        NSLayoutConstraint.activate([
            pickerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            pickerView.topAnchor.constraint(equalTo: topAnchor),
            pickerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])

        calculate()
        setDate(Date(), animated: false)
    }


    func setDate(_ date: Date, animated: Bool) {
        _date = date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        if let dateFormat = dateFormat {
            dateFormatter.dateFormat = dateFormat
        } else {
            dateFormatter.dateStyle = .medium
        }

        let dateString: String = {
            if calendar.isDateInToday(date) {
                dateFormatter.doesRelativeDateFormatting = true
                dateFormatter.dateStyle = .medium
            } else {
                dateFormatter.doesRelativeDateFormatting = false
                if let dateFormat = dateFormat {
                    dateFormatter.dateFormat = dateFormat
                } else {
                    dateFormatter.dateStyle = .medium
                }
            }
            return dateFormatter.string(from: date)
        }()
        if let index = dateStrings.index(of: dateString) {
            pickerView.selectRow(index, inComponent: 0, animated: animated)
        }
    }

    private func calculate() {
        dateStrings.removeAll()
        dates.removeAll()
        let dateComponents = calendar.dateComponents([.day], from: minimumDate, to: maximumDate)
        let diff = dateComponents.day!
        let dateFormatter = DateFormatter()
        dateFormatter.locale = locale
        dateFormatter.calendar = calendar
        dateFormatter.timeZone = timeZone
        for i in 0..<diff {
            let date = calendar.date(byAdding: .day, value: i, to: minimumDate)!
            let dateString: String = {
                if calendar.isDateInToday(date) {
                    dateFormatter.doesRelativeDateFormatting = true
                    dateFormatter.dateStyle = .medium
                } else {
                    dateFormatter.doesRelativeDateFormatting = false
                    if let dateFormat = dateFormat {
                        dateFormatter.dateFormat = dateFormat
                    } else {
                        dateFormatter.dateStyle = .medium
                    }
                }
                return dateFormatter.string(from: date)
            }()
            dateStrings.append(dateString)
            dates.append(date)
        }
        pickerView.reloadAllComponents()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if needsReload {
            needsReload = false
            calculate()
        }
    }

    override var intrinsicContentSize: CGSize {
        return pickerView.intrinsicContentSize
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        return pickerView.sizeThatFits(size)
    }


}

extension SingleDatePicker: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dateStrings.count
    }
}

extension SingleDatePicker: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row < dateStrings.count {
            return dateStrings[row]
        } else {
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return rowHeight
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row < dates.count {
            let date = dates[row]
            self.date = date
        }
    }
}
