//
//  Logger.swift
//  WeatherList_example
//
//  Created by Jin Wook Yang on 2023/05/05.
//

import Foundation
import os

let logger = os.Logger(subsystem: "com.tsunaGoAir", category: "DataChannel")

let logflag = true
public enum Logger {
   
    
    public static func data(_ string: String) {
        if logflag {
            debugPrint("Data:\(string)")
        }
    }
    
    public static func ui(_ string: String) {
        if logflag {
            debugPrint("UI:\(string)")
        }
    }
  
}
