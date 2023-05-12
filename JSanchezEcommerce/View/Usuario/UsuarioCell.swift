//
//  UsuarioCell.swift
//  JSanchezEcommerce
//
//  Created by MacBookMBA6 on 03/05/23.
//

import UIKit
import SwipeCellKit

class UsuarioCell: SwipeTableViewCell {

    @IBOutlet weak var lblIdUsuarioOutlet: UILabel!
    
    @IBOutlet weak var lblNombreOutlet: UILabel!
    
    @IBOutlet weak var lblUsernameOutlet: UILabel!
    
    @IBOutlet weak var lblRolOutlet: UILabel!
    
    @IBOutlet weak var lblFechaNacimientoOutlet: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
