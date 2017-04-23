//
//  RecordsListTableViewCell.swift
//  recorder
//
//  Created by Dongsheng He on 2017/4/23.
//  Copyright © 2017年 Dongsheng He. All rights reserved.
//

import UIKit

class RecordsListTableViewCell: UITableViewCell {

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var recordNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
