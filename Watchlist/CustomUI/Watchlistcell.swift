//
//  Watchlistcell.swift
//  Watchlist
//
//  Created by Balagurubaran Kalingarayan on 12/29/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit
class Watchlistcell:UITableViewCell{
    
    @IBOutlet weak var ShareID: UIImageView!
    @IBOutlet weak var currentPrice: UIButton!
   
    
    @IBOutlet weak var actualtotarget: UILabel!
    func configure(widget:WidgetModel){
        //ShareId.text = widget.StockID
        let value = "$" + makeTwoPreci(value:widget.ShareActualPrice!) + " -> $" + makeTwoPreci(value:widget.shareTargetPrice!)
        actualtotarget.text = value;
        ShareID.setImage(string: widget.StockID!, color: UIColor.colorHash(name: widget.StockID!), circular:true)
        currentPrice.setTitle("$ " + makeTwoPreci(value:widget.sharePrice!), for: UIControlState.normal)
    }
    
    func makeTwoPreci(value:Float)->String{
        return String(format: "%.2f", value)
    }
}
