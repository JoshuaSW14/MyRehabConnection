//
//  Clinic.swift
//  MyRehabConnection
//
//  Created by Joshua Symons-Webb on 2025-11-23.
//

import Foundation

struct Clinic: Codable {
    let name: String
    let address1: String
    let address2: String
    let city: String
    let provinceState: String
    let postalZip: String
    let phone: String
    let fax: String
    let email: String
    let website: String
    let logo: String
    let appointment: String
    let active: String
    let fbPageId: String
    let social: [SocialLink]
    let hours: String
    
    enum CodingKeys: String, CodingKey {
        case name, address1, address2, city
        case provinceState = "province_state"
        case postalZip = "postal_zip"
        case phone, fax, email, website, logo, appointment, active
        case fbPageId = "fb_page_id"
        case social, hours
    }
}

struct SocialLink: Codable {
    let type: String
    let url: String
}
