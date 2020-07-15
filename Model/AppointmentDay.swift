//
//  ApointmentDay.swift
//  CustomDatePicker
//
//  Created by Bogdan on 14/7/20.
//

import Foundation

struct AppointmentDay: Codable {
    let day: String
    let times: [AppointmentTime]
}
