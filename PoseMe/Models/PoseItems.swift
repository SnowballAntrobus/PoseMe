//
//  PoseItems.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 2/19/22.
//

import Foundation
import FirebaseDatabase

class PoseItems: ObservableObject {
  private static var documentsFolder: URL {
    do {
      return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
    } catch {
      fatalError("Can't find documents directory.")
    }
  }
  
  private static var poseItemsURL: URL { return documentsFolder.appendingPathComponent("poseItems.data") }
  
  @Published var data: [PoseItem] = []
  
  func load() {
    //let dbReference = Database.database().reference()
    //dbReference.child("name/first_name").setValue("Vivian")
      
    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let data = try? Data(contentsOf: Self.poseItemsURL) else {
        return
      }
      guard let data = try? JSONDecoder().decode([PoseItem].self, from: data) else {
        fatalError("Can't decode saved cloth user data.")
      }
      DispatchQueue.main.async {
        self?.data = data
      }
    }
  }
  
  func save() {
    DispatchQueue.global(qos: .background).async { [weak self] in
      guard let data = self?.data else { fatalError("Self out of scope") }
      guard let data = try? JSONEncoder().encode(data) else { fatalError("Error encoding data") }
      do {
        let outfile = Self.poseItemsURL
        try data.write(to: outfile)
      } catch {
          fatalError("Can't write to file")
      }
    }
  }
  
  
}
