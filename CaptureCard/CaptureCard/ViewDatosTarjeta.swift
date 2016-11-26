//
//  ViewDatosTarjeta.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 11/04/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class ViewDatosTarjeta: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mImageViewCaptura: UIImageView!
    @IBOutlet weak var mTextFieldEmpresa: UITextField!
    @IBOutlet weak var mTextFieldNombre: UITextField!
    @IBOutlet weak var mTextFieldPuesto: UITextField!
    @IBOutlet weak var mTextFieldCorreo: UITextField!
    @IBOutlet weak var mTextFieldDireccion: UITextField!
    @IBOutlet weak var mTextFieldTelefono1: UITextField!
    @IBOutlet weak var mTextFieldTelefono2: UITextField!
    @IBOutlet weak var mButtonOpciones: UIButton!
    
    @IBOutlet weak var ConstraintTelefono2: NSLayoutConstraint!
    @IBOutlet weak var ConstraintTelefono1: NSLayoutConstraint!
    @IBOutlet weak var ConstraintDireccion: NSLayoutConstraint!
    @IBOutlet weak var ConstraintCorreo: NSLayoutConstraint!
    @IBOutlet weak var ConstraintPuesto: NSLayoutConstraint!
    @IBOutlet weak var ConstraintContacto: NSLayoutConstraint!
    
    
    
    var mViewMain:ViewMain!
    var mCaptura:UIImage!
    var mTarjeta:AdminTarjetas!
    var mEditando = false
    var mEditado = false
    
    fileprivate var keyboardHeight:CGFloat!
    fileprivate var mArrayTextField = [UITextField]()

    override func viewDidLoad() {
        super.viewDidLoad()
        vistaPersonalizada()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewVistaPrevia.animateWithKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewVistaPrevia.animateWithKeyboard(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        mArrayTextField = [mTextFieldEmpresa, mTextFieldNombre, mTextFieldPuesto, mTextFieldCorreo, mTextFieldDireccion,mTextFieldTelefono1, mTextFieldTelefono2]
        for item in mArrayTextField{
            item.addTarget(self, action: #selector(ViewDatosTarjeta.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        }
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        mImageViewCaptura.image = mCaptura
        mTextFieldEmpresa.text = mTarjeta.getEmpresa()
        mTextFieldNombre.text = mTarjeta.getNombre()
        mTextFieldPuesto.text = mTarjeta.getPuesto()
        mTextFieldCorreo.text = mTarjeta.getCorreo()
        mTextFieldDireccion.text = mTarjeta.getDireccion()
        mTextFieldTelefono1.text = mTarjeta.getTelefono1()
        mTextFieldTelefono2.text = mTarjeta.getTelefono2()
    }
    
    fileprivate func vistaPersonalizada(){
        let cornerR = CGFloat(10.0)
        mButtonOpciones.layer.cornerRadius = cornerR
    }
    
    @objc fileprivate func textFieldDidChange(_ textField:UITextField){
        mEditado = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        self.view.layoutIfNeeded()
    }
    
    fileprivate func editarDatos(){
        mEditando = true
        mTextFieldEmpresa.isEnabled = true
        mTextFieldNombre.isEnabled = true
        mTextFieldPuesto.isEnabled = true
        mTextFieldCorreo.isEnabled = true
        mTextFieldDireccion.isEnabled = true
        mTextFieldTelefono1.isEnabled = true
        mTextFieldTelefono2.isEnabled = true
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        let button:String = alertView.buttonTitle(at: buttonIndex)!
        let dialogBorrarTarjeta = DialogBorrarTarjeta(viewController:self)
        switch button {
        case "EDITAR":
            editarDatos()
            break
        case "BORRAR":
            dialogBorrarTarjeta.crearDialog(mTarjeta.getEmpresa()).show()
            break
        case "CERRAR VISTA":
            navigationController!.popViewController(animated: true)
            break
        case "SI":
             dialogBorrarTarjeta.borrar(mTarjeta, viewMain: mViewMain)
             navigationController!.popViewController(animated: true)
            break
        case "GUARDAR":
            if mEditado{
                let mId = mTarjeta.getID()
                let mEmpresa = mTextFieldEmpresa.text!
                let mNombre = mTextFieldNombre.text!
                let mPuesto = mTextFieldPuesto.text!
                let mCorreo = mTextFieldCorreo.text!
                let mDireccion = mTextFieldDireccion.text!
                let mTelefono1 = mTextFieldTelefono1.text!
                let mTelefono2 = mTextFieldTelefono2.text!
                
                let mAdminCoreData = AdminCoreData()
                if mAdminCoreData.modificarTarjeta(mId, empresa: mEmpresa, nombre: mNombre, puesto: mPuesto, correo: mCorreo, direccion: mDireccion,telefono1: mTelefono1, telefono2: mTelefono2){
                    self.view.makeToast("Cambios guardados", duration: 2, position: ToastPosition.center)
                    mViewMain.recargarDatos()
                    mViewMain.TableViewTarjetas.reloadData()
                } else{
                    self.view.makeToast("No se guardaron los cambios", duration: 2, position: ToastPosition.center)
                }
            }else {
                self.view.makeToast("No hay cambios", duration: 2, position: ToastPosition.center)
            }
            break
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func buttonOpciones(_ sender: UIButton) {
        if mEditando{
            DialogOpcionesTarjeta().crearDialog(self, titulo: "GUARDAR").show()
        } else{
            DialogOpcionesTarjeta().crearDialog(self, titulo: "EDITAR").show()
        }
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
