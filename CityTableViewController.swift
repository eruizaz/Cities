//
//  CityTableViewController.swift
//  Cities
//
//  Created by g216 DIT UPM on 16/12/14.
//  Copyright (c) 2014 g216 DIT UPM. All rights reserved.
//

import UIKit
import MapKit

private let OPEN_WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"

class CityTableViewController: UITableViewController {
    
    var celda: miCeldaTableViewCell!
    lazy var citiesModel = CitiesModel()
    
    // Las ciudades a mostrar en la tabla.
    var cities: [String]!
    
    // Fichero donde salvo los nombres de las ciudades.
    private let SAVED_FILENAME = "cities.plist"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadCities()
        
        self.title = "Ciudades";
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        
        return citiesModel.cities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        celda = tableView.dequeueReusableCellWithIdentifier("Cities", forIndexPath: indexPath) as miCeldaTableViewCell
        
        
        downloadWeather(toString(citiesModel.cities[indexPath.row]), indexPath: indexPath)
        
        return celda
    }

    
    private func downloadWeather(city: String, indexPath: NSIndexPath) {
        let queue = dispatch_queue_create("Cola de descargas", DISPATCH_QUEUE_SERIAL)
        dispatch_async(queue, {
            let str = OPEN_WEATHER_URL + "?q="+city+"&units=metric&lang=sp"
            
            // Mostrar indicador de actividad de red
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            
            if let strEscaped = str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
                
                let url = NSURL(string: strEscaped)!
                
                if let data = NSData(contentsOfURL: url) {
                    
                    var err: NSError?
                    if let dic = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &err) as?  [String:AnyObject] {
                        
                        dispatch_async(dispatch_get_main_queue(), {
                            if let celda2 = self.tableView.cellForRowAtIndexPath(indexPath) as? miCeldaTableViewCell{
                                celda2.city?.text = self.citiesModel.cities[indexPath.row]
                                if let main = dic["main"] as? [String:AnyObject]{
                                    //println(dic) // Descomentar para ver por consola los datos
                                    celda2.city?.text=city
                                    celda2.mapView?.hidden = false
                                    self.updateOutlets(dic, celda2: celda2)
                                    
                                } else {
                                    celda2.temperature.text = "N/A"
                                    celda2.weather?.text = "N/A"
                                    celda2.sunrise?.text = "N/A"
                                    celda2.sunset?.text = "N/A"
                                    if let coord = dic["coord"] as? [String: AnyObject]{
                                        
                                    } else {
                                        celda2.mapView?.hidden = true
                                    }
                                    println("La ciudad no existe")
                                }
                            }
                        })
 
                        
                    } else {
                        println("No puedo sacar el JSON")
                    }
                } else {
                    println("Error: no se han podido descargar los datos.")
                }
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                
            } else {
                println("Error escapando URL")
            }
        })
        
    }
 
    
    private func updateOutlets(dic: [String:AnyObject], celda2: miCeldaTableViewCell) {
        let main = dic["main"] as [String:AnyObject]
        let sys = dic["sys"] as [String:AnyObject]
        let weather = dic["weather"] as [[String:AnyObject]]
        let coord = dic["coord"] as [String:AnyObject]
        
        if let coord = dic["coord"] as? [String: AnyObject]{
            
        } else {
            celda2.mapView?.hidden = true
        }
        
        if let temp = main["temp"] as? Float {
            celda2.temperature.text="\(temp) ºC"
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        if let ndate = sys["sunrise"] as? Double {
            let date = NSDate(timeIntervalSince1970: ndate)
            celda2.sunrise?.text = dateFormatter.stringFromDate(date)
        }
        if let ndate = sys["sunset"] as? Double {
            let date = NSDate(timeIntervalSince1970: ndate)
            celda2.sunset?.text = dateFormatter.stringFromDate(date)
        }
        
        if let weather = weather[0]["description"] as? String {
            celda2.weather?.text = weather
        }
        
        var allWeather = ""
        for item in weather {
            if let weather = item["description"] as? String {
                if allWeather != "" {
                    allWeather += ", "
                }
                allWeather += weather
            }
        }
        celda2.weather?.text = allWeather
        
        // if let coord = dic["coord"] as? [String: AnyObject]{
        if let latitude = coord["lat"] as? Float {
            if let longitude = coord["lon"] as? Float {
                
                let center = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
                let span = MKCoordinateSpanMake(0.5, 0.5)
                var reg =  MKCoordinateRegionMake(center, span)
                
                celda2.mapView?.setRegion(reg, animated: false)
                celda2.mapView?.mapType = .Hybrid
                celda2.mapView?.userInteractionEnabled = false
            }
        }
        //} else {
        //    celda2.mapView?.hidden = true
        //}
    }
    
}
