//
//  CustomCellTableViewCell.swift
//  CaptureCard
//
//  Created by Miguel Palacios on 17/03/16.
//  Copyright © 2016 Miguel Palacios. All rights reserved.
//

import UIKit

class CustomCellTableViewCell: UITableViewCell {
    @IBOutlet weak var mImageViewCaptura: UIImageView!
    @IBOutlet weak var mLabelEmpresa: UILabel!
    @IBOutlet weak var mLabelPuesto: UILabel!
    @IBOutlet weak var mLabelNombre: UILabel!
    @IBOutlet weak var mLabelCorreo: UILabel!
    @IBOutlet weak var mLabelDireccion: UILabel!
    @IBOutlet weak var mLabelTelefono1: UILabel!
    @IBOutlet weak var mLabelTelefono2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
