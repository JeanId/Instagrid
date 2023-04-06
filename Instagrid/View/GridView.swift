//
//  GridView.swift
//  Instagrid
//
//  Created by Jean Barottin on 22/03/2023.
//

import UIKit

protocol GridViewDelegate : AnyObject  {
    func viewWasSelected(_ viewSelector: ViewSelector)
}

class GridView: UIView {

    @IBOutlet var photo1: UIImageView!
    @IBOutlet var photo2: UIImageView!
    @IBOutlet var photo3: UIImageView!
    @IBOutlet var photo4: UIImageView!
    
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    
    weak var delegate: GridViewDelegate?
    
    let tapView1 = UITapGestureRecognizer()
    let tapView2 = UITapGestureRecognizer()
    let tapView3 = UITapGestureRecognizer()
    let tapView4 = UITapGestureRecognizer()
    
    var gridType: GridType = .largeViewTop {
        didSet {
            setGridType(with: gridType)
        }
    }
    
    
// MARK: - grid display changing Method
    private func setGridType(with gridType: GridType) {
        switch gridType {
        case .largeViewTop:
            view1.isHidden = false
            view2.isHidden = true
            view3.isHidden = false
            view4.isHidden = false
        case .largeViewBottom:
            view1.isHidden = false
            view2.isHidden = false
            view3.isHidden = false
            view4.isHidden = true
        case .sameViews:
            view1.isHidden = false
            view2.isHidden = false
            view3.isHidden = false
            view4.isHidden = false
        }
    }
    
    
// MARK: - GridView init
    override func awakeFromNib() {
        
        self.view1.addGestureRecognizer(tapView1)
        tapView1.addTarget(self, action: #selector(handlerTapGesture(_ :)))
        
        
        self.view2.addGestureRecognizer(tapView2)
        tapView2.addTarget(self, action: #selector(handlerTapGesture(_ :)))
        
        
        self.view3.addGestureRecognizer(tapView3)
        tapView3.addTarget(self, action: #selector(handlerTapGesture(_ :)))
        
        
        self.view4.addGestureRecognizer(tapView4)
        tapView4.addTarget(self, action: #selector(handlerTapGesture(_ :)))
        
    }
    
// MARK: - tapGesture action Methods
    @objc func handlerTapGesture(_ sender: UITapGestureRecognizer) {
        switch sender {
        case tapView1:
            delegate?.viewWasSelected(.view1)
        case tapView2:
            delegate?.viewWasSelected(.view2)
        case tapView3:
            delegate?.viewWasSelected(.view3)
        case tapView4:
            delegate?.viewWasSelected(.view4)
        default:
            break
        }
        
    }
    
}
