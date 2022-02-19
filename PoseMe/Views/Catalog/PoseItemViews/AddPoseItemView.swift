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
  
  @State private var posePoints: [CGPoint]? = nil
  @State private var image: CGImage? = nil
  @State private var name: String = ""
  
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    VStack {
      if let img = selectedImage {
        if let cgImage = img.cgImage {
          if let points = runPoseDetection(cgImage: cgImage).first {
            if let finalImage = imageWithPosePoints(cgImage: cgImage, points: points) {
              Image(uiImage: UIImage(cgImage: finalImage))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
            }
          }
        }
      } else {
        Button(action: {
          self.isImagePickerDisplay.toggle()
        }) {
          Image(systemName: "photo")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 300, height: 300)
        }
      }
      
      HStack {
        Text("Name:")
        TextField("Pose Name", text: $name)
      }.padding(30)
      
      
      HStack {
        if let p = self.posePoints{
          Text("Found \(p.count) pose points!")
        } else {
          Text("No pose points found yet...")
        }
      }.padding(30)
      
      Button(action: addPoseItem, label: {Text("Done")})
      
      .sheet(isPresented: $isImagePickerDisplay) {
        ImagePicker(selectedImage: self.$selectedImage)
      }
      
    }
  }
  
  private func imageWithPosePoints(cgImage: CGImage, points: [CGPoint]) -> CGImage? {
    var finalImage: CGImage? = nil
    if let ctx = cgImage.copyContext() {
      ctx.setFillColor(UIColor.blue.cgColor)
      posePointDrawing(ctx: ctx, points: points)
      if let img = ctx.makeImage() {
        finalImage = img
      }
    }
    self.posePoints = points
    self.image = finalImage
    return finalImage
  }
  
  private func addPoseItem() {
    if self.posePoints != nil && self.image != nil && self.name != "" {
      let newPoseItem = PoseItem(name: self.name, points: self.posePoints!, image: self.image!)
      poseItems.append(newPoseItem)
      self.posePoints = nil
      self.image = nil
      self.name = ""
      self.presentationMode.wrappedValue.dismiss()
    }
  }
}

struct AddPoseItemView_Previews: PreviewProvider {
    static var previews: some View {
      AddPoseItemView(poseItems: .constant([]))
    }
}
