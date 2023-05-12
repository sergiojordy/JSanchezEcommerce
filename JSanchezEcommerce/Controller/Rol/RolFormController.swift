//
//  RolFormController.swift
//  JSanchezEcommerce
//
//  Created by MacBookMBA6 on 09/05/23.
//

import UIKit
import SwipeCellKit

class RolFormController: UIViewController {

    @IBOutlet weak var txtIdRolOutlet: UITextField!
    
    @IBOutlet weak var txtNombreRolOutlet: UITextField!
    
    @IBOutlet weak var lblErrorNombreRol: UILabel!
    
    @IBOutlet weak var btnActionOutlet: UIButton!
    
    var idRol : Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
//        let result = RolViewModel.GetAll()
        if idRol == 0{
            print("Id Rol Form: \(self.idRol)")
            btnActionOutlet.backgroundColor = .green
            btnActionOutlet.setTitle("Agregar", for: .normal)
        }
        else{
            btnActionOutlet.backgroundColor = .yellow
            btnActionOutlet.setTitle("Actualizar", for: .normal)
            
            let result = RolViewModel.GetById(idRol: self.idRol)
            
            if result.Correct! == true{
                let rol = result.Object as! Rol
                
                txtIdRolOutlet.text = "\(rol.idRol!)"
                txtNombreRolOutlet.text = rol.nombre
                print("GetByID Correcto")
            }
            else{
                print("Ocurrio un error")
            }
        }

    }
    
    @IBAction func btnAction(_ sender: UIButton) {
        print("Hola soy boton de form rol")
        let opcion = btnActionOutlet.titleLabel?.text
        
        guard txtNombreRolOutlet.text != "" else{
            lblErrorNombreRol.text = "El nombre no puede estar vacío"
            txtNombreRolOutlet.layer.borderWidth = 1
            txtNombreRolOutlet.layer.borderColor = UIColor.red.cgColor
            return
        }
        
        if opcion == "Agregar"{
            var rol = Rol()
            rol.nombre = txtNombreRolOutlet.text!
            
            var result = RolViewModel.Add(rol: rol)
            
            if result.Correct == true {
                print("Result Add True")
                
                let alert = UIAlertController(title: "Aviso", message: "Rol Agregado", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(action)
                present(alert, animated: true)
            }
            else{
                print("Ocurrio un error")
            }
        }
        
        if opcion == "Actualizar"{
            var rol = Rol()
            rol.idRol = Int(txtIdRolOutlet.text!)
            rol.nombre = txtNombreRolOutlet.text!
            
            var result : Result = RolViewModel.Update(rol: rol)
            
            if result.Correct == true{
                print("Result Update True")
                
                let alert = UIAlertController(title: "Aviso", message: "Usuario Actualizado", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
//                    self.dismiss(animated: true)
                    self.navigationController?.popViewController(animated: true)
                })
                
                alert.addAction(action)
                present(alert, animated: true)
            }
            else{
                print("Ocurrio un error")
            }
        }
    }
    
    func LimpiarCampos(){
        txtIdRolOutlet.text = ""
        txtNombreRolOutlet.text = ""
    }
    
}
