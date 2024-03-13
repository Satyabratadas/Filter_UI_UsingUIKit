//
//  ViewController.swift
//  FilterUiUsingUIKit
//
//  Created by Satyabrata Das on 18/02/24.
//

import UIKit

struct Section {
    var mainCellTitle: String
    var expandableCellOptions: [String]
    var isExpandableCellsHidden: Bool
}

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, CGFilterPriceTableViewCellDelegate{
    func cgFilterPriceTableViewCellDelegatePriceChange(minSelectedValue: Int, maxSelectedValue: Int) {
        print("maxvalue\(maxSelectedValue), minvalue\(minSelectedValue)")
    }
    
    
    
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    let tapableCellIdentifier = "TableViewCellForTapableSection"
    let sliderCellIdentifier = "CGFilterPriceTableViewCell"
    let cellIdentifier = "TableViewCell"
    var category = ["Banner", "Canvas Photo", "Bookmark","Banner", "Canvas Photo", "Bookmark","Banner", "Canvas Photo", "Bookmark"]
    var sortBy = ["A-Z", "Z-A"]
    var color = ["Red", "Green", "Blue"]
    var size = ["Regular", "Large", "Medium"]
    var sections: [Section] = []
    var selectedCells : [IndexPath:String] = [:]
    
    
    override func viewDidLoad() {
        
        sections.append(Section(mainCellTitle: "CATEGORIES", expandableCellOptions: category, isExpandableCellsHidden: false))
        sections.append(Section(mainCellTitle: "PRICE", expandableCellOptions: [], isExpandableCellsHidden: true))
        sections.append(Section(mainCellTitle: "Sort By", expandableCellOptions: sortBy, isExpandableCellsHidden: true))
        sections.append(Section(mainCellTitle: "Color", expandableCellOptions: color, isExpandableCellsHidden: true))
        sections.append(Section(mainCellTitle: "Size", expandableCellOptions: size, isExpandableCellsHidden: true))
        self.filtersTableView.register(UINib(nibName: tapableCellIdentifier, bundle: nil), forCellReuseIdentifier: tapableCellIdentifier)
        self.filtersTableView.register(UINib(nibName: sliderCellIdentifier, bundle: nil), forCellReuseIdentifier: sliderCellIdentifier)
        self.filtersTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self
        self.filtersTableView.separatorStyle = .none
        super.viewDidLoad()
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        if !section.isExpandableCellsHidden {
            return section.expandableCellOptions.count + 1
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            // Load a different cell for a specific section
            let cell = tableView.dequeueReusableCell(withIdentifier: sliderCellIdentifier, for: indexPath) as! CGFilterPriceTableViewCell
            cell.sliderCellHeader.text = sections[indexPath.section].mainCellTitle
            cell.delegate = self
            cell.setPrice(minPrice: 0, maxPrice: 5000)
            cell.setSelectedPrice(minSelectedPrice: 0 , maxSelectedPrice: 5000)
//            cell.sliderHeader.text = sections[indexPath.section].mainCellTitle
            // Configure the cell as needed
            return cell
        }else{
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: tapableCellIdentifier, for: indexPath) as! TableViewCellForTapableSection
                cell.cellHeaderTxt.text = sections[indexPath.section].mainCellTitle
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
                if let selectedData = selectedCells[indexPath] {
                        cell.sectionCellName.text = selectedData
                        if indexPath.section == 4{
                            cell.typeofSelectedBtn.image = UIImage(named: "COVID_Address_checkBox")
                        }else{
                            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnActive")
                        }
                    
                } else {
                    cell.sectionCellName.text = sections[indexPath.section].expandableCellOptions[indexPath.row - 1]
                    if indexPath.section == 4{
                        cell.typeofSelectedBtn.image = UIImage(named: "COVID_Address_unCheckBox")
                    }else{
                        cell.typeofSelectedBtn.image = UIImage(named: "radioBtnDeactive")
                    }
                }
                return cell
            }
        }
       
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 1{
            if indexPath.row != 0{
                var selectedFilters : [String] = []
                if indexPath.section == 4{
                    if let selectedCell = tableView.cellForRow(at: indexPath) as? TableViewCell{
                        selectedCell.typeofSelectedBtn.image = UIImage(named: "COVID_Address_checkBox")
                        if let selectFilter = selectedCell.sectionCellName.text{
                            selectedFilters.append(selectFilter)
                        }
                        print("Selected cell: \(selectedCell)")
                    }
                }else{
                    if let selectedCell = tableView.cellForRow(at: indexPath) as? TableViewCell{
                        selectedCell.typeofSelectedBtn.image = UIImage(named: "radioBtnActive")
                        if let selectFilter = selectedCell.sectionCellName.text{
                            selectedFilters.append(selectFilter)
                        }
                        print("Selected cell: \(selectedCell)")
                    }
                }
                for filter in selectedFilters{
                    selectedCells[indexPath] = filter
                }
                print("selected filters cells \(selectedCells)")
            }else {
                sections[indexPath.section].isExpandableCellsHidden = !sections[indexPath.section].isExpandableCellsHidden
                tableView.reloadSections([indexPath.section], with: .none)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1{
            return 110
        }else{
            if indexPath.row == 0{
                return 50
            }else{
                return 30
            }
        }
        
    }
  
}

