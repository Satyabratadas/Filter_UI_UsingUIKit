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
        case size
        
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
    var sections = [FilterTitle]()
    //var selectedCells : [SectionCellIndexpath:Any] = [:]
    var selectedIndexPathRow: Int?
    
    struct FilterTitle {
       
        var  sectionData : SectionData
        var index: SectionCellIndexpath
    }
    
    override func viewDidLoad() {
        
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "CATEGORIES", expandableCellOptions: category, isExpandabled: true), index: SectionCellIndexpath(section: .categories)))
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "PRICE", expandableCellOptions: [], isExpandabled: false), index: SectionCellIndexpath( section: .price)))
        
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Sort By", expandableCellOptions: sortBy, isExpandabled: false), index: SectionCellIndexpath( section: .sortedBy)))
        
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Color", expandableCellOptions: color, isExpandabled: false), index: SectionCellIndexpath( section: .color)))
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Size", expandableCellOptions: size, isExpandabled: false), index: SectionCellIndexpath( section: .size)))
        
        
//        sections.append(Section(mainCellTitle: "CATEGORIES", expandableCellOptions: category, isExpandableCellsHidden: false))
//        sections.append(Section(mainCellTitle: "PRICE", expandableCellOptions: [], isExpandableCellsHidden: true))
//        sections.append(Section(mainCellTitle: "Sort By", expandableCellOptions: sortBy, isExpandableCellsHidden: true))
//        sections.append(Section(mainCellTitle: "Color", expandableCellOptions: color, isExpandableCellsHidden: true))
//        sections.append(Section(mainCellTitle: "Size", expandableCellOptions: size, isExpandableCellsHidden: true))
        
        
        
        self.filtersTableView.register(UINib(nibName: tapableCellIdentifier, bundle: nil), forCellReuseIdentifier: tapableCellIdentifier)
        self.filtersTableView.register(UINib(nibName: sliderCellIdentifier, bundle: nil), forCellReuseIdentifier: sliderCellIdentifier)
        self.filtersTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self
        self.filtersTableView.separatorStyle = .none
        
        
        super.viewDidLoad()
        
        self.filtersTableView.estimatedRowHeight = 30.0
        self.filtersTableView.rowHeight = UITableView.automaticDimension

        self.filtersTableView.tableFooterView = UIView()
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
}


extension ViewController{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = sections[section]
        
        switch section.index.section {
        case .price: return 1
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
        case .size :
            return self.tableViewSize(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    /*
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
         cell.selectionStyle = .none
         return cell
     }
     
     **/
    
    private func tableViewCategory(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! TableViewCell
       
        
        let data = sections[indexPath.section]
        let title = data.sectionData.expandableCellOptions[indexPath.row]
        
        cell.sectionCellName.text = title
        
        if  indexPath.row == data.index.row.first {
            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnActive")
        }else{
            cell.typeofSelectedBtn.image = UIImage(named: "radioBtnDeactive")
        }
        
        if indexPath.row == 0{
            cell.sectionCellNameTopConstraint.constant = 30
        }else{
            cell.sectionCellNameTopConstraint.constant = 15
        }

        cell.selectionStyle = .none
        
        return cell
    }
    
    private func tableViewPrice(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sliderCellIdentifier, for: indexPath) as! CGFilterPriceTableViewCell
        
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
        
        if indexPath.row == 0{
            cell.sectionCellNameTopConstraint.constant = 30
        }else{
            cell.sectionCellNameTopConstraint.constant = 15
        }

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
        
        if indexPath.row == 0{
            cell.sectionCellNameTopConstraint.constant = 30
        }else{
            cell.sectionCellNameTopConstraint.constant = 15
        }

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
        
        if indexPath.row == 0{
            cell.sectionCellNameTopConstraint.constant = 30
        }else{
            cell.sectionCellNameTopConstraint.constant = 15
        }
        return cell
        
    }
    
  
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: tapableCellIdentifier) as! TableViewCellForTapableSection
        headerCell.frame = CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 40)
        let title = sections[section].sectionData.mainCellTitle
        headerCell.cellHeaderTxt.text = title
        headerCell.dropDownImage.image = UIImage(named: "down")
        headerCell.seperatorView.layer.backgroundColor = UIColor.lightGray.cgColor
        headerCell.backgroundColor = .cyan
       
        
        if sections[section].sectionData.isExpandabled {
            headerCell.dropDownImage.image = UIImage(named: "up")
        }else {
            headerCell.dropDownImage.image = UIImage(named: "down")
        }
        
        
        switch sections[section].index.section {
        case .price:
            headerCell.dropDownImage.isHidden = true
            headerCell.seperatorView.isHidden = true
            headerCell.cellHeaderTxtTopConstraint.constant = 0
        case .categories,.sortedBy:
            headerCell.seperatorView.isHidden = true
            headerCell.cellHeaderTxtTopConstraint.constant = 10
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
//
        if sections[sender.section!].sectionData.isExpandabled {
            sections[sender.section!].sectionData.isExpandabled = false
            sender.cell?.dropDownImage.image = UIImage(named: "up")
             
        }else {
            sections[sender.section!].sectionData.isExpandabled = true
            sender.cell?.dropDownImage.image = UIImage(named: "down")
        }
        self.filtersTableView.reloadData()
//        self.filtersTableView.reloadSections(IndexSet(integer: sender.section ?? 0), with: .none)
//        sender.cell.
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        switch sections[indexPath.section].index.section {
        case .size:
            
            if  let index = sections[indexPath.section].index.row.firstIndex(of: indexPath.row){
                sections[indexPath.section].index.row.remove(at: index)
            }else{
                sections[indexPath.section].index.row.append(indexPath.row)
            }
        default:
            sections[indexPath.section].index.row = [indexPath.row]
        }
        tableView.reloadData()
        
    }

    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch sections[section].index.section{
        case .categories,.price,.sortedBy:
            return 35
        default :
            return 40
        }
        
    }

  
}

