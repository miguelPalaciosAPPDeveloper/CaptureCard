//
//  AdminCapturas.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 29/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class AdminCapturas: NSObject {
    fileprivate let PREFIJO = "/tp_"
    fileprivate let TIPO_ARCHIVO = ".png"
    fileprivate let DATE_FORMAT = "yyyyMMddHHmmss"
    
    func getNombreArchivo() ->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DATE_FORMAT
        let date = Date()
        let fecha = dateFormatter.string(from: date)
        let nombreArchivo = PREFIJO + fecha + TIPO_ARCHIVO
        
        return nombreArchivo
    }
    
    func getRutaArchivo(_ nombreArchivo:String) ->String{
        let directorio = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                let rutaDocumentos = directorio[0]
        let rutaArchivo = rutaDocumentos + nombreArchivo
        
        return rutaArchivo
    }
    
    
    func scaleImage(_ image: UIImage, maxDimension: CGFloat) -> UIImage {
        
        var scaledSize = CGSize(width: maxDimension, height: maxDimension)
        var scaleFactor: CGFloat
        
        if image.size.width > image.size.height {
            scaleFactor = image.size.height / image.size.width
            scaledSize.width = maxDimension
            scaledSize.height = scaledSize.width * scaleFactor
        } else {
            scaleFactor = image.size.width / image.size.height
            scaledSize.height = maxDimension
            scaledSize.width = scaledSize.height * scaleFactor
        }
        
        UIGraphicsBeginImageContext(scaledSize)
        image.draw(in: CGRect(x: 0, y: 0, width: scaledSize.width, height: scaledSize.height))
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
    
    func configurarImagen(_ image:UIImage) ->UIImage{
        let imageGrayScale = image.g8_grayScale()
        let imageBlackAndWhite = imageGrayScale?.g8_blackAndWhite()
        
        return imageBlackAndWhite!
    }
}
