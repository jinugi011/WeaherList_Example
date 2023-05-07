//
//  WeatherModel.swift
//  WeatherList_example
//
//  Created by Jin Wook Yang on 2023/05/04.
//


import Foundation
import Differentiator
import RxDataSources

struct WeatherResponse: Codable {
    let cod: String
    let message: Double
    let cnt: Int
    let list: [Weather]
    let city: City
}

struct Weather: Codable {
    let dt: Int
    let main: Main
    let weather: [WeatherData]
    let clouds: Clouds
    let wind: Wind
    let visibility: Int
    let pop: Double
    let rain: Rain?
    let sys: Sys
    let dtTxt: String
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, clouds, wind, visibility, pop, rain, sys
        case dtTxt = "dt_txt"
    }
}

struct Main: Codable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let seaLevel: Int
    let groundLevel: Int
    let humidity: Int
    let tempKf: Double
    
    enum CodingKeys: String, CodingKey {
        case temp, feelsLike = "feels_like", tempMin = "temp_min", tempMax = "temp_max", pressure, seaLevel = "sea_level", groundLevel = "grnd_level", humidity, tempKf = "temp_kf"
    }
}

struct WeatherData: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Clouds: Codable {
    let all: Int
}

struct Wind: Codable {
    let speed: Double
    let deg: Int
    let gust: Double
}

struct Rain: Codable {
    let threeHour: Double
    
    enum CodingKeys: String, CodingKey {
        case threeHour = "3h"
    }
}

struct Sys: Codable {
    let pod: String
}

struct City: Codable {
    let id: Int
    let name: String
    let coord: Coordinates
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
}

struct Coordinates: Codable {
    let lat: Double
    let lon: Double
}


//struct MyModel {
//    var weather : Weather
//}

extension Weather: IdentifiableType,Equatable {
    static func == (lhs: Weather, rhs: Weather) -> Bool {
        return false
    }
    
    var identity: String {
        return UUID().uuidString
    }
}

struct WeatherSelection {
    var headerTitle: String
    var items: [Weather]
}

extension WeatherSelection: AnimatableSectionModelType {
    typealias Item = Weather
    
    var identity: String {
        return headerTitle
    }
    
    init(original: WeatherSelection, items: [Weather]) {
        self = original
        self.items = items
    }
}








