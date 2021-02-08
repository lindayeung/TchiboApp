//
//  ImagePicker.swift
//  Tchibo
//
//  Created by Linda Yeung on 1/24/21.
//

import SwiftUI
import PhotosUI

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var showPicker : Bool
    @Binding var image : UIImage?
    
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        var config = PHPickerConfiguration()
        config.selectionLimit = 1
        
        let controller = PHPickerViewController(configuration: config)
        
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
        
    }
    
    class Coordinator : NSObject,PHPickerViewControllerDelegate{
        
        var parent : ImagePicker
        
        init(parent : ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            if results.isEmpty{
                self.parent.showPicker = false
                return
            }
            
            let item = results.first!.itemProvider
            
            if item.canLoadObject(ofClass: UIImage.self){
                
                item.loadObject(ofClass: UIImage.self) { (image, err) in
                    if err != nil{
                        return
                    }
                    let imageData = image as! UIImage
                    
                    DispatchQueue.main.async {
                        self.parent.image = imageData
                        self.parent.showPicker = false
                    }
                }
            }
        }
    }
}
