//
//  PoseCompare.swift
//  PoseMe
//
//  Created by Dante Gil-Marin on 3/14/22.
//

import Foundation

func fixPose(currentPose: Pose, groudTruthPose: Pose) -> String {
  let currentAngles = currentPose.getAngleDict()
  let gtAngles = groudTruthPose.getAngleDict()
  
  // Check that we have all angles so we can !! in next section
  for (_, value) in currentAngles {
    if value == nil {
      return "Move Back - your body is not in full view"
    }
  }
  
  for (_, value) in gtAngles {
    if value == nil {
      return "Error - Catalog Pose does not have all joints"
    }
  }
  
  // Adjusting hip angle with root,hip,knee points
  if currentAngles["r_root_knee"]!! < gtAngles["r_root_knee"]!! && gtAngles["r_root_knee"]!! - currentAngles["r_root_knee"]!! > 5 { return "Move your right leg out" }
  else if currentAngles["r_root_knee"]!! > gtAngles["r_root_knee"]!! && gtAngles["r_root_knee"]!! - currentAngles["r_root_knee"]!! < -5 { return "Move your right leg in" }
  else if currentAngles["l_root_knee"]!! > gtAngles["l_root_knee"]!! && gtAngles["l_root_knee"]!! - currentAngles["l_root_knee"]!! < -5 { return "Move your left leg out" }
  else if currentAngles["l_root_knee"]!! < gtAngles["l_root_knee"]!! && gtAngles["l_root_knee"]!! - currentAngles["l_root_knee"]!! > 5 { return "Move your left leg in" }
  // Adjusting knee angle with hip,knee,ankle points
  else if currentAngles["r_hip_ankle"]!! < gtAngles["r_hip_ankle"]!! && gtAngles["r_hip_ankle"]!! - currentAngles["r_hip_ankle"]!! > 5 { return "Straighten your right knee" }
  else if currentAngles["r_hip_ankle"]!! > gtAngles["r_hip_ankle"]!! && gtAngles["r_hip_ankle"]!! - currentAngles["r_hip_ankle"]!! < -5 { return "Bend your right knee" }
  else if currentAngles["l_hip_ankle"]!! > gtAngles["l_hip_ankle"]!! && gtAngles["l_hip_ankle"]!! - currentAngles["l_hip_ankle"]!! < -5 { return "Straighten your left knee" }
  else if currentAngles["l_hip_ankle"]!! < gtAngles["l_hip_ankle"]!! && gtAngles["l_hip_ankle"]!! - currentAngles["l_hip_ankle"]!! > 5 { return "Bend your left knee" }
  // Adjusting shoulder angle with neck,shoulder,elbow points
  else if currentAngles["r_neck_elbow"]!! < gtAngles["r_neck_elbow"]!! && gtAngles["r_neck_elbow"]!! - currentAngles["r_neck_elbow"]!! > 5 { return "Raise your right arm" }
  else if currentAngles["r_neck_elbow"]!! > gtAngles["r_neck_elbow"]!! && gtAngles["r_neck_elbow"]!! - currentAngles["r_neck_elbow"]!! < -5 { return "Lower your right arm" }
  else if currentAngles["l_neck_elbow"]!! > gtAngles["l_neck_elbow"]!! && gtAngles["l_neck_elbow"]!! - currentAngles["l_neck_elbow"]!! < -5 { return "Raise your left arm" }
  else if currentAngles["l_neck_elbow"]!! < gtAngles["l_neck_elbow"]!! && gtAngles["l_neck_elbow"]!! - currentAngles["l_neck_elbow"]!! > 5 { return "Lower your left arm" }
  // Adjusting elbow angle with shoulder,elbow,wrist points
  else if currentAngles["r_shoulder_wrist"]!! < gtAngles["r_shoulder_wrist"]!! && gtAngles["r_shoulder_wrist"]!! - currentAngles["r_shoulder_wrist"]!! > 5 { return "Bend your right elbow" }
  else if currentAngles["r_shoulder_wrist"]!! > gtAngles["r_shoulder_wrist"]!! && gtAngles["r_shoulder_wrist"]!! - currentAngles["r_shoulder_wrist"]!! < -5 { return "Straighten your right elbow" }
  else if currentAngles["l_shoulder_wrist"]!! < gtAngles["l_shoulder_wrist"]!! && gtAngles["l_shoulder_wrist"]!! - currentAngles["l_shoulder_wrist"]!! > 5 { return "Straighten your left elbow" }
  else if currentAngles["l_shoulder_wrist"]!! > gtAngles["l_shoulder_wrist"]!! && gtAngles["l_shoulder_wrist"]!! - currentAngles["l_shoulder_wrist"]!! < -5 { return "Bend your left elbow" }
  else { return "Nice pose!" }
  
}
