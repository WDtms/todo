//
//  DateUtils.swift
//  Todo
//
//  Created by Aleksey Shepelev on 24.08.2024.
//

import Foundation

enum DateUtils {
    static func convertDateToDdMmYyyy(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
