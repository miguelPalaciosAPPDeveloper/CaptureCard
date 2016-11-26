//
//  Tarjeta+CoreDataProperties.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 10/04/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tarjeta {

    @NSManaged var archivo: String?
    @NSManaged var correo: String?
    @NSManaged var direccion:String?
    @NSManaged var empresa: String?
    @NSManaged var id: String?
    @NSManaged var nombre: String?
    @NSManaged var puesto:String?
    @NSManaged var telefono1: String?
    @NSManaged var telefono2: String?

}
