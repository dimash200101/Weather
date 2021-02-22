//
//  Model.swift
//  lecture8
//
//  Created by admin on 08.02.2021.
//

import Foundation

public struct ErrorModel: Codable {
    let cod: Double
    let message: String
}

public struct Model2: Codable {
    let list: [Model]
}

public struct Model: Codable {
    let weather: [Weather]?
    let main: MainRes?
    let name: String?
    let dt_txt: String?
    let dt: Int?
    let temp: MainTemp?
    let feels_like: MainTemp?
}

struct MainTemp: Codable {
    let morn: Double?
    let night: Double?
}

struct MainRes: Codable {
    let temp: Double?
    let feels_like: Double?
}

struct Weather: Codable {
    let main: String?
    let description: String?
}


