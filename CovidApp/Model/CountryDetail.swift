//
//  CountryDetail.swift
//  CovidApp
//
//  Created by ic iMac on 16.06.20 : 25.
//  Copyright © 2020 interactive curiosity. All rights reserved.
//

import Foundation

struct CountryDetail: Decodable {
    var Confirmed: Int
    var Active: Int
    var Lat: String
    var Lon: String
}
