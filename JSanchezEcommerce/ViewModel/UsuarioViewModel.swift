//
//  UsuarioViewModel.swift
//  JSanchezEcommerce
//
//  Created by MacBookMBA6 on 04/05/23.
//

import Foundation
import SQLite3

class UsuarioViewModel{
    
    
    static func Add(usuario: Usuario) -> Result{
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        
        var query = "INSERT INTO Usuario(Nombre, ApellidoPaterno, ApellidoMaterno,FechaNacimiento,Username,Password, IdRol) VALUES(?,?,?,?,?,?,\(usuario.Rol!.idRol!));"
        do{
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                sqlite3_bind_text(statement, 1, (usuario.nombre as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (usuario.apellidoPaterno as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (usuario.apellidoMaterno as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 4, (usuario.fechaNacimiento as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 5, (usuario.username as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 6, (usuario.password as! NSString).utf8String, -1, nil)
                
                if try(sqlite3_step(statement) == SQLITE_DONE){
                    print("Usuario Insertado")
                    result.Correct = true
                }
                else{
                    print("Error al insertar usuario")
                    result.Correct = false
                }
            }
            else{
                print("Ocurrio un error")
                result.Correct = false
            }
        }
        catch var error{
            result.Correct = false
            result.ErrorMessage = error.localizedDescription
            result.Ex = error
        }
        sqlite3_finalize(statement)
        sqlite3_close(context.db)
        return result
        
    }
    
    static func Update(usuario: Usuario) ->Result{
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        
        var query = "UPDATE Usuario SET Nombre = ?, ApellidoPaterno = ?, ApellidoMaterno = ?, FechaNacimiento = ?, Username = ?, Password = ?, IdRol = \(usuario.Rol!.idRol!) WHERE IdUsuario = \(usuario.idUsuario!)"
        
        do{
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                sqlite3_bind_text(statement, 1, (usuario.nombre as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 2, (usuario.apellidoPaterno as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 3, (usuario.apellidoMaterno as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 4, (usuario.fechaNacimiento as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 5, (usuario.username as! NSString).utf8String, -1, nil)
                sqlite3_bind_text(statement, 6, (usuario.password as! NSString).utf8String, -1, nil)
                //            sqlite3_bind_int(statement, 7, usuario.idUsuario!)
                
                if try(sqlite3_step(statement) == SQLITE_DONE){
                    result.Correct = true
                    print("Usuario Actualizado")
                }
                else{
                    result.Correct = false
                    print("Error al actualizar usuario")
                }
            }
            else{
                result.Correct = false
                print("Ocurrio un error")
            }
        }
        catch var error{
            result.Correct = false
            result.ErrorMessage = error.localizedDescription
            result.Ex = error
        }
        sqlite3_finalize(statement)
        sqlite3_close(context.db)
        return result
    }
    
    static func Delete(idUsuario: Int) -> Result{
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        let query = "DELETE FROM Usuario WHERE IdUsuario =\(idUsuario)"
        
        do{
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                if try(sqlite3_step(statement) == SQLITE_DONE){
                    result.Correct = true
                    print("Usuario eliminado")
                }
                else{
                    result.Correct = false
                    print("Error al eliminar usuario")
                }
            }
            else{
                print("Ocurrio un error")
            }
            
        }
        catch var error{
            result.Correct = false
            result.ErrorMessage = error.localizedDescription
            result.Ex = error
        }
        sqlite3_finalize(statement)
        sqlite3_close(context.db)
        return result
    }
    
    
    static func GetAll() -> Result{
        let context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        let query = "SELECT Usuario.IdUsuario, Usuario.Nombre, Usuario.ApellidoPaterno, Usuario.ApellidoMaterno, Usuario.FechaNacimiento, Usuario.Username, Usuario.Password, Usuario.IdRol AS 'Rol', Rol.Nombre AS 'NombreRol' FROM Usuario INNER JOIN Rol ON Rol.IdRol = Usuario.IdRol"
        
        do {
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                result.Objects = []
                while try sqlite3_step(statement) == SQLITE_ROW {
                    var usuario = Usuario()
                    usuario.Rol = Rol()
                    
                    usuario.idUsuario = Int(sqlite3_column_int(statement, 0))
                    usuario.nombre = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    usuario.apellidoPaterno = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    usuario.apellidoMaterno = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                    usuario.fechaNacimiento = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                    usuario.username = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                    usuario.password = String(describing: String(cString: sqlite3_column_text(statement, 6)))
                    
                    usuario.Rol?.idRol = Int(sqlite3_column_int(statement, 7))
                    usuario.Rol?.nombre = String(describing: String(cString: sqlite3_column_text(statement, 8)))
                    
                    result.Objects?.append(usuario)
                    print(usuario.idUsuario!)
                    print(usuario.nombre!)
                    print(usuario.apellidoPaterno!)
                    print(usuario.apellidoMaterno!)
                    print(usuario.fechaNacimiento!)
                    print(usuario.username!)
                    print(usuario.password!)
                    print(usuario.Rol!.idRol!)
                    print(usuario.Rol!.nombre!)
                }
                result.Correct = true
            }
            else{
                result.Correct = false
//                result.ErrorMessage = "Ocurrio un error"
            }
        }
        catch var error{
            result.Correct = false
            result.ErrorMessage = error.localizedDescription
            result.Ex = error
        }
        sqlite3_finalize(statement)
        sqlite3_close(context.db)
        return result
    }
    
    static func GetById(idUsuario : Int) -> Result{
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        let query = "SELECT Usuario.IdUsuario, Usuario.Nombre, Usuario.ApellidoPaterno, Usuario.ApellidoMaterno, Usuario.FechaNacimiento, Usuario.Username, Usuario.Password, Usuario.IdRol AS 'Rol', Rol.Nombre AS 'NombreRol' FROM Usuario INNER JOIN Rol ON Rol.IdRol = Usuario.IdRol WHERE IdUsuario = \(idUsuario)"
        do{
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                while try sqlite3_step(statement) == SQLITE_ROW{
                    var usuario = Usuario()
                    usuario.Rol = Rol()
                    
                    usuario.idUsuario = Int(sqlite3_column_int(statement, 0))
                    usuario.nombre = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    usuario.apellidoPaterno = String(describing: String(cString: sqlite3_column_text(statement, 2)))
                    usuario.apellidoMaterno = String(describing: String(cString: sqlite3_column_text(statement, 3)))
                    usuario.fechaNacimiento = String(describing: String(cString: sqlite3_column_text(statement, 4)))
                    usuario.username = String(describing: String(cString: sqlite3_column_text(statement, 5)))
                    usuario.password = String(describing: String(cString: sqlite3_column_text(statement, 6)))
                    
                    usuario.Rol?.idRol = Int(sqlite3_column_int(statement, 7))
                    usuario.Rol?.nombre = String(describing: String(cString: sqlite3_column_text(statement, 8)))
                    
                    result.Object = usuario
                    
                    print(usuario.idUsuario!)
                    print(usuario.nombre!)
                    print(usuario.apellidoPaterno!)
                    print(usuario.apellidoMaterno!)
                    print(usuario.fechaNacimiento!)
                    print(usuario.username!)
                    print(usuario.password!)
                    print(usuario.Rol!.idRol!)
                    print(usuario.Rol!.nombre!)
                }
                result.Correct = true
                
            }
            else{
                print("Ocurrio un error")
            }
        }
        catch var error{
            result.Correct = false
            result.ErrorMessage = error.localizedDescription
            result.Ex = error
        }
        sqlite3_finalize(statement)
        sqlite3_close(context.db)
        return result
    }
}
