begin
  ;;;;��ȡ����   
  f   = addfile("./data/h300-197901-201412.nc", "r")   
  var := short2flt(f->hgt(0,{300},:,:)) 
  
  wks  = gsn_open_wks("eps","plot-hgt-Satellite")
  gsn_define_colormap(wks,"amwg256")
  
  res=True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@gsnAddCyclic = True          
  ;res@gsnMaximize  = True
  res@gsnLeftString = ""
  res@gsnRightString = ""  

   ; ͶӰ����
  res@mpCenterLonF       = 120.0       ; ͼ�����ľ��ȼ�
  res@mpCenterLatF       = 50.         ;           γ��
    
 ; color continents
 ; ����                            
 ; ��½����
 ; ½��
 ; turn on continental outlines
 ;"Geophysical" ; �߽��ߡ������ϳ��õ�Ϊ��National����AllBoundaries��
  
  ;; ���õ�ֵ��
  res@cnFillOn = False
  res@cnInfoLabelOn = False
  
  ; ��ֵ�����á�L�����
         ; turn on L labels
        ; change L font
  
  ; ��ֵ�����á�H�����
         ; turn on L labels
         ; change L font
  
  
  plot = gsn_csm_contour_map(wks,var,res)     
  
  draw(plot)  
  frame(wks)
end