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
}
