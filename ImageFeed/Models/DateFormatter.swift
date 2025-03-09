//
//  DateFormatter.swift
//  ImageFeed
//
//  Created by Pavel Seleznev on 3/2/25.
//

import Foundation

extension DateFormatter {
    static let dateFormatterDefault: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "dd MMMM yyyy"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        return dateFormatter
    }()
    
    static let dateFormatterISO: ISO8601DateFormatter = {
        let dateFormatterISO = ISO8601DateFormatter()
        return dateFormatterISO
    }()
    
    func date(from dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        return DateFormatter.dateFormatterISO.date(from: dateString)
    }
}
