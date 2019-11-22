                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                # coding: utf-8
import mxnet as mx
from mtcnn_detector import MtcnnDetector
import numpy as np
import cv2
import os
import time
import linecache
import sys

def travel_folder(file_folder, img_type, landmark_type):
    file_path_list = []
    landmark_path_list = []
    finf = os.walk(file_folder)
    for file_folder, tmp, filename_list in finf: 
        for filename in filename_list:
            if filename.endswith(img_type):
                file_path_list.append(os.path.join(file_folder, filename))
            elif filename.endswith(landmark_type):
                landmark_path_list.append(os.path.join(file_folder, filename))
    return file_path_list, landmark_path_list

def read_landmark(lankmark_file):
    lankmark_list = []
    for i in range(4, 72):
        unit_landmark = linecache.getline(lankmark_file, i).strip()
        unit_pos_x = float(unit_landmark.split(' ')[0])
        unit_pos_y = float(unit_landmark.split(' ')[1])
        unit_pos = (unit_pos_x, unit_pos_y)

        lankmark_list.append(unit_pos)
    return lankmark_list

    
def detect_face(img_path, landmark, dest_path):
    detector = MtcnnDetector(model_folder='model', ctx=mx.cpu(0), num_worker = 4 , accurate_landmark = False)
    img = cv2.imread(img_path)
    print(dest_path)
    results = detector.detect_face(img)
    #print(results)
    if results is not None:
        total_boxes = results[0]
        points = results[1]
        img_pos = 0
        for i in range(len(total_boxes)):
            tmp_count = 0
            for j in range(len(landmark)):
    
                if((landmark[j][0] >= float(total_boxes[i][0])) & (landmark[j][0] <= float(total_boxes[i][2])) & (landmark[j][1] >= float(total_boxes[i][1])) & (landmark[j][0] <= float(total_boxes[i][3]))):
                    tmp_count += 1
            if(tmp_count > len(landmark) / 2):
                img_pos = i
                break
        '''
        # extract aligned face chips
        chips = detector.extract_image_chips(img, points, 144, 0.37)
        chip = chips[img_pos]

        tmp_img = detector.detect_face(chip)
        sub_total_boxes = tmp_img[0]
        sub_tmp_points = tmp_img[1]
        #10个点：sub_total_boxes 
        #框点：sub_tmp_points 
        
        #print(tmp_img)
        #print(sub_total_boxes)
        #print(sub_tmp_points)
        #整合14个点,先框后点
        pointss = np.hstack((sub_total_boxes,sub_tmp_points))
        print(pointss)
        #将点写进pts文件
        portion = os.path.splitext(dest_path)
        if portion[1] ==".jpg":
            newname = portion[0] + ".txt"
        print(newname)
        #file_handle = open(newname,mode='wb+')
        #print(file_handle)
        #file_handle.write(pointss)
        #file_handle.close()
        np.savetxt(newname,pointss)
        #print(dest_path) 
        
        for unit_point in sub_tmp_points:
            for i in range(5):
                cv2.circle(chip, (unit_point[i], unit_point[i + 5]), 1, (0, 0, 255), 2)
        cv2.rectangle(chip, (int(sub_total_boxes[0][0]), int(sub_total_boxes[0][1])), (int(sub_total_boxes[0][2]), int(sub_total_boxes[0][3])), (162, 165, 62))        
        #print(unit_point[1], unit_point[6])
        #print(int(sub_total_boxes[0][0]))
        #print(int(sub_total_boxes[0][3]))
        print('dest_path:{0}'.format(dest_path))
        cv2.imshow("detection result", chip)
        cv2.imwrite(dest_path, chip)
        '''

        draw = img.copy()
        total_boxes1 = results[0][img_pos]
        points1 = results[1][img_pos]

        pointss = np.hstack((total_boxes1,points1))
        print(pointss)
        #将点写进pts文件
        portion = os.path.splitext(dest_path)
        if portion[1] ==".jpg":
            newname = portion[0] + ".txt"
        print(newname)
        np.savetxt(newname,pointss)
        b = total_boxes1
        cv2.rectangle(draw, (int(b[0]), int(b[1])), (int(b[2]), int(b[3])), (162, 165, 62))

        p = points1
        for i in range(5):
            cv2.circle(draw, (p[i], p[i + 5]), 5, (0, 0, 255), 10)

        cv2.imshow("detection result", draw)
        cv2.imwrite(dest_path, draw)
        

def exec_dect_face(img_list, landmark_list, dest_folder):
    for i in range(len(img_list)):
        for j in range(len(landmark_list)):
            if(img_list[i].split('/')[-1].split('.')[0] in landmark_list[j]):
                dest_path = os.path.join(dest_folder, img_list[i].split('/')[-1])
                tmp_landmark = read_landmark(landmark_list[j])
                print(tmp_landmark)
                 #将点写进pts文件
                portion = os.path.splitext(dest_path)
                if portion[1] ==".png":
                    newname = portion[0] + ".txt"
                print(newname)
                np.savetxt(newname,tmp_landmark)
                #total_boxes1 = results[0][img_pos]
                #points1 = results[1][img_pos]
                #detect_face(img_list[i], tmp_landmark, dest_path)
                continue

if __name__ == '__main__':
    
    cur_folder = os.getcwd() # 获得当前目录
    print(cur_folder)
    #train_floder = os.path.join(cur_folder, 'lfpw/trainset8')
    test_floder = os.path.join(cur_folder, 'lfpw/testset')
    #test_floder = os.path.join(cur_folder, 'lfpw/testset2')
    #test_floder = os.path.join(cur_folder, 'lfpw11/untrain1')
    #test_floder = os.path.join(cur_folder, 'data1/lfpw/test')
    #test_floder = os.path.join(cur_folder, 'helen11/train')
    #train_dest_folder = os.path.join(cur_folder, 'lfpw_face/trainset8')
    #test_dest_folder = os.path.join(cur_folder, 'align_face/testset')
    #test_dest_folder = os.path.join(cur_folder, 'lfpw_face/testset2')
    test_dest_folder = os.path.join(cur_folder, 'lfpw/2')
    #test_dest_folder = os.path.join(cur_folder, 'data1/lfpw/b')
    #test_dest_folder = os.path.join(cur_folder, 'helen11/res1')

    img_type = '.png'
    landmark_type = '.pts'

    #train_img_list, train_landmark_list = travel_folder(train_floder, img_type, landmark_type)
    test_img_list, test_landmark_list = travel_folder(test_floder, img_type, landmark_type)
    
    #exec_dect_face(train_img_list, train_landmark_list, train_dest_folder)
    exec_dect_face(test_img_list, test_landmark_list, test_dest_folder)

    print('Done')


