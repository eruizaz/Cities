//
//  miCeldaTableViewCell.swift
//  Cities
//
//  Created by g216 DIT UPM on 18/12/14.
//  Copyright (c) 2014 g216 DIT UPM. All rights reserved.
//

import UIKit
import MapKit

class miCeldaTableViewCell: UITableViewCell {

    @IBOutlet weak var city: UILabel?
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var weather: UILabel?
    @IBOutlet weak var sunrise: UILabel?
    @IBOutlet weak var sunset: UILabel?
    @IBOutlet weak var mapView: MKMapView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func actualizarCampos(temp: Float){
        self.temperature.text = "\(temp)"
    }
}
