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
        var minValue : Int = 1
        var maxValue : Int = 5000
        var minSelectedValue : Int = 1
        var maxSelectedValue : Int = 5000
    }
//    
//    struct PriceCellData{
//        var minValue : Int
//        var maxValue : Int
//    }
    
    enum CellType : Int{
        
        case categories = 0
        case price = 1
        case sortedBy = 2
        case color = 3
        case shape = 4
        case orientation = 5
        case size = 6
        
    }
    
    enum ShapeType : String{
        case rectangle = "Rectangle"
        case square = "Square"
        case panoramic = "Panoramic"
    }
    
    enum OrientationType : String{
        case vertical = "Vertical"
        case horizontal = "Horizontal"
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
        self.sections[CellType.price.rawValue].sectionData.minSelectedValue = minSelectedValue
        self.sections[CellType.price.rawValue].sectionData.maxSelectedValue = maxSelectedValue

    }
    
    
    
    @IBOutlet weak var clearAllBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var filtersTableView: UITableView!
    @IBOutlet weak var applyBtn: UIButton!
    let tapableCellIdentifier = "TableViewCellForTapableSection"
    let sliderCellIdentifier = "FilterPriceTableViewCell"
    let cellIdentifier = "TableViewCell"
    let categoryCellIdentifier = "CategoryTableViewcell"
    var category = ["Banner", "Canvas Photo", "Bookmark","Banner", "Canvas Photo", "Bookmark","Banner", "Canvas Photo", "Bookmark", "Bookmark","Banner", "Canvas Photo", "Bookmark"]
    var sortBy = ["A-Z", "Z-A"]
    var color = ["Red", "Green", "Blue"]
    var shape = ["Square", "Rectangle", "Panoramic"]
    var orientation = ["Vertical", "Horizontal"]
    var squareSize = ["2 x 2","4 x 4"]
    var rectangleVerticalSize = ["3 x 2", "5 x 3"]
    var rectangleHorizontalSize = ["2 x 3", "3 x 5"]
    var panoramicVerticalSize = ["10 x 11","12 x 13"]
    var panoramicHorizontalSize = ["11 x 9","13 x 10"]
    
    var sections = [FilterTitle]()
    var selectedFilters : [Any] = []
    let categogoryCell = CategoryTableViewcell()
    
    var selectedShape : ShapeType? = nil
    
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
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Orientation", expandableCellOptions: [], isExpandabled: false), index: SectionCellIndexpath( section: .orientation)))
        
        sections.append(FilterTitle(sectionData: SectionData(mainCellTitle: "Size", expandableCellOptions: [], isExpandabled: false), index: SectionCellIndexpath( section: .size)))
        
        
        
        self.filtersTableView.register(UINib(nibName: tapableCellIdentifier, bundle: nil), forCellReuseIdentifier: tapableCellIdentifier)
        self.filtersTableView.register(UINib(nibName: sliderCellIdentifier, bundle: nil), forCellReuseIdentifier: sliderCellIdentifier)
        self.filtersTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.filtersTableView.register(UINib(nibName: categoryCellIdentifier, bundle: nil), forCellReuseIdentifier: categoryCellIdentifier)
        self.filtersTableView.delegate = self
        self.filtersTableView.dataSource = self
        self.filtersTableView.separatorStyle = .none
//        priceData.maxValue = 5000
//        priceData.minValue = 0
        
        
        super.viewDidLoad()
        
        self.filtersTableView.estimatedRowHeight = 30.0
        self.filtersTableView.rowHeight = UITableView.automaticDimension
    }

    @IBAction func clearallFilterBtn(_ sender: UIButton) {
        print("Clear all Pressed")
        self.sections[CellType.price.rawValue].sectionData.maxSelectedValue = self.sections[CellType.price.rawValue].sectionData.maxValue
        self.sections[CellType.price.rawValue].sectionData.minSelectedValue = self.sections[CellType.price.rawValue].sectionData.minValue
        self.selectedFilters.removeAll()
        for section in sections{
            switch CellType(rawValue: section.index.section.rawValue){
            case .orientation:
                self.updateExpandableOptionsForOrientation(forSection: .orientation, withNewOptions: [])
            case .size:
                self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: [])
           
            default : break
            }
            for row in  section.index.row{
                self.sections[section.index.section.rawValue].index.row = []
            }
        }
        print("Selected Max Price \(self.sections[CellType.price.rawValue].sectionData.maxSelectedValue)")
        print("Selected Min Price \(self.sections[CellType.price.rawValue].sectionData.minSelectedValue)")
        print("selected Filters \(self.selectedFilters)")
        self.filtersTableView.reloadData()
        
        
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        print("Cancel Pressed")
    }
    
    @IBAction func applyBtn(_ sender: UIButton) {
        print("Apply btn Pressed")
        
        for selected in sections {
            for row in  selected.index.row{
                print(selected.index.row)
            
                self.selectedFilters.append(selected.sectionData.expandableCellOptions[row])
            }
        }
        print("Selected Max Price \(self.sections[CellType.price.rawValue].sectionData.maxSelectedValue)")
        print("Selected Min Price \(self.sections[CellType.price.rawValue].sectionData.minSelectedValue)")
        print("selected Filters \(self.selectedFilters)")
    }
    ///  After selected shape then orientation will be represent regarding to shape
    private func updateExpandableOptionsForOrientation(forSection section: CellType, withNewOptions orientationOptions: [String]) {
        // Find the index of the section in the sections array
        if let sectionIndex = sections.firstIndex(where: { $0.index.section == section }) {
            // Update the expandable options for the section
            sections[sectionIndex].sectionData.expandableCellOptions = orientationOptions
            // Reload the section to reflect the changes
            self.filtersTableView.reloadData()
        }
    }
    
    ///  After selected orientation then size will be represent regarding to orientation
    private func updateExpandableOptionsForSize(forSection section: CellType, withNewOptions sizeOptions: [String]) {
        // Find the index of the section in the sections array
        if let sectionIndex = sections.firstIndex(where: { $0.index.section == section }) {
            // Update the expandable options for the section
            sections[sectionIndex].sectionData.expandableCellOptions = sizeOptions
            // Reload the section to reflect the changes
            self.filtersTableView.reloadData()
        }
    }
    
    private func modifySizeDependOnShapeAndOrientation(shapeType: String, orientationType: String){
        switch ShapeType(rawValue: shapeType){
        case .rectangle:
            switch OrientationType(rawValue: orientationType){
            case .vertical:
                self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: rectangleVerticalSize)
            case .horizontal:
                self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: rectangleHorizontalSize)
            default :
                print("not selected orientationtype")
            }
        case .panoramic:
            switch OrientationType(rawValue: orientationType){
            case .vertical:
                self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: panoramicVerticalSize)
            case .horizontal:
                self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: panoramicHorizontalSize)
            default :
                print("not selected orientationtype")
            }
        case .square:
            self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: squareSize)
        default :
            self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: [])
        }
    }
    
    private func modifyOrientationDependOnShape(shapeType: String){
        switch ShapeType(rawValue: shapeType){
        case .rectangle:
            self.updateExpandableOptionsForOrientation(forSection: .orientation, withNewOptions: orientation)
            self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: [])
            self.selectedShape = .rectangle
           
        case .square:
//                self.updateExpandableOptions(forSection: .orientation, withNewOptions: [])
            self.updateExpandableOptionsForOrientation(forSection: .orientation, withNewOptions: [])
            self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: squareSize)
            self.selectedShape = .square
        case .panoramic:
            self.updateExpandableOptionsForOrientation(forSection: .orientation, withNewOptions: orientation)
            self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: [])
            self.selectedShape = .panoramic
            
        default :
            print("not selected shape")
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
        case .orientation:
            return self.tableViewOrientation(tableView, cellForRowAt: indexPath)
        case .size :
            return self.tableViewSize(tableView, cellForRowAt: indexPath)
        default:
            return UITableViewCell()
        }
    }
   
    
    private func tableViewCategory(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: categoryCellIdentifier, for: indexPath) as! CategoryTableViewcell
        
        let data = sections[indexPath.section]
        cell.categoryItems = data.sectionData.expandableCellOptions
        cell.delegate = self
        cell.selectedRow = data.index.row.first
        cell.categoryListTableview.reloadData()
        return cell
    }
    
    private func tableViewPrice(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: sliderCellIdentifier, for: indexPath) as! FilterPriceTableViewCell
       
        cell.delegate = self
        cell.setPrice(minPrice: sections[indexPath.section].sectionData.minValue, maxPrice: sections[indexPath.section].sectionData.maxValue)
//        if
        cell.setSelectedPrice(minSelectedPrice: sections[indexPath.section].sectionData.minSelectedValue , maxSelectedPrice: sections[indexPath.section].sectionData.maxSelectedValue)
        cell.rangeSliderCurrency.refresh()
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
    
    private func tableViewOrientation(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
        case .orientation,.size:
            let btn = HaderButtonAction()
            btn.section = section
            btn.cell = headerCell
            btn.frame = headerCell.frame
            if sections[section].sectionData.expandableCellOptions.count > 0{
                btn.addTarget(self, action: #selector(addTarget), for: .touchUpInside)
                headerCell.addSubview(btn)
            }
           
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
            self.modifyOrientationDependOnShape(shapeType: selectedItem)
            self.sections[CellType.orientation.rawValue].index.row = []
            sections[indexPath.section].index.row = [indexPath.row]
        case .orientation:
            let selectedItem = sections[indexPath.section].sectionData.expandableCellOptions[indexPath.row]// Assuming sectionData holds the items for each section
            if let selectedShape = self.selectedShape{
                modifySizeDependOnShapeAndOrientation(shapeType: selectedShape.rawValue, orientationType: selectedItem)
            }else{
                self.updateExpandableOptionsForSize(forSection: .size, withNewOptions: [])
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
    
    
    func selectedCategoryFilter(selectedRow: Int?, section: Int?) {
        if let selectedRow = selectedRow, let section = section{
            sections[section].index.row = [selectedRow]
        }
    }
}

