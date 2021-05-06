//
//  weatherModel.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 28.04.2021.
//

import Foundation
// для отображения текущей погоды в Москве
struct Weather: Codable {
    var id: Int
    var main: String
    var description: String
    var icon: String
}

struct Main: Codable {
    var temp: Double = 0.0
    var feels_like: Double = 0.0
}

struct WeatherData: Codable {
    var weather: [Weather] = []
    var main: Main = Main()
    var name: String = ""
}


// для прогноза на 5 дней

struct Weather5: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
}

struct Main5: Codable {
    var temp: Double?
    var feels_like: Double?
}

struct WeatherData5: Codable {
    var dt_txt: String?
    var weather: [Weather5] = []
    var main: Main5 = Main5()
    
    
}

struct  City: Codable {
    var name: String?
}
struct ListW: Codable {
    var list: [WeatherData5] = []
    var city: City?
}
