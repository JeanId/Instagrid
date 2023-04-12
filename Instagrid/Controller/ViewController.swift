//
//  ViewController.swift
//  Instagrid
//
//  Created by Jean Barottin on 06/04/2023.
//

import UIKit
import PhotosUI

class ViewController: UIViewController , UIImagePickerControllerDelegate, UINavigationControllerDelegate, PickerGridDelegate, GridViewDelegate {
    
    @IBOutlet weak var pickerGrid: PickerGrid!
    @IBOutlet weak var gridView: GridView!
    
    
    @IBOutlet weak var actionAdvice: UILabel!
    @IBOutlet weak var arrowType: UIImageView!
    
    @IBOutlet var bigView: UIView!
    
    @IBOutlet weak var stackGrid: UIStackView!
    
    
    let imagePicker = UIImagePickerController()
    let swipeUp = UISwipeGestureRecognizer()
    let swipeLeft = UISwipeGestureRecognizer()
    
    var viewSelector = ViewSelector.view1
    
    enum SwipeDirection {
        case up, left
    }
    
    var swipeDirection = SwipeDirection.up
    
// MARK: - application init
    override func viewDidLoad() {
        super.viewDidLoad()
        

        pickerGrid.gridType = .largeViewBottom
        gridView.gridType = .largeViewBottom
        
        pickerGrid.delegate = self
        gridView.delegate = self
        imagePicker.delegate = self
        
        actionAdvice.text = "Swipe up to share !"
        arrowType.image = UIImage(named: "Arrow Up")
         
        swipeUp.addTarget(self, action:  #selector(swipeUpAction(_:)))
        swipeUp.direction = UISwipeGestureRecognizer.Direction.up
        self.bigView.addGestureRecognizer(swipeUp)
        
        swipeLeft.addTarget(self, action:  #selector(swipeLeftAction(_:)))
        swipeLeft.direction = UISwipeGestureRecognizer.Direction.left
        self.bigView.addGestureRecognizer(swipeLeft)
        
        swipeManagement(swipeDirection: .up)
        
    }
    
   
// MARK: - swipe action Method
    @objc func swipeUpAction(_ sender: UISwipeGestureRecognizer) {
        let screenHeight = UIScreen.main.bounds.height
        let translationTransform = CGAffineTransform(translationX: 0, y: -screenHeight/1.2)
        
        UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
            self.stackGrid.transform = translationTransform
        }, completion: { success in
            if success {
                self.launchUIactivityViewController()
            }
        })
        
    }
    

    @objc func swipeLeftAction(_ sender: UISwipeGestureRecognizer) {
        let screenWidth = UIScreen.main.bounds.width
        let translationTransform = CGAffineTransform(translationX: -screenWidth/1.2, y:0 )
        
        UIView.animate(withDuration: 1, delay: 0.1, options: [], animations: {
            self.stackGrid.transform = translationTransform
        }, completion: { success in
            if success {
                self.launchUIactivityViewController()
            }
        })
    }
  
// MARK: - UIActivityViewController launching
    private func launchUIactivityViewController() {
        let gridImage = UIImage.init(view: gridView)
        let shareViewControl = UIActivityViewController(activityItems: [gridImage], applicationActivities: nil)
        present(shareViewControl, animated: true, completion: nil)
        
        shareViewControl.completionWithItemsHandler = { (activityType: UIActivity.ActivityType?, completed: Bool, arrayReturnedItems: [Any]?, error: Error?) in
                UIView.animate(withDuration: 1, delay: 0.1, options: [], animations: {
                self.stackGrid.transform = .identity
                }, completion: nil)
        }
    }
    
// MARK: - detection of device orientation
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
            if UIDevice.current.orientation.isPortrait {
                actionAdvice.text = "Swipe up to share !"
                arrowType.image = UIImage(named: "Arrow Up")
                swipeManagement(swipeDirection: .up)
            } else {
                actionAdvice.text = "Swipe left to share !"
                arrowType.image = UIImage(named: "Arrow Left")
                swipeManagement(swipeDirection: .left)
            }
        }
   
// MARK: - swipe direction enabling
    private func swipeManagement(swipeDirection: SwipeDirection) {
            switch swipeDirection {
                case .up:
                    swipeUp.isEnabled = true
                    swipeLeft.isEnabled = false
                case .left:
                    swipeUp.isEnabled = false
                    swipeLeft.isEnabled = true
            }
        }

    
// MARK: - PickerGridDelegate Method
    func gridTypeWasChanged(_ gridType: GridType) {
       gridView.gridType = gridType
    }
    
    
// MARK: - GridViewDelegate Method
    func viewWasSelected(_ viewSelector: ViewSelector) {
        let photos = PHPhotoLibrary.authorizationStatus()
            if photos != .authorized {
                PHPhotoLibrary.requestAuthorization({status in
                    DispatchQueue.main.async {
                        if status == .authorized{
                            self.imagePicker.allowsEditing = false
                            self.imagePicker.sourceType = .photoLibrary
                            self.viewSelector = viewSelector
                            self.present(self.imagePicker, animated: true, completion: nil)
                        } else {
                            let alertController = UIAlertController(title: "Caution !", message: "Your photo Access is not valid please change the settings", preferredStyle: .alert)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }
                })
            } else {
                self.imagePicker.allowsEditing = false
                self.imagePicker.sourceType = .photoLibrary
                self.viewSelector = viewSelector
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        
    }
    
    
// MARK: - UIImagePickerControllerDelegate Methods
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                
            switch viewSelector {
                case .view1:
                    selectedImageLoading(selectedImage: gridView.photo1, pickedImage: pickedImage)
                case .view2:
                    selectedImageLoading(selectedImage: gridView.photo2, pickedImage: pickedImage)
                case .view3:
                    selectedImageLoading(selectedImage: gridView.photo3, pickedImage: pickedImage)
                case .view4:
                    selectedImageLoading(selectedImage: gridView.photo4, pickedImage: pickedImage)
            }
        }
            
        dismiss(animated: true, completion: {
            UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.7, options: [], animations: {
                switch self.viewSelector {
                    case .view1:
                        self.gridView.photo1.transform = .identity
                    case .view2:
                        self.gridView.photo2.transform = .identity
                    case .view3:
                        self.gridView.photo3.transform = .identity
                    case .view4:
                        self.gridView.photo4.transform = .identity
                    }
            })
        })
    }
    
        
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            dismiss(animated: true, completion: nil)
    }
    
    private func selectedImageLoading( selectedImage: UIImageView, pickedImage: UIImage) {
        selectedImage.contentMode = .scaleToFill
        selectedImage.image = pickedImage
        selectedImage.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
    }
    
    
}



