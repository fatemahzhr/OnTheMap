//  DataString.swift
//  onTheMap_Fatima
//
//  Created by Fatimah Abdulraheem on  28/01/2019.
//

import Foundation

extension String {
    //this variabe is to change the date format that was obtained from the API
    var toDate: Date? {
        let x = ISO8601DateFormatter() //to parse data String
        //chose the format options:
        x.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return x.date(from: self)//reterned the formatted date
    }
}//end of String extension
