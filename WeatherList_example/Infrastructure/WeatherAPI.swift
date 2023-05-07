//
//  WeatherAPI.swift
//  WeatherList_example
//
//  Created by Jin Wook Yang on 2023/05/05.
//

import Foundation

//https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid=37de8022f6e78caddae3b1c1a7d42347
//api.openweathermap.org/data/2.5/forecast/daily?lat={lat}&lon={lon}&cnt={cnt}&appid={API key}
struct API {
    static let SEOUL     = "https://api.openweathermap.org/data/2.5/forecast?q=seoul&appid=e1d11c2609db6bff619062c00dac47f5"
    static let LONDON    = "https://api.openweathermap.org/data/2.5/forecast?q=london&appid=e1d11c2609db6bff619062c00dac47f5"
    static let CHICAGO   = "https://api.openweathermap.org/data/2.5/forecast?q=chicago&appid=e1d11c2609db6bff619062c00dac47f5"
}




