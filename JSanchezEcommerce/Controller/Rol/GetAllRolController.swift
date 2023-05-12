//
//  GetAllRolController.swift
//  JSanchezEcommerce
//
//  Created by MacBookMBA6 on 09/05/23.
//

import UIKit
import SwipeCellKit

// MARK: Main
class GetAllRolController: UIViewController {
    
    
    @IBOutlet weak var tableViewRol: UITableView!
    
    var roles : [Rol] = []
    var idRol : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewRol.delegate = self
        tableViewRol.dataSource = self
        tableViewRol.register(UINib(nibName: "RolCell", bundle: .main), forCellReuseIdentifier: "rolCustomCell")
        
        self.UpdateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateUI()
    }
    
    
    func UpdateUI(){
        var result = RolViewModel.GetAll()
        roles.removeAll()
        if result.Correct!{
            for objRol in result.Objects!{
                let rol = objRol as! Rol // Unboxing con casting
                roles.append(rol)
            }
            // Recarga el tableView.
            tableViewRol.reloadData()
        }
        else{
            print("Ocurrio un error \(result.ErrorMessage)")
        }
    }
    
    
    
}

// MARK: TableView
extension GetAllRolController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rolCustomCell", for: indexPath) as! RolCell
        cell.delegate = self
        cell.lblIdRolOutlet.text = "Id: \(roles[indexPath.row].idRol!)"
        cell.lblNombreRolOutlet.text = "\(roles[indexPath.row].nombre!)"
        return cell
    }
    
}


// MARK: SwipeCellKit
extension GetAllRolController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        //        guard orientation == .right else { return nil }
        
        if orientation == .right{
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                var result = RolViewModel.Delete(idRol: self.roles[indexPath.row].idRol!)
                
                if result.Correct == true{
                    print("Rol eliminado")
                    self.UpdateUI()
                }
                else{
                    print("Ocurrio un error")
                }
            }
            return [deleteAction]
        }
        
        if orientation == .left{
            let updateAction = SwipeAction(style: .default, title: "Update") { action, indexPath in
                print("LEFT")
                self.idRol = self.roles[indexPath.row].idRol!
                self.performSegue(withIdentifier: "formularioRolSegue", sender: self)
            }
            return [updateAction]
        }
        return nil
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "formularioRolSegue"{
            // el segue de destino se castea a tipo FormController para cambiar los valores de la clase FormController
            let formController = segue.destination as! RolFormController
            formController.idRol = self.idRol
            print("ID ROL: \(self.idRol)")
        }
    }
    
}
