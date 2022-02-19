//
//  ImagePickerView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode
  
  var sourceType: UIImagePickerController.SourceType = .photoLibrary
        
    func makeUIViewController(context: Context) -> UIImagePickerController {
      let imagePicker = UIImagePickerController()
      imagePicker.sourceType = self.sourceType
      imagePicker.delegate = context.coordinator
      return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {

    }
  
  func makeCoordinator() -> Coordinator {
      Coordinator(self)
  }
  
  final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
   
      var parent: ImagePicker
   
      init(_ parent: ImagePicker) {
          self.parent = parent
      }
   
      func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
   
          if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
              parent.selectedImage = image
          }
   
          parent.presentationMode.wrappedValue.dismiss()
      }
  }
  
}
