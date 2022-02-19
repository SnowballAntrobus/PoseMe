//
//  PoseItemView.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import SwiftUI

struct PoseItemView: View {
  let poseItem: PoseItem
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct PoseItemView_Previews: PreviewProvider {
    static var previews: some View {
        PoseItemView(poseItem: PoseItem(name: "hey", points: [], image: nil))
    }
}
