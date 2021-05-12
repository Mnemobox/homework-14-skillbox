//
//  LoadingDataManager.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 11.05.2021.
//

import Foundation

class loadingDataManager {
    static let shared = loadingDataManager()
    
    let vc = WeatherViewController()
    
    //    parse json with current weather
    func updateweather (completion: @escaping (WeatherData) -> Void) {
            let urlString = "http://api.openweathermap.org/data/2.5/weather?q=Moscow&units=metric&lan=ru&appid=7ab62b3d88787a70fc84d3ba416ceeed"
            let url = URL(string: urlString)!
            let session = URLSession.shared
            let task = session.dataTask(with: url) { (data, response, error) in
                guard error == nil else { print("error - \(error?.localizedDescription)")
                    return}
                do {
                    
                    let jsonData = try JSONDecoder().decode(WeatherData.self, from: data!)
                   
                    completion(jsonData)
                    self.vc.currentWeather = jsonData
                    DispatchQueue.main.async {
                        self.vc.updateView()
                    }
                }
                catch {
                    print("\(error.localizedDescription)")
                }
            }
            task.resume()
            
        }
    
    //    parsing json with forecast for our table view
    //    func updateTableViewForecast(completion: @escaping (ListW) -> Void) {

    func updateTableViewForecast(completion: @escaping (ListW) -> Void) {
        
        let urlString = "http://api.openweathermap.org/data/2.5/forecast?q=Moscow&units=metric&lan=ru&appid=7ab62b3d88787a70fc84d3ba416ceeed"
        let url = URL(string: urlString)
        let session = URLSession.shared
        let task = session.dataTask(with: url!) { (data, response, error) in
            guard error == nil else { print("\(error?.localizedDescription)")
                return }
            
            do {
                let datalist = try JSONDecoder().decode(ListW.self, from: data!)
             completion(datalist)
            }
            catch {
                print("\(error.localizedDescription)")
            }
       
        }
        
        task.resume()
    }
    
}



