//
//  customMainLogoCell.swift
//  StockEMC2
//
//  Created by Balagurubaran Kalingarayan on 3/18/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import UIKit

class CustomMainLogoCell: UITableViewCell {
    
    @IBOutlet weak var mainStockCell: UIImageView!
    func configure(index:Int,isWatchList:Bool = false){
       
//        if(index == 0){
//            mainStockCell.image = UIImage.init(named: "Search")
//        }else{
            let share = DataHandler.getIndexDataFromTheMenuStock(index: index)
            mainStockCell.setImage(string: share.shareName?.uppercased(), color: UIColor.colorHash(name:share.shareName), circular: true, textAttributes: nil,fontSize: 18.0)
       // }
        mainStockCell.dropShadow()
        mainStockCell.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //newStockStatusIcon.isHidden = true
//        if(share.isNew! ){
//            newStockStatusIcon.isHidden = false
//            newStockStatusIcon.heartBeatAnimation(toVlaue: 1.3)
//        }
    }
}
