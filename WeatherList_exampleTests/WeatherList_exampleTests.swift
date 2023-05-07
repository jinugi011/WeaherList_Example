//
//  WeatherList_exampleTests.swift
//  WeatherList_exampleTests
//
//  Created by Jin Wook Yang on 2023/05/07.
//

import RxSwift
import RxTest
import XCTest

@testable import WeatherList_example

final class WeatherList_exampleTests: XCTestCase {

    
    var viewModel: WeatherViewModel!
    var scheduler: ConcurrentDispatchQueueScheduler!
    var disposeBag: DisposeBag!
    var testScheduler: TestScheduler!
    
    
    override func setUp() async throws {
     
        viewModel = WeatherViewModel()
        scheduler = ConcurrentDispatchQueueScheduler(qos: .default)
        testScheduler = TestScheduler(initialClock: 0)
    }
    
    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }
    
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testapi_seoul() {
        
        let request = URLRequest(url: URL(string: API.SEOUL)!)
        let response = URLSession.shared.rx.response(request: request)
        response
            .map { response, data in
                // Use the `data` part of the tuple here
                String(data: data, encoding: .utf8)!
            }
            .subscribe(onNext:  { res in
                do {
                    let jsonString = res
                    let jsonData = jsonString.data(using: .utf8)!
                    let decoder = JSONDecoder()
                    let weatherResponse = try decoder.decode(WeatherResponse.self, from: jsonData)
                }catch {
                    XCTFail("Error: \(error)")
                }
                
            }, onError: { error in
                XCTFail("\(error.localizedDescription)")
            })
            .disposed(by: DisposeBag())
    }

    func testExample() throws {
        
        let isGetSeoulList = testScheduler.createObserver(WeatherResponse.self)
        let isGetlondonlList = testScheduler.createObserver(WeatherResponse.self)
        let isGetChicagoList = testScheduler.createObserver(WeatherResponse.self)
        
        viewModel.SeoulList
            .bind(to: isGetSeoulList)
            .disposed(by: DisposeBag())
        
        viewModel.LondonList
            .bind(to: isGetlondonlList)
            .disposed(by: DisposeBag())
        
        viewModel.ChicagoList
            .bind(to: isGetChicagoList)
            .disposed(by: DisposeBag())
        
        
        XCTAssertRecordedElements(isGetSeoulList.events, [WeatherResponse]())
        XCTAssertRecordedElements(isGetlondonlList.events, [WeatherResponse]())
        XCTAssertRecordedElements(isGetChicagoList.events, [WeatherResponse]())
    }

    func testPerformanceExample() throws {
        measure {
            
        }
    }

}
