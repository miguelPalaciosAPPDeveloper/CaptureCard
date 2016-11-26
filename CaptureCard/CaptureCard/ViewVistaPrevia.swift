//
//  ViewVistaPrevia.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 17/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class ViewVistaPrevia: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var mTextFieldEmpresa: UITextField!
    @IBOutlet weak var mTextFieldNombre: UITextField!
    @IBOutlet weak var mTextFieldPuesto: UITextField!
    @IBOutlet weak var mTextFieldCorreo: UITextField!
    @IBOutlet weak var mTextFieldDireccion: UITextField!
    @IBOutlet weak var mTextFieldTelefono1: UITextField!
    @IBOutlet weak var mTextFieldTelefono2: UITextField!
    
    @IBOutlet weak var mButtonGuardar: UIButton!
    @IBOutlet weak var mImageViewCaptura: UIImageView!
    
    @IBOutlet weak var ConstraintTelefono2: NSLayoutConstraint!
    @IBOutlet weak var ConstraintTelefono1: NSLayoutConstraint!
    @IBOutlet weak var ConstraintDireccion: NSLayoutConstraint!
    @IBOutlet weak var ConstraintCorreo: NSLayoutConstraint!
    @IBOutlet weak var ConstraintPuesto: NSLayoutConstraint!
    @IBOutlet weak var ConstraintContacto: NSLayoutConstraint!
    
    var mCapturaRealizada:UIImage!
    var mViewMain:ViewMain!
    
    fileprivate var mDialogCargandoDatos:UIAlertView!
    fileprivate var mImagePickerController:UIImagePickerController!
    fileprivate var mCapturaEscalada:UIImage!
    fileprivate var mArrayContactos:Array<String> = []
    fileprivate var mArrayNumeros:Array<String> = []
    fileprivate var mArrayCorreos:Array<String> = []
    fileprivate var mAdminCapturas:AdminCapturas!
    fileprivate var keyboardHeight:CGFloat!
    
    fileprivate let ER_CONTACTO = "(([a-zA-Z.ñáéíóú]{2,}+ ){2,}(.*)[a-zA-Zñáéíóú]{3,})"
    fileprivate let ER_NUMERO = "((([0-9()]{2,}( |-){0,4}){2,10}){2})"
    fileprivate let ER_CORREO = "([\\\\a-zA-Z0-9._%-|]+@[\\\\a-zA-Z0-9.-|]+(.|_)[\\\\a-zA-Z|]{2,4})"
    fileprivate let EMPRESA = "EMPRESA"
    fileprivate let NOMBRE = "NOMBRE"
    fileprivate let PUESTO = "PUESTO"
    fileprivate let CORREO = "CORREO"
    fileprivate let DIRECCION = "DIRECCION"
    fileprivate let TELEFONO1 = "TELEFONO1"
    fileprivate let TELEFONO2 = "TELEFONO2"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vistaPersonalizada()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewVistaPrevia.animateWithKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewVistaPrevia.animateWithKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        mDialogCargandoDatos = DialogCargandoDatos().crearDialog(self)
        mDialogCargandoDatos.show()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mAdminCapturas = AdminCapturas()
        mCapturaEscalada = mAdminCapturas.scaleImage(mCapturaRealizada, maxDimension: 640)
        mImageViewCaptura.image = mCapturaEscalada
        let imagenConfigurada = mAdminCapturas.configurarImagen(mCapturaRealizada)
        DispatchQueue.main.async(execute: {self.performImageRecognition(imagenConfigurada)})

    }
    
    fileprivate func vistaPersonalizada(){
        let cornerR = CGFloat(10.0)
        mButtonGuardar.layer.cornerRadius = cornerR
        
        mTextFieldEmpresa.delegate = self
        mTextFieldNombre.delegate = self
        mTextFieldPuesto.delegate = self
        mTextFieldCorreo.delegate = self
        mTextFieldDireccion.delegate = self
        mTextFieldTelefono1.delegate = self
        mTextFieldTelefono2.delegate = self
    }
    
    @IBAction func guardadCaptura(_ sender: UIButton) {
        if mCapturaRealizada != nil {
            let mNombreArchivo = mAdminCapturas.getNombreArchivo()
            
            let mEmpresa = mTextFieldEmpresa.text!
            let mNombre = mTextFieldNombre.text!
            let mPuesto = mTextFieldPuesto.text!
            let mCorreo = mTextFieldCorreo.text!
            let mDireccion = mTextFieldDireccion.text!
            let mTelefono1 = mTextFieldTelefono1.text!
            let mTelefono2 = mTextFieldTelefono2.text!
            
            let mAdminCoreData = AdminCoreData()
            
            if mAdminCoreData.subirTarjeta(mEmpresa, nombre: mNombre, puesto: mPuesto, correo: mCorreo, direccion: mDireccion, telefono1: mTelefono1, telefono2: mTelefono2, archivo: mNombreArchivo){
                let mRutaArchivo = mAdminCapturas.getRutaArchivo(mNombreArchivo)
                let captura = UIImagePNGRepresentation(mCapturaEscalada)
                try? captura!.write(to: URL(fileURLWithPath: mRutaArchivo), options: [.atomic])
                
                self.view.makeToast("Tarjeta guardada", duration: 2, position:ToastPosition.center)
                mViewMain.recargarDatos()
                navigationController!.popViewController(animated: true)
            }
        }
    }
    
    fileprivate func performImageRecognition(_ image: UIImage) {
        let tesseract = G8Tesseract()
        tesseract.language = "eng"
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        tesseract.maximumRecognitionTime = 60.0
        tesseract.image = image
        
        let dispatchBackground:DispatchQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background)
        
        dispatchBackground.async(execute: {
            tesseract.recognize()
            DispatchQueue.main.async(execute: {self.conseguirTexto(tesseract.recognizedText)})
        })

    }
    
    fileprivate func conseguirTexto(_ informacion:String){
        let mAdminTexto = AdminTexto()
        
        mArrayContactos = mAdminTexto.obtenerTexto(ER_CONTACTO, textoTesseract: informacion)
        if mArrayContactos.count >= 1{
            enviarTexto(mTextFieldNombre, texto: mArrayContactos[0])
        }
        
        mArrayNumeros = mAdminTexto.obtenerTexto(ER_NUMERO, textoTesseract: informacion)
        if mArrayNumeros.count > 1{
            enviarTexto(mTextFieldTelefono1, texto: mArrayNumeros[0])
            enviarTexto(mTextFieldTelefono2, texto: mArrayNumeros[1])
        }else if mArrayNumeros.count == 1{
            enviarTexto(mTextFieldTelefono1, texto: mArrayNumeros[0])
        }
        
        mArrayCorreos = mAdminTexto.obtenerTexto(ER_CORREO, textoTesseract: informacion)
        if mArrayCorreos.count >= 1{
            enviarTexto(mTextFieldCorreo, texto: mArrayCorreos[0])
        }
        
        mDialogCargandoDatos.dismiss(withClickedButtonIndex: 0, animated: true)
    }
    
    fileprivate func enviarTexto(_ TextField:UITextField, texto:String){
        TextField.text = texto
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func ButtonEmpresa(_ sender: UIButton) {
        if mArrayContactos.count > 1{
            DialogListaDatos().crearDialog(mArrayContactos, viewController: self, TexlField: EMPRESA)
        }else{self.view.makeToast("No hay más datos que mostrar", duration: 2, position: ToastPosition.center)}
    }
    @IBAction func ButtonNombre(_ sender: UIButton) {
        if mArrayContactos.count > 1{
            DialogListaDatos().crearDialog(mArrayContactos, viewController: self, TexlField: NOMBRE)
        }else{self.view.makeToast("No hay más datos que mostrar", duration: 2, position: ToastPosition.center)}
    }
    
    @IBAction func ButtonPuesto(_ sender: AnyObject) {
        if mArrayContactos.count > 1{
            DialogListaDatos().crearDialog(mArrayContactos, viewController: self, TexlField: PUESTO)
        }else{self.view.makeToast("No hay más datos que mostrar", duration: 2, position: ToastPosition.center)}
    }
    
    @IBAction func ButtonCorreo(_ sender: UIButton) {
        if mArrayCorreos.count > 1{
            DialogListaDatos().crearDialog(mArrayCorreos, viewController: self, TexlField: CORREO)
        }else{self.view.makeToast("No hay más datos que mostrar", duration: 2, position: ToastPosition.center)}
    }
    
    @IBAction func ButtonDireccion(_ sender: AnyObject) {
        if mArrayContactos.count > 1{
            DialogListaDatos().crearDialog(mArrayContactos, viewController: self, TexlField: DIRECCION)
        }else{self.view.makeToast("No hay más datos que mostrar", duration: 2, position: ToastPosition.center)}
    }
    
    @IBAction func ButtonTelefono1(_ sender: UIButton) {
        if mArrayNumeros.count > 2{
            DialogListaDatos().crearDialog(mArrayNumeros, viewController: self, TexlField: TELEFONO1)
        }else{self.view.makeToast("No hay más datos que mostrar", duration: 2, position: ToastPosition.center)}
    }
    @IBAction func ButtonTelefono2(_ sender: UIButton) {
        if mArrayNumeros.count > 2{
            DialogListaDatos().crearDialog(mArrayNumeros, viewController: self, TexlField: TELEFONO2)
        }else{self.view.makeToast("No hay más datos que mostrar", duration: 2, position: ToastPosition.center)}
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
    }
    
    func animateWithKeyboard(_ notification:Notification){
        if notification.name == NSNotification.Name.UIKeyboardWillShow{
            let info:NSDictionary = (notification as NSNotification).userInfo! as NSDictionary
            let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
            keyboardHeight = keyboardSize.height
            reajusteVista()
            ajustarVista()
            self.view.layoutIfNeeded()
        }else if notification.name == NSNotification.Name.UIKeyboardWillHide {
           reajusteVista()
        }
    }
    
    fileprivate func reajusteVista(){
        ConstraintContacto.constant = 15
        ConstraintPuesto.constant = 15
        ConstraintCorreo.constant = 15
        ConstraintDireccion.constant = 15
        ConstraintTelefono1.constant = 15
        ConstraintTelefono2.constant = 63
        self.view.layoutIfNeeded()
    }
    
    fileprivate func ajustarVista(){
        if mTextFieldNombre.isFirstResponder{
            ConstraintContacto.constant = ConstraintContacto.constant + 30
        } else if mTextFieldPuesto.isFirstResponder{
            ConstraintPuesto.constant = ConstraintPuesto.constant + 70
        } else if mTextFieldCorreo.isFirstResponder{
            ConstraintCorreo.constant = ConstraintCorreo.constant + 100
        } else if mTextFieldDireccion.isFirstResponder{
            ConstraintDireccion.constant = ConstraintDireccion.constant + 130
        } else if mTextFieldTelefono1.isFirstResponder{
            ConstraintTelefono1.constant = ConstraintPuesto.constant + 150
        } else if mTextFieldTelefono2.isFirstResponder{
            ConstraintTelefono2.constant = keyboardHeight + 10
        }

        self.view.layoutIfNeeded()
    }
}
