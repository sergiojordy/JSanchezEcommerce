//
//  DBManager.swift
//  JSanchezEcommerce
//
//  Created by MacBookMBA6 on 28/04/23.
//

import Foundation
import SQLite3

class DBManager{

    var db : OpaquePointer?
    let path : String = "Document.JSanchezEcommerce.sqlite"
    
    init(){
        self.db = Get()
    }
    
    func Get() -> OpaquePointer?{
        
        let filePath = try! FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(path)
        
        if (sqlite3_open(filePath.path, &db) == SQLITE_OK){
            print("Conexion exitosa")
            print(filePath)
            return db
        }
        else{
            print("Conexion fallida")
            return nil
        }
    }
//    let dbPath : String = "JSanchezEcommerce.sqlite"
//    var db : OpaquePointer?
    
//    init(){
//        db = Get()
//        createTable()
//    }
    
//    func Get() -> OpaquePointer?{
//        let filePath = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent(dbPath)
//
//        var db : OpaquePointer? = nil
//
//        if sqlite3_open(filePath.path, &db) != SQLITE_OK{
//            debugPrint("No se puede abrir la base de datos")
//            return nil
//        }
//        else{
//            print("Conexion creada correctamente a: \(dbPath)")
//            return db
//        }
//    }
    
//    func createTable(){
//        let createTableString = "CREATE TABLE IF NOT EXISTS Usuario(IdUsuario INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, Nombre TEXT NOT NULL, ApellidoPaterno TEXT NOT NULL, ApellidoMaterno TEXT NOT NULL, FechaDeNacimiento TEXT NOT NULL, Username TEXT NOT NULL UNIQUE, Password TEXT NOT NULL);"
//
//        var createTableStatement : OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK{
//            if sqlite3_step(createTableStatement)==SQLITE_DONE{
//                print("Tabla creada")
//            }
//            else{
//                print("Error al crear la tabla")
//            }
//        }
//        else{
//            print("Error con la sentencia CREATE TABLE. No pudo ser preparada")
//        }
//        sqlite3_finalize(createTableStatement)
//    }
}
