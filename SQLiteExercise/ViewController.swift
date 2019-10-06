//
//  ViewController.swift
//  SQLiteExercise
//
//  Created by Camilo Cabana on 10/5/19.
//  Copyright © 2019 Camilo Cabana. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        var dbPointer: OpaquePointer?
        do {
            let fileUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("HeroDatabase.sqlite")
            
            if sqlite3_open(fileUrl.path, &dbPointer) != SQLITE_OK {
                print("error opening data base!!")
                return
            }
            
            let tableQuery = "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"
            
            if sqlite3_exec(dbPointer, tableQuery, nil, nil, nil) != SQLITE_OK {
                print("error creating table!!")
                return
            }
            
            var statement: OpaquePointer?
            let insertStatement = "INSERT INTO Heroes(name) VALUES ('Minami Kikuchi') "
            
            sqlite3_prepare_v2(dbPointer, insertStatement, -1, &statement, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("error inserted element!!")
            }
            sqlite3_finalize(statement)
            
            var selectStatement: OpaquePointer?
            let selectSql = "select * from Heroes"
            if sqlite3_prepare_v2(dbPointer, selectSql, -1, &selectStatement, nil) == SQLITE_OK {
                while sqlite3_step(selectStatement) == SQLITE_ROW {
                    let rowId = sqlite3_column_int(selectStatement, 0)
//                    let name = UnsafePointer<cc_t>(sqlite3_column_text(selectStatement, 1))
                    let name = sqlite3_column_text(selectStatement, 1)
                    let stringName = String(cString: name!)
                    print("\(rowId): \(stringName)")
                }
            }
            sqlite3_finalize(selectStatement)
        
        } catch { }
        
        
    }


}

