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
                destination: PoseItemDetailView(poseItem: poseItem),
                label: { PoseItemView(poseItem: poseItem) }
              )
            }
          }.onDelete(perform: removeRows)
        }
      }
    }
  
  private func removeRows(at offsets: IndexSet) {
    withAnimation {
      poseItems.remove(atOffsets: offsets)
    }
  }
}

struct PosesView_Previews: PreviewProvider {
    static var previews: some View {
      PosesView(poseItems: .constant([]))
    }
}
