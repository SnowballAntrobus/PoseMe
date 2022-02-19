//
//  AddPoseItemView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import SwiftUI

struct AddPoseItemView: View {
  @Binding var poseItems: [PoseItem]
  @State private var selectedImage: UIImage?
  @State private var isImagePickerDisplay = false
  
  var body: some View {
    VStack {
      if selectedImage != nil {
        Image(uiImage: selectedImage!)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 300, height: 300)
      }
      else {
        Button(action: {
          self.isImagePickerDisplay.toggle()
        }) {
          Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 300)
        }
      }
      
      Text("Pose Name")
      
      .sheet(isPresented: $isImagePickerDisplay) {
        ImagePicker(selectedImage: self.$selectedImage)
      }
      
    }
  }
}

struct AddPoseItemView_Previews: PreviewProvider {
    static var previews: some View {
      AddPoseItemView(poseItems: .constant([]))
    }
}
