//
//  FormController.swift
//  JSanchezEcommerce
//
//  Created by MacBookMBA6 on 27/04/23.
//

import UIKit
import SwipeCellKit
import iOSDropDown

class FormController: UIViewController {
    @IBOutlet weak var txtNombreOutlet: UITextField!
    
    @IBOutlet weak var txtApellidoPaternoOutlet: UITextField!
    
    @IBOutlet weak var txtApellidoMaternoOutlet: UITextField!
    
    @IBOutlet weak var txtUsernameOutlet: UITextField!
    
    @IBOutlet weak var txtPasswordOutlet: UITextField!
    
    @IBOutlet weak var txtIdUsuario: UITextField!
    
    @IBOutlet weak var dateFechaNacimientoOutlet: UIDatePicker!
    
    @IBOutlet weak var btnAction: UIButton!
    
    @IBOutlet weak var lblNombreError: UILabel!
    
    @IBOutlet weak var lblApellidoPaternoError: UILabel!
    
    @IBOutlet weak var lblApellidoMaternoError: UILabel!
    
    @IBOutlet weak var lblFechaNacimientoError: UILabel!
    
    @IBOutlet weak var lblUsernameError: UILabel!
    
    @IBOutlet weak var lblPasswordError: UILabel!
        
    @IBOutlet weak var lblIdRolError: UILabel!
    
    @IBOutlet weak var ddlIdRol: DropDown!
    
    let dbManager = DBManager()
    var idUsuario : Int = 0
    var idRol : Int = 0
    var textoSeleccionado : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ddlIdRol.optionArray = []
        ddlIdRol.optionIds = []

        ddlIdRol.didSelect{(selectedText, index, id) in
            self.idRol = id
            self.textoSeleccionado = selectedText
            
            print("Id Did select: \(id)")
            print("Id Rol Global: \(self.idRol)")
            print("Texto selecionado Global: \(self.textoSeleccionado)")
            print("Selected text: \(selectedText)")
        }
        
        let resultRol : Result = RolViewModel.GetAll()
        
        if resultRol.Correct!{
            for objRol in resultRol.Objects!{
                let rol = objRol as! Rol
                ddlIdRol.optionArray.append(rol.nombre!)
                ddlIdRol.optionIds?.append(rol.idRol!)
            }
        }
        
        
        if idUsuario == 0{
            print(self.idUsuario)
            LimpiarCampos()
            btnAction.backgroundColor = .green
            btnAction.setTitle("Agregar", for: .normal)
        }
        else{
            btnAction.backgroundColor = .yellow
            btnAction.setTitle("Actualizar", for: .normal)
            
            let result = UsuarioViewModel.GetById(idUsuario: self.idUsuario)
            
            if result.Correct != nil{
                let usuario = result.Object as! Usuario
                
                let fechaNacimiento = usuario.fechaNacimiento
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yy"
                let fechaNacimientoFormatted = dateFormatter.date(from: fechaNacimiento!)
                
                txtIdUsuario.text = "\(usuario.idUsuario!)"
                txtNombreOutlet.text = usuario.nombre
                txtApellidoPaternoOutlet.text = usuario.apellidoPaterno
                txtApellidoMaternoOutlet.text = usuario.apellidoMaterno
                txtUsernameOutlet.text = usuario.username
                txtPasswordOutlet.text = usuario.password
//                txtIdRolOutlet.text = "\(usuario.Rol!.idRol!)"
                dateFechaNacimientoOutlet.date = fechaNacimientoFormatted!
                
                print(self.idUsuario)
                
                self.idUsuario = 0
                print(self.idUsuario)
                print("correcto")
            }
            else{
                print("Ocurrio un error")
            }
        }
//      let result = Usuario.GetAll(dbManager: dbManager)
//        let result = UsuarioViewModel.GetById(idUsuario: 8)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        LimpiarCampos()
        self.idUsuario = 0
        txtNombreOutlet.text = ""
        txtApellidoPaternoOutlet.text = ""
        txtApellidoMaternoOutlet.text = ""
        txtIdUsuario.text = ""
        txtUsernameOutlet.text = ""
        txtPasswordOutlet.text = ""
//        txtIdRolOutlet.text = ""
    }
    
    func LimpiarCampos(){
        txtNombreOutlet.text = ""
        txtApellidoPaternoOutlet.text = ""
        txtApellidoMaternoOutlet.text = ""
        txtIdUsuario.text = ""
        txtUsernameOutlet.text = ""
        txtPasswordOutlet.text = ""
//        txtIdRolOutlet.text = ""
    }
    
    @IBAction func btnSender(_ sender: UIButton) {
//        let btnSeleccionado = sender.titleLabel?.text
        let opcion = btnAction.titleLabel?.text
        
        guard txtNombreOutlet.text != "" else{
            lblNombreError.text = "El nombre no puede estar vacío"
            txtNombreOutlet.layer.borderWidth = 1
            txtNombreOutlet.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        guard txtApellidoPaternoOutlet.text != "" else{
            lblApellidoPaternoError.text = "El apellido paterno no puede estar vacío"
            txtApellidoPaternoOutlet.layer.borderWidth = 1
            txtApellidoPaternoOutlet.layer.borderColor = UIColor.red.cgColor
            return
        }
        
//        guard txtApellidoMaternoOutlet.text != "" else{
//            lblApellidoMaternoError.text = "El apellido materno no puede estar vacío"
//            txtApellidoMaternoOutlet.layer.borderColor = UIColor.red.cgColor
//            return
//        }
        
        guard txtUsernameOutlet.text != "" else{
            lblUsernameError.text = "El username no puede estar vacío"
            txtUsernameOutlet.layer.borderWidth = 1
            txtUsernameOutlet.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        guard txtPasswordOutlet.text != "" else{
            lblPasswordError.text = "El password no puede estar vacío"
            txtPasswordOutlet.layer.borderWidth = 1
            txtPasswordOutlet.layer.borderColor = UIColor.red.cgColor
            return
        }
        
//        guard txtIdRolOutlet.text != "" else{
//            lblIdRolError.text = "El Id del rol no puede estar vacío"
//            txtIdRolOutlet.layer.borderWidth = 1
//            txtIdRolOutlet.layer.borderColor = UIColor.red.cgColor
//            return
//        }
        
        if opcion == "Agregar"{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = formatter.string(from: dateFechaNacimientoOutlet.date)
            
            var usuario = Usuario()
            usuario.Rol = Rol()
            
            usuario.nombre = txtNombreOutlet.text!
            usuario.apellidoPaterno = txtApellidoPaternoOutlet.text!
            usuario.apellidoMaterno = txtApellidoMaternoOutlet.text!
            usuario.fechaNacimiento = formattedDate
            usuario.username = txtUsernameOutlet.text!
            usuario.password = txtPasswordOutlet.text!
            
//            usuario.Rol!.idRol = Int(txtIdRolOutlet.text!)
            usuario.Rol!.idRol = self.idRol
            
            var result : Result = UsuarioViewModel.Add(usuario: usuario)
            
            if(result.Correct == true){
                print("Result Add True")
                
                let alert = UIAlertController(title: "Aviso", message: "Usuario Agregado", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                  dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(action)
                present(alert, animated: true)
            }
            else{
                print("Result Add False")
            }
        }
        
        if opcion == "Actualizar"{
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy"
            let formattedDate = formatter.string(from: dateFechaNacimientoOutlet.date)
            
            var usuario = Usuario()
            usuario.Rol = Rol()
            
            usuario.nombre = txtNombreOutlet.text!
            usuario.apellidoPaterno = txtApellidoPaternoOutlet.text!
            usuario.apellidoMaterno = txtApellidoMaternoOutlet.text!
            usuario.fechaNacimiento = formattedDate
            usuario.username = txtUsernameOutlet.text!
            usuario.password = txtPasswordOutlet.text!
            usuario.idUsuario = Int(txtIdUsuario.text!)
            usuario.Rol!.idRol = self.idRol
            
            
            var result : Result = UsuarioViewModel.Update(usuario: usuario)
            
            if(result.Correct == true){
                print("Result Update Correcto (true)")
                let alert = UIAlertController(title: "Aviso", message: "Usuario Actualizado", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    //                  dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                })
                alert.addAction(action)
                
//                alert.show(alert, sender: self)
                present(alert, animated: true)
            }
            else{
                print("Result Update incorrecto (false)")
            }
        }
        
        
//        if(btnSeleccionado == "Insertar"){
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-yyyy"
//            let formattedDate = formatter.string(from: dateFechaNacimientoOutlet.date)
//
//            var usuario = Usuario()
//
//            usuario.nombre = txtNombreOutlet.text!
//            usuario.apellidoPaterno = txtApellidoPaternoOutlet.text!
//            usuario.apellidoMaterno = txtApellidoMaternoOutlet.text!
//            usuario.fechaNacimiento = formattedDate
//            usuario.username = txtUsernameOutlet.text!
//            usuario.password = txtPasswordOutlet.text!
//
//            var result : Result = UsuarioViewModel.Add(usuario: usuario)
//
//            if(result.Correct == true){
//                print("Result Add True")
//                let getAllController = GetAllUsuarioController()
////                getAllController.UpdateUI()
//                GetAllUsuarioController().tableView.reloadData()
//            }
//            else{
//                print("Result Add False")
//            }
//        }
        
//        if(btnSeleccionado == "Actualizar"){
//            let formatter = DateFormatter()
//            formatter.dateFormat = "dd-MM-yyyy"
//            let formattedDate = formatter.string(from: dateFechaNacimientoOutlet.date)
//
//            var usuario = Usuario()
//
//            usuario.nombre = txtNombreOutlet.text!
//            usuario.apellidoPaterno = txtApellidoPaternoOutlet.text!
//            usuario.apellidoMaterno = txtApellidoMaternoOutlet.text!
//            usuario.fechaNacimiento = formattedDate
//            usuario.username = txtUsernameOutlet.text!
//            usuario.password = txtPasswordOutlet.text!
//            usuario.idUsuario = Int(txtIdUsuario.text!)
//
//            var result : Result = UsuarioViewModel.Update(usuario: usuario)
//
//            if(result.Correct == true){
//                print("Result Update Correcto (true)")
//            }
//            else{
//                print("Result Update incorrecto (false)")
//            }
//        }
        
        
        
        //    @IBAction func btnAddAction() {
        //
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "dd-MM-yyyy"
        //        let formattedDate = formatter.string(from: dateFechaNacimientoOutlet.date)
        //
        //        var usuario = Usuario()
        //
        //        usuario.nombre = txtNombreOutlet.text!
        //        usuario.apellidoPaterno = txtApellidoPaternoOutlet.text!
        //        usuario.apellidoMaterno = txtApellidoMaternoOutlet.text!
        //        usuario.fechaNacimiento = formattedDate
        //        usuario.username = txtUsernameOutlet.text!
        //        usuario.password = txtPasswordOutlet.text!
        //
        //        Usuario.Add(usuario: usuario, dbManager: dbManager)
        //
        //        print("Nombre: \(txtNombreOutlet.text!)")
        //        print("Apellido Paterno: \(txtApellidoPaternoOutlet.text!)")
        //        print("Apellido Materno: \(txtApellidoMaternoOutlet.text!)")
        //        //        print("Fecha de Nacimiento: \(dateFechaNacimientoOutlet.date)")
        //        print("Fecha de Nacimiento: \(formattedDate)")
        //        print("Username: \(txtUsernameOutlet.text!)")
        //        print("Password: \(txtPasswordOutlet.text!)")
        //    }
        //
        //
        //    @IBAction func btnDelete() {
        //        var idUsuario = Int32(txtIdUsuario.text!)!
        //        Usuario.Delete(idUsuario: idUsuario, dbManager: dbManager)
        //    }
        //
        //    @IBAction func btnUpdateAction() {
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "dd-MM-yyyy"
        //        let formattedDate = formatter.string(from: dateFechaNacimientoOutlet.date)
        //
        //        var usuario = Usuario()
        //
        //        usuario.nombre = txtNombreOutlet.text!
        //        usuario.apellidoPaterno = txtApellidoPaternoOutlet.text!
        //        usuario.apellidoMaterno = txtApellidoMaternoOutlet.text!
        //        usuario.fechaNacimiento = formattedDate
        //        usuario.username = txtUsernameOutlet.text!
        //        usuario.password = txtPasswordOutlet.text!
        //        usuario.idUsuario = Int32(txtIdUsuario.text!)
        //
        //         Usuario.Update(usuario: usuario, dbManager: dbManager)
        //    }
        //
        
    }
    
}
