//
//  CellDetailTableViewCell.swift
//  facebook
//
//  Created by Kenneth Wieschhoff on 3/20/21.
//

import UIKit

class CellDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var end: UILabel!
    @IBOutlet weak var overlaps: UIImageView!
    
    
    func configureCell( event: Event) {
        self.title?.text = event.title
        self.start?.text = event.start
        self.end?.text = event.end
        self.overlaps?.image = event.overlaps ? UIImage(named: "redDot") : nil
    }
}
