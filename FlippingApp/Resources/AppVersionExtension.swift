//
//  AppVersionExtension.swift
//  FlippingApp
//
//  Created by Bronson Mullens on 2/16/21.
//

import UIKit

extension UIApplication {

 static var appVersion: String? {
    return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
 }

}
