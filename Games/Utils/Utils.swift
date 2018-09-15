//
//  Utils.swift
//  Games
//
//  Created by Anna Garcia on 9/14/18.
//  Copyright © 2018 Juice Crawl. All rights reserved.
//

import UIKit

class Utils: UIView {

}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        }else {
            return 0
        }
    }
}
