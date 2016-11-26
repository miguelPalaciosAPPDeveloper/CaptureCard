//
//  DialogIndicatorView.swift
//  KidMonitor
//
//  Created by Miguel Palacios on 06/12/15.
//  Copyright © 2015 Miguel Palacios. All rights reserved.
//

import Foundation
import UIKit
class DialogCargandoDatos:NSObject {
    fileprivate let titulo = "Obteniendo información ...."
    
    func crearDialog(_ tableViewController:UIViewController) ->UIAlertView{
        let indicatorViewAlert = UIAlertView(title: titulo, message: nil, delegate: nil, cancelButtonTitle: nil);
        let loadingIndicator: UIActivityIndicatorView = UIActivityIndicatorView(frame: CGRect(x: 50, y: 10, width: 37, height: 37)) as UIActivityIndicatorView
        loadingIndicator.center = tableViewController.view.center;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        loadingIndicator.color = UIColor(red: 0.4705, green: 0.5647, blue: 0.6117, alpha: 1.0)
        loadingIndicator.startAnimating();
        
        indicatorViewAlert.setValue(loadingIndicator, forKey: "accessoryView")
        loadingIndicator.startAnimating()

        return indicatorViewAlert
    }
}
