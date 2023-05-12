//
//  GetAllUsuarioController.swift
//  JSanchezEcommerce
//
//  Created by MacBookMBA6 on 03/05/23.
//

import UIKit
import SwipeCellKit

class GetAllUsuarioController: UITableViewController {
    
    var usuarios : [Usuario] = []
    var idUsuario : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "UsuarioCell", bundle: .main), forCellReuseIdentifier: "usuarioCustomCell")
        self.UpdateUI()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.UpdateUI()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return usuarios.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "usuarioCustomCell", for: indexPath) as! UsuarioCell
        cell.delegate = self
        cell.lblIdUsuarioOutlet.text = "Id: \(usuarios[indexPath.row].idUsuario!)"
        cell.lblNombreOutlet.text = "Nombre: \(usuarios[indexPath.row].nombre!) \(usuarios[indexPath.row].apellidoPaterno!) \(usuarios[indexPath.row].apellidoMaterno!)"
        cell.lblUsernameOutlet.text = "Username: \(usuarios[indexPath.row].username!)"
        cell.lblFechaNacimientoOutlet.text = "Nacimiento: \(usuarios[indexPath.row].fechaNacimiento!)"
        cell.lblRolOutlet.text = "\(usuarios[indexPath.row].Rol!.nombre!)"
        return cell

    }
    

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension GetAllUsuarioController : SwipeTableViewCellDelegate{
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        if orientation == .right{
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//                self.tableView.reloadData()
//                print(indexPath.row)
//                print("Funcion borrar")
                
                var result = UsuarioViewModel.Delete(idUsuario: self.usuarios[indexPath.row].idUsuario!)
                
                if(result.Correct!){
                    print("Usuario eliminado")
                    self.UpdateUI()
                }
                else{
                    print("Error al eliminar usuario")
                }
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            // customize the action appearance
//            deleteAction.image = UIImage(named: "delete")
            return [deleteAction]
        }
        
        if orientation == .left{
            let updateAction = SwipeAction(style: .default, title: "Update") { action, indexPath in
//                self.tableView.reloadData()
//                print(indexPath.row)
//                print("Funcion actualizar")
                self.idUsuario = self.usuarios[indexPath.row].idUsuario!
                self.performSegue(withIdentifier: "formularioSegues", sender: self)
            }

            return [updateAction]
        }
           return nil
    }
    
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
//        var options = SwipeOptions()
//        options.expansionStyle = .destructive
//        options.transitionStyle = .border
//        return options
//    }
    
    func UpdateUI(){
        var result = UsuarioViewModel.GetAll()
        usuarios.removeAll()
        if result.Correct!{
            for objUsuario in result.Objects!{
                let usuario = objUsuario as! Usuario // Unboxing con casting
                usuarios.append(usuario)
            }
            // Recarga el tableView.
            tableView.reloadData()
        }
        else{
            print("Ocurrio un error \(result.ErrorMessage)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "formularioSegues"{
            // el segue de destino se castea a tipo FormController para cambiar los valores de la clase FormController
            let formController = segue.destination as! FormController
            formController.idUsuario = self.idUsuario
            print(self.idUsuario)
        }
    }
    
}


