# Face Alignment Using Two-Stage Cascaded Pose Regression and Mirror Error Correction(Tscpr)

![image](https://github.com/DuoLong/Tscpr/blob/master/results/pipeline.png)


**Install Requirement**
First, make sure you have OPENCV and MXNET already installed.

- OPENCV [How to install OPENCV](https://docs.opencv.org/master/d3/d52/tutorial_windows_install.html "With a Title"). 

  ​	We use cv2 for image IO and resize(much faster than skimage), the input image's channel is acutally BGR

- MXNET [How to install MXNET](https://mxnet.apache.org/get_started/? "With a Title").

  ​	please update to the newest version, we need 'full' mode in Pooling operation

  ​ Only tested on Linux and Mac.
  
## Robust Initialization：

We use a Robust Initialization for Cascaded Pose Regression (RICPR) by providing texture and pose correlated initial shapes for the testing face.

### **Pose correlated initialization:**

**MTCNN:**

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

