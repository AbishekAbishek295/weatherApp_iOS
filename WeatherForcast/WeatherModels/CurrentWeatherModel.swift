//
//  CurrentWeatherModel.swift
//  WeatherForcast
//
//  Created by abishek m on 15/01/24.
//

import Foundation

struct CurrentWeather1: Codable {
    let coord: Coord1?
    let weather: [Weather1]?
    let base: String?
    let main: Main1?
    let visibility: Int?
    let wind: Wind1?
    let clouds: Clouds1?
    let dt: Int?
    let sys: Sys1?
    let timezone, id: Int?
    let name: String?
    let cod: Int?
}

// MARK: - Clouds
struct Clouds1: Codable {
    let all: Int?
}

// MARK: - Coord
struct Coord1: Codable {
    let lon, lat: Double?
}

// MARK: - Main
struct Main1: Codable {
    let temp, feelsLike, tempMin, tempMax: Double?
    let pressure, humidity: Int?

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys1: Codable {
    let type, id: Int?
    let country: String?
    let sunrise, sunset: Int?
}

// MARK: - Weather
struct Weather1: Codable {
    let id: Int?
    let main, description, icon: String?
}

// MARK: - Wind
struct Wind1: Codable {
    let speed: Double?
    let deg: Int?
}



