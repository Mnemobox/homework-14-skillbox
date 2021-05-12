//
//  WeatherViewController.swift
//  RealmTest
//
//  Created by Юрий Мирзамагомедов on 28.04.2021.
//

import UIKit

class WeatherViewController: UIViewController {

  
    
    let weatherTableView = UITableView()
    let cityLabel = UILabel()
    let tempLabel = UILabel()
    let feelsLikeLabel = UILabel()
    let labelWidth: CGFloat = 200
    
    
//    make all the labels for representing current weather on th upp side of the screen
    func createLabels () {
        cityLabel.frame = CGRect(x: view.frame.width/2 - labelWidth/2, y: view.frame.height*0.2, width: labelWidth, height: 50)
        tempLabel.frame = CGRect(x: view.frame.width/2 - labelWidth/2, y: view.frame.height*0.3, width: labelWidth, height: 50)
        feelsLikeLabel.frame = CGRect(x: view.frame.width/2 - labelWidth/2, y: view.frame.height*0.4, width: labelWidth, height: 50)
        
        for v in [cityLabel, tempLabel, feelsLikeLabel] {
            view.addSubview(v)
            v.textAlignment = .center
            v.numberOfLines = 0
            
        }
        cityLabel.font = .boldSystemFont(ofSize: 50)
        tempLabel.font = .italicSystemFont(ofSize: 50)
    }
    
//    make table view for representing forecast for a several days down the controller
    func createTableView() {
        weatherTableView.frame = CGRect(x: 0, y: view.frame.height*0.5, width: view.frame.width, height: view.frame.height*0.5)
        view.addSubview(weatherTableView)
       
    }
    
//    updating labels for the current weather from parsing function
    func updateView() {
        cityLabel.text = currentWeather.name
        tempLabel.text = currentWeather.main.temp.description + " º"
        feelsLikeLabel.text = "ощущается как " + currentWeather.main.feels_like.description + " º"
//        saving current weather data in UserDefaults after parsing is done
        Persistance.shared.cityName = cityLabel.text
        Persistance.shared.currentTemp = tempLabel.text
        Persistance.shared.feelsLike = feelsLikeLabel.text
        
    }
//    variables for the parsing
    var currentWeather = WeatherData()
   
    var parsingWeather:[WeatherData5] = [] // массив для промежуточного хранения даты после парсинга
    var takeFromRealm: [WeatherDataRealm] = [] // массив для выгрузки и хранения данных из реалма и заполнения таблицы
    var main: [MainRealm] = [] // массив для выгрузки вложенных данных из структуры json
    var parsingCity: City = City()
    var cityRealm: [CityRealm] = []
    
//   loading parsed data from json
    func loadDataToRealm() {
        loadingDataManager.shared.updateTableViewForecast { (result) in
            DispatchQueue.main.async {
                self.parsingWeather = result.list
                self.parsingCity = result.city!
                
             
                Persistance.shared.clearRealm()
                self.takeFromRealm.removeAll()
                self.main.removeAll()
                self.cityRealm.removeAll()
                
                for _ in 1 ... result.list.count {
                    let name = CityRealm()
                    name.name = result.city?.name
                    self.cityRealm.append(name)
                    Persistance.shared.saveCityToRealm(name)
                }
            
              
                
                for el in self.parsingWeather {
                    let weather = WeatherDataRealm()
                    let main = MainRealm()
                    
                    
                    main.temp = el.main.temp!.description
                    main.feels_like = el.main.feels_like!.description
                    self.main.append(main)
                    Persistance.shared.saveAbotherDataToRealm(main)
                    
                    weather.dt_txt = el.dt_txt
                    Persistance.shared.saveDataToRealm(weather)
                    self.takeFromRealm.append(weather)
                  
                }
               
                self.weatherTableView.reloadData()
                
            }
        }
         
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        loadingDataManager.shared.updateweather { (currentWeather) in
            DispatchQueue.main.async {
                self.currentWeather = currentWeather
                self.updateView()
            }
        }
    
        
        createLabels()
        
        createTableView()
        weatherTableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: "forecastCell")
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
      
        loadDataToRealm()
     
//        loading data from realm to fill table view while the new data is being loaded from json
        let weather = uiRealm.objects(WeatherDataRealm.self)
        for el in weather {
            let loadedelement = WeatherDataRealm()
            loadedelement.dt_txt = el.dt_txt
            takeFromRealm.append(loadedelement)
        }
        let mainEl = uiRealm.objects(MainRealm.self)
        for el in mainEl {
            let loadedElement = MainRealm()
            loadedElement.temp = el.temp.description
            loadedElement.feels_like = el.feels_like.description
            main.append(loadedElement)
        }
        
        let cityName = uiRealm.objects(CityRealm.self)
        for el in cityName {
            let loadedCity = CityRealm()
            loadedCity.name = el.name
            cityRealm.append(loadedCity)
        }
      
        
//        we load the latest data out of UserDefaults before the new api request is done
        cityLabel.text = Persistance.shared.cityName
        tempLabel.text = Persistance.shared.currentTemp
        feelsLikeLabel.text = Persistance.shared.feelsLike
    }
    

}

extension WeatherViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return takeFromRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "forecastCell", for: indexPath) as! ForecastTableViewCell
   
        
        cell.nameLabel.text = cityRealm[indexPath.row].name
        cell.dailyTempLabel.text = main[indexPath.row].temp + " º"
        cell.dataLabel.text = takeFromRealm[indexPath.row].dt_txt
        
//        cell.nameLabel.text = city[indexPath.row].city?.name
        cell.layer.borderWidth = 0.5
        

        return cell
    }
    
    
}


