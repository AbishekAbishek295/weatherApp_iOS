//
//  ForecastModel.swift
//  WeatherForcast
//
//  Created by abishek m on 15/01/24.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

struct CurrentWeatherForcast: Codable {

  var cod     : String? = nil
  var message : Int?    = nil
  var cnt     : Int?    = nil
  var list    : [List]? = []
  var city    : City?   = City()

  enum CodingKeys: String, CodingKey {

    case cod     = "cod"
    case message = "message"
    case cnt     = "cnt"
    case list    = "list"
    case city    = "city"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

//    cod     = try values.decodeIfPresent(String.self , forKey: .cod     )
//    message = try values.decodeIfPresent(Int.self    , forKey: .message )
//    cnt     = try values.decodeIfPresent(Int.self    , forKey: .cnt     )
    list    = try values.decodeIfPresent([List].self , forKey: .list    )
    city    = try values.decodeIfPresent(City.self   , forKey: .city    )
 
  }

  init() {

  }

}
struct City: Codable {
    var id: Int?
    var name: String?
    var coord: Coord?
    var country: String?
    var population: Int?
    var timezone: Int?
    var sunrise: Int?
    var sunset: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case coord
        case country
        case population
        case timezone
        case sunrise
        case sunset
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        coord = try values.decodeIfPresent(Coord.self, forKey: .coord)
        country = try values.decodeIfPresent(String.self, forKey: .country)
        population = try values.decodeIfPresent(Int.self, forKey: .population)
        timezone = try values.decodeIfPresent(Int.self, forKey: .timezone)
        sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise)
        sunset = try values.decodeIfPresent(Int.self, forKey: .sunset)
    }
    init() {
  
    }
}

struct Coord: Codable {
    var lat: Double?
    var lon: Double?

    enum CodingKeys: String, CodingKey {
        case lat
        case lon
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        lat = try values.decodeIfPresent(Double.self, forKey: .lat)
        lon = try values.decodeIfPresent(Double.self, forKey: .lon)
    }
    init() {
  
    }
}


struct List: Codable {

  var dt         : Int?       = nil
  var main       : Main?      = Main()
  var weather    : [Weather]? = []
  var clouds     : Clouds?    = Clouds()
  var wind       : Wind?      = Wind()
  var visibility : Int?       = nil
  var pop        : Double?       = nil
  var sys        : Sys?       = Sys()
  var dtTxt      : String?    = nil

  enum CodingKeys: String, CodingKey {

    case dt         = "dt"
    case main       = "main"
    case weather    = "weather"
    case clouds     = "clouds"
    case wind       = "wind"
    case visibility = "visibility"
    case pop        = "pop"
    case sys        = "sys"
    case dtTxt      = "dt_txt"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    dt         = try values.decodeIfPresent(Int.self       , forKey: .dt         )
    main       = try values.decodeIfPresent(Main.self      , forKey: .main       )
    weather    = try values.decodeIfPresent([Weather].self , forKey: .weather    )
    clouds     = try values.decodeIfPresent(Clouds.self    , forKey: .clouds     )
    wind       = try values.decodeIfPresent(Wind.self      , forKey: .wind       )
    visibility = try values.decodeIfPresent(Int.self       , forKey: .visibility )
    pop        = try values.decodeIfPresent(Double.self       , forKey: .pop        )
    sys        = try values.decodeIfPresent(Sys.self       , forKey: .sys        )
    dtTxt      = try values.decodeIfPresent(String.self    , forKey: .dtTxt      )
 
  }

  init() {

  }

}
struct Clouds: Codable {

  var all : Int? = nil

  enum CodingKeys: String, CodingKey {

    case all = "all"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    all = try values.decodeIfPresent(Int.self , forKey: .all )
 
  }

  init() {

  }

}
struct Main: Codable {

  var temp      : Double? = nil
  var feelsLike : Double? = nil
  var tempMin   : Double? = nil
  var tempMax   : Double? = nil
  var pressure  : Int?    = nil
  var seaLevel  : Int?    = nil
  var grndLevel : Int?    = nil
  var humidity  : Int?    = nil
  var tempKf    : Double? = nil

  enum CodingKeys: String, CodingKey {

    case temp      = "temp"
    case feelsLike = "feels_like"
    case tempMin   = "temp_min"
    case tempMax   = "temp_max"
    case pressure  = "pressure"
    case seaLevel  = "sea_level"
    case grndLevel = "grnd_level"
    case humidity  = "humidity"
    case tempKf    = "temp_kf"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    temp      = try values.decodeIfPresent(Double.self , forKey: .temp      )
    feelsLike = try values.decodeIfPresent(Double.self , forKey: .feelsLike )
    tempMin   = try values.decodeIfPresent(Double.self , forKey: .tempMin   )
    tempMax   = try values.decodeIfPresent(Double.self , forKey: .tempMax   )
    pressure  = try values.decodeIfPresent(Int.self    , forKey: .pressure  )
    seaLevel  = try values.decodeIfPresent(Int.self    , forKey: .seaLevel  )
    grndLevel = try values.decodeIfPresent(Int.self    , forKey: .grndLevel )
    humidity  = try values.decodeIfPresent(Int.self    , forKey: .humidity  )
    tempKf    = try values.decodeIfPresent(Double.self , forKey: .tempKf    )
 
  }

  init() {

  }

}
struct Sys: Codable {

  var pod : String? = nil

  enum CodingKeys: String, CodingKey {

    case pod = "pod"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    pod = try values.decodeIfPresent(String.self , forKey: .pod )
 
  }

  init() {

  }

}
struct Weather: Codable {

  var id          : Int?    = nil
  var main        : String? = nil
  var description : String? = nil
  var icon        : String? = nil

  enum CodingKeys: String, CodingKey {

    case id          = "id"
    case main        = "main"
    case description = "description"
    case icon        = "icon"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    id          = try values.decodeIfPresent(Int.self    , forKey: .id          )
    main        = try values.decodeIfPresent(String.self , forKey: .main        )
    description = try values.decodeIfPresent(String.self , forKey: .description )
    icon        = try values.decodeIfPresent(String.self , forKey: .icon        )
 
  }

  init() {

  }

}
struct Wind: Codable {

  var speed : Double? = nil
  var deg   : Int?    = nil
  var gust  : Double? = nil

  enum CodingKeys: String, CodingKey {

    case speed = "speed"
    case deg   = "deg"
    case gust  = "gust"
  
  }

  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    speed = try values.decodeIfPresent(Double.self , forKey: .speed )
    deg   = try values.decodeIfPresent(Int.self    , forKey: .deg   )
    gust  = try values.decodeIfPresent(Double.self , forKey: .gust  )
 
  }

  init() {

  }

}
enum WeatherAPIError: Error {
    case unknown
    case apiError(String)
    case jsonDecodingError(DecodingError)
    case networkError(Error)
}

