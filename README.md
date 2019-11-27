# Tscpr
## Initialization：
we use a Robust Initialization for Cascaded Pose Regression (RICPR) by providing texture and pose correlated initial shapes for the testing face. By examining the correlation of local binary patterns histograms between the testing face and the training faces, the shapes of the training faces that are most correlated with the testing face are selected as the texture correlated initialization. To make the initialization more robust to various poses, we estimate the rough pose of the testing face according to five fiducial landmarks located by multitask cascaded convolutional networks. Then the pose correlated initial shapes are constructed by the mean face's shape and the rough testing face pose. Finally, the texture correlated and the pose correlated initial shapes are joined together as the robust initialization. 


## Global Stage:  
rcpr_with_initialization、rcpr_with_initialization_mirror、correction_model

### rcpr_with_initialization:  
we use a global cascaded pose regression with robust
initialization to get localization results for the original image

### rcpr_with_initialization_mirror： 
we use a global cascaded pose regression with robust
initialization to get localization results its mirror image.

### correction_model: 
The localization difference between the original image and the
mirror image is used to determine whether the localization of each landmark is
reliable, while unreliable localization can be adjusted.

## Local Stage:  
Local 、Local_mirror、correction_model

#### local ：
we use a local cascaded pose regression with robust
initialization to get localization results its original image.

### local_mirror: 
we use a local cascaded pose regression with robust
initialization to get localization results its mirror image.
