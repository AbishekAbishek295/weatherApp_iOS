//
//  ViewController.swift
//  WeatherForcast
//
//  Created by abishek m on 14/01/24.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate {
    
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var cloudLbl: UILabel!
    @IBOutlet weak var latAndLongLbl: UILabel!
    @IBOutlet weak var backgroundImg: UIImageView!
    @IBOutlet weak var bottomButton: UIButton!
    
    @IBOutlet weak var weatherTableView: UITableView!
    
    var cityName = ""
    var weatherModel: CurrentWeather1?
    var dayArray = [List]()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    var latitude: Double?
    var longitude: Double?
    
    let mf = MeasurementFormatter()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        
        backgroundImg.image = UIImage(named: "backGround")
        bottomButton.setImage(UIImage(named: "ThreeDotsIcon"), for: .normal)
        
        // Register cell
        weatherTableView.register(weatherTableViewCell.nib(), forCellReuseIdentifier: weatherTableViewCell.identifier)
       
        //TableViewRadius
        self.weatherTableView.layer.cornerRadius = 15.0
        
        self.setUpLocation()
        
    }
    
    // MARK: - Locations
    
    func setUpLocation(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if !locations.isEmpty, currentLocation == nil{
            currentLocation = locations.first
            let lat = currentLocation?.coordinate.latitude
            let long = currentLocation?.coordinate.longitude
            
            //CurrentWeather
            NetworkApi.CurrentweatherCondition(latitude: lat ?? 0.0, longitude: long ?? 0.0) { result in
                self.weatherModel = result
                DispatchQueue.main.async {
                    self.Location(self.weatherModel!)
                }
            }
            
            //CurrentForcast
   
            NetworkApi.CurrentWeatherForecast(latitude: lat ?? 0.0, longitude: long ?? 0.0) { value in
                switch value {
                case .success(let weatherData):
                    self.cityName = weatherData.city?.name ?? ""
                    if let days = weatherData.list,days.count>0 {
                        var prevDay = ""
                        days.forEach { day in
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let date = Date(timeIntervalSince1970: TimeInterval(day.dt ?? 0))
                            dateFormatter.dateFormat = "EEEE"
                            let dayOfWeekString = dateFormatter.string(from: date)
                            if dayOfWeekString != prevDay,self.dayArray.count<5 {
                                prevDay = dayOfWeekString
                                self.dayArray.append(day)
                            }
                            
                        }
                    }
                    DispatchQueue.main.async {
                        self.weatherTableView.reloadData()
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
            
        }
    }
    func requestWeatherForLocation(){
        guard let currentLocation = currentLocation else {
            return
        }
        let lat = currentLocation.coordinate.latitude
        let long = currentLocation.coordinate.longitude
        
        latitude = lat
        longitude = long
        
        
        print("\(lat) | \(long)")
    }
    
    
    
    
    
    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherTableViewCell.identifier, for: indexPath) as! weatherTableViewCell
        cell.selectionStyle = .none
        if let timestamp = dayArray[indexPath.row].dt{
            let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            dateFormatter.dateFormat = "EEEE"
            print("date ->", date)
            let dayOfWeekString = dateFormatter.string(from: date)
            print("day ->", dayOfWeekString)
            cell.dayLabel.text = dayOfWeekString
            cell.dayLabel.textColor = .white
            cell.dayLabel.font = UIFont.boldSystemFont(ofSize: 18)
            
            let temperatureMin = dayArray[indexPath.row].main?.tempMin ?? 0
            print("temp -> ", temperatureMin)
            let celsiusMin = convertTemp(temp: temperatureMin, from: .kelvin, to: .celsius)
            cell.lowTempLabel.text = celsiusMin
            cell.lowTempLabel.textColor = .white
            cell.lowTempLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            let temperatureMax = dayArray[indexPath.row].main?.tempMax ?? 0
            let celsiusMax = convertTemp(temp: temperatureMax, from: .kelvin, to: .celsius)
            cell.highTempLabel.text = celsiusMax
            cell.highTempLabel.textColor = .white
            cell.highTempLabel.font = UIFont.boldSystemFont(ofSize: 20)
            
            if let weatherDescription = dayArray[indexPath.row].weather?.first?.description {
                cell.descriptions.text = weatherDescription
                cell.descriptions.textColor = .white
                cell.descriptions.font = UIFont.systemFont(ofSize: 15)
                cell.iconImage.image = UIImage(named: "Sun")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.width/2))
        headerView.layer.masksToBounds = true
        headerView.layer.cornerRadius = 5.0
        let foreCastLbl = UILabel(frame: CGRect(x: 5, y: 5, width: view.frame.size.width, height: headerView.frame.size.height/10))
        if cityName.count > 0{
            foreCastLbl.text = "5-DAY FORECAST - \(cityName)"
            headerView.backgroundColor = .lightGray
            
        }
        foreCastLbl.textColor = .white
        
        headerView.addSubview(foreCastLbl)
        
        return headerView
    }

    // MARK: - Function
    
    @IBAction func bottomButtonAction(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
        self.present(newViewController, animated: true, completion: nil)
        
    }
    
    func Location(_ weatherModel: CurrentWeather1){
        print(weatherModel)
        locationLbl.text = "My Location"
        locationLbl.textAlignment = .center
        locationLbl.textColor = .white
        locationLbl.font = UIFont.boldSystemFont(ofSize: 25)
        
        
        cityNameLbl.text = weatherModel.name
        cityNameLbl.textAlignment = .center
        cityNameLbl.textColor = .white
        cityNameLbl.font = UIFont.boldSystemFont(ofSize: 15)
        
        let temperature = weatherModel.main?.temp ?? 0
        let celsius = convertTemp(temp: temperature, from: .kelvin, to: .celsius) // 18°C
        temperatureLbl.text = celsius
        temperatureLbl.textAlignment = .center
        temperatureLbl.textColor = .white
        temperatureLbl.font = UIFont.boldSystemFont(ofSize: 55)
        
        cloudLbl.text = weatherModel.weather?.first?.main
        cloudLbl.textAlignment = .center
        cloudLbl.textColor = .white
        cloudLbl.font = UIFont.boldSystemFont(ofSize: 20)
        
        let location = CLLocation(latitude: weatherModel.coord?.lat ?? 0, longitude: weatherModel.coord?.lon ?? 0)
        latAndLongLbl.text = "\("H:\(location.latitude)")  \("L:\(location.longitude)")"
        latAndLongLbl.textAlignment = .center
        latAndLongLbl.textColor = .white
        latAndLongLbl.font = UIFont.boldSystemFont(ofSize: 20)
    }
    
    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
    }
    
}

//BinaryFloating

extension BinaryFloatingPoint {
    var dms: (degrees: Int, minutes: Int, seconds: Int) {
        var seconds = Int(self * 3600)
        let degrees = seconds / 3600
        seconds = abs(seconds % 3600)
        return (degrees, seconds / 60, seconds % 60)
    }
}

extension CLLocation {
    var dms: String { latitude + " " + longitude }
    var latitude: String {
        let (degrees, minutes, seconds) = coordinate.latitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "N" : "S")
    }
    var longitude: String {
        let (degrees, minutes, seconds) = coordinate.longitude.dms
        return String(format: "%d°%d'%d\"%@", abs(degrees), minutes, seconds, degrees >= 0 ? "E" : "W")
    }
}
