//
//  DialogListaDatos.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 31/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class DialogListaDatos: NSObject {
    
    func crearDialog(_ datos:Array<String>, viewController:ViewVistaPrevia, TexlField:String){
        let listaDatosAlert = UIAlertController(title: "DATOS", message: "", preferredStyle: .alert)
        
        var i = 1
        for item in datos{
            let alertAction = UIAlertAction(title: item, style: .default, handler: { (UIAlertAction) in
                switch(TexlField)
                {
                    case "EMPRESA":
                        DispatchQueue.main.async(execute: {viewController.mTextFieldEmpresa.text = item})
                        break
                    case "NOMBRE":
                        DispatchQueue.main.async(execute: {viewController.mTextFieldNombre.text = item})
                        break
                    
                    case "PUESTO":
                        DispatchQueue.main.async(execute: {viewController.mTextFieldPuesto.text = item})
                        break
                    
                    case "CORREO":
                        DispatchQueue.main.async(execute: {viewController.mTextFieldCorreo.text = item})
                        break
                    case "DIRECCION":
                        DispatchQueue.main.async(execute: {viewController.mTextFieldDireccion.text = item})
                        break
                    
                    case "TELEFONO1":
                        DispatchQueue.main.async(execute: {viewController.mTextFieldTelefono1.text = item})
                        break
                    
                    case "TELEFONO2":
                        DispatchQueue.main.async(execute: {viewController.mTextFieldTelefono2.text = item})
                        break
                    
                    default:
                        break
                }
            })
            
            listaDatosAlert.addAction(alertAction)
            i += 1
        }
        
        let cancel = UIAlertAction(title: "CANCELAR", style: .cancel) { (UIAlertAction) in
            listaDatosAlert.dismiss(animated: true, completion: nil)
        }
        
        
        listaDatosAlert.addAction(cancel)
        DispatchQueue.main.async(execute: {viewController.present(listaDatosAlert, animated: true, completion: nil)})
        
    }
    
    func AlertActionClick(_ alertAction:UIAlertAction, titulo:String){
        
    }
}
