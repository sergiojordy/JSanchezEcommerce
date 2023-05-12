//
//  RolViewModel.swift
//  JSanchezEcommerce
//
//  Created by MacBookMBA6 on 09/05/23.
//

import Foundation
import SQLite3

class RolViewModel{
    
    static func Add(rol: Rol) -> Result{
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        var query = "INSERT INTO Rol(Nombre) VALUES(?);"
        
        do{
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                sqlite3_bind_text(statement, 1, (rol.nombre as! NSString).utf8String, -1, nil)
                
                if try(sqlite3_step(statement) == SQLITE_DONE){
                    print("Rol Insertado")
                    result.Correct = true
                }
                else{
                    print("Error al insertar Rol")
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
    
    
    static func Update(rol: Rol) -> Result{
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        var query = "UPDATE Rol SET Nombre = ? WHERE IdRol = \(rol.idRol!);"
        
        do{
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                sqlite3_bind_text(statement, 1, (rol.nombre as! NSString).utf8String, -1, nil)
                
                if try(sqlite3_step(statement) == SQLITE_DONE){
                    result.Correct = true
                    print("Rol Actualizado")
                }
                else{
                    result.Correct = false
                    print("Error al actualizar Rol")
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
    
    
    
    static func Delete(idRol: Int) -> Result{
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        var query = "DELETE FROM Rol WHERE IdRol = \(idRol);"
        
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
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        var query = "SELECT IdRol, Nombre FROM Rol"
        
        do{
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                result.Objects = []
                while try sqlite3_step(statement) == SQLITE_ROW {
                    var rol = Rol()
                    rol.idRol = Int(sqlite3_column_int(statement, 0))
                    rol.nombre = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                    
                    result.Objects?.append(rol)
                    print(rol.idRol!)
                    print(rol.nombre!)
                  
                }
                result.Correct = true
            }
            else{
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
    
    static func GetById(idRol: Int) -> Result{
        var context = DBManager()
        var result = Result()
        var statement : OpaquePointer? = nil
        var query = "SELECT IdRol, Nombre FROM Rol WHERE IdRol = \(idRol)"
        
        do{
            if try(sqlite3_prepare_v2(context.db, query, -1, &statement, nil) == SQLITE_OK){
                while try sqlite3_step(statement) == SQLITE_ROW{
                    var rol = Rol()
                    rol.idRol = Int(sqlite3_column_int(statement, 0))
                    rol.nombre = String(describing: String(cString: sqlite3_column_text(statement, 1)))
                                        
                    result.Object = rol
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
