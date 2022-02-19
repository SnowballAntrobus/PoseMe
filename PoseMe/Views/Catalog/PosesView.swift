//
//  PosesView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import SwiftUI

struct PosesView: View {
  @Binding var poseItems: [PoseItem]
  
  var body: some View {
    List {
      if poseItems.isEmpty {
        Text("You have \(poseItems.count) poses try adding some!")
      } else {
        ForEach(poseItems) { poseItem in
          VStack {
            NavigationLink(
              destination: PoseItemDetailView(poseItem: binding(for: poseItem)),
              label: { PoseItemView(poseItem: poseItem) }
            )
          }
        }.onDelete(perform: removeRows)
      }
    }
  }
  
  private func binding(for poseItem: PoseItem) -> Binding<PoseItem> {
    guard let poseItemIndex = poseItems.firstIndex(where: { $0.id == poseItem.id }) else {
      fatalError("Error: Can't find pose in array to create binding")
    }
    return $poseItems[poseItemIndex]
  }
  
  private func removeRows(at offsets: IndexSet) {
    withAnimation {
      poseItems.remove(atOffsets: offsets)
    }
  }
}

struct PosesView_Previews: PreviewProvider {
    static var previews: some View {
      NavigationView {
        PosesView(poseItems: .constant([PoseItem(name: "Pose", points: [], image: nil)]))
      }
    }
}
