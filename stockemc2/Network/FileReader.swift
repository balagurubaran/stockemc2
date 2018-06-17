//
//  FileReader.swift
//  Gradient
//
//  Created by Balagurubaran Kalingarayan on 11/19/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation

func readJSONFile(fileName:String)->Data{
    var jsonString:String?
    var jsonData:Data?
    
    if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
        do {
            jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
            do{
                
                //let json =  try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                // JSONObjectWithData returns AnyObject so the first thing to do is to downcast to dictionary type
               // print(json)
                jsonString = String.init(data: jsonData!, encoding: .utf8)//jsonData.data(using: .utf8, allowLossyConversion: false)
            }catch let error{
                jsonString = nil
                jsonData = nil
                print(error.localizedDescription)
            }
            
        } catch let error {
            jsonString = nil
            jsonData = nil
            print(error.localizedDescription)
        }
    } else {
        jsonString = nil
        jsonData = nil
        print("Invalid filename/path.")
    }
    
    return jsonData!;
}
