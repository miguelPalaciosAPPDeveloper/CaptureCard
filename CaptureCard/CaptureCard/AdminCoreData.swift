//
//  AdminCoreData.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 28/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit
import CoreData
import Foundation

class AdminCoreData: NSObject {
    fileprivate let mKeyNSUserDefault = "tarjetasGuardadas"
    fileprivate let mDataBase = "Tarjetas"
    fileprivate let ID = "id"
    fileprivate let EMPRESA = "empresa"
    fileprivate let NOMBRE = "nombre"
    fileprivate let PUESTO = "puesto"
    fileprivate let CORREO = "correo"
    fileprivate let DIRECCION = "direccion"
    fileprivate let TELEFONO1 = "telefono1"
    fileprivate let TELEFONO2 = "telefono2"
    fileprivate let ARCHIVO = "archivo"
    fileprivate let AUTO_INCREMENT = 1
    fileprivate let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    fileprivate var mDatosConsulta:Array<AnyObject> = []
    fileprivate var mBusqueda = [String]()
    fileprivate var mObjetoNSUserDefault = UserDefaults.standard
    fileprivate var mGuardados:Int = 0
    
    func getTamaño() ->Int{
        if(mDatosConsulta.count > 0){
            return mDatosConsulta.count
        }else{
            return 0
        }
        
    }
    func getBusqueda() ->[String]{return mBusqueda}
    
    override init() {
        super.init()
        consultarCoreData()
        consultaBusqueda()
    }
    
    fileprivate func consultarCoreData(){
        let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext
        //let frequest = NSFetchRequest<NSFetchRequest>(entityName: mDataBase)
        let frequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: mDataBase)
        
        do{
            mDatosConsulta = try managedObjectContext.fetch(frequest)
        }catch let error as NSError{
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    fileprivate func consultaBusqueda(){
        for itemEmpresas in mDatosConsulta{
            let consulta = itemEmpresas as! NSManagedObject
            if let consultaEmpresa:String = consulta.value(forKey: EMPRESA) as? String{
                mBusqueda.append(consultaEmpresa)
            }
        }
        
        for itemNombres in mDatosConsulta{
            let consulta = itemNombres as! NSManagedObject
            if let consultaNombres:String = consulta.value(forKey: NOMBRE) as? String{
                mBusqueda.append(consultaNombres)
            }
        }
        
        for itemPuesto in mDatosConsulta{
            let consulta = itemPuesto as! NSManagedObject
            if let consultaPuesto:String = consulta.value(forKey: PUESTO) as? String{
                mBusqueda.append(consultaPuesto)
            }
        }
    }
    
    func consultaIDPorBusqueda(_ itemBusqueda:String) ->String{
        var mDatos:String!
        for item in mDatosConsulta{
            let consulta = item as! NSManagedObject
            if let consultaEmpresa:String = consulta.value(forKey: EMPRESA) as? String{
                if consultaEmpresa == itemBusqueda{
                    let id = consulta.value(forKey: ID) as! String
                    mDatos = id
                    break
                } else if let consultaNombre:String = consulta.value(forKey: NOMBRE) as? String{
                    if consultaNombre == itemBusqueda{
                        let id = consulta.value(forKey: ID) as! String
                        mDatos = id
                        break
                    } else if let consultaPuesto:String = consulta.value(forKey: PUESTO) as? String{
                        if consultaPuesto == itemBusqueda{
                            let id = consulta.value(forKey: ID) as! String
                            mDatos = id
                            break
                        }
                    }
                }
            }
        }
        
        return mDatos
    }
    
    func consultaIdTarjetas(_ item:Int) ->String{
        let consulta = mDatosConsulta[item] as! NSManagedObject
        let id = consulta.value(forKey: ID) as! String
        
        return id
    }
    
    func consultarTarjeta(_ itemId:String) ->AdminTarjetas{
        var mDatos:AdminTarjetas!
        for item in mDatosConsulta{
            let consulta = item as! NSManagedObject
            if let consultaID:String = consulta.value(forKey: ID) as? String
            {
                if consultaID == itemId {
                    let id = consulta.value(forKey: ID) as! String
                    let empresa = consulta.value(forKey: EMPRESA) as! String
                    let nombre = consulta.value(forKey: NOMBRE) as! String
                    let puesto = consulta.value(forKey: PUESTO) as! String
                    let correo = consulta.value(forKey: CORREO) as! String
                    let direccion = consulta.value(forKey: DIRECCION) as! String
                    let telefono1 = consulta.value(forKey: TELEFONO1) as! String
                    let telefono2 = consulta.value(forKey: TELEFONO2) as! String
                    let archivo = consulta.value(forKey: ARCHIVO) as! String
                    
                    mDatos = AdminTarjetas(id: id, empresa: empresa, nombre: nombre, puesto: puesto, correo: correo, direccion: direccion, telefono1: telefono1, telefono2: telefono2, archivo: archivo)
                    break
                }
            }
        }
        
        return mDatos
    }
    
    func subirTarjeta(_ empresa:String, nombre:String, puesto: String, correo:String, direccion:String, telefono1:String, telefono2:String, archivo:String) ->Bool{
        let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext
        let nuevaTarjeta:Tarjeta = NSEntityDescription.insertNewObject(forEntityName: mDataBase, into: managedObjectContext) as! Tarjeta
        
        mGuardados = mObjetoNSUserDefault.integer(forKey: mKeyNSUserDefault)
        mGuardados = mGuardados + AUTO_INCREMENT;
        
        nuevaTarjeta.id = "\(mGuardados)"
        nuevaTarjeta.empresa = empresa
        nuevaTarjeta.nombre = nombre
        nuevaTarjeta.puesto = puesto
        nuevaTarjeta.correo = correo
        nuevaTarjeta.direccion = direccion
        nuevaTarjeta.telefono1 = telefono1
        nuevaTarjeta.telefono2 = telefono2
        nuevaTarjeta.archivo = archivo
        
        do{
            try managedObjectContext.save()
            mObjetoNSUserDefault.setValue(mGuardados, forKey: mKeyNSUserDefault)
            return true
        }catch let error as NSError{
            print("Fetch failed: \(error.localizedDescription)")
            return false
        }

    }
    
    func borrarTarjeta(_ id:String, nombre:String, archivo:String) ->Bool{
        let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext
        var tarjetaExistente:NSManagedObject!
        
        for item in mDatosConsulta{
            let consulta = item as! NSManagedObject
            let consultaID:String = consulta.value(forKey: ID) as! String
            let consultaNombre:String = consulta.value(forKey: NOMBRE) as! String
            
            if consultaID == id && consultaNombre == nombre{
                tarjetaExistente = consulta
                break
            }
        }
        
        managedObjectContext.delete(tarjetaExistente)
        if managedObjectContext.deletedObjects.contains(tarjetaExistente){
            if FileManager.default.fileExists(atPath: archivo) {
                do {
                    try FileManager.default.removeItem(atPath: archivo)
                    print("Imagen borrada")
                } catch {
                    print("No se borro la imagen")
                }
            }
            print("borrado")
        }else{
            print("no se borro")
        }
        do{
            try managedObjectContext.save()
            return true
        }catch let error as NSError{
            print("Fetch failed: \(error.localizedDescription)")
            return false
        }

    }
    
    func modificarTarjeta(_ id:String, empresa:String, nombre:String, puesto:String, correo:String, direccion:String, telefono1:String, telefono2:String) ->Bool{
        let managedObjectContext:NSManagedObjectContext = appDelegate.managedObjectContext
        var tarjetaExistente:NSManagedObject!
        
        for item in mDatosConsulta{
            let consulta = item as! NSManagedObject
            if let consultaID:String = consulta.value(forKey: ID) as? String{
                if consultaID == id{
                    tarjetaExistente = consulta
                    break
                }
            }
        }
        
        tarjetaExistente.setValue(empresa, forKey: EMPRESA)
        tarjetaExistente.setValue(nombre, forKey: NOMBRE)
        tarjetaExistente.setValue(puesto, forKey: PUESTO)
        tarjetaExistente.setValue(correo, forKey: CORREO)
        tarjetaExistente.setValue(direccion, forKey: DIRECCION)
        tarjetaExistente.setValue(telefono1, forKey: TELEFONO1)
        tarjetaExistente.setValue(telefono2, forKey: TELEFONO2)
        
        do{
            try managedObjectContext.save()
            return true
        }catch let error as NSError{
            print("Fetch failed: \(error.localizedDescription)")
            return false
        }
    }
}
