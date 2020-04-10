//
//  ImagePicker.swift
//  CRI
//
//  Created by Dong Kang on 4/8/20.
//  Copyright © 2020 Yooniverse. All rights reserved.
//

import Foundation
import SwiftUI

struct ImagePicker : UIViewControllerRepresentable {
    
    @Binding var isShown    : Bool
    @Binding var image      : UIImage?
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {
        
    }
    
    func makeCoordinator() -> ImagePickerCoordinator {
        return ImagePickerCoordinator(isShown: $isShown, image: $image)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
}

class ImagePickerCoordinator : NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    @Binding var isShown    : Bool
    @Binding var image      : UIImage?
    
    init(isShown : Binding<Bool>, image: Binding<UIImage?>) {
        _isShown = isShown
        _image   = image
    }
    
    //Selected Image
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let extractedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
		image = extractedImage.resized(toWidth: 250.0)
        isShown = false
    }
    
    //Image selection got cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}

struct PhotoCaptureView: View {
    
    @Binding var showImagePicker    : Bool
    @Binding var image              : UIImage?
    
    var body: some View {
        ImagePicker(isShown: $showImagePicker, image: $image)
    }
}

//struct PhotoCaptureView_Previews: PreviewProvider {
//    static var previews: some View {
//        PhotoCaptureView(showImagePicker: .constant(false), image: .constant(Image("")))
//    }
//}

extension UIImage {
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
