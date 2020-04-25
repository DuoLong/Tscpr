# Tscpr

![image-20200425223547796](C:\Users\DELL\AppData\Roaming\Typora\typora-user-images\image-20200425223547796.png)

## Robust Initialization：

We use a Robust Initialization for Cascaded Pose Regression (RICPR) by providing texture and pose correlated initial shapes for the testing face.

### **Pose correlated initialization:**

**MTCNN:**

**Requirement**

- opencv

  ​	I use cv2 for image io and resize(much faster than skimage), the input image's channel is acutally BGR

- mxnet

  ​	please update to the newest version, we need 'full' mode in Pooling operation

​    Only tested on Linux and Mac.

**Test**

```python
cd initialization/mxnet_mtcnn_face_detection/
```

**Run:**

```python
python main.py
```

**Epnp_Mapping**

**Run the following file:**

```
initialization/Epnp_Mapping/ConsoleApplication1/ConsoleApplication1.cpp
```

### Texture correlated initialization:

 **Run the following file:**

```python
initialization/Texture_initialization/getlbpHist.m
```

## Regression:

### Global Stage:

#### rcpr_with_initialization:

we use a global cascaded pose regression with robust initialization to get localization results for the original image

 **Run the following file:**

```matlab
rcpr_with_initialization/FULL_demoRCPR.m
```

####  rcpr_with_initialization_mirror：

 **Run the following file:**

```matlab
rcpr_with_initialization_mirror/FULL_demoRCPR.m
```

#### Global_correction_model:

**Run the following file:**

```matlab
correction_model/Correlation_model/zhenshi_jiance.m
correction_model/Correlation_model/jiance_jingxiang.m
correction_model/Correlation_model/myPearson.m
correction_model/dingquezhi_tichu.m
correction_model/zhengli.m
```

### Local Stage:

#### rcpr_with_initialization:

we use a global cascaded pose regression with robust initialization to get localization results for the original image

 **Run the following file:**

```matlab
Local/rcpr_v1_stable_left_eye/FULL_demoRCPR.m
Local/rcpr_v1_stable_right_eye/FULL_demoRCPR.m
Local/rcpr_v1_stable_nose/FULL_demoRCPR.m
Local/rcpr_v1_stable_mouse/FULL_demoRCPR.m
```

 **Run the following file:**

```matlab
Local/Integration.m
```

####  Integration

#### rcpr_with_initialization_mirror：

 **Run the following file:**

```matlab
Local_mirror/rcpr_v1_stable_left_eye/FULL_demoRCPR.m
Local_mirror/rcpr_v1_stable_right_eye/FULL_demoRCPR.m
Local_mirror/rcpr_v1_stable_nose/FULL_demoRCPR.m
Local_mirror/rcpr_v1_stable_mouse/FULL_demoRCPR.m
```

**Run the following file:**

```matlab
Local_mirror/Integration.m
```

#### Local_correction_model:

**Run the following file:**

```matlab
correction_model/Correlation_model/zhenshi_jiance.m
correction_model/Correlation_model/jiance_jingxiang.m
correction_model/Correlation_model/myPearson.m
correction_model/dingquezhi_tichu.m
correction_model/zhengli.m
```

## Results:

Some results is shown in the folder "results".
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


## Results: 

the results is in the folder "results".
