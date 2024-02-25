//
//  ViewController.swift
//  FilterUiUsingUIKit
//
//  Created by Satyabrata Das on 18/02/24.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate{
    
    
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    let identifiewrForCell = "TableViewCell"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.bottomView.layer.borderWidth = 1
//        self.bottomView.layer.borderColor = UIColor.lightGray.cgColor
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self
        self.filtersTableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: identifiewrForCell)
        self.filtersTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
    }

    @IBAction func clearallFilterBtn(_ sender: UIButton) {
        print("Clear all Pressed")
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        print("Cancel Pressed")
    }
    
    @IBAction func applyBtn(_ sender: UIButton) {
        print("Apply btn Pressed")
    }
}

extension ViewController{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TableViewCell = tableView.dequeueReusableCell(withIdentifier: identifiewrForCell, for: indexPath) as! TableViewCell
        if indexPath.row == 0{
            cell.cellTxt.text = "Category"
        }else{
            cell.cellTxt.text = "Price"
        }
        cell.backgroundColor = .cyan
        return cell
        
    }


}

