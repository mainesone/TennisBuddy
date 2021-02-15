//
//  SegmentedBarView.swift
//  tennislike
//
//  Created by Maik Nestler on 16.12.20.
//

import UIKit

class SegmentedBarView: UIStackView {
    
    init(numberOfSegments: Int) {
        super.init(frame: .zero)
        
        (0..<numberOfSegments).forEach { _ in
            let barView = UIView()
            barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
            addArrangedSubview(barView)
        }
        
        spacing = 4
        distribution = .fillEqually
        
        arrangedSubviews.first?.backgroundColor = .brandingColor
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper Functions
    
    func setHighlightedBar(index: Int) {
        arrangedSubviews.forEach({ $0.backgroundColor = UIColor(white: 0, alpha: 0.1) })
        arrangedSubviews[index].backgroundColor = .brandingColor
    }
}
