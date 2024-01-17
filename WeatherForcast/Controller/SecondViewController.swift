//
//  SecondViewController.swift
//  WeatherForcast
//
//  Created by abishek m on 14/01/24.
//

import UIKit

class SecondViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var weatherLbl: UILabel!
    @IBOutlet weak var weatherTableView: UITableView!
    @IBOutlet weak var backgroundImg: UIImageView!
     var dayArray = [List]()
    var searchedCity = ""

    var SearchBarValue:String!
    var searchActive : Bool = false

    let mf = MeasurementFormatter()
    
    @IBOutlet weak var searchBarTextField: UISearchBar!

    override func viewDidLoad() {
        super.viewDidLoad()

       
        
      self.searchBarTextField.delegate = self
        
        weatherLbl.text = "Weather"
        weatherLbl.textColor = .white
        weatherLbl.font = UIFont.boldSystemFont(ofSize: 40)
        
        backgroundImg.image = UIImage(named: "backGround")
        
        searchBarTextField.placeholder = "Search for a city"
        
        weatherTableView.delegate = self
        weatherTableView.dataSource = self
        // Register cell
        weatherTableView.register(weatherTableViewCell.nib(), forCellReuseIdentifier: weatherTableViewCell.identifier)
    }
    

    // MARK: - SearchBar
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
        searchBarTextField.text = nil
        searchBar.resignFirstResponder()
        searchBar.showsCancelButton = false
        weatherTableView.reloadData()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let location = searchBarTextField.text else { return }
        
        // Clear existing data before fetching new data
        dayArray.removeAll()

        NetworkApi.fetchWeatherData(city: location) { result in
            switch result {
            case .success(let weatherData):
                self.searchedCity = weatherData.city?.name ?? ""
                if let days = weatherData.list,days.count>0 {
                    var prevDay = ""
                    days.forEach { day in
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        if let date = dateFormatter.date(from: day.dtTxt ?? "") {
                            dateFormatter.dateFormat = "EEEE"
                            let dayOfWeekString = dateFormatter.string(from: date)
                            if dayOfWeekString != prevDay,self.dayArray.count<5 {
                                prevDay = dayOfWeekString
                                self.dayArray.append(day)
                            }
                        }
                    }
                }
                DispatchQueue.main.async {
                    self.weatherTableView.reloadData()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "", message: "Invalid Location", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
//                    print("error ->", error)
                }
            }
        }

        // Dismiss the keyboard and clear the search bar text
        searchBar.resignFirstResponder()
        searchBar.text = ""
        searchBar.showsCancelButton = false
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        return true
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // Clear existing data when text is empty
            dayArray.removeAll()
            searchBar.showsCancelButton = false
            searchActive = false
            weatherTableView.reloadData()
        } else {
            searchActive = true
            searchBar.showsCancelButton = true
        }
    }

    // MARK: - TableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayArray.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: weatherTableViewCell.identifier, for: indexPath) as! weatherTableViewCell
        cell.selectionStyle = .none
        if let timestamp = dayArray[indexPath.row].dtTxt {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            if let date = dateFormatter.date(from: timestamp) {
                print("date1 ->", date)
                // Use the current calendar for the user's preferred localization
                // Calculate the next date
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
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width/2, height: view.frame.size.width/2))
        headerView.layer.masksToBounds = true
        headerView.layer.cornerRadius = 5.0
        
        let foreCastLbl = UILabel(frame: CGRect(x: 10, y: 10, width: view.frame.size.width-20, height: headerView.frame.size.height/15))
        if searchedCity.count > 0{
            foreCastLbl.text = "5-DAY FORECAST - \(searchedCity)"
            headerView.backgroundColor = .lightGray
        }
        foreCastLbl.textColor = .white
        headerView.addSubview(foreCastLbl)
        
        return headerView
    }

    func convertTemp(temp: Double, from inputTempType: UnitTemperature, to outputTempType: UnitTemperature) -> String {
        mf.numberFormatter.maximumFractionDigits = 0
        mf.unitOptions = .providedUnit
        let input = Measurement(value: temp, unit: inputTempType)
        let output = input.converted(to: outputTempType)
        return mf.string(from: output)
      }
}
