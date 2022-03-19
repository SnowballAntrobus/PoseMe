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
  @State private var enabledPose: Bool = false
  
  @EnvironmentObject var model: CaptureViewModel
  @Binding var showingCatalog: Bool
  
  @Environment(\.presentationMode) var presentationMode
  
  var body: some View {
    VStack {
      if let _ = selectedImage {
        Image(uiImage: UIImage(cgImage: (self.image ?? UIImage(systemName: "timelapse")?.cgImage)!))
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(width: 300, height: 300)
          .onAppear {
            if let cgImage = self.selectedImage?.cgImage {
              if let points = runPoseDetection(cgImage: cgImage).first {
                imageWithPosePoints(cgImage: cgImage, points: points)
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
          if p.count == 14 {
            Text("Found all pose points!")
          } else {
            Text("Move Back - only found \(p.count) out of 14 pose points")
          }
        } else {
          Text("No pose points found yet...")
        }
      }.padding(30)
      
      Button(action: addPoseItem, label: {Text("Done")}).disabled(!enabledPose)
      
      .sheet(isPresented: $isImagePickerDisplay) {
        ImagePicker(selectedImage: self.$selectedImage)
      }
      
    }
  }
  
  private func imageWithPosePoints(cgImage: CGImage, points: [CGPoint]) {
    var finalImage: CGImage? = nil
    if let ctx = cgImage.copyContext() {
      ctx.setFillColor(UIColor.blue.cgColor)
      posePointDrawing(ctx: ctx, points: points)
      if let img = ctx.makeImage() {
        finalImage = img
      }
    }
    self.posePoints = points
    // Todo: Make this not hacky
    if points.count == 14 {
      self.enabledPose = true
    } else {
      self.enabledPose = false
    }
    self.image = finalImage
  }
  
  private func addPoseItem() {
    if self.posePoints != nil && self.image != nil && self.name != "" {
      let newPoseItem = PoseItem(name: self.name, points: self.posePoints!, image: self.image!)
      poseItems.append(newPoseItem)
      model.selectedPose = newPoseItem
      self.posePoints = nil
      self.image = nil
      self.name = ""
      self.presentationMode.wrappedValue.dismiss()
      showingCatalog = false
    }
  }
}

struct AddPoseItemView_Previews: PreviewProvider {
    static var previews: some View {
      AddPoseItemView(poseItems: .constant([]), showingCatalog: .constant(false))
    }
}
