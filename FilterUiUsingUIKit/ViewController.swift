//
//  ViewController.swift
//  FilterUiUsingUIKit
//
//  Created by Satyabrata Das on 18/02/24.
//

import UIKit





extension ViewController {
    
    struct SectionData {
        var mainCellTitle: String
        var expandableCellOptions: [String]
        var isExpandabled : Bool
    }
    
    enum CellType : Int{
        
        case categories = 0
        case price
        case sortedBy
        case color
        case shape
        case size
        
    }
    
    enum ShapeType : String{
        case Rectangle
        case Square
        case none
    }
    
    struct SectionCellIndexpath : Equatable, Hashable{
        var row = [Int]()
        var section : CellType
    }
    
    class HaderButtonAction : UIButton {
        
        var section : Int?
        weak var cell : TableViewCellForTapableSection?
    }
    
}


class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate, FilterPriceTableViewCellDelegate{
    
   
    
    
    func cgFilterPriceTableViewCellDelegatePriceChange(minSelectedValue: Int, maxSelectedValue: Int) {
        print("maxvalue\(maxSelectedValue), minvalue\(minSelectedValue)")
    }
    
    
    
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    let tapableCellIdentifier = "TableViewCellForTapableSection"
    let sliderCellIdentifier = "FilterPriceTableViewCell"
    let cellIdentifier = "TableViewCell"
    let categoryCell = "CategoryTableViewcell"
    var category = ["Banner", "Canvas Photo", "Bookmark","Banner", "Canvas Photo", "Bookmark","Banner", "Canvas Photo", "Bookmark", "Bookmark","Banner", "Canvas Photo", "Bookmark"]
    var sortBy = ["A-Z", "Z-A"]
    var color = ["Red", "Green", "Blue"]
    var shape = ["Square", "Rectangle"]
//    var size = ["Regular", "Large", "Medium"]
//    var size = []
    var squareSize = ["Regular"]
    var rectangleSize = ["Extra Large", "Large", "Medium"]
    
    
    var sections = [FilterTitle]()
    //var selectedCells : [SectionCellIndexpath:Any] = [:]
//    var selectedIndexPathRow: Int?    //not use currently check later
    var initialCellCount = 10
    
    struct FilterTitle {
       
        var  sectionData : SectionData
        var index: SectionCellIndexpath
    }
    
    override func viewDidLoad() {
        
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "CATEGORIES", expandableCellOptions: category, isExpandabled: true), index: SectionCellIndexpath(section: .categories)))
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "PRICE", expandableCellOptions: [], isExpandabled: false), index: SectionCellIndexpath( section: .price)))
        
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Sort By", expandableCellOptions: sortBy, isExpandabled: false), index: SectionCellIndexpath( section: .sortedBy)))
        
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Color", expandableCellOptions: color, isExpandabled: false), index: SectionCellIndexpath( section: .color)))
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Shape", expandableCellOptions: shape, isExpandabled: false), index: SectionCellIndexpath( section: .shape)))
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Size", expandableCellOptions: [], isExpandabled: false), index: SectionCellIndexpath( section: .size)))
        
        
        
        self.filtersTableView.register(UINib(nibName: tapableCellIdentifier, bundle: nil), forCellReuseIdentifier: tapableCellIdentifier)
        self.filtersTableView.register(UINib(nibName: sliderCellIdentifier, bundle: nil), forCellReuseIdentifier: sliderCellIdentifier)
        self.filtersTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.filtersTableView.register(UINib(nibName: categoryCell, bundle: nil), forCellReuseIdentifier: categoryCell)
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self
        self.filtersTableView.separatorStyle = .none
        
        
        super.viewDidLoad()
        
        self.filtersTableView.estimatedRowHeight = 30.0
        self.filtersTableView.rowHeight = UITableView.automaticDimension
    }

    @IBAction func clearallFilterBtn(_ sender: UIButton) {
        print("Clear all Pressed")
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        print("Cancel Pressed")
    }
    
    @IBAction func applyBtn(_ sender: UIButton) {
        print("Apply btn Pressed")
        
        for selected in sections {
            for row in  selected.index.row{
                print(selected.sectionData.expandableCellOptions[row])
            }
        }
    }
    
    
    ///  After selected shape then size will be represent regarding to shape
    private func updateExpandableOptions(forSection section: CellType, withNewOptions options: [String], shapeType: ShapeType) {
        // Find the index of the section in the sections array
        if let sectionIndex = sections.firstIndex(where: { $0.index.section == section }) {
            // Update the expandable options for the section
            sections[sectionIndex].sectionData.expandableCellOptions = options
            // Reload the section to reflect the changes
            self.filtersTableView.reloadData()
        }
    }
}


extension ViewController{
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section.index.section {
        case .price: return 1
        case .categories:
            if section.sectionData.isExpandabled {
                return 1
            }else{
                return 0
            }
            
            
        default:
            
            if section.sectionData.isExpandabled {
                return section.sectionData.expandableCellOptions.count
            }else {
                return 0
            }
            
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch CellType(rawValue: indexPath.section){
        case .categories :
           return self.tableViewCategory(tableView, cellForRowAt: indexPath)
            
        case .price :
           return  self.tableViewPrice(tableView, cellForRowAt: indexPath)
        case .sortedBy :
            return self.tableViewSortedBy(tableView, cellForRowAt: indexPath)
        case .color :
            return self.tableViewColor(tableView, cellForRowAt: indexPath)
        case .shape:
            return self.tableViewShape(tableView, cellForRowAt: indexPath)
        case .size :
            return self.tableViewSize(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
   
    
    private func tableViewCategory(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCell, for: indexPath) as! CategoryTableViewcell
        
        
        let data = sections[indexPath.section]
        cell.categoryItems = data.sectionData.expandableCellOptions
        cell.delegate = self
        return cell
    }
    
    private func tableViewPrice(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sliderCellIdentifier, for: indexPath) as! FilterPriceTableViewCell
        
        cell.delegate = self
        cell.setPrice(minPrice: 0, maxPrice: 5000)
        cell.setSelectedPrice(minSelectedPrice: 0 , maxSelectedPrice: 5000)
        return cell
    }
    
    private func tableViewSortedBy(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        let data = sections[indexPath.section]
        let title = data.sectionData.expandableCellOptions[indexPath.row]
        cell.sectionCellName.text = title

        if  indexPath.row == data.index.row.first {
            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnActive")
        }else{
            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnDeactive")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func tableViewColor(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        let data = sections[indexPath.section]
        let title = data.sectionData.expandableCellOptions[indexPath.row]
        cell.sectionCellName.text = title
        
        if  indexPath.row == data.index.row.first {
            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnActive")
        }else{
            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnDeactive")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func tableViewShape(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        let data = sections[indexPath.section]
        let title = data.sectionData.expandableCellOptions[indexPath.row]
        cell.sectionCellName.text = title

        if  indexPath.row == data.index.row.first {
            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnActive")
        }else{
            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnDeactive")
        }
        cell.selectionStyle = .none
        return cell
    }
    
    private func tableViewSize(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
        
        let data = sections[indexPath.section]
        let title = data.sectionData.expandableCellOptions[indexPath.row]
        cell.sectionCellName.text = title
        
        if  (data.index.row.contains(indexPath.row)) {
            cell.typeofSelectedBtn.image = UIImage(named: "COVID_Address_checkBox")
        }else{
            cell.typeofSelectedBtn.image = UIImage(named: "COVID_Address_unCheckBox")
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
  
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: tapableCellIdentifier) as! TableViewCellForTapableSection
        headerCell.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50)
        let title = sections[section].sectionData.mainCellTitle
        headerCell.cellHeaderTxt.text = title
        headerCell.dropDownImage.image = UIImage(named: "down")
        headerCell.seperatorView.layer.backgroundColor = UIColor.lightGray.cgColor
        if sections[section].sectionData.isExpandabled {
            headerCell.dropDownImage.image = UIImage(named: "up")
        }else {
            headerCell.dropDownImage.image = UIImage(named: "down")
        }
        
        
        switch sections[section].index.section {
        case .price:
            headerCell.dropDownImage.isHidden = true
            headerCell.seperatorView.isHidden = true
        case .categories,.sortedBy:
            headerCell.seperatorView.isHidden = true
            let btn = HaderButtonAction()
            btn.section = section
            btn.cell = headerCell
            btn.frame = headerCell.frame
            btn.addTarget(self, action: #selector(addTarget), for: .touchUpInside)
            headerCell.addSubview(btn)
        default:
            let btn = HaderButtonAction()
            btn.section = section
            btn.cell = headerCell
            btn.frame = headerCell.frame
            btn.addTarget(self, action: #selector(addTarget), for: .touchUpInside)
            headerCell.addSubview(btn)
        }
        
        return headerCell
    }
    
    
    @objc func addTarget(_ sender: HaderButtonAction){
        
        for sectionIndex in 0..<sections.count {
            if sender.section != sectionIndex{
                sections[sectionIndex].sectionData.isExpandabled = false
            }
        }
        if sections[sender.section!].sectionData.isExpandabled {
            sections[sender.section!].sectionData.isExpandabled = false
            sender.cell?.dropDownImage.image = UIImage(named: "up")
             
        }else {
            sections[sender.section!].sectionData.isExpandabled = true
            sender.cell?.dropDownImage.image = UIImage(named: "down")
        }
        self.filtersTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        switch sections[indexPath.section].index.section {
        case .size:
            
            if  let index = sections[indexPath.section].index.row.firstIndex(of: indexPath.row){
                sections[indexPath.section].index.row.remove(at: index)
            }else{
                sections[indexPath.section].index.row.append(indexPath.row)
            }
        case .shape:
            let selectedItem = sections[indexPath.section].sectionData.expandableCellOptions[indexPath.row]// Assuming sectionData holds the items for each section
            
            switch ShapeType(rawValue: selectedItem){
            case .Rectangle:
                self.updateExpandableOptions(forSection: .size, withNewOptions: rectangleSize, shapeType: .Rectangle)
            case .Square:
                self.updateExpandableOptions(forSection: .size, withNewOptions: squareSize, shapeType: .Square)
            case nil:
                self.updateExpandableOptions(forSection: .size, withNewOptions: [], shapeType: .none)
            default :
                print("not selected type")
//                self.updateExpandableOptions(forSection: .size, withNewOptions: [], shapeType: )
            }
            
            self.sections[CellType.size.rawValue].index.row = []
            sections[indexPath.section].index.row = [indexPath.row]
        default:
            sections[indexPath.section].index.row = [indexPath.row]
        }
        tableView.reloadData()
        
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section].index.section{
        case .price:
            return 40
        default :
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 0{
            return nil
        }else{
            return indexPath
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if sections[indexPath.section].sectionData.expandableCellOptions.count > 10{
                
                // Set a custom height for cells in the "categories" section if item greater than 10
                return 300
            }else{
                //other wise return cell height multiply with items
                return CGFloat(40 * (sections[indexPath.section].sectionData.expandableCellOptions.count))
            }
            
        } else {
            return UITableView.automaticDimension // Use default height for cells in other sections
        }
    }
    
  
}

extension ViewController : CategoryFilter{
    func selectedCategoryFilter(selectedRow: [Int]?, section: Int?) {
        if let selectedRow = selectedRow, let section = section{
            sections[section].index.row = selectedRow
        }
    }
}

