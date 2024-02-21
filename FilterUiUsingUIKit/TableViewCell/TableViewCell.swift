//
//  TableViewCell.swift
//  Multiple_TapableSection_TableView
//
//  Created by Satyabrata Das on 18/02/24.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var cellTxt: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
