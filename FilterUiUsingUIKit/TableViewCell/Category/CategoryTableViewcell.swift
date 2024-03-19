//
//  CategoryTableViewcell.swift
//  FilterUiUsingUIKit
//
//  Created by Satyabrata Das on 19/03/24.
//

import UIKit

protocol CategoryFilter{
    func selectedCategoryFilter(selectedRow: [Int]?, section: Int?)
}

class CategoryTableViewcell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
   

    @IBOutlet weak var categoryListTableview: UITableView!
     var delegate: CategoryFilter?
    var categoryItems : [String]? = nil
    var selectedRow = [Int]()
    let cellIdentifier = "TableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.categoryListTableview.delegate = self
        self.categoryListTableview.dataSource = self
        self.categoryListTableview.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.categoryListTableview.separatorStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

extension CategoryTableViewcell{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categoryItems = self.categoryItems{
            return categoryItems.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        if let categoryItems = categoryItems{
            let title = categoryItems[indexPath.row]
            cell.sectionCellName.text = title
            
            if  indexPath.row == selectedRow.first{
                cell.typeofSelectedBtn.image = UIImage(named: "radioBtnActive")
            }else{
                cell.typeofSelectedBtn.image = UIImage(named: "radioBtnDeactive")
            }
            cell.selectionStyle = .none
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = [indexPath.row]
        delegate?.selectedCategoryFilter(selectedRow: self.selectedRow, section: indexPath.section)
        tableView.reloadData()
    }
}
