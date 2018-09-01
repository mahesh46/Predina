//
//  Utility.swift
//  Predina
//
//  Created by Administrator on 07/08/2018.
//  Copyright © 2018 mahesh lad. All rights reserved.
//

import Foundation
import UIKit


func randomColour()-> UIColor {
    // return UIColor(red: 255, green: 0, blue: 0, alpha: 0.1)
    let randomInt = Int.random(in: 1...4)
    let alpha : CGFloat = 0.5
    switch randomInt {
    case 1:
        return UIColor(red: 255/255, green: 142/255, blue: 2/255, alpha: alpha)
    case 2:
        return UIColor(red: 255/255, green: 0, blue: 1/255, alpha: alpha)
    case 3:
        return UIColor(red: 255/255, green: 255/255, blue: 3/255, alpha: alpha)
    case 4:
        return UIColor(red: 6/255, green: 255/255, blue: 2/255, alpha: alpha)
    default:
        return UIColor(red: 255/255, green: 142/255, blue: 2/255, alpha: alpha)
    }
    
    
  
    
}

func csv(data: String) -> [[String]] {
    var result: [[String]] = []
    let rows = data.components(separatedBy: "\n")
    for row in rows {
        let columns = row.components(separatedBy: ",")
        result.append(columns)
    }
    return result
}

func cleanRows(file:String)->String{
    var cleanFile = file
    cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
    cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
    
    return cleanFile
}


func readDataFromCSV(fileName:String, fileType: String)-> String!{
    guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
        else {
            return nil
    }
    do {
        var contents = try String(contentsOfFile: filepath, encoding: .utf8)
        contents = cleanRows(file: contents)
        return contents
    } catch {
        print("File Read Error for file \(filepath)")
        return nil
    }
}

func timeValue(i: Int)-> String {
    let  min : Int = i / 60
    let  sec = i - min * 60
    let timeFormatted = String(format: "%02d", min) + ":" + String(format: "%02d", sec)
    
    return timeFormatted
}
