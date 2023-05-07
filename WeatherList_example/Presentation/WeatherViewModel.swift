//
//  WeatherViewModel.swift
//  WeatherList_example
//
//  Created by Jin Wook Yang on 2023/05/05.
//

import Foundation
import RxRelay
import RxSwift
import RxAlamofire


protocol WeatherListViewModelType {
    var SeoulList : PublishSubject<WeatherResponse>{ get }
    var LondonList : PublishSubject<WeatherResponse>{ get }
    var ChicagoList : PublishSubject<WeatherResponse>{ get }
}


final class WeatherViewModel : WeatherListViewModelType {
   
    var SeoulList =  PublishSubject<WeatherResponse>()
    var LondonList =  PublishSubject<WeatherResponse>()
    var ChicagoList = PublishSubject<WeatherResponse>()
    
    
    var totalList = BehaviorRelay(value: [WeatherSelection]())
  
    
    let disposeBag = DisposeBag()

    init() {
       
        
    }
   
    /// 서울 날씨정보 받기 (16개 5일치)
    func getSeoulWeather() {
        
        let request = URLRequest(url: URL(string: API.SEOUL)!)
        let response = URLSession.shared.rx.response(request: request)
        response
            .map { response, data in
                // Use the `data` part of the tuple here
                String(data: data, encoding: .utf8)!
            }
            .subscribe(onNext:  { [weak self] res in
                do {
                    let jsonString = res
                    let jsonData = jsonString.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)
                    self?.SeoulList.onNext(weatherResponse)
                }catch {
                    Logger.data("Error: \(error)")
                }
                
            }, onError: { error in
                Logger.data("\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    ///런던 날씨정보 받기 (16개 5일치)
    func getLonDonWeather() {
        
        let request = URLRequest(url: URL(string: API.LONDON)!)
        let response = URLSession.shared.rx.response(request: request)
        response
            .map { response, data in
                // Use the `data` part of the tuple here
                String(data: data, encoding: .utf8)!
            }
            .subscribe(onNext: { [weak self] res in
                do {
                    let jsonString = res
                    let jsonData = jsonString.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)
                   
                    self?.LondonList.onNext(weatherResponse)
                }catch {
                    Logger.data("Error: \(error)")
                }
                
            }, onError: { error in
                Logger.data("\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    //
    func getCicagoWeather() {
        
        let request = URLRequest(url: URL(string: API.CHICAGO)!)
        let response = URLSession.shared.rx.response(request: request)
        response
            .map { response, data in
                // Use the `data` part of the tuple here
                String(data: data, encoding: .utf8)!
            }
            .subscribe(onNext: { [weak self] res in
                do {
                    let jsonString = res
                    let jsonData = jsonString.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)
                    self?.ChicagoList.onNext(weatherResponse)
                }catch {
                    Logger.data("Error: \(error)")
                }
                
            }, onError: { error in
                Logger.data("\(error.localizedDescription)")
            })
            .disposed(by: disposeBag)
    }
    
    
    /// 받은데이터 변환
    func fetchListData () {
        
        Observable.combineLatest(SeoulList, LondonList, ChicagoList)
            .subscribe(onNext: { [weak self] seoul, london, chigo in
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM-dd"
                let tempDate = Date()
                var temp_seoul = dateFormatter.string(from: tempDate)
                var temp_London = dateFormatter.string(from: tempDate)
                var temp_Chicago = dateFormatter.string(from: tempDate)
                
                let seoulList = seoul.list.filter {value in
                    let timestamp = value.dt
                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                    let weatherDay = dateFormatter.string(from: date)
                    
                    if weatherDay != temp_seoul {
                        temp_seoul = weatherDay
                        return true
                    }else {
                        return false
                    }
                }
                
                let londonList = london.list.filter {value in
                    let timestamp = value.dt
                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                    let weatherDay = dateFormatter.string(from: date)
                    
                    if weatherDay != temp_London {
                        temp_London = weatherDay
                        return true
                    }else {
                        return false
                    }
                }
                
                let chigoList = chigo.list.filter {value in
                    let timestamp = value.dt
                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                    let weatherDay = dateFormatter.string(from: date)
                    
                    if weatherDay != temp_Chicago {
                        temp_Chicago = weatherDay
                        return true
                    }else {
                        return false
                    }
                }
                
                let selectWeather = [
                    WeatherSelection(headerTitle: seoul.city.name, items: seoulList),
                    WeatherSelection(headerTitle: london.city.name, items: londonList),
                    WeatherSelection(headerTitle: chigo.city.name, items: chigoList)
                ]
                
                self?.totalList.accept(selectWeather)
                
            })
            .disposed(by: disposeBag)
        
        
    }
    
    
    
}




