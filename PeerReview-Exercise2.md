# Peer-Review for Programming Exercise 2 #

## Description ##

For this assignment, you will be giving feedback on the completeness of assignment two: Obscura. To do so, we will give you a rubric to provide feedback. Please give positive criticism and suggestions on how to fix segments of code.

You only need to review code modified or created by the student you are reviewing. You do not have to check the code and project files that the instructor gave out.

Abusive or hateful language or comments will not be tolerated and will result in a grade penalty or be considered a breach of the UC Davis Code of Academic Conduct.

If there are any questions at any point, please email the TA.   

## Due Date and Submission Information
See the official course schedule for due date.

A successful submission should consist of a copy of this markdown document template that is modified with your peer review. This review document should be placed into the base folder of the repo you are reviewing in the master branch. The file name should be the same as in the template: `CodeReview-Exercise2.md`. You must also include your name and email address in the `Peer-reviewer Information` section below.

If you are in a rare situation where two peer-reviewers are on a single repository, append your UC Davis user name before the extension of your review file. An example: `CodeReview-Exercise2-username.md`. Both reviewers should submit their reviews in the master branch.  

# Solution Assessment #

## Peer-reviewer Information

* *name:* Richard Zhang
* *email:* rimzhang@ucdavis.edu

### Description ###

For assessing the solution, you will be choosing ONE choice from: unsatisfactory, satisfactory, good, great, or perfect.

The break down of each of these labels for the solution assessment.

#### Perfect #### 
    Can't find any flaws with the prompt. Perfectly satisfied all stage objectives.

#### Great ####
    Minor flaws in one or two objectives. 

#### Good #####
    Major flaw and some minor flaws.

#### Satisfactory ####
    Couple of major flaws. Heading towards solution, however did not fully realize solution.

#### Unsatisfactory ####
    Partial work, not converging to a solution. Pervasive Major flaws. Objective largely unmet.


___

## Solution Assessment ##

### Stage 1 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Switching to the position lock camera successfully centers it on the player and keeps centered even through movement and sonic booms. When the camera draw toggle is pressed, a 5x5 cross is drawn in the center.

___
### Stage 2 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Switching to the framing with horizontal auto-scroll camera successfully changes the camera scheme to move in the direction and magnitude of autoscroll speed. If the player is pressed against the side of the box opposite to the direction of movement, the player is successfully pushed in the movement direction. The player can never leave the confines of the box. Toggling the camera draw successfully shows the correct box that represents the limits within where the player can move. However, I found that changing the autoscroll box in the inspector will cause the drawn box to change but the actual limits of the box will stay as their defaults. [This likely is due to the way _box_width, and _box_height is set immediately and not updated later](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/autoscroll.gd#L9).

___
### Stage 3 ###

- [x] Perfect
- [ ] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Changing to the position lock and lerp smoothing camera successfully allows the player to move ahead of the camera and the camera will catch up when the player stops moving. I would reccomend reducing the following speed in order to better showcase the functionalities of the camera, since the defaults right now make it very difficult to see that the camera is lagging behind the player when standard movement speed is applied. When the camera draw toggle is enabled, the camera successfully draws a cross in the center of the screen. 


### Stage 4 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Changing to the lerp smoothing target focus camera successfully allows the camera to move ahead of the player when the player is moving. The speed and duration of the catch up and lead feel good. However, the distance to player still seems to go over the leash_distance by a significant margin during sustained sonic booms. With the default values, this causes the player to move out of screen view when moving in the north/south directions. When the camera draw is toggled on, the cross is successfully drawn at the center of the screen.

___
### Stage 5 ###

- [ ] Perfect
- [x] Great
- [ ] Good
- [ ] Satisfactory
- [ ] Unsatisfactory

___
#### Justification ##### 
Switching to the 4-way speedup push zone camera successfully creates the two boxes needed for this camera controller. If the player pushes against the edge of the outer box, they also push the camera in that direction at the same speed. If the player stays within the inner box, the camera does not move. If the player moves within the in-between zone between the two boxes, the camera moves in the direction of movement if that direction matches the side of the box the player is on. If the player moves towards the center of the box, no camera movement occurs. This accurately captures the functionality for this camera. However, I noticed that if I change the push_ratio to a higher value such as >0.4, there starts to be some bugs with the camera such as the player stuttering when trying to move out of the inner box and causing the camera to move at full speed when it shouldn't. This is likely because the student forgot to [multiply the position updates by delta and instead divided by 60](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/position_lock_lerp_lead.gd#L29). Changing the math to multiply the position update by delta fixes the issue. Toggling the camera draw on successfully shows both boxes.
___
# Code Style #

### Description ###
Check the scripts to see if the student code adheres to the GDScript style guide.

If sections do not adhere to the style guide, please peramlink the line of code from Github and justify why the line of code has not followed the style guide.

It should look something like this:

* [description of infraction](https://github.com/dr-jam/ECS189L) - this is the justification.

Please refer to the first code review template on how to do a permalink.


#### Style Guide Infractions ####
[Should have a whitespace seperating colon operators. Same with all other occurances in other files](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/autoscroll.gd#L5)

[Extra debugging comments that can be removed](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/autoscroll.gd#L37)

[More debugging comments that can be removed](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/position_lock_lerp_lead.gd#L57)

[Extra block of commented code that can be removed](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/autoscroll.gd#L54)

[Another block of commented code that can be removed](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/push_zone.gd#L81)



#### Style Guide Exemplars ####
[The student successfully names private variables with a leading underscore and uses standard snake_case for other cases](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/autoscroll.gd#L9)

[The student successfully names their class names after their file names and uses pascal case](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/position_lock.gd#L1)

[The student successfully names their virtual functions that they override with a leading underscore](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/position_lock.gd#L13)

___

# Best Practices #

### Description ###

If the student has followed best practices then feel free to point at these code segments as examplars. 

If the student has breached the best practices and has done something that should be noted, please add the infraction.


This should be similar to the Code Style justification.

#### Best Practices Infractions ####
[The student should not use a magic number 60 when calculating the position updates and instead multiply by delta to be framerate independent](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/push_zone.gd#L49)

[The student should make some variables private such as the position or distance assignments within the update function](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/autoscroll.gd#L28)

The student has only made one commit. It is usually a good practice to make multiple commits. 

The draw logic is the same in all controllers which require a cross in the center of the screen. This repeated code can be put in a single file and be called when needed in any of these controllers.

#### Best Practices Exemplars ####
[The student includes good comments that concisely give details about what the code is doing](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/push_zone.gd#L40)

[The student successfully exports all the required fields](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/position_lock_lerp_lead.gd#L4)

[The student assigns accurate types to variables when appropriate](https://github.com/ensemble-ai/exercise-2-camera-control-arnzhou/blob/33b5d3c53dd8c98e5bca887afe304679d0c32179/Obscura/scripts/camera_controllers/position_lock_lerp_lead.gd#L29)