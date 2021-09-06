//
//  WeatherTableViewCell.swift
//  WeatherApp
//
//  Created by M1066900 on 28/07/21.
//

import UIKit

class WeatherTableViewCell: UITableViewCell {

   
    @IBOutlet weak var cloudsLabel: UILabel!
    @IBOutlet weak var temparatureLabel: UILabel!

    var cellViewModel:WeatherCellViewModel?{
        didSet{
            //textLabel?.text = cellViewModel?.clouds
            textLabel?.text = cellViewModel?.temperature
            imageView?.image = UIImage(named: (cellViewModel?.description)!)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        textLabel?.text = nil
        detailTextLabel?.text = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
