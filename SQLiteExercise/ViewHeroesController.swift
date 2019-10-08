//
//  ViewHeroesController.swift
//  SQLiteExercise
//
//  Created by Camilo Cabana on 10/8/19.
//  Copyright © 2019 Camilo Cabana. All rights reserved.
//

import UIKit

class ViewHeroesController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var heroesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return heroes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "heroes") as! TableViewHeroesCell
        cell.id.text = String(heroes[indexPath.row].id)
        cell.name.text = heroes[indexPath.row].name
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
