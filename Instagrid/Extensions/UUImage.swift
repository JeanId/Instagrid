//
//  Extensions.swift
//  Instagrid
//
//  Created by Jean Barottin on 23/03/2023.
//

import UIKit

extension UIImage {
    
    
// MARK: - Transfert UIView into UIImage
    convenience init(view: UIView) {

    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.isOpaque, 0.0)
    view.drawHierarchy(in: view.bounds, afterScreenUpdates: false)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: (image?.cgImage)!)

    }
    
}
