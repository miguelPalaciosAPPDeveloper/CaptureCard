//
//  AdminTexto.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 30/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class AdminTexto: NSObject {
    
    func obtenerTexto(_ expresionRegular:String, textoTesseract:String) ->Array<String>{
        var resultados:Array<String> = []
        let rango = NSMakeRange(0, textoTesseract.characters.count)
        let regex = try! NSRegularExpression(pattern: expresionRegular, options: [.caseInsensitive])
        
        let matches = regex.matches(in: textoTesseract, options: .reportCompletion, range: rango) as Array<NSTextCheckingResult>
        
        var i = 0
        for match in matches{
            resultados.insert((textoTesseract as NSString).substring(with: match.range), at: i)
            i += 1
        }
        
        return resultados
    }
}
