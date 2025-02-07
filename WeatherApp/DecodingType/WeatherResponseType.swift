//
//  WeatherResponseType.swift
//  WeatherApp
//
//  Created by Lalana Thanthirigama on 2024-11-04.
//

import Foundation
import UIKit


struct WeatherResponseType: Codable {
    let location: Location?
    let current: Current?
}

struct Current: Codable {
    let lastUpdatedEpoch: Int?
    let lastUpdated: String?
    let tempC: Double?
    let tempF:Double?
    let isDay: Int?
    let condition: Condition?
    let windMph: Double?
    let windKph, windDegree: Double?
    let windDir: String?
    let pressureMB: Double?
    let pressureIn: Double?
    let precipMm, precipIn, humidity, cloud: Double?
    let feelslikeC: Double?
    let feelslikeF, windchillC, windchillF, heatindexC: Double?
    let heatindexF, dewpointC, dewpointF: Double?
    let visKM, visMiles, uv: Double?
    let gustMph, gustKph: Double?

    enum CodingKeys: String, CodingKey {
        case lastUpdatedEpoch = "last_updated_epoch"
        case lastUpdated = "last_updated"
        case tempC = "temp_c"
        case tempF = "temp_f"
        case isDay = "is_day"
        case condition
        case windMph = "wind_mph"
        case windKph = "wind_kph"
        case windDegree = "wind_degree"
        case windDir = "wind_dir"
        case pressureMB = "pressure_mb"
        case pressureIn = "pressure_in"
        case precipMm = "precip_mm"
        case precipIn = "precip_in"
        case humidity, cloud
        case feelslikeC = "feelslike_c"
        case feelslikeF = "feelslike_f"
        case windchillC = "windchill_c"
        case windchillF = "windchill_f"
        case heatindexC = "heatindex_c"
        case heatindexF = "heatindex_f"
        case dewpointC = "dewpoint_c"
        case dewpointF = "dewpoint_f"
        case visKM = "vis_km"
        case visMiles = "vis_miles"
        case uv
        case gustMph = "gust_mph"
        case gustKph = "gust_kph"
    }
}

struct Condition: Codable {
    let text, icon: String?
    let code: Int?
}

struct Location: Codable {
    let name, region, country: String?
    let lat, lon: Double?
    let tzID: String?
    let localtimeEpoch: Int?
    let localtime: String?

    enum CodingKeys: String, CodingKey {
        case name, region, country, lat, lon
        case tzID = "tz_id"
        case localtimeEpoch = "localtime_epoch"
        case localtime
    }
}

struct WeatherCondition {
    var backgroundImage: UIImage?
    var icon: String // SF Symbol icon name
    var description: String
}

