//
//  String.swift
//  GoCheap
//
//  Created by Nguyễn Quang on 1/14/21.
//

import Foundation
import UIKit

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
