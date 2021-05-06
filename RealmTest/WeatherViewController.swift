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
    
    
    
//    parse json with current weather
    func updateweather () {
        let urlString = "http://api.openweathermap.org/data/2.5/weather?q=Moscow&units=metric&lan=ru&appid=7ab62b3d88787a70fc84d3ba416ceeed"
        let url = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            guard error == nil else { print("error - \(error?.localizedDescription)")
                return}
            do {
                
                let jsonData = try JSONDecoder().decode(WeatherData.self, from: data!)
                self.currentWeather = jsonData
                DispatchQueue.main.async {
                    self.updateView()
                }
            }
            catch {
                print("\(error.localizedDescription)")
            }
        }
        task.resume()
        
    }
    
//    parsing json with forecast for our table view
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
    
    func loadDataToRealm() {
        updateTableViewForecast { (result) in
            DispatchQueue.main.async {
                self.parsingWeather = result.list
                self.parsingCity = result.city!
                
                self.clearRealm()
                self.takeFromRealm.removeAll()
                self.main.removeAll()
                self.cityRealm.removeAll()
                
                for _ in 1 ... result.list.count {
                    let name = CityRealm()
                    name.name = result.city?.name
                    self.cityRealm.append(name)
                    self.saveCityToRealm(name)
                }
            
              
                
                for el in self.parsingWeather {
                    let weather = WeatherDataRealm()
                    let main = MainRealm()
                    
                    
                    main.temp = el.main.temp!.description
                    main.feels_like = el.main.feels_like!.description
                    self.main.append(main)
                    self.saveAbotherDataToRealm(main)
                    
                    weather.dt_txt = el.dt_txt
                    self.saveDataToRealm(weather)
                    self.takeFromRealm.append(weather)
                  
                }
               
                self.weatherTableView.reloadData()
                
            }
        }
         
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        updateweather()
        createLabels()
        
        createTableView()
        weatherTableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: "forecastCell")
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
      
        loadDataToRealm()
     
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
    
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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


