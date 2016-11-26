//
//  ViewController.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 16/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class ViewMain: UIViewController,UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UISearchResultsUpdating, UIAlertViewDelegate {
    @IBOutlet weak var mSearchBar: UISearchBar!
    
    @IBOutlet var TableViewTarjetas: UITableView!
    var mAdminCoreData:AdminCoreData!
    var mImagePickerController:UIImagePickerController!
    let mViewVistaPrevia:String = "ViewVistaPrevia"
    let mViewDatosTarjeta:String = "ViewDatosTarjeta"
    var mBusqueda = [String]()
    var mFiltroBusqueda = [String]()
    var mResultadoBusqueda:UISearchController!
    var mTarjeta:AdminTarjetas!
    var mDatosTarjeta:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        cargarDatos()
        configurarSearchBar()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewMain.longPress(_:)))
        self.view.addGestureRecognizer(longPressRecognizer)
        TableViewTarjetas.reloadData()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func configurarSearchBar(){
        mResultadoBusqueda = UISearchController(searchResultsController: nil)
        mResultadoBusqueda.searchResultsUpdater = self
        mResultadoBusqueda.dimsBackgroundDuringPresentation = false
        mResultadoBusqueda.searchBar.sizeToFit()
        mResultadoBusqueda.searchBar.placeholder = "Buscar"
        TableViewTarjetas.tableHeaderView = mResultadoBusqueda.searchBar
        
        if(mAdminCoreData.getTamaño() > 0){
            TableViewTarjetas.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableViewScrollPosition.top, animated: false)
        }
    }
    
    fileprivate func cargarDatos(){
        mAdminCoreData = AdminCoreData()
        mBusqueda = mAdminCoreData.getBusqueda()
    }
    
    func recargarDatos(){
        mAdminCoreData = AdminCoreData()
        mBusqueda = mAdminCoreData.getBusqueda()
        TableViewTarjetas.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        mFiltroBusqueda.removeAll(keepingCapacity: false)
        
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[cd] %@", searchController.searchBar.text!)
        let arrayPredicate = (mBusqueda as NSArray).filtered(using: searchPredicate)
        if let arrayBusqueda:[String] = arrayPredicate as? [String]{
            for item in arrayBusqueda{
                //mFiltroBusqueda.append(mAdminCoreData.consultaIDPorBusqueda(item))
                let id = mAdminCoreData.consultaIDPorBusqueda(item)
                
                if mFiltroBusqueda.count > 0{
                    for idExistente in mFiltroBusqueda{
                        if idExistente != id{
                            mFiltroBusqueda.append(id)
                        }
                    }
                } else{
                    mFiltroBusqueda.append(id)
                }
                
            }
        }
        
        TableViewTarjetas.reloadData()
    }
    @IBAction func agregarTarjeta(_ sender: UIBarButtonItem) {
        mImagePickerController = UIImagePickerController()
        mImagePickerController.delegate = self
        mImagePickerController.allowsEditing = false
        mImagePickerController.sourceType = .camera
        present(mImagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var capturaRealizada:UIImage!
        mImagePickerController.dismiss(animated: true, completion: nil)
        capturaRealizada = info[UIImagePickerControllerOriginalImage] as? UIImage
        self.performSegue(withIdentifier: mViewVistaPrevia, sender: capturaRealizada)
    }
    
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {
        let button:String = alertView.buttonTitle(at: buttonIndex)!
        if button == "SI"{
            print("SI")
            DialogBorrarTarjeta(viewController:self).borrar(mTarjeta, viewMain: self)
        }
    }
 
    //TableView

    func numberOfSections(in tableView:UITableView) -> Int{
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if mResultadoBusqueda.isActive{
            return mFiltroBusqueda.count
        }else{
            return mAdminCoreData!.getTamaño()
        }
        //return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CustomCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CustomCellTableViewCell
        var id:String!
        var cargarTarjeta:AdminTarjetas!
        var nombreArchivo:String!
        var rutaArchivo:String!
        
        if mResultadoBusqueda.isActive{
            id = mFiltroBusqueda[(indexPath as NSIndexPath).row]
            cargarTarjeta = mAdminCoreData!.consultarTarjeta(id)
            nombreArchivo = cargarTarjeta.getArchivo()
            
            cell.mLabelEmpresa.text = cargarTarjeta.getEmpresa()
            cell.mLabelNombre.text = cargarTarjeta.getNombre()
            cell.mLabelPuesto.text = cargarTarjeta.getPuesto()
            cell.mLabelCorreo.text = cargarTarjeta.getCorreo()
            cell.mLabelDireccion.text = cargarTarjeta.getDireccion()
            cell.mLabelTelefono1.text = cargarTarjeta.getTelefono1()
            cell.mLabelTelefono2.text = cargarTarjeta.getTelefono2()
            rutaArchivo = AdminCapturas().getRutaArchivo(nombreArchivo)
        } else {
            
            id = mAdminCoreData!.consultaIdTarjetas((indexPath as NSIndexPath).row)
            cargarTarjeta = mAdminCoreData!.consultarTarjeta(id)
            nombreArchivo = cargarTarjeta.getArchivo()
            
            cell.mLabelEmpresa.text = cargarTarjeta.getEmpresa()
            cell.mLabelNombre.text = cargarTarjeta.getNombre()
            cell.mLabelPuesto.text = cargarTarjeta.getPuesto()
            cell.mLabelCorreo.text = cargarTarjeta.getCorreo()
            cell.mLabelDireccion.text = cargarTarjeta.getDireccion()
            cell.mLabelTelefono1.text = cargarTarjeta.getTelefono1()
            cell.mLabelTelefono2.text = cargarTarjeta.getTelefono2()
            rutaArchivo = AdminCapturas().getRutaArchivo(nombreArchivo)
        }
        
        let dispatchBackground:DispatchQueue = DispatchQueue.global(priority: DispatchQueue.GlobalQueuePriority.background)
        
        dispatchBackground.async(execute: {
            let capturaGuardada = UIImage.init(named: rutaArchivo)
            DispatchQueue.main.async(execute: {cell.mImageViewCaptura.image = capturaGuardada})
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id:String!
        if mResultadoBusqueda.isActive{
            id = mFiltroBusqueda[(indexPath as NSIndexPath).row]
            mTarjeta = mAdminCoreData!.consultarTarjeta(id)
        } else{
            id = mAdminCoreData!.consultaIdTarjetas((indexPath as NSIndexPath).row)
            mTarjeta = mAdminCoreData!.consultarTarjeta(id)
        }
        mDatosTarjeta = true
        let nombreArchivo = mTarjeta.getArchivo()
        let rutaArchivo = AdminCapturas().getRutaArchivo(nombreArchivo)
        let capturaGuardada = UIImage.init(named: rutaArchivo)
        
        self.performSegue(withIdentifier: mViewDatosTarjeta, sender: capturaGuardada)
    }
    
    
    func longPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer){
        if longPressGestureRecognizer.state == UIGestureRecognizerState.began{
            let point = longPressGestureRecognizer.location(in: TableViewTarjetas)
            if let indexPath = TableViewTarjetas.indexPathForRow(at: point){
                var id:String!
                if mResultadoBusqueda.isActive{
                    id = mFiltroBusqueda[(indexPath as NSIndexPath).row]
                    mTarjeta = mAdminCoreData!.consultarTarjeta(id)
                }else{
                    id = mAdminCoreData!.consultaIdTarjetas((indexPath as NSIndexPath).row)
                    mTarjeta = mAdminCoreData!.consultarTarjeta(id)
                }
                
                DialogBorrarTarjeta(viewController:self).crearDialog(mTarjeta.getEmpresa()).show()
            }
        }
    }
    //Fin TableView
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let captura = sender as! UIImage
        if (mDatosTarjeta){
            let crearDatosTarjeta:ViewDatosTarjeta = segue.destination as! ViewDatosTarjeta
            crearDatosTarjeta.mCaptura = captura
            crearDatosTarjeta.mTarjeta = mTarjeta
            crearDatosTarjeta.mViewMain = self
            mDatosTarjeta = false
        } else{
            let crearVistaPrevia:ViewVistaPrevia = segue.destination as! ViewVistaPrevia
            crearVistaPrevia.mCapturaRealizada = captura
            crearVistaPrevia.mViewMain = self
        }
    }

}

