# Walking cat
ProjectCat is an iOS augmented reality (AR) app developed using Apple's SwiftUI, RealityKit and ARKit frameworks. The app features a 2D cat that walks on the horizontal plane, showcasing movement behavior, animation, and texture switching. This project serves as a learning exercise to understand the basics of RealityKit, ARKit, SwiftUI and practice with Swift programming language.<br/>
![](cat.gif)
## Project Description

This project implements several features to create a  AR experience:<br/>
<br/>
- Creating a Mesh: Constructed a simple mesh to represent the 2D cat in the AR environment.<br/>
- Adding a Texture: Applied a texture image of a cat to the mesh to provide a visual representation.<br/>
- Update Function: Developed an update function with a switch statement to handle the cat's states, which include:<br/>
  - Walking: The cat moves in a random direction.<br/>
  - Idle: The cat remains stationary.<br/>
- Random Timer: Implemented a variable that generates a random number used to set a timer, determining the duration of each state.<br/>
- Idle Function: Changes the cat's texture to an idle image when the cat is not moving.<br/>
- Walking Function: Changes the cat's texture to a walking image and assigns a random direction for movement.<br/>
- Audio: audio plays when cat is in the idle state


## Setup 

Prerequisites <br/>
- macOS with Xcode installed.<br/>
- An iOS device with AR capabilities (ARKit compatible).<br/>
<br/>

Environment <br/>
- macOS Sonoma 14.4.1<br/>
- iOS 17.4.1<br/> 
- Xcode 15.3<br/> 
<br/>

Installation<br/>
1. Clone the repository:<br/>
git clone https://github.com/ViktoriiaDorzhieva/ProjectCat.git<br/>
2. Open the project in Xcode.<br/>
<br/> 

Running the App<br/>
1. Connect your ARKit compatible iOS device to your Mac.<br/> 
2. Select your device as the target in Xcode.<br/> 
3. Build and run the project.<br/> 

## Learning Outcomes

- Mastered the basics of RealityKit for AR development.<br/> 
- Developed skills in Swift and SwiftUI.<br/> 
- Implemented interactive and animated AR experiences.<br/> 
- Learned texture management and state-based animations in RealityKit.<br/>

# Testing

## Test case 1

Summary<br/>
The image of the cat disappears after reopening the app multiple times.<br/>

Description<br/>
1. Open the app.<br/>
2. Find a horizontal plane for the cat to appear.<br/>
3. Close and open the running app multiple times. <br/>

Expected results<br/>
The cat image is stable and stays on the place after reopening.<br/>

Environment <br/>
- macOS Sonoma 14.4.1 <br/>
- iOS 17.4.1<br/> 
- Xcode 15.3<br/> 
<br/>

Attachment<br/>

![](walkingCatBug.gif)<br/>

Jira bug report<br/>

![jiraBugReport](https://github.com/user-attachments/assets/e23bafed-eac7-4957-9fca-ad0e6cea021a)<br/>

## Test case 2

Summary<br/>
When pointing on a vertical plane, the cat audio can be heard but the cat is not visible until camera is pointed on a horizontal plane. <br/>

Description<br/>
1. Open the app.<br/>
2. Find a vertical plane.<br/>
3. Turn on the volume on the device.<br/>
4. Wait for the sound.<br/>

Expected results<br/>
The cat and the sound must appear only on a horizontal plane.<br/>

Environment <br/>
- macOS Sonoma 14.4.1<br/>
- iOS 17.6.1<br/> 
- Xcode 15.3<br/> 
<br/>

Attachment<br/>

![](catBugPlane.gif)<br/>

Jira bug report<br/>

![jiraBugVerticalPlane](https://github.com/user-attachments/assets/7e425b37-f0e9-4caf-8e02-d7292a37fa56)<br/>







