//
//  ViewController.swift
//  WeatherList_example
//
//  Created by Jin Wook Yang on 2023/05/04.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources


/// <#Description#>
class WeatherList : UIViewController, UITableViewDelegate {
  
    
    @IBOutlet weak var SubView: UIView!
    
    private var viewModel = WeatherViewModel()
    
    private let disposeBag = DisposeBag()
    
    lazy var tableView : UITableView = {
        let tableview = UITableView(frame: self.view.frame, style: .grouped)
        tableview.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        let nib = UINib(nibName: "WeatherCell", bundle: nil)
        tableview.register(nib, forCellReuseIdentifier: "WeatherCell")
        tableview.delegate = self
       
   
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.SubView.addSubview(tableView)
        
        
        viewModel.getSeoulWeather()
        viewModel.getLonDonWeather()
        viewModel.getCicagoWeather()
        
        viewModel.fetchListData()
        
        bindWeatherTable()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Return the height you want for the cell at the given index path
        return 70.0 // Replace with the desired height value
    }
    
    
    func bindWeatherTable() {
        
        let groupObservable = viewModel.totalList
        
        groupObservable
            .bind(to: tableView.rx.items(
                // Configure the data source
                dataSource: RxTableViewSectionedReloadDataSource<WeatherSelection>(
                    // Configure the cell
                    configureCell: { (dataSource, tableView, indexPath, item) -> UITableViewCell in
                        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
                             
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "MM-dd"
                        
                        let dateFormatter_week = DateFormatter()
                        dateFormatter_week.dateFormat = "EEEE"
                        
                        let timestamp = item.dt
                        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
                        let weatherDay = dateFormatter.string(from: date)
                        let weekday = dateFormatter_week.string(from: date)
                      
                        cell.titleDay.text = weekday + "(\(weatherDay))"
            
                        let tempMin = item.main.tempMin - 273.15
                        let tempMax = item.main.tempMax - 273.15
            
                        cell.tmpLabel.text = String(format: "Max:%.01fC   Min:%.01fC", tempMax,tempMin)
                        cell.dateLabel.text = item.weather[0].main
            
                        cell.icon.image = UIImage(named: item.weather[0].icon)
            
                        cell.textLabel?.text = ""// item.main/
                        return cell
                    },
                    // Configure the section header
                    titleForHeaderInSection: { dataSource, index in
                        return dataSource.sectionModels[index].headerTitle
                    }
                )
            ))
            .disposed(by: disposeBag) // Dispose the subscription when the view controller is deallocated
    }

}

