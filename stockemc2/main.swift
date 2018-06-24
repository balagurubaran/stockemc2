//
//  main.swift
//  stockemc2
//
//  Created by Balagurubaran Kalingarayan on 6/23/18.
//  Copyright © 2018 Balagurubaran Kalingarayan. All rights reserved.
//

import Foundation
import UIKit

UIApplicationMain(
    CommandLine.argc,
    UnsafeMutableRawPointer(CommandLine.unsafeArgv)
        .bindMemory(
            to: UnsafeMutablePointer<Int8>.self,
            capacity: Int(CommandLine.argc)),
    NSStringFromClass(TimerApplication.self),
    NSStringFromClass(AppDelegate.self)
)
