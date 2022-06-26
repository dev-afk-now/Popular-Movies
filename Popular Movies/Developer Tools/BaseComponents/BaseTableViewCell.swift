//
//  BaseTableViewCell.swift
//  Popular Movies
//
//  Created by devmac on 12.01.2022.
//

import UIKit

class BaseTableViewCell: UITableViewCell,
                         TableCellRegistrable,
                         TableCellReusable {
    
    override init(style: UITableViewCell.CellStyle,
                  reuseIdentifier: String?) {
        super.init(style: style,
                   reuseIdentifier: reuseIdentifier)
        commomInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func commomInit() {
        selectionStyle = .none
    }
}
