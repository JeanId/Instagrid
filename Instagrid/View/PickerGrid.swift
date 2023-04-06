//
//  PickerGrid.swift
//  Instagrid
//
//  Created by Jean Barottin on 22/03/2023.
//

import UIKit

protocol PickerGridDelegate: AnyObject {
    func gridTypeWasChanged(_ gridType: GridType)
}

class PickerGrid: UIView {

    @IBOutlet var select1: UIImageView!
    @IBOutlet var select2: UIImageView!
    @IBOutlet var select3: UIImageView!
   
    let tapSelect1 = UITapGestureRecognizer()
    let tapSelect2 = UITapGestureRecognizer()
    let tapSelect3 = UITapGestureRecognizer()
    
    weak var delegate: PickerGridDelegate?
    
    var gridType: GridType = .largeViewTop {
        didSet {
            setGridType(with: gridType)
        }
    }
    
 
   
// MARK: - PickerGrid init
    override func awakeFromNib() {
        
        self.select1.addGestureRecognizer(tapSelect1)
        tapSelect1.addTarget(self, action: #selector(handlerTapGesture(_ :)))
        
        self.select2.addGestureRecognizer(tapSelect2)
        tapSelect2.addTarget(self, action: #selector(handlerTapGesture(_ :)))
        tapSelect2.numberOfTapsRequired = 1
        
        self.select3.addGestureRecognizer(tapSelect3)
        tapSelect3.addTarget(self, action: #selector(handlerTapGesture(_ :)))
        
        self.select1.isUserInteractionEnabled = true
        self.select2.isUserInteractionEnabled = true
        self.select3.isUserInteractionEnabled = true
        
    }
    
   
    
// MARK: - selection display changing Method
    private func setGridType(with gridType: GridType) {
        switch gridType {
        case .largeViewTop:
            select1.image = UIImage(named: "Selected")
            select1.alpha = 0.7
            select2.image = UIImage(named: "Layout 2")
            select3.image = UIImage(named: "Layout 3")
        case .largeViewBottom:
            select1.image = UIImage(named: "Layout 1")
            select2.image = UIImage(named: "Selected")
            select2.alpha = 0.7
            select3.image = UIImage(named: "Layout 3")
        case .sameViews:
            select1.image = UIImage(named: "Layout 1")
            select2.image = UIImage(named: "Layout 2")
            select3.image = UIImage(named: "Selected")
            select3.alpha = 0.7
        }
    }
    
// MARK: - tapGesture action Methods
    @objc func handlerTapGesture(_ sender: UITapGestureRecognizer) {
        switch sender {
            case tapSelect1:
                self.gridType = .largeViewTop
                delegate?.gridTypeWasChanged(.largeViewTop)
            case tapSelect2:
                self.gridType = .largeViewBottom
                delegate?.gridTypeWasChanged(.largeViewBottom)
            case tapSelect3:
                self.gridType = .sameViews
                delegate?.gridTypeWasChanged(.sameViews)
            default:
                break
        }
    }
    
}
