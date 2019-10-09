//
//  ViewController.swift
//  SQLiteExercise
//
//  Created by Camilo Cabana on 10/5/19.
//  Copyright © 2019 Camilo Cabana. All rights reserved.
//

import UIKit

var heroes = [Heroes]()

class ViewController: UIViewController {
    
    var dbPointer: OpaquePointer?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        do {
            let fileUrl = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("HeroDatabase.sqlite")
            
            if sqlite3_open(fileUrl.path, &dbPointer) != SQLITE_OK {
                print("error opening data base!!")
                return
            } else {
                print("data base opened")
            }
            
            let tableQuery = "CREATE TABLE IF NOT EXISTS Heroes (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)"
            
            if sqlite3_exec(dbPointer, tableQuery, nil, nil, nil) != SQLITE_OK {
                print("error creating table!!")
                return
            } else {
                print("table created")
            }
        
        } catch { }
        
        
    }
    
    
    @IBAction func addButton(_ sender: UIButton) {
        let alert = UIAlertController(title: "Add", message: "Please Add a Hero", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Add a name"
            textField.textAlignment = .right
        }
        let actionOne = UIAlertAction(title: "Add", style: .default) { (actionOne) in
            let heroName = alert.textFields?[0].text
            var statement: OpaquePointer?
            let insertStatement = "INSERT INTO Heroes(name) VALUES ('\(heroName!)')"
            sqlite3_prepare_v2(self.dbPointer, insertStatement, -1, &statement, nil)
            
            if sqlite3_step(statement) != SQLITE_DONE {
                print("error inserted element!!")
            } else {
                print("element inserted")
            }
            sqlite3_finalize(statement)
            
        }
        let actionTwo = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func listButton(_ sender: Any) {
        var selectStatement: OpaquePointer?
        let selectSql = "select * from Heroes"
        var hero = Heroes(name: "", id: 0)
        heroes = []
        if sqlite3_prepare_v2(dbPointer, selectSql, -1, &selectStatement, nil) == SQLITE_OK {
            while sqlite3_step(selectStatement) == SQLITE_ROW {
                let rowId = sqlite3_column_int(selectStatement, 0)
                let name = sqlite3_column_text(selectStatement, 1)
                let stringName = String(cString: name!)
                hero.id = rowId
                hero.name = stringName
                heroes.append(hero)
            }
        }
        sqlite3_finalize(selectStatement)
    }
    
    
    @IBAction func deleteButton(_ sender: Any) {
        let alert = UIAlertController(title: "Delete a hero", message: "with the id of the hero", preferredStyle: .alert)
        alert.addTextField { (textFiled) in
            textFiled.placeholder = "ID"
            textFiled.textAlignment = .right
        }
        let actionOne = UIAlertAction(title: "Delere", style: .default) { (actionOne) in
            let id = alert.textFields?[0].text
            var statement: OpaquePointer?
            let deleteSQL = "DELETE FROM heroes WHERE id = ?"
            if sqlite3_prepare_v2(self.dbPointer, deleteSQL, -1, &statement, nil) == SQLITE_OK {

                sqlite3_bind_int(statement, 1, Int32(id!)!)

                if sqlite3_step(statement) == SQLITE_DONE {
                    print("Successfully deleted row.")
                } else {
                    print("Could not delete row.")
                }
            } else {
                print("DELETE statement could not be prepared")
            }
            sqlite3_finalize(statement)
        }
        let actionTwo = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func updateButton(_ sender: Any) {
        let alert = UIAlertController(title: "Update", message: "Update a Hero", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.textAlignment = .right
            textField.placeholder = "ID"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.textAlignment = .right
        }
        let actionOne = UIAlertAction(title: "Update", style: .default) { (actionOne) in
            let id = alert.textFields?[0].text
            let name = alert.textFields?[1].text
            var statement: OpaquePointer?
            let updateSQL = "UPDATE heroes SET name = '\(name!)' WHERE id = \(id!);"
            if sqlite3_prepare_v2(self.dbPointer, updateSQL, -1, &statement, nil) == SQLITE_OK {
              if sqlite3_step(statement) == SQLITE_DONE {
                print("Successfully updated row.")
              } else {
                print("Could not update row.")
              }
            } else {
              print("UPDATE statement could not be prepared")
            }
            sqlite3_finalize(statement)
        }
        let actionTwo = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(actionOne)
        alert.addAction(actionTwo)
        present(alert, animated: true, completion: nil)
        
//        let updateStatementString = "UPDATE heroes SET name = 'Chris' WHERE id = 10;"
//        var updateStatement: OpaquePointer? = nil
//        if sqlite3_prepare_v2(dbPointer, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
//            if sqlite3_step(updateStatement) == SQLITE_DONE {
//                print("Successfully updated row.")
//            } else {
//                print("Could not update row.")
//            }
//
//        } else {
//            print("UPDATE statement could not be prepared")
//
//        }
//        sqlite3_finalize(updateStatement)
    }
    
    
}

