//
//  Task.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 24.04.2021.
//

import Foundation
import RealmSwift

class TaskList: Object {
    @objc dynamic var name: String = String()
    @objc dynamic var createdAt = NSDate()
  var tasks = List<Task>()
}


class Task: Object {
    @objc dynamic var name: String = String()
    @objc dynamic var createdAt = NSDate()
    @objc dynamic var notes = ""
    @objc dynamic var isCompleted = false
}


// structure for saving objects in realm after being parsed from json


class WeatherRealm: Object, Codable {
    @objc dynamic var id: String?
    @objc dynamic var main: String?
    @objc dynamic var descriptionR: String?
    @objc dynamic var icon: String?
    
   public required convenience init(from decoder: Decoder) throws {
        self.init()
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try container.decode(String.self, forKey: .id)
    self.main = try container.decode(String.self, forKey: .main)
    self.descriptionR = try container.decode(String.self, forKey: .descriptionR)
    self.icon = try container.decode(String.self, forKey: .icon)
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case descriptionR = "descriptionR"
        case icon = "icon"
    }
}

class MainRealm: Object, Codable {
    @objc dynamic var temp: String = ""
    @objc dynamic var feels_like: String = ""
    
    enum MCodingKeys: String, CodingKey {
        case temp
        case feels_like
    }
    
    public required convenience init(from decoder: Decoder) throws {
         self.init()
     let container = try decoder.container(keyedBy: MCodingKeys.self)
        self.temp = try container.decode(String.self, forKey: .temp)
        self.feels_like = try container.decode(String.self, forKey: .feels_like)
     }
}

class WeatherDataRealm: Object, Codable {
    @objc dynamic var dt_txt: String?
    var weather = List<WeatherRealm>()
    var main: MainRealm?
    
    enum WCodingKeys: String, CodingKey {
        case dt_txt
        case weather
        case main
    }
    
    public required convenience init(from decoder: Decoder) throws {
         self.init()
     let container = try decoder.container(keyedBy: WCodingKeys.self)
        self.dt_txt = try container.decode(String.self, forKey: .dt_txt)
        self.main = try container.decode(MainRealm.self, forKey: .main)
        self.weather = try container.decode(List<WeatherRealm>.self, forKey: .weather)
     }
    
}

class  CityRealm: Object, Codable {
    @objc dynamic var name: String?
    
    enum CCodingKeys: String, CodingKey {
    case name
    }
    
    public required convenience init(from decoder: Decoder) throws {
         self.init()
     let container = try decoder.container(keyedBy: CCodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
   
     }
}
class ListRealm: Object, Codable {
     var list = List<WeatherDataRealm>()
   var city: CityRealm?
    
    enum LCodingKeys: String, CodingKey {
        case list
        case city
    }
    
    public required convenience init(from decoder: Decoder) throws {
         self.init()
     let container = try decoder.container(keyedBy: LCodingKeys.self)
        self.list = try container.decode(List<WeatherDataRealm>.self, forKey: .list)
        self.city = try container.decode(CityRealm.self, forKey: .city)
     }
    
}



class Persistance {
    
    static let shared = Persistance()
    
    private let kUserNameKey: String = "Persistance.kUserNameKey"
    private let kUserSecondNameKey: String = "Persistance.kUserSecondNameKey"

    var userName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserNameKey) }
        get { return UserDefaults.standard.string(forKey: kUserNameKey) }
    }
    
    var secondUserName: String? {
        set { UserDefaults.standard.set(newValue, forKey: kUserSecondNameKey) }
        get { return UserDefaults.standard.string(forKey: kUserSecondNameKey) }
    }
    
    private let kCityNameKey: String = "Persistance.kCityNameKey"
    private let kCurrentTempKey: String = "Persistance.kCurrentTempKey"
    private let kFeelsLikeKey: String = "Persistance.kFeelsLikeKey"
    
    var cityName: String? {
        set {UserDefaults.standard.set(newValue, forKey: "Persistance.kCityNameKey")}
        get {return UserDefaults.standard.string(forKey: "Persistance.kCityNameKey")}
    }
    
    var currentTemp: String? {
        set { UserDefaults.standard.set(newValue, forKey: "Persistance.kCurrentTempKey")}
        get { return UserDefaults.standard.string(forKey: "Persistance.kCurrentTempKey")}
    }
    
    var feelsLike: String? {
        set { UserDefaults.standard.set(newValue, forKey: "Persistance.kFeelsLikeKey")}
        get { return UserDefaults.standard.string(forKey: "Persistance.kFeelsLikeKey")}
    }
    
    func clearRealm() {
        try! uiRealm.write {
            uiRealm.deleteAll()
        }
    }
    
    func saveDataToRealm(_ weather: WeatherDataRealm) {
        try! uiRealm.write {
            uiRealm.add(weather)
        }
    }
    
    func saveAbotherDataToRealm(_ weather: MainRealm) {
        try! uiRealm.write{
            uiRealm.add(weather)
        }
    }
    
    func saveCityToRealm(_ city: CityRealm) {
        try! uiRealm.write {
            uiRealm.add(city)
        }
    }
    
    
    
    
    
}
