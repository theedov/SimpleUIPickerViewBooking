//
//  ApointmentDay.swift
//  CustomDatePicker
//
//  Created by Bogdan on 14/7/20.
//

import Foundation

struct ApointmentDay: Codable {
    let day: String
    let times: [ApointmentTime]
}
