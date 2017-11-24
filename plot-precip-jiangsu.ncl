load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/esmf/ESMF_regridding.ncl" ; ���轫̨վ���ϲ�ֵ��������ϣ��������ظ�ncl�ļ�

begin
  
  regrid_On = True  ; �Ƿ���Ҫ��ֵ��
  ;!! ע�⣬��������̨վ���Ϸֱ��ʽϵͣ�ֱ���ø����Ͻ��л�ͼ������ڽ���ʡ�߽紦����Щ�հס���ˣ�Ϊ�ﵽ�Ϻõ�ͼ��Ч�������Ƚ���ˮ���ϲ�ֵ��0.1�Ⱦ��Ⱦ�γ��������ϡ�����������ע�⣬�����ɵͷֱ��ʲ�ֵ���߷ֱ��ʵĽ�����ܴ��ڽϴ�����˸�������ʾ�������á�
   
  preci = fbindirread("./data/preci-160-JJA-30yr.grd",0,(/30,160/),"float")
  preci!0 = "year"
  preci!1 = "stations"
  preci&year = ispan(1979,2008,1)
  preci&stations = ispan(1,160,1)
  
  var = dim_avg_n_Wrap(preci,0) ; ȡ����ƽ��
  
  ;; ��ȡ����̨վ�ľ�γ������
  path_station = "./data/160stations.txt"
  station = asciiread(path_station,(/160,2/),"float") 
  lat = station(:,0)
  lon = station(:,1)
  
  ;�Ƿ���в�ֵ
  if(regrid_On)
    minlat = min(lat)
    maxlat = max(lat)
    minlon = min(lon)
    maxlon = max(lon)
      
    Opt                 = True
    Opt@SrcGridLat      = lat
    Opt@SrcGridLon      = lon
    Opt@DstLLCorner     = (/floor(minlat)-0.1,floor(minlon)+0.1/)
    Opt@DstURCorner     = (/ceil(maxlat)-0.1, ceil(maxlon)+0.1/)
    Opt@DstGridType     = "0.1deg"   ; ��ֵ�����ݵķֱ���
    Opt@ForceOverwrite  = True
    Opt@Debug           = True
    
    Opt@InterpMethod    = "patch" ; ���� "bilinear"
    var := ESMF_regrid(var,Opt) ; ���ڲ�ֵ������ά����С��ԭvar��һ�£���������"="ǰ���ϡ�:�� 
  end if
 
  wks  = gsn_open_wks("eps","plot-preci-jiangsu")
  gsn_define_colormap(wks,"gsltod")
  
  res=True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@gsnAddCyclic = False          
  res@gsnMaximize  = True
  
  ;; ������ֵ����ֱ����̨վ���ϻ���
  if(.not.regrid_On)
   res@sfXArray    = lon
   res@sfYArray    = lat
  end if
  
  ;; ���þ�γ��   
  res@mpGridAndLimbOn       = True 
  res@mpGridLineColor       = "red"
  res@mpGridLatSpacingF     = 1
  res@mpGridLonSpacingF     = 1
  res@mpGridLineDashPattern = 16
  res@mpGridLineThicknessF  = 0.2
 
  res@mpMaxLatF = 36  
  res@mpMinLatF = 30
  res@mpMaxLonF = 123
  res@mpMinLonF = 116  

     ; �еȷֱ���             
                         
                
     
  
                               
    
  

   
          
  
  
  ;;���������ǩ�������С
  res@pmTickMarkDisplayMode  = "Always"
  res@tmXBLabelFontHeightF   = 0.018    ; YL��ǩ�����С��ͬ���仯�����Բ�������
  
  ;;���õ�ֵ��
  res@cnFillOn         = True     
  res@cnLineColor      = "white"
  res@cnLineThicknessF = 0.5
  res@lbOrientation    = "Vertical" ; ��ֱ�ڷ�

  res@cnLevelSelectionMode = "ManualLevels"
  res@cnMinLevelValF       = 500     
  res@cnMaxLevelValF       = 560
  res@cnLevelSpacingF      = 5
    
   
   

  plot = gsn_csm_contour_map(wks,var,res)    

  draw(plot)  
  frame(wks)
end