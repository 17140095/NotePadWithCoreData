//
//  CustomeAlert.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 03/02/2023.
//

import UIKit

class CustomeKit {
    static func getAlert(title: String, message: String) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        return alert
    }
    static func getTableViewSeparator(cell: UITableViewCell)->UIView{
        let thickness: CGFloat = 10.0
        let seprator = UIView(frame: CGRect(x: 0,
                                            y: cell.frame.height-thickness,
                                            width: cell.frame.width,
                                            height: thickness)
        )
        seprator.backgroundColor = UIColor.systemGray6
        seprator.cornerRadius(radius: 10)
        seprator.clipsToBounds = true
        
        return seprator
    }
}
