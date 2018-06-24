//
//  Network.swift
//  PennyPlus
//
//  Created by Balagurubaran Kalingarayan on 12/29/17.
//  Copyright © 2017 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation

class Network{
    
    func getData(_ urlString:String, completion: @escaping (_ Data:Data) -> Void){
        let url:URL = URL(string:urlString)!
        let request = URLRequest(url: url, cachePolicy:.reloadIgnoringLocalAndRemoteCacheData,
                                 timeoutInterval: 0)// Creating Http Request
        
        let session = URLSession.init(configuration: URLSessionConfiguration.default)
        let task = session.dataTask(with: request, completionHandler:{ (data,response,error) -> Void in
            if error == nil {
                completion(data!);
            }else{
                print("Error",error.debugDescription);
            }
        })
        
        task.resume()
    }
}
