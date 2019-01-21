import numpy as np
from osgeo import gdal
#import sys
#import matplotlib.mlab as mlab
import matplotlib.pyplot as plt
import scipy
from scipy import signal
from scipy.misc import toimage
import cv2
from PIL import Image, ImageEnhance
from gdal import Open
import os
import csv
from skimage import data, io, filters, morphology, img_as_ubyte
import statistics
import math
import random
from shapely.geometry import Point, Polygon
#######################################################
def all_inte_coord(paint1):
    paint_gr=paint1.copy()
    paint_red=paint1.copy()
    
    for i in range(paint1.shape[0]):
        for j in range(paint1.shape[1]):
            if not(paint_gr[i,j,2]<50 and paint_gr[i,j,2]>22 and paint_gr[i,j,1]<200 and paint_gr[i,j,1]>150 and paint_gr[i,j,0]<90 and paint_gr[i,j,0]>54):
                paint_gr[i,j,0]=0
                paint_gr[i,j,1]=0
                paint_gr[i,j,2]=0
            else:
                paint_gr[i,j,0]=255
                paint_gr[i,j,1]=255
                paint_gr[i,j,2]=255
    for i in range(paint1.shape[0]):  
        for j in range(paint1.shape[1]):
            if not(paint_red[i,j,2]<255 and paint_red[i,j,2]>215 and paint_red[i,j,1]<50 and paint_red[i,j,1]>15 and paint_red[i,j,0]<50 and paint_red[i,j,0]>20):
                paint_red[i,j,0]=0
                paint_red[i,j,1]=0
                paint_red[i,j,2]=0
            else:
                paint_red[i,j,0]=255
                paint_red[i,j,1]=255
                paint_red[i,j,2]=2555           
    gre_coord=int_coord(paint_gr)
    red_coord=int_coord(paint_red)
   
    return(gre_coord,red_coord)
    ################################################################

def get_random_point_in_polygon(poly):
    (minx, miny, maxx, maxy) = poly.bounds
    while True:
        p = Point(random.uniform(minx, maxx), random.uniform(miny, maxy))
        if poly.contains(p):
            return p
################################################################################
def int_coord(paint2):
    gray_image = cv2.cvtColor(paint2, cv2.COLOR_BGR2GRAY)
#cv2.imwrite("2.jpg",gray_image)
    th, im_th = cv2.threshold(gray_image, 10, 255, cv2.THRESH_BINARY);
    im_floodfill = im_th.copy()
    h, w = im_th.shape[:2]
    mask = np.zeros((h+2, w+2), np.uint8)
    y=cv2.floodFill(im_floodfill, mask, (0,0), 255);
    im_floodfill_inv = cv2.bitwise_not(im_floodfill)
    im_out = im_th | im_floodfill_inv
    _ , img = cv2.threshold(im_out,0,255,cv2.THRESH_BINARY)
    image,contours,hierarchy = cv2.findContours(img,cv2.RETR_LIST, cv2.CHAIN_APPROX_NONE)
    #cv2.drawContours(paint11, contours, -1, (0,0,255), 6)
    check=[]
    i=0
    for i in range(len(contours)):
        M=cv2.moments(contours[i])
        if(M['m00']!=0):
            cx=int(M['m10']/M['m00'])
            cy=int(M['m01']/M['m00'])
        else:
            cx=0
            cy=0
        if (cx!=0 and cy!=0):
            if not([cx,cy] in check ):
                check.extend([[cx,cy]])
    return(check);    
            
        
            
                
####################################################################################            
    