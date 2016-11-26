//
//  AdminTarjetas.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 28/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class AdminTarjetas: NSObject {
    fileprivate var ID:String = ""
    fileprivate var Empresa:String = ""
    fileprivate var Nombre:String = ""
    fileprivate var Puesto:String = ""
    fileprivate var Correo:String = ""
    fileprivate var Direccion:String = ""
    fileprivate var Telefono1:String = ""
    fileprivate var Telefono2:String = ""
    fileprivate var Archivo:String = ""
    
    init(id:String, empresa:String, nombre:String, puesto:String, correo:String, direccion:String, telefono1:String, telefono2:String, archivo:String){
        ID = id
        Empresa = empresa
        Nombre = nombre
        Puesto = puesto
        Correo = correo
        Direccion = direccion
        Telefono1 = telefono1
        Telefono2 = telefono2
        Archivo = archivo
    }
    
    func getID() ->String{return ID}
    
    func getEmpresa() ->String{return Empresa}
    
    func getNombre() ->String{return Nombre}
    
    func getPuesto() ->String{return Puesto}
    
    func getCorreo() ->String{return Correo}
    
    func getDireccion() ->String{return Direccion}
    
    func getTelefono1() ->String{return Telefono1}
    
    func getTelefono2() ->String{return Telefono2}
    
    func getArchivo() ->String{return Archivo}
}
