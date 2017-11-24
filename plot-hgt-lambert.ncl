; �����Զ���һ����Ϊadd_lc_labels�ĳ����������Ӿ�γ�ȱ�ǩ
procedure add_lc_labels(wks,map,minlat,maxlat,minlon,maxlon,fontheight)
local lat_values, nlat, lat1_ndc, lat2_ndc, lon1_ndc, lon2_ndc,slope,txres, \
lon_values, PI, RAD_TO_DEG, dum_lft, dum_rgt, dum_bot
begin
  PI         = 3.14159
  RAD_TO_DEG = 180./PI

  ;�������Ϻá���γ�ȱ�ǩ
  lat_values = ispan(toint(minlat),toint(maxlat),10) * 1.
  nlat      = dimsizes(lat_values)
  
  ;�ֱ����ͼ������������б�ʣ�����NDC���꣩
  lat1_ndc = new(1,float)
  lon1_ndc = new(1,float)
  lat2_ndc = new(1,float)
  lon2_ndc = new(1,float)
  datatondc(map,minlon,lat_values(0),lon1_ndc,lat1_ndc)
  datatondc(map,minlon,lat_values(nlat-1),lon2_ndc,lat2_ndc)
  slope_lft = (lat2_ndc-lat1_ndc)/(lon2_ndc-lon1_ndc)

  datatondc(map,maxlon,lat_values(0),lon1_ndc,lat1_ndc)
  datatondc(map,maxlon,lat_values(nlat-1),lon2_ndc,lat2_ndc)
  slope_rgt = (lat2_ndc-lat1_ndc)/(lon2_ndc-lon1_ndc)
  
  txres              = True
  txres@txFontHeightF = fontheight
  txres@txPosXF     = 0.1

  dum_lft = new(nlat,graphic)    ; �������������Ի��ƾ�γ���ַ�
  dum_rgt = new(nlat,graphic)    ; 
  do n=0,nlat-1
    ;�����ʵ��հ�
    lat_label_rgt = "          "  + lat_values(n) + "~S~o~N~"  ;����¼ͼA.5

    ;����Ƿ��ڱ�γ����γ������ 
    if(lat_values(n).lt.0) then
      lat_label_lft = lat_values(n) + "~S~o~N~S          "  ;����¼ͼA.5
      lat_label_rgt = lat_label_rgt + "S"
    end if
    if(lat_values(n).gt.0) then
      lat_label_lft = lat_values(n) + "~S~o~N~N          "  ;����¼ͼA.5
      lat_label_rgt = lat_label_rgt + "N"
    end if
    if(lat_values(n).eq.0) then
      lat_label_lft = lat_values(n) + "~S~o~N~           "  ;����¼ͼA.5
    end if

    ;������������ǩ
    txres@txAngleF = RAD_TO_DEG * atan(slope_lft) - 90 ; �ʵ���ת�����Ը�������
    dum_lft(n) = gsn_add_text(wks,map,lat_label_lft,minlon,lat_values(n),txres)

    ;�����ұ������ǩ
    txres@txAngleF = RAD_TO_DEG * atan(slope_rgt) + 90
    dum_rgt(n) = gsn_add_text(wks,map,lat_label_rgt,maxlon,lat_values(n),txres)
  end do

;----------------------------------------------------------------------
  ; ���Ӿ��ȱ�ǩ
  delete(txres@txPosXF)
  txres@txPosYF = -5.0

  ;�������Ϻá��ľ��ȱ�ǩ
  lon_values = ispan(toint(minlon+10),toint(maxlon-10),10) * 1.
  nlon     = dimsizes(lon_values)

  dum_bot = new(nlon,graphic)    

  do n=0,nlon-1
    ; ����ÿ�����ȱ�ǩ������������ת�ĽǶȣ���ʹ����������ۡ�
    datatondc(map,lon_values(n)-0.25,minlat,lon1_ndc,lat1_ndc)
    datatondc(map,lon_values(n)+0.25,minlat,lon2_ndc,lat2_ndc)
    slope_bot = (lat1_ndc-lat2_ndc)/(lon1_ndc-lon2_ndc)
    txres@txAngleF  = atan(slope_bot) * RAD_TO_DEG

    ;��Բ�ͬ�Ķ�����������0�Ȼ��Ʋ�ͬ���ַ�
    lon_label_bot = "  ~C~  ~C~" + abs(lon_values(n)) + "~S~o~N~"  ;����¼ͼA.5
    if(lon_values(n).lt.0) then
      lon_label_bot = lon_label_bot + "W"
    end if
    if(lon_values(n).gt.0) then
      lon_label_bot = lon_label_bot + "E"
    end if

    dum_bot(n) = gsn_add_text(wks,map,lon_label_bot,lon_values(n),minlat,txres)
  end do
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

begin
  ; ���ƵĿռ䷶Χ
  minlat =  20.    
  maxlat =  70.    
  minlon =  60.    
  maxlon =  140.    
  fontheight = 0.012 ; ���������ǩ�����С
  
  ;;;;��ȡ����   
  f   = addfile("./data/h300-197901-201412.nc", "r")   
  var := short2flt(f->hgt(0,{300},{minlat:maxlat},{minlon:maxlon})) 
  
  wks  = gsn_open_wks("eps","plot-hgt-lambert")
  gsn_define_colormap(wks,"rainbow")
  
  res=True
  res@gsnDraw      = False
  res@gsnFrame     = False
  res@gsnAddCyclic = False          

  res@gsnLeftString = ""
  res@gsnRightString = ""  

  
  
   ; ͶӰ����
  res@mpMinLatF      = minlat
  res@mpMaxLatF      = maxlat
  res@mpMinLonF      = minlon
  res@mpMaxLonF      = maxlon

  res@mpGridAndLimbOn         = True  
  res@mpGridLatSpacingF       = 10
  res@mpGridLonSpacingF       = 10
  res@mpGridLineDashPattern   = 1
  res@mpGridLineColor         = "white"
     
  ;; ���õ�ֵ��
  res@cnFillOn = True
  res@cnLineLabelsOn = True
  res@cnLineLabelFontHeightF = 0.015
  res@lbLabelFontHeightF     = 0.015
  
  ; ��ֵ�����á�L�����
  res@cnLowLabelsOn              = True     ; turn on L labels
  res@cnLowLabelFontColor        = "white"
    
  plot = gsn_csm_contour_map(wks,var,res)     
  
  draw(plot)  
  frame(wks)
end