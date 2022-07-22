//
//  UIViewConroller + Storyboard.swift
//  MyMysic
//
//  Created by Anna Nosyk on 21/07/2022.
//

import UIKit


extension UIViewController {
    
    class func loadFromStoryboard<T:UIViewController>() ->T {
        let name = String(describing: T.self)
        let storyboard = UIStoryboard(name: name, bundle: nil)
        if  let vc = storyboard.instantiateInitialViewController() as? T {
                return vc
        } else {
            fatalError("No initial ViewController in \(name) storyboard")
        }
    }
}
