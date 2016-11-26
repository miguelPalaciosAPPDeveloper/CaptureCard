//
//  DialogConfirmarBorrado.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 31/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class DialogBorrarTarjeta: NSObject, UIAlertViewDelegate {
    var mViewController:UIViewController!
    
    init(viewController:UIViewController) {
        mViewController = viewController
    }
    
    func crearDialog(_ titulo:String) ->UIAlertView{
        let borrarAlert = UIAlertView(title: titulo, message: "¿Desea borrar esta tarjeta?", delegate: mViewController, cancelButtonTitle: "NO")
        
        borrarAlert.addButton(withTitle: "SI")
        
        return borrarAlert
    }
    
    func borrar(_ tarjeta:AdminTarjetas, viewMain:ViewMain){
        let mAdminCoreData = AdminCoreData()
        if mAdminCoreData.borrarTarjeta(tarjeta.getID(), nombre: tarjeta.getNombre(), archivo: tarjeta.getArchivo()){
            viewMain.recargarDatos()
            viewMain.view.makeToast("Tarjeta borrada", duration: 2, position: ToastPosition.center)
        } else
        {
            viewMain.view.makeToast("No se pudo borrar la tarjeta", duration: 2, position: ToastPosition.center)
        }

    }

}
