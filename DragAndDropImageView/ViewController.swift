//
//  ViewController.swift
//  DragAndDropImageView
//
//  Created by Brandon Kim on 12/9/19.
//  Copyright © 2019 John Hersey High School. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController, UIDragInteractionDelegate, UIDropInteractionDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var theView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    let data: [UIImage] = [UIImage(named: "5000limit")!, UIImage(named: "5000limit")!, UIImage(named: "5000limit")!, UIImage(named: "5000limit")!]
    var tempArray:[CGPoint] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let dragInteraction = UIDragInteraction(delegate: self)
        imageView.addInteraction(dragInteraction)
        let dropInteraction = UIDropInteraction(delegate: self)
        theView.addInteraction(dropInteraction)
        imageView.isUserInteractionEnabled = true
        
       
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectCell", for: indexPath)
        
        let imageView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        let image: UIImage = data[indexPath.row]
        imageView.image = image
        
        cell.contentView.addSubview(imageView)
        return cell
    }
    
    func createImage(_ imageName:String, _ location:CGRect) {
        var mage: UIImage = UIImage(named: "\(imageName)")!
        
        var IV = UIImageView(image: mage)
        self.view.addSubview(IV)
        IV.frame = location
        

    }
   
    
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = imageView.image else { return [] }

        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        
        /*
             Returning a non-empty array, as shown here, enables dragging. You
             can disable dragging by instead returning an empty array.
        */
        print(imageView.frame)
        
        
            
            
            
            
        print(image)
        return [item]
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        
        let dropLocation = session.location(in: view)
        print(dropLocation)
//        let lastDropLocation = session.
        DispatchQueue.main.async {
            self.view.reloadInputViews()
        }
        

        let operation: UIDropOperation

        if imageView.frame.contains(dropLocation) {
            /*
                 If you add in-app drag-and-drop support for the .move operation,
                 you must write code to coordinate between the drag interaction
                 delegate and the drop interaction delegate.
            */
            
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            // Do not allow dropping outside of the image view.
            operation = .copy
            
            
        }
        
        createImage("5000limit", CGRect(origin: dropLocation, size: CGSize(width: 240, height: 128)))
        return UIDropProposal(operation: operation)
        
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // Consume drag items (in this example, of type UIImage).
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]

            /*
                 If you do not employ the loadObjects(ofClass:completion:) convenience
                 method of the UIDropSession class, which automatically employs
                 the main thread, explicitly dispatch UI work to the main thread.
                 For example, you can use `DispatchQueue.main.async` method.
            */
            self.imageView.image = images.first
            
        }

        // Perform additional UI updates as needed.
        
        let dropLocation = session.location(in: view)
        tempArray.append(dropLocation)
        createImage("5000limit", CGRect(origin: dropLocation, size: CGSize(width: 240, height: 128)))
        
         DispatchQueue.main.async {
            self.view.reloadInputViews()
            
               }
               
    }
    
    
    
   
}








