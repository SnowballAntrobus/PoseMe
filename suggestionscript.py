import math
import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
from cmath import acos
"""
Functions:
- angleCosRule: calculates angle at point p1 given three points
- processGT: creates a jointdict for the ground truth joint coordinates and relative joint positions too
- relateJoint: given a joint dict and relation type, returns the angle between the relation type
- fixPose: should be continuously called to give the user feedback on how to correct their pose to ground truth
"""

jointNames = ["neck", 
              "rightShoulder", 
              "rightElbow",
              "rightWrist", 
              "rightHip", 
              "rightKnee", 
              "rightAnkle", 
              "root", 
              "leftHip", 
              "leftKnee", 
              "leftAnkle", 
              "leftShoulder", 
              "leftElbow", 
              "leftWrist"]

"""
    anglecosrule: returns angle between three points. Note: This is the angle at p1
    input: three arrays, p1,p2,p3 of [x,y] coords
    output: returns angle at p1 in degrees
    https://stackoverflow.com/questions/1211212/how-to-calculate-an-angle-from-three-points
"""
def angleCosRule(p1,p2,p3):
    #Lengths of p1 to p2, p2 to p3, p3 to p1
    # seg12 = math.sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2)
    # seg23 = math.sqrt((p3[0] - p2[0])**2 + (p3[1] - p2[1])**2)
    # seg13 = math.sqrt((p1[0] - p3[0])**2 + (p1[1] - p3[1])**2)
    # return(acos((seg12**2 + seg13**2 - seg23**2)/(2*seg12*seg13)))

    ang = math.degrees(math.atan2(p3[1]-p1[1], p3[0]-p1[0]) - math.atan2(p2[1]-p1[1], p2[0]-p1[0]))
    return ang + 360 if ang < 0 else ang



"""
processPose: creates dictionary of pose coordinates and relative joint positions
Input: -pose: joint array example: [[3,20],None, None, [40,300] ...]

Return: joint dictionary with key as joint name and value as the corresponding row from input.
        dictionary also includes angles for joint relations
"""
def processPose(pose):
    poseDict = {}
    for i in range(len(jointNames)):
        poseDict[jointNames[i]] = pose[i]
    
    poseDict["r_neck_elbow"] = relateJoint(poseDict,"r_neck_elbow")
    poseDict["r_shoulder_wrist"] = relateJoint(poseDict,"r_shoulder_wrist")
    poseDict["l_neck_elbow"] = relateJoint(poseDict,"l_neck_elbow")
    poseDict["l_shoulder_wrist"] = relateJoint(poseDict,"l_shoulder_wrist")
    poseDict["r_root_knee"] = relateJoint(poseDict,"r_root_knee")
    poseDict["r_hip_ankle"] = relateJoint(poseDict,"r_hip_ankle")
    poseDict["l_root_knee"] = relateJoint(poseDict,"l_root_knee")
    poseDict["l_hip_ankle"] = relateJoint(poseDict,"l_hip_ankle")
    return poseDict


"""
relateJoint: calculates a bend angle.

Input: - jdict: joint dict
       - calculation type. 
        Type nomenclature: (side)_(start joint)_(end joint)
        Ex: r_neck_elbow gives the angle at the right shoulder between neck and right elbow joint
Return: - calculated angle
"""

def relateJoint(jDict, type):
    if type == "r_neck_elbow":
        return angleCosRule(jDict["rightShoulder"],jDict["neck"],jDict["rightElbow"])
    elif type == "r_shoulder_wrist":
        return angleCosRule(jDict["rightElbow"],jDict["rightShoulder"],jDict["rightWrist"])
    elif type == "l_neck_elbow":
        return angleCosRule(jDict["leftShoulder"],jDict["neck"],jDict["leftElbow"])
    elif type == "l_shoulder_wrist":
        return angleCosRule(jDict["leftElbow"],jDict["leftShoulder"],jDict["leftWrist"])
    elif type == "r_root_knee":
        return angleCosRule(jDict["rightHip"],jDict["root"],jDict["rightKnee"])
    elif type == "r_hip_ankle":
        return angleCosRule(jDict["rightKnee"],jDict["rightHip"],jDict["rightAnkle"])
    elif type == "l_root_knee":
        return angleCosRule(jDict["leftHip"],jDict["root"],jDict["leftKnee"])
    elif type == "l_hip_ankle":
        return angleCosRule(jDict["leftKnee"],jDict["leftHip"],jDict["leftAnkle"])

"""
fixPose: Called continuoiusly and provides the user with an instruction to move a body part 
        to the desired position in the ground truth. 
         Method for each limb: 
         -Align limb: For each limb, instruct the user to move that limb until the center joint is similar 
          to the relative desired position
         -Bend limb: Instruct user to bend the aligned limb until the angle between the torso, center, and 
          end joint form the correct angle
        Example: Standard right bicep flex
        1.instruct user to move arm up until the right elbow joint is parallel with the neck joint
        2.instruct user to bend arm until the angle formed between right wrist,elbow,shoulder is 'correct'

         Gives precedence to the body part that deviates most from the 
         grount truth

        Moves: Start with legs to establish pose stability. Moving legs after fixing arms is bad.
        Legs:
            -move right/left leg in/out
            -bend/straighten right/left leg
        Arms:
            -raise/lower right/left arm
            -bend/straighten right/left arm
    Input:
        - Cpose: constant stream of current pose points given as an array of CGPoints: (x,y)
        - GTpose: Ground truth pose points given as an array of CGPoints: (x,y)
    Output:
        -prints a suggestion to fix pose with an error bound of 5 degrees
"""
def fixPose(Cpose, GTdata):
    

    #run indefinitely
    # while 1:
    Cdata = processPose(Cpose)
    #If the person pictured is not in-frame
    if len(Cpose) != 14:
        return "Move back - your body is not in full-view"

    #Adjusting hip angle with root,hip,knee points
    elif Cdata["r_root_knee"] < GTdata["r_root_knee"] and GTdata["r_root_knee"] - Cdata["r_root_knee"] > 5:
        return "Move your right leg out"
    elif Cdata["r_root_knee"] > GTdata["r_root_knee"] and GTdata["r_root_knee"] - Cdata["r_root_knee"] < -5:
        return "Move your right leg in"
    elif Cdata["l_root_knee"] > GTdata["l_root_knee"] and GTdata["l_root_knee"] - Cdata["l_root_knee"] < -5:
        return "Move your left leg out"
    elif Cdata["l_root_knee"] < GTdata["l_root_knee"] and GTdata["l_root_knee"] - Cdata["l_root_knee"] > 5:
        return "Move your left leg in"
    #Adjusting knee angle with hip,knee,ankle points
    elif Cdata["r_hip_ankle"] < GTdata["r_hip_ankle"] and GTdata["r_hip_ankle"] - Cdata["r_hip_ankle"] > 5:
        return "Straighten your right knee"
    elif Cdata["r_hip_ankle"] > GTdata["r_hip_ankle"] and GTdata["r_hip_ankle"] - Cdata["r_hip_ankle"] < -5:
        return "Bend your right knee"
    elif Cdata["l_hip_ankle"] > GTdata["l_hip_ankle"] and GTdata["l_hip_ankle"] - Cdata["l_hip_ankle"] < -5:
        return "Straighten your left knee"
    elif Cdata["l_hip_ankle"] < GTdata["l_hip_ankle"] and GTdata["l_hip_ankle"] - Cdata["l_hip_ankle"] > 5:
        return "Bend your left knee"
    #Adjusting shoulder angle with neck,shoulder,elbow points
    elif Cdata["r_neck_elbow"] < GTdata["r_neck_elbow"] and GTdata["r_neck_elbow"] - Cdata["r_neck_elbow"] > 5:
        return "Raise your right arm"
    elif Cdata["r_neck_elbow"] > GTdata["r_neck_elbow"] and GTdata["r_neck_elbow"] - Cdata["r_neck_elbow"] < -5:
        return "Lower your right arm"
    elif Cdata["l_neck_elbow"] > GTdata["l_neck_elbow"] and GTdata["l_neck_elbow"] - Cdata["l_neck_elbow"] < -5:
        return "Raise your left arm"
    elif Cdata["l_neck_elbow"] < GTdata["l_neck_elbow"] and GTdata["l_neck_elbow"] - Cdata["l_neck_elbow"] > 5:
        return "Lower your left arm"
    #Adjusting elbow angle with shoulder,elbow,wrist points
    elif Cdata["r_shoulder_wrist"] < GTdata["r_shoulder_wrist"] and GTdata["r_shoulder_wrist"] - Cdata["r_shoulder_wrist"] > 5:
        return "Bend your right elbow"
    elif Cdata["r_shoulder_wrist"] > GTdata["r_shoulder_wrist"] and GTdata["r_shoulder_wrist"] - Cdata["r_shoulder_wrist"] < -5:
        return "Straighten your right elbow"
    elif Cdata["l_shoulder_wrist"] < GTdata["l_shoulder_wrist"] and GTdata["l_shoulder_wrist"] - Cdata["l_shoulder_wrist"] > 5:
        return "Straighten your left elbow"
    elif Cdata["l_shoulder_wrist"] > GTdata["l_shoulder_wrist"] and GTdata["l_shoulder_wrist"] - Cdata["l_shoulder_wrist"] < -5:
        return "Bend your left elbow"
    else:
        return "Nice pose!"

    


###########################Testing####################################
#Cosine Law to get angle at p1
p1 = [30,30]
p2 = [20,30]
p3 = [50,60]
print(angleCosRule(p1,p2,p3)) #expected 236.31

def showJoints(pose, GTData):
    
    f = plt.figure()
    f.set_figwidth(5)
    f.set_figheight(7)
    plt.xlim([0,600])
    plt.ylim([0,700])
    plt.title(fixPose(pose,GTData))
    for val in pose:
        if val != None:
            plt.plot(val[0],val[1], "ro")
    plt.show()

#Ground Truth
Tpose = [[310,520],
         [370,520],
         [430,520],
         [500,520],
         [350,285],
         [350,200],
         [350,70],
         [310,280],
         [270,280],
         [270,200],
         [270,70],
         [240,520],
         [170,520],
         [100,520]]

#Standing in X pose
pose1 = [[310,520],
         [370,520],
         [430,620],
         [500,680],
         [350,285],
         [420,200],
         [450,70],
         [310,280],
         [270,280],
         [200,200],
         [180,70],
         [240,520],
         [170,610],
         [100,680]]

#Shift right leg inwards
pose2 = [[310,520],
         [370,520],
         [430,620],
         [500,680],
         [350,285],
         [355,200],
         [450,70],
         [310,280],
         [270,280],
         [200,200],
         [180,70],
         [240,520],
         [170,610],
         [100,680]]

#shift left leg inwards
pose3 = [[310,520],
         [370,520],
         [430,620],
         [500,680],
         [350,285],
         [355,200],
         [450,70],
         [310,280],
         [270,280],
         [268,200],
         [180,70],
         [240,520],
         [170,610],
         [100,680]]

#Shift right foot in, bend right knee
pose4 = [[310,520],
         [370,520],
         [430,620],
         [500,680],
         [350,285],
         [355,200],
         [355,70],
         [310,280],
         [270,280],
         [268,200],
         [180,70],
         [240,520],
         [170,610],
         [100,680]]

#Standing with arms raised in Y pose
pose5 = [[310,520],
         [370,520],
         [430,620],
         [500,680],
         [350,285],
         [350,200],
         [350,70],
         [310,280],
         [270,280],
         [270,200],
         [270,70],
         [240,520],
         [170,610],
         [100,680]]

#lowered right arm
pose6 = [[310,520],
         [370,520],
         [500,590],
         [580,650],
         [350,285],
         [350,200],
         [350,70],
         [310,280],
         [270,280],
         [270,200],
         [270,70],
         [240,520],
         [170,610],
         [100,680]]

#lower right arm more
pose6 = [[310,520],
         [370,520],
         [450,525],
         [580,650],
         [350,285],
         [350,200],
         [350,70],
         [310,280],
         [270,280],
         [270,200],
         [270,70],
         [240,520],
         [170,610],
         [100,680]]

#lower left arm
pose7 = [[310,520],
         [370,520],
         [450,525],
         [580,650],
         [350,285],
         [350,200],
         [350,70],
         [310,280],
         [270,280],
         [270,200],
         [270,70],
         [240,520],
         [170,520],
         [50,620]]

#straighten right elbow
pose7 = [[310,520],
         [370,520],
         [450,525],
         [580,650],
         [350,285],
         [350,200],
         [350,70],
         [310,280],
         [270,280],
         [270,200],
         [270,70],
         [240,520],
         [170,520],
         [50,620]]

pose8 = [[310,520],
         [370,520],
         [450,525],
         [580,525],
         [350,285],
         [350,200],
         [350,70],
         [310,280],
         [270,280],
         [270,200],
         [270,70],
         [240,520],
         [170,520],
         [50,620]]


pose9 = [[310,520],
         [370,520],
         [450,525],
         [580,525],
         [350,285],
         [350,200],
         [350,70],
         [310,280],
         [270,280],
         [270,200],
         [270,70],
         [240,520],
         [170,520],
         [25,525]]


Tdata = processPose(Tpose)
showJoints(Tpose, Tdata)
showJoints(pose1, Tdata)
showJoints(pose2, Tdata)
showJoints(pose3, Tdata)
showJoints(pose4, Tdata)
showJoints(pose5, Tdata)
showJoints(pose6, Tdata)
showJoints(pose7, Tdata)
showJoints(pose8, Tdata)
showJoints(pose9, Tdata)


