//
//  Tarjeta+CoreDataProperties.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 29/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Tarjetas {

    @NSManaged var correo: String?
    @NSManaged var id: String?
    @NSManaged var nombre: String?
    @NSManaged var telefono1: String?
    @NSManaged var telefono2: String?
    @NSManaged var archivo: String?

}
