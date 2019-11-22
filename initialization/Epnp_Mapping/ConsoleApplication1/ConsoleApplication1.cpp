// ConsoleApplication1.cpp : 定义控制台应用程序的入口点。
//
#include "stdafx.h"
#include <opencv2/opencv.hpp>
#include <iostream>
#include <fstream>

using namespace std;
using namespace cv;

cv::Mat rotation_vector; // Rotation in axis-angle form
cv::Mat translation_vector;
CvMat* rotation_vector1 = cvCreateMat(3, 1, CV_64FC1);
double R_matrix[9];
CvMat* rotation_matrix = cvCreateMat(3, 3, CV_64FC1);
cv::Mat im;
std::vector<cv::Point2d> image_points;
std::vector<cv::Point3d> model_points;
vector<Point3d> mean3D;
vector<Point2d> mean2D;
int main(int argc, char **argv)
{

	//读取坐标点
	//string filename = "D:\\文档\\colorT\\";   //测试集的507张图片 
	//string filename = "D:\\pose\\ConsoleApplication1\\data\\helen\\testall\\";
	string filename = "D:\\pose\\ConsoleApplication1\\data\\helen\\testall\\";
	string picture = "";
	stringstream sout;
	//ifstream fin("helentrainpoint.txt", std::ios::in);     //mtcnn求得的507组10个点
	ifstream fin("helentestpoint.txt", std::ios::in);     //mtcnn求得的507组10个点 
	float point[10];

	double focal_length;
	cv::Mat camera_matrix;
	cv::Mat dist_coeffs;
	Point2d center;
	CvMat temp;
	
	

	//ifstream fin1("m11.txt", std::ios::in);
	ifstream fin1("point20.txt", std::ios::in);
	float pmean[136];
	for (int i = 0; i < 136;) {
		fin1 >> pmean[i] >> pmean[i + 1];
		mean3D.push_back(cv::Point3d(pmean[i], pmean[i + 1], -45.0f));
		i = i + 2;
	}

	//model_points.push_back(cv::Point3d(pmean[40], pmean[41], 0.0f));               // Nose tip
	//model_points.push_back(cv::Point3d(pmean[32], pmean[33], -40.0f));       // Left eye middle
	//model_points.push_back(cv::Point3d(pmean[34], pmean[35], -40.0f));        // Right eye middle
	//model_points.push_back(cv::Point3d(pmean[44], pmean[45], -45.0f));      // Left Mouth corner
	//model_points.push_back(cv::Point3d(pmean[46], pmean[47], -45.0f));       // Right mouth corner
	model_points.push_back(cv::Point3d(pmean[60], pmean[61], 0.0f));               // Nose tip
	model_points.push_back(cv::Point3d(pmean[80], pmean[81], -40.0f));       // Left eye middle
	model_points.push_back(cv::Point3d(pmean[94], pmean[95], -40.0f));        // Right eye middle
	model_points.push_back(cv::Point3d(pmean[120], pmean[121], -45.0f));      // Left Mouth corner
	model_points.push_back(cv::Point3d(pmean[128], pmean[129], -45.0f));       // Right mouth corner

	cvInitMatHeader(rotation_matrix, 3, 3, CV_64FC1, R_matrix, CV_AUTOSTEP);
	for (int k = 1; k <= 330; k++) {
		cout << k << endl;
		// Read input image
		sout << k;
		picture = filename + sout.str() + ".jpg";
		im = cv::imread(picture);
		// 2D image points. If you change the image, you need to change vector
		for (int i = 0; i < 10; i++)
			fin >> point[i];
		//image_points.push_back(cv::Point2d(point[0], point[1]));    // Nose tip
																	//	image_points.push_back(cv::Point2d(399, 561));    // Chin
		//image_points.push_back(cv::Point2d(point[2], point[3]));     // Left eye middle
		//image_points.push_back(cv::Point2d(point[4], point[5]));    // Right eye middle
		//image_points.push_back(cv::Point2d(point[6], point[7]));    // Left Mouth corner
		//image_points.push_back(cv::Point2d(point[8], point[9]));    // Right mouth corner
																	//		cout << image_points[0] << endl;
		image_points.push_back(cv::Point2d(point[2], point[7]));    // Nose tip
																	//	image_points.push_back(cv::Point2d(399, 561));    // Chin
		image_points.push_back(cv::Point2d(point[0], point[5]));     // Left eye middle
		image_points.push_back(cv::Point2d(point[1], point[6]));    // Right eye middle
		image_points.push_back(cv::Point2d(point[3], point[8]));    // Left Mouth corner
		image_points.push_back(cv::Point2d(point[4], point[9]));    // Right mouth corner
																	// Camera internals
		focal_length = im.cols; // Approximate focal length.
		center = cv::Point2d(im.cols / 2, im.rows / 2);
		camera_matrix = (cv::Mat_<double>(3, 3) << focal_length, 0, center.x, 0, focal_length, center.y, 0, 0, 1);
		dist_coeffs = cv::Mat::zeros(4, 1, cv::DataType<double>::type); // Assuming no lens distortion

																		//cout << "Camera Matrix " << endl << camera_matrix << endl;
																		// Output rotation and translation

																		// Solve for pose
		cv::solvePnP(model_points, image_points, camera_matrix, dist_coeffs, rotation_vector, translation_vector);
		temp = rotation_vector;
		cvCopy(&temp, rotation_vector1);

		// Project a 3D point (0, 0, 1000.0) onto the image plane.
		// We use this to draw a line sticking out of the nose


		//	nose_end_point3D.push_back(Point3d(0, 0, 1000.0));


		projectPoints(mean3D, rotation_vector, translation_vector, camera_matrix, dist_coeffs, mean2D);
		string outName2 = "helentest20.txt";
		ofstream flbp2(outName2.c_str(), ios::app);
		for (int i = 0; i < 68;i++)
		flbp2 << mean2D[i].x << ' ' << mean2D[i].y<< ' ';


		string outName1 = "helentestrvector_t20.txt";
		ofstream flbp(outName1.c_str(), ios::app);
		for (int i = 0; i<3; i++)
		{
			double *data = rotation_vector.ptr<double>(i);
			flbp << data[0] << ' ';
		}
		/*for (int i = 0; i < 3; i++){
		for (int j = 0; j < 3; j++)
		flbp << cvmGet(rotation_matrix, i, j) << ' ';
		}
		for (int j = 0; j < 3; j++){
		double *data = translation_vector.ptr<double>(j);
		flbp << data[0] << ' ';
		}*/
		flbp << '\n';
		flbp.close();
		sout.str("");
		//nose_end_point3D.clear();
		//nose_end_point2D.clear();
		image_points.clear();
		mean2D.clear();
		//cout << nose_end_point2D << endl;
		// Display image.
	}
	fin.close();
	model_points.clear();
	cvReleaseMat(&rotation_vector1);
	cvReleaseMat(&rotation_matrix);
	//cv::imshow("Output", im);
	cv::waitKey(0);

}









