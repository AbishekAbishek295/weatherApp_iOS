//
//  ApiServices.swift
//  WeatherForcast
//
//  Created by abishek m on 17/01/24.
//

import Foundation


open class NetworkApi {
    
    // MARK: - CurrentForcastApiCalls
    
    class func CurrentWeatherForecast(latitude: Double, longitude: Double, completion: @escaping (Result<CurrentWeatherForcast, WeatherAPIError>) -> Void) {
        
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=995f5822e0eb678ae2034e84d1f78210"
        let url = URL(string: urlString)!
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.networkError(error)))
                return
            }
            
            if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                completion(.failure(.apiError("Invalid response from server: \(response.statusCode)")))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let weatherData = try decoder.decode(CurrentWeatherForcast.self, from: data!)
                completion(.success(weatherData))
            } catch let error as DecodingError {
                completion(.failure(.jsonDecodingError(error)))
            } catch {
                completion(.failure(.unknown))
            }
        }
        task.resume()
    }
    
    // MARK: - CurrentWeatherApiCalls

    class func CurrentweatherCondition(latitude: Double, longitude: Double, completion: @escaping (CurrentWeather1) -> Void)  {
        if let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=995f5822e0eb678ae2034e84d1f78210") {
            // Create a URLSession instance
            let session = URLSession.shared
            
            // Create a data task
            let task = session.dataTask(with: url) { (data, response, error) in
                do {
                    // Check for errors
                    if let error = error {
                        throw error
                    }
                    
                    // Check if data is available
                    guard let data = data else {
                        print("Error: No data received.")
                        return
                    }
                    
                    print(url)
                    debugPrint(data)
                    // Parse and process the data
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON Data: \(json)")
                    
                    let decoder = JSONDecoder()
                    let weatherData = try decoder.decode(CurrentWeather1.self, from: data)
                    completion(weatherData)
                    
                } catch {
                    print("Error: \(error.localizedDescription)")
                }
            }
            task.resume()
        } else {
            print("Error: Unable to create URL.")
        }
        
    }
    
    // MARK: - ForcastApiCalls
     
    class func fetchWeatherData(city: String, completion: @escaping (Result<CurrentWeatherForcast, WeatherAPIError>) -> Void) {
         
         let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(city)&appid=995f5822e0eb678ae2034e84d1f78210"
         let url = URL(string: urlString)!
         let request = URLRequest(url: url)

         let task = URLSession.shared.dataTask(with: request) { data, response, error in
             if let error = error {
                 completion(.failure(.networkError(error)))
                 return
             }

             if let response = response as? HTTPURLResponse, response.statusCode != 200 {
                 completion(.failure(.apiError("Invalid response from server: \(response.statusCode)")))
                 return
             }

             do {
                 let decoder = JSONDecoder()
                 let weatherData = try decoder.decode(CurrentWeatherForcast.self, from: data!)
                 completion(.success(weatherData))
             } catch let error as DecodingError {
                 completion(.failure(.jsonDecodingError(error)))
             } catch {
                 completion(.failure(.unknown))
             }
         }
         task.resume()
     }
}
