//
//  DialogEditarTarjeta.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 31/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class DialogOpcionesTarjeta: NSObject, UIAlertViewDelegate {
    
    func crearDialog(_ viewDatosTarjeta:ViewDatosTarjeta, titulo:String) ->UIAlertView{
        let opcionesAlert = UIAlertView(title: "OPCIONES", message: "", delegate: viewDatosTarjeta, cancelButtonTitle: "CANCELAR")
        
        opcionesAlert.addButton(withTitle: titulo)
        opcionesAlert.addButton(withTitle: "BORRAR")
        opcionesAlert.addButton(withTitle: "CERRAR VISTA")
        
        return opcionesAlert
    }
}
