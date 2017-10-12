//
//  ViewController.swift
//  RandomUsers
//
//  Created by Norbert Szydłowski on 10/10/2017.
//  Copyright © 2017 Norbert Szydłowski. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var viewModel: ViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewModel = ViewModel(networkDataProvider: API(), localDataProvider: Database(), reloadViewCallback: {
            self.tableView.reloadData()
        })
        
        self.viewModel.fetchData()
        
    }

    @IBAction func textFieldChange(_ sender: UITextField) {
        
        self.viewModel.searchTextDidChange(text: sender.text!)
        
    }
}



extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! UserCell

        self.viewModel.changeStateInDatabase(index: indexPath.row) { saved in
            cell.setSaved(saved: saved)
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.size()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier:UserCell.cellIdentifier, for: indexPath) as! UserCell
        
        self.viewModel.itemAtIndex(index: indexPath.row) { user, saved  in
            cell.setUser(user: user)
            cell.setSaved(saved: saved)
        }
        
        return cell
    }

    
}

