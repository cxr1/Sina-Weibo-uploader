#SingleInstance force
#NoEnv
SetControlDelay -1

Text:="|<>*210$29.3A7zy4M1VUMM331UE6660kAAM0rzzVUkkk301VUAk330Ek4610UMA6TVUMT1a0l" ;公开
Text1:="|<>*160$43.0C00Q700700C7003U07TzU1k07Dzs0s03bzw0Q01ks00DzVkQ007zktzzk3zswzzs1k0S7000s0T3U00Q07Vzy0C02kzz0700MTz03U0A07U1k0677U0s037zVzzzVUzUzzzkk7wTzzsM0S0000A024" ;上传
Text2:="|<>*140$30.403zy4zsEE410EET10EE410EE417zz510EEC10EEo10EE410EE410UE4110EQD20EU" ;打开
Text3:="|<>*165$59.0U0V00U01M101Tw1U02M20483zzDzs408E406E80DsrzU00UE0E2W07zVyW0U540002BA102DtzzYOE2040k8U8r0409X0F2FaE80Ew1W5WMUE0UM64+Rdzzl0MkDo6D" ;上传完成

Run msedge.exe https://weibo.com/login.php/
Sleep 5000
MouseClick, Left,1715 ,130
Sleep 1000
MouseClick, Left,1071 ,377

Loop {
if (FindText(1084, 278, 1162, 332, 0, 0, Text)){
    Sleep 100
    MouseClick, Left,722 ,316
    Break
    }
}
Loop {
    if (FindText(534, 173, 622, 241, 0, 0, Text1)){
        MouseClick, Left,958 ,635
        Break
        }
}
Loop {                                               ;打开文件选择界面，并选择显示所有文件
    if (FindText(12, 3, 92, 35, 0, 0, Text2)){
        MouseClick, Left,574, 57
        ;MsgBox %fliepath%
        Sleep 100
        Send ^{A}
        send {BS}
        SendInput {Text}C:\Users\CXR\Desktop\微博视频
        MouseClick, Left,655, 62
        MouseClick, Left,1018, 518
        MouseClick, Left,1018, 562
        Break
        }
}

;y := 172
Loop,Files,C:\Users\CXR\Desktop\微博视频\*.*,R 
{
    
    ;MouseClick, Left,468, %y%  ;选择文件
    ;MouseClick, Left,948, 555  ;打开
    MouseClick, Left,962,61
    clipboard := SubStr(A_LoopFileName, 1, InStr(A_LoopFileName,".")-1)
    ;MsgBox %filename%
    ;Sleep 1000
    ;SendInput {Text}%filename%
    ;Send {Enter}
    Sleep 300
    Send ^v
    Sleep 5000
    MouseClick, Left,1111,60
    Sleep 5000
    MouseClick, Left,530,152
    MouseClick, Left,948, 555  ;打开
    ;y+=26
    Loop {
        if (FindText(545, 303, 665, 339, 0, 0, Text3)){
        Sleep 15000
        MouseClick, Left,672, 498
        Send %A_LoopFileName%
        Send {Enter}
        Sleep 3000
        Click, WheelDown 5
        Sleep 2000
        MouseClick, Left,688, 467
        Send %A_LoopFileName%
        Send {Enter}
        MouseClick, Left,1200, 559
        MouseClick, Left,1095, 771
        MouseClick, Left,1309, 562
        Sleep 1000
        MouseClick, Left,966, 432
        Break
        }
    }
    Loop {
    if (FindText(534, 173, 622, 241, 0, 0, Text1)){
        MouseClick, Left,958 ,635
        Break
        }
    }
    Loop {
    if (FindText(12, 3, 92, 35, 0, 0, Text2)){
        MouseClick, Left,574, 57
        ;MsgBox %fliepath%
        Sleep 100
        Send ^{A}
        send {BS}
        SendInput {Text}C:\Users\CXR\Desktop\微博视频
        MouseClick, Left,655, 62
        MouseClick, Left,1018, 518
        MouseClick, Left,1018, 562
        Break
        }
    }
    
}
MsgBox 全部上传完成
ExitApp


;函数部分

FindText(args*)
{
  return FindText.FindText(args*)
}

Class FindText
{  ;// Class Begin

static bind:=[], bits:=[], Lib:=[]

__New()
{
  this.bind:=[], this.bits:=[], this.Lib:=[]
}

__Delete()
{
  if (this.bits.hBM)
    DllCall("DeleteObject", "Ptr",this.bits.hBM)
}

FindText( x1, y1, x2, y2, err1:=0, err0:=0, text:="", ScreenShot:=1
  , FindAll:=1, JoinText:=0, offsetX:=20, offsetY:=10, dir:=1 )
{
  local
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  x:=(x1<x2?x1:x2), y:=(y1<y2?y1:y2)
  , w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  , this.xywh2xywh(x,y,w,h,x,y,w,h,zx,zy,zw,zh)
  if (w<1 or h<1)
  {
    SetBatchLines, %bch%
    return 0
  }
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy,zw,zh)
  info:=[]
  Loop, Parse, text, |
    if IsObject(j:=this.PicInfo(A_LoopField))
      info.Push(j)
  if (!(num:=info.MaxIndex()) or !bits.Scan0)
  {
    SetBatchLines, %bch%
    return 0
  }
  arr:=[], in:={zx:zx, zy:zy, zw:zw, zh:zh
  , sx:x-zx, sy:y-zy, sw:w, sh:h}, k:=0
  For i,j in info
    k+=Round(j.8=5 ? j.10 : j.2*j.3), in.comment .= j.11
  VarSetCapacity(s1, k*4), VarSetCapacity(s0, k*4)
  , VarSetCapacity(gs, (w+2)*(h+2)), VarSetCapacity(ss, w*h)
  , JoinText:=(num=1 ? 0 : JoinText)
  , allpos_max:=(FindAll or JoinText ? 10240 : 1)
  , VarSetCapacity(allpos, allpos_max*2*4)
  Loop, 2
  {
    if (err1=0 and err0=0) and (num>1 or A_Index>1 or info.1.8=5)
      err1:=0.05, err0:=0.05
    Loop, % JoinText ? 1 : num
    {
      this.PicFind(arr, in, info, A_Index, err1, err0, dir
        , bits, 0, 0, offsetX, offsetY, gs, ss, s1, s0
        , allpos, allpos_max, FindAll, JoinText)
      if (!FindAll and arr.MaxIndex())
        Break
    }
    if (err1!=0 or err0!=0 or arr.MaxIndex())
      Break
  }
  SetBatchLines, %bch%
  return arr.MaxIndex() ? arr:0
}

PicFind(arr, in, info, index, err1, err0, dir
  , bits, x, y, offsetX, offsetY
  , ByRef gs, ByRef ss, ByRef s1, ByRef s0
  , ByRef allpos, allpos_max, FindAll, JoinText)
{
  local
  static MyFunc:=""
  if (!MyFunc)
  {
    x32:=""
    . "5557565383EC548B9424880000008B8C24900000008B84248C00000001D13B8C"
    . "24800000000F4F8C248000000089CF894C242C31C985D20F48D189D689542424"
    . "8B94249400000001C23B9424840000000F4F94248400000085C00F49C889CB89"
    . "4C242889F929F18954243829DA85C9894C24048954241C0F8E8602000085D20F"
    . "8E7E020000837C2468050F84810200008B9C24B000000085DB0F8EDB07000031"
    . "FFC744241000000000C744240C0000000031EDC744241800000000897C241490"
    . "8B4C24148BB424AC0000008B5C24188B54241001CE89C829CB8B8C24AC000000"
    . "039C24A800000085C97E6D897C240889D1891C24EB218D76008DBC2700000000"
    . "8BBC24A400000083C00183C1048914AF83C50139C67432837C2468038B3C2489"
    . "CA0F45D0803C073175D68B5C24088BBC24A000000083C00183C10439C689149F"
    . "8D7B01897C240875CE8BB424AC000000017424188B7C24088344240C018B5C24"
    . "048B44240C015C24148B74247C01742410398424B00000000F8542FFFFFF897C"
    . "243431C08B7C243439BC24B40000000F4DF839AC24B8000000897C24340F4DE8"
    . "39EF0F4CFD837C246803897C243C0F84730100008B4424288B7C24240FAF4424"
    . "7C8B74247CC1E702897C24148D1C388B7C240489F8F7D88D0C868B44246885C0"
    . "0F84DA010000837C2468010F84DB050000837C2468020F848D0600008B44246C"
    . "896C24508BAC249C000000895C2430C1E8100FB6D08B44246C895424080FB6FC"
    . "8B442470C1E8100FB6F08B44247029F20374240889142489FA0FB6C429C28944"
    . "24100FB644246C8954240C037C24108974240889C20FB644247089542414897C"
    . "24108B7C240429C203442414C74424140000000089542418BA04000000894424"
    . "2089F8C1E00285FF0F4EC201C885FF89442444B80100000089C60F4FF731FF89"
    . "7424488B44243089FA03442478EB4090395C24087C49394C240C7F43394C2410"
    . "7C3D89F30FB6F3397424180F9EC3397424200F9DC121D9884C150083C20183C0"
    . "0489D129F9394C24040F8E230200000FB658020FB64801391C240FB6307EB131"
    . "C9EBD431DB83C45489D85B5E5F5DC25C008B4424708944243C8B44246C894424"
    . "40F7D88944244C8B44247483E80183F8030F87C50800008B44246883E80383E0"
    . "FD0F85610100008B44242C2B8424AC000000C7442414000000008944240C8B44"
    . "24382B8424B0000000837C247401894424108B442428894424088B4424248904"
    . "240F8461010000837C2474020F84A8010000837C2474030F84300300008B7424"
    . "0C31DB3B34248B7C24080F8C55FFFFFF3B7C24100F8E9D01000083EE01EBE490"
    . "8B44246CBA04000000896C24308BAC249C000000895C2414C744241000000000"
    . "C1E8100FB6C08904248B44246C0FB6C4894424080FB644246C8944240C89F8C1"
    . "E00285FF0F4EC201C885FF89442418B8010000000F4FC731FF894424208D7600"
    . "8B5C2414035C247889FE8DB6000000000FB643020FB64B012B04242B4C24080F"
    . "B6132B54240C0FAFC00FAFC98D04400FAFD28D04888D0450394424700F934435"
    . "0083C60183C30489F029F8394424047FBF83442410018B5C24188B442410015C"
    . "2414037C24203944241C7F948B6C24308B44247483E80183F8030F8697FEFFFF"
    . "C7442474010000008B4424042B8424AC000000C744240800000000C704240000"
    . "0000C7442414010000008944240C8B44241C2B8424B0000000837C2474018944"
    . "24100F859FFEFFFF8B7C240831DB3B7C24108B34240F8F0AFEFFFF3B74240C7E"
    . "5683C7013B7C24108B34247EEEE9F3FDFFFF83442414018B5C24448B44241401"
    . "5C2430037C24483944241C0F8F72FDFFFF8B6C2450E956FFFFFF8B7C241031DB"
    . "3B7C24088B34240F8CB8FDFFFF3B74240C0F8F6D0200008B44241485C00F858C"
    . "0100008B44247C0FAFC7837C2468038D04B00F844D0500008B54243C89442430"
    . "85D20F8EE80000008B8C24A0000000030189C18B8424A40000008B008944246C"
    . "8B4424780FB614080FB644246C29C28B44244C39C20F8CE90000003B5424400F"
    . "8FDF000000895C24188974241C31D2897C242089C6896C242C8B5C246C8B7C24"
    . "78EB338B8424A00000008B4C2430030C908B8424A40000008B1C900FB6040F0F"
    . "B6EB29E8394424400F8CFB05000039C60F8FF30500000FB6440F010FB6EF29E8"
    . "8B6C244039C50F8CDD05000039C60F8FD50500000FB6440F0289D9C1E9100FB6"
    . "C929C839C50F8CBE05000039C60F8FB605000083C2013B54243C75878B74241C"
    . "8B7C24208B6C242C895C246C8B5C24188B4C24148B4424248B9424BC0000000F"
    . "AFC101F08904DA8B4424280FAFC101F88944DA0483C3013B9C24C00000000F8D"
    . "61FCFFFF837C2474010F840E040000837C2474020F84FB030000837C2474030F"
    . "842F05000083C701E9E3FCFFFF8B342431DB3B74240C8B7C24080F8F25FCFFFF"
    . "3B7C24100F8E6DFEFFFF83C601EBE38B4424048B54243C0FAFC701F085D289C1"
    . "8944242C8B8424B80000008944244C8B8424B4000000894424407E6C038C249C"
    . "000000895C241831C08B5C24348974241C897C242039D87D1C8BBC24A0000000"
    . "8B348701CE803E00750B836C2440010F884F03000039E87D1C8BBC24A4000000"
    . "8B348701CE803E00740B836C244C010F882F03000083C00139D075B98B5C2418"
    . "8B74241C8B7C24208B44243485C00F84DCFEFFFF8B9424A00000008B4C242C8D"
    . "0482894424188B84249C00000001C18B0283C20401C83B542418C6000075F0E9"
    . "ACFEFFFF83EF01E974FDFFFF8B44246C8B7C2404BA04000000896C24148BAC24"
    . "9C000000895C2408C704240000000083C001C1E0078944246C89F8C1E00285FF"
    . "0F4EC201C885FF8944240C89F80F4E44246831FF894424108B4C2408034C2478"
    . "89FB0FB651026BF2260FB651016BC24B8D14060FB63189F0C1E00429F001D039"
    . "44246C0F97441D0083C30183C10489D829F8394424047FCA830424018B5C240C"
    . "8B0424015C2408037C24103944241C7FA78B6C2414E916FCFFFF31EDC7442434"
    . "00000000E9F9F8FFFF8B44242883E801394424388904240F8CFE0000008B7424"
    . "24C744241000000000896C244489F083E801894424208B04240FAF44247C8944"
    . "240C8B44243883C001894424188B44242C8D780129F083C002894424308B4424"
    . "203944242C0F8C930000008B0C248B5C240C8B742410035C24142B742424035C"
    . "2478C1E91F03B42498000000894C2408EB4C398424800000007E4C807C240800"
    . "75458B0C24398C24840000007E390FB64BFE83C3046BE9260FB64BF96BD14B8D"
    . "4C15000FB66BF889EAC1E20429EA01CAC1FA078854060183C00139F8741889C2"
    . "C1EA1F84D274ABC64406010083C00183C30439F875E88B742430017424108304"
    . "24018B5C247C8B0424015C240C394424180F8546FFFFFF8B6C24448B7C2404B8"
    . "01000000C744240C0000000089C6C744240801000000896C243085FF89F80F4F"
    . "F78D7F0283C0048974241489442420897C241803BC2498000000897C24108B54"
    . "24108B7C2420B9010000008B5C240C890C2489D62B74240401D78DB600000000"
    . "0FB642010FB62AB9010000000344246C39E8723C0FB66A0239E872340FB66EFF"
    . "39E8722C0FB66FFF39E872240FB66EFE39E8721C0FB62E39E872150FB66FFE39"
    . "E8720D0FB62F39E80F92C1908D7426008BAC249C0000008304240183C20183C7"
    . "0183C601884C1D0083C3018B0C24394C24047D8C83442408018B5C24148B7C24"
    . "08015C240C8B5C2418015C2410397C241C0F8D47FFFFFF8B6C243089442470E9"
    . "ECF9FFFF8B5C24188B74241C8B7C2420E9EFFBFFFF83C601E990FAFFFF83C601"
    . "E936FAFFFF8944241C0344246C8B4C24780FB64C0102894C24208B4C24780FB6"
    . "4C0101894C242C8B4C24780FB604018B4C243C85C9894424308B8424B8000000"
    . "8944244C8B8424B4000000894424400F8E5BFBFFFF895C241831C98B5C2478EB"
    . "6C39E97D5B8B9424A40000008B44241C03048A0FB65403022B54242089542438"
    . "0FB65403010FB604032B54242C2B4424300FAFD2894424448B4424380FAFC08D"
    . "04408D14908B4424440FAFC08D04423B442470770B836C244C010F8899000000"
    . "83C1013B4C243C0F84DFFAFFFF3B4C24347D8E8B9424A00000008B44241C0304"
    . "8A0FB65403022B542420895424380FB65403010FB604032B54242C2B4424300F"
    . "AFD2894424448B4424380FAFC08D04408D14908B4424440FAFC08D04423B4424"
    . "700F863AFFFFFF836C2440010F892FFFFFFFEB2583C701E9E4FAFFFFC7442474"
    . "01000000E93EF7FFFF8B74241C8B7C24208B6C242C895C246C8B5C2418E982FA"
    . "FFFF9090909090909090909090909090"
    x64:=""
    . "4157415641554154555756534883EC688B8424F8000000488BB4242801000089"
    . "5424204589C68B9424F0000000448B84240001000044898C24C80000004101D0"
    . "443B8424E0000000440F4F8424E00000004589C7448944242C4531C085D2410F"
    . "48D089D7895424248B94240801000001C23B9424E80000000F4F9424E8000000"
    . "85C0440F49C04129FF4489442428895424304429C24585FF8954241C0F8ECD02"
    . "000085D20F8EC502000083F9050F84D3020000448B9424400100004585D20F8E"
    . "CC08000044897C24104489B424C00000004531ED4C8BB42420010000448BBC24"
    . "3801000031ED4531E44531D231DBC744240800000000662E0F1F840000000000"
    . "4585FF7E624863542408428D7C3D0089E848039424300100004589E8EB1C6690"
    . "83C0014D63DA4183C0044183C2014883C20139C746890C9E742883F9034589C1"
    . "440F45C8803A3175D783C0014C63DB4183C00483C3014883C20139C747890C9E"
    . "75D844017C24084183C401036C24104403AC24D80000004439A424400100000F"
    . "857BFFFFFF448B7C2410448BB424C000000031C0399C24480100000F4DD84439"
    . "942450010000440F4DD04439D34489D00F4DC383F903894424340F84D9010000"
    . "8B4424288B7C24240FAF8424D80000008B9424D80000008D3CB84489F8F7D885"
    . "C9448D04820F844902000083F9010F84C306000083F9020F849D0700008B5424"
    . "204489B424C00000004889B424280100004489542454898C24B000000089D044"
    . "0FB6DA0FB6D6C1E8104189D5440FB6E04489F0C1E8104489E5440FB6C84C89F0"
    . "4429CD0FB6C444894C2408896C24504189C14129C54489DD410FB6C64101D129"
    . "C54401D8440364240889442448428D04BD000000004585FFBA04000000896C24"
    . "404189FB0F4EC24585FF488BBC2418010000428D1400B801000000448B742448"
    . "410F4FC78B7424408B6C2450895424084863D0895C2450488954241031D24589"
    . "CA89D3488B8C24D00000004963C331D2488D440102EB38660F1F840000000000"
    . "4539CC7C3C4139CD7F374139CA7C324439C6410F9EC14539C60F9DC14883C004"
    . "4421C9880C174883C2014139D77E24440FB6080FB648FF440FB640FE4439CD7E"
    . "BF31C94883C004880C174883C2014139D77FDC83C30144035C240848037C2410"
    . "395C241C0F8F79FFFFFF8B5C2450448B5424548B8C24B0000000448BB424C000"
    . "0000488BB42428010000E9B90100004531DB4489D84883C4685B5E5F5D415C41"
    . "5D415E415FC38B442420448974243489442438F7D88944243C8B8424C8000000"
    . "83E80183F8030F87010A00008D41FD83E0FD0F858E0100008B44242C2B842438"
    . "010000448B642428448B6C2424C744241C00000000894424088B4424302B8424"
    . "4001000083BC24C800000001894424100F848901000083BC24C8000000020F84"
    . "A501000083BC24C8000000030F841E0300008B7C24084531DB4439EF4489E50F"
    . "8C4DFFFFFF3B6C24100F8E9701000083EF01EBE58B5424204889B42428010000"
    . "488BB424D0000000895C24104489542450898C24B00000004889D089D5440FB6"
    . "E20FB6C4C1ED10BA040000004189C5428D04BD000000004585FF400FB6ED0F4E"
    . "C289FA488BBC24180100004401C04585FF4189D289442408B801000000410F4F"
    . "C74531DB48984889C30F1F80000000004963C24531C94C8D4406020F1F440000"
    . "410FB600410FB648FF410FB650FE29E84429E90FAFC04429E20FAFC98D04400F"
    . "AFD28D04888D04504139C6420F93040F4983C1014983C0044539CF7FC34183C3"
    . "0144035424084801DF44395C241C7FA08B5C2410448B5424508B8C24B0000000"
    . "488BB424280100008B8424C800000083E80183F8030F8671FEFFFFC78424C800"
    . "0000010000004489F82B8424380100004531E44531ED894424088B44241C2B84"
    . "244001000083BC24C800000001C744241C01000000894424100F8577FEFFFF44"
    . "89E54531DB3B6C24104489EF0F8FE0FDFFFF3B7C24087E2E83C5013B6C241044"
    . "89EF7EEEE9C9FDFFFF8B6C24104531DB4439E54489EF0F8CB6FDFFFF3B7C2408"
    . "0F8FE9020000448B4C241C89E84585C90F857C0100000FAF8424D800000083F9"
    . "038D04B80F84660600008B5424348944245485D20F8E40020000488B94242001"
    . "00004C8B8424D000000003024189C18B0689C2894424204963C1410FB604000F"
    . "B6D229D03B44243C0F8C4F0200003B4424380F8F450200008B44243444895C24"
    . "2C4531C0897C2430896C245044896C2440448B5C243883E8018B7C243C8B5424"
    . "2048C1E002488BAC24D00000004889442448EB3B488B842420010000448B4C24"
    . "54428B54060446034C00044983C004440FB6EA4963C10FB64405004429E84139"
    . "C30F8C1607000039C70F8F0E070000418D410148980FB6440500894424200FB6"
    . "C64189C58B4424204429E84139C30F8CE906000039C70F8FE1060000418D4102"
    . "4189D141C1E9104898450FB6C90FB64405004429C84139C30F8CBF06000039C7"
    . "0F8FB70600004C3B4424480F8563FFFFFF448B5C242C8B7C24308B6C2450448B"
    . "6C244089542420E90E0100000F1F40004489EF4531DB3B7C24084489E50F8F2F"
    . "FCFFFF3B6C24100F8E79FEFFFF83C701EBE4410FAFC78B542434448D0C388B84"
    . "245001000085D28944243C8B842448010000894424380F8E7F00000044895C24"
    . "2C31C04189D3898C24B00000000F1F0039D889C27D2C488B8C2420010000448B"
    . "0481488B8C24180100004501C84D63C042803C0100750B836C2438010F886D04"
    . "00004439D27D1F4489CA031486488B8C2418010000803C1100740B836C243C01"
    . "0F88490400004883C0014139C37FA1448B5C242C8B8C24B000000085DB743B48"
    . "8B8424200100008D53FF898C24B00000004C8D4490048B10488B8C2418010000"
    . "4883C0044401CA4C39C04863D2C604110075E38B8C24B0000000438D041B448B"
    . "44241C4C8B8C24580100004183C3014863D08B442424410FAFC001F841890491"
    . "8B442428410FAFC001E8443B9C246001000041894491040F8DF5FAFFFF83BC24"
    . "C8000000010F84BD03000083BC24C8000000020F84A703000083BC24C8000000"
    . "030F84FE04000083C501E976FBFFFF83ED01E9F9FCFFFF8B542420428D04BD00"
    . "0000004189FC895C2408898C24B0000000488BBC2418010000488B9C24D00000"
    . "0083C2014889B424280100004489542410C1E2074585FF4189D389542420BA04"
    . "0000000F4EC24401C04585FF89C289C88B4C241C410F4FC789D631ED4C63E849"
    . "63C44531C94C8D440302660F1F440000410FB610410FB640FF450FB650FE6BC0"
    . "4B6BD22601C24489D0C1E0044429D001D04139C3420F97040F4983C1014983C0"
    . "044539CF7FCA83C5014101F44C01EF39E97FAC8B5C2408448B5424108B8C24B0"
    . "000000488BB42428010000E998FBFFFF4531D231DBE9F8F7FFFF8B442428448D"
    . "68FF44396C24300F8C5B0100008B542424448B7424304531DB8BBC24D8000000"
    . "448954245C4889B42428010000448B9424E000000089D04183C6018BB424E800"
    . "000083E801448974240844897C245489442410C1E0024589DF89442450489889"
    . "5C245848894424408B44242C410FAFFD898C24B0000000448D700129D083C002"
    . "894424488B4424103944242C0F8CA30000008B5C24504C8B6424404D63C74863"
    . "EF4C038424100100008D141F4489EBC1EB1F4863D24989D14929D44C038C24D0"
    . "000000EB4E4139C27E5284DB754E4439EE7E49410FB6490283C0014983C00144"
    . "6BD926410FB649016BD14B418D0C134B8D140C4983C104440FB61C2A4489DAC1"
    . "E2044429DA01CAC1FA07418850FF4439F0741D89C2C1EA1F84D274A983C00141"
    . "C600004983C1044983C0014439F075E344037C24484183C50103BC24D8000000"
    . "44396C24080F8539FFFFFF448B7C24548B5C2458448B54245C8B8C24B0000000"
    . "488BB42428010000488BBC2410010000418D47024585FF4C8BAC241801000089"
    . "8C24B0000000BD0100000048984889B42428010000895C24504C8D6407014889"
    . "442410B801000000410F4FC74489542440489848894424084963C7488D780348"
    . "F7D04889C64889FA8B7C24204889D14E8D14214E8D0C264D89E84C89E0BA0100"
    . "0000440FB630440FB658FFBB010000004101FE4539DE7248440FB658014539DE"
    . "723E450FB659FF4539DE7234450FB65AFF4539DE722A450FB659FE4539DE7220"
    . "450FB6194539DE7217450FB65AFE4539DE720D450FB61A4539DE0F92C30F1F00"
    . "83C2014188184883C0014983C0014983C2014983C1014139D77D8783C5014C03"
    . "6424104C036C2408396C241C0F8D5DFFFFFF8B5C2450448B5424408B8C24B000"
    . "0000488BB42428010000E9F9F8FFFF448B5C242C8B8C24B0000000E93DFCFFFF"
    . "83C701E974F9FFFF83C701E942F9FFFF8B5424208944242C4C8B8424D0000000"
    . "01C24863C28D50024863D2410FB61410895424308D5001410FB604004863D241"
    . "0FB61410894424408B842450010000895424504C89C2448B4424348944243C8B"
    . "8424480100004585C0894424380F8E87FBFFFF898C24B00000004531C94889D1"
    . "4139D94489C87D734C8B8424200100008B54242C43031488448D42024D63C046"
    . "0FB60401442B4424304489442448448D42014863D20FB614112B5424404D63C0"
    . "460FB60401442B442450895424548B542448450FAFC00FAFD28D1452468D0482"
    . "8B5424540FAFD2418D14504439F2760B836C2438010F889D0000004439D07D51"
    . "8B54242C4203148E8D4202448D42014863D20FB6141148984D63C02B5424400F"
    . "B60401460FB604012B442430442B4424500FAFD20FAFC0450FAFC08D0440428D"
    . "04808D04504439F07707836C243C0178474983C10144394C24340F8F20FFFFFF"
    . "E98EFAFFFF83C501E996F9FFFFC78424C800000001000000E9FBF5FFFF448B5C"
    . "242C8B7C24308B6C2450448B6C244089542420E9A5FAFFFF8B8C24B0000000E9"
    . "99FAFFFF909090909090909090909090"
    this.MCode(MyFunc, A_PtrSize=8 ? x64:x32)
  }
  num:=info.MaxIndex(), j:=info[index]
  , text:=j.1, w:=j.2, h:=j.3, mode:=j.8
  , color:=j.9, n:=j.10, comment:=j.11
  , e1:=(err1 and !j.12 ? Round(j.4*err1) : j.6)
  , e0:=(err0 and !j.12 ? Round(j.5*err0) : j.7)
  , sx:=in.sx, sy:=in.sy, sw:=in.sw, sh:=in.sh
  , Scan0:=bits.Scan0, Stride:=bits.Stride
  if (mode=3)
    color:=(color//w)*Stride+Mod(color,w)*4
  else if (mode=5)
  {
    r:=StrSplit(text,"/"), i:=0
    Loop, % n
      NumPut(r[3*i+2]*Stride+r[3*i+1]*4, s1, 4*i, "int")
      , NumPut(r[3*i+3], s0, 4*i, "uint"), i++
  }
  if (!JoinText or index=1)
    x1:=sx, y1:=sy, x2:=sx+sw, y2:=sy+sh
  else
  {
    x1:=x, y1:=y-offsetY, y1:=(y1<sy ? sy:y1)
    , x2:=x+offsetX+w, x2:=(x2>sx+sw ? sx+sw:x2)
    , y2:=y+offsetY+h, y2:=(y2>sy+sh ? sy+sh:y2)
  }
  ok:=!Scan0 ? 0:DllCall(&MyFunc
    , "int",mode, "uint",color, "uint",n, "int",dir
    , "Ptr",Scan0, "int",Stride, "int",in.zw, "int",in.zh
    , "int",x1, "int",y1, "int",x2-x1, "int",y2-y1
    , "Ptr",&gs, "Ptr",&ss, "Ptr",&s1, "Ptr",&s0
    , "AStr",text, "int",w, "int",h, "int",e1, "int",e0
    , "Ptr",&allpos, "int",allpos_max)
  pos:=[]
  Loop, % ok*2
    pos[A_Index]:=NumGet(allpos, 4*(A_Index-1), "uint")
  Loop, % ok
  {
    x:=pos[2*A_Index-1], y:=pos[2*A_Index]
    if (!JoinText)
      arr.Push( {1:x+=in.zx, 2:y+=in.zy, 3:w, 4:h
      , x:x+w//2, y:y+h//2, id:comment} )
    else if (index=1)
    {
      in.x:=x+w, in.y:=y, in.minY:=y, in.maxY:=y+h
      Loop, % num-1
        if !this.PicFind(arr, in, info, A_Index+1, err1, err0, 3
        , bits, in.x, in.y, offsetX, offsetY, gs, ss, s1, s0
        , allpos, allpos_max, FindAll, JoinText)
          Continue, 2
      x1:=x+in.zx, y1:=in.minY+in.zy
      , w1:=in.x-x, h1:=in.maxY-in.minY
      , arr.Push( {1:x1, 2:y1, 3:w1, 4:h1
      , x:x1+w1//2, y:y1+h1//2, id:in.comment} )
    }
    else
    {
      in.x:=x+w, in.y:=y
      , (y<in.minY && in.minY:=y)
      , (y+h>in.maxY && in.maxY:=y+h)
      return 1
    }
    if (!FindAll and arr.MaxIndex())
      return
  }
}

PicInfo(text)
{
  local
  static info:=[]
  if !InStr(text,"$")
    return
  if (info[text])
    return info[text]
  v:=text, comment:="", e1:=e0:=0, set_e1_e0:=0
  ; You Can Add Comment Text within The <>
  if RegExMatch(v,"<([^>]*)>",r)
    v:=StrReplace(v,r), comment:=Trim(r1)
  ; You can Add two fault-tolerant in the [], separated by commas
  if RegExMatch(v,"\[([^\]]*)]",r)
  {
    v:=StrReplace(v,r), r:=StrSplit(r1, ",")
    , e1:=r.1, e0:=r.2, set_e1_e0:=1
  }
  r:=StrSplit(v,"$"), color:=r.1, v:=r.2
  mode:=InStr(color,"##") ? 5
    : InStr(color,"-") ? 4 : InStr(color,"#") ? 3
    : InStr(color,"**") ? 2 : InStr(color,"*") ? 1 : 0
  color:=RegExReplace(color,"[*#]")
  if (mode=5)
  {
    v:=StrReplace(RegExReplace(v,"\s"), ",", "/")
    r:=StrSplit(Trim(v,"/"),"/"), n:=r.MaxIndex()//3
    if (!n)
      return
    x1:=x2:=r.1, y1:=y2:=r.2, v:="", i:=1
    Loop, % n
      x:=r[3*A_Index-2], y:=r[3*A_Index-1]
      , (x<x1 && x1:=x), (y<y1 && y1:=y)
      , (x>x2 && x2:=x), (y>y2 && y2:=y)
    Loop, % n
      v.="/" (r[i++]-x1) "/" (r[i++]-y1) "/0x" r[i++]
    v:=SubStr(v,2), w1:=x2-x1+1, h1:=y2-y1+1
  }
  else
  {
    r:=StrSplit(v,"."), w1:=r.1
    , v:=this.base64tobit(r.2), h1:=StrLen(v)//w1
    if (w1<1 or h1<1 or StrLen(v)!=w1*h1)
      return
    if (mode=4)
    {
      r:=StrSplit(StrReplace(color,"0x"),"-")
      , color:=Round("0x" r.1), n:=Round("0x" r.2)
    }
    else
    {
      r:=StrSplit(color,"@")
      , color:=r.1, n:=Round(r.2,2)+(!r.2)
      , n:=Floor(9*255*255*(1-n)*(1-n))
    }
    StrReplace(v,"1","",len1), len0:=StrLen(v)-len1
    , e1:=Round(len1*e1), e0:=Round(len0*e0)
  }
  return info[text]:=[v,w1,h1,len1,len0,e1,e0
    , mode,color,n,comment,set_e1_e0]
}

; 绑定窗口从而可以后台查找这个窗口的图像
; 相当于始终在前台。解绑窗口使用 FindText.BindWindow(0)

BindWindow(bind_id:=0, bind_mode:=0, get_id:=0, get_mode:=0)
{
  local
  bind:=this.bind
  if (get_id)
    return bind.id
  if (get_mode)
    return bind.mode
  if (bind_id)
  {
    bind.id:=bind_id, bind.mode:=bind_mode, bind.oldStyle:=0
    if (bind_mode & 1)
    {
      WinGet, oldStyle, ExStyle, ahk_id %bind_id%
      bind.oldStyle:=oldStyle
      WinSet, Transparent, 255, ahk_id %bind_id%
      Loop, 30
      {
        Sleep, 100
        WinGet, i, Transparent, ahk_id %bind_id%
      }
      Until (i=255)
    }
  }
  else
  {
    bind_id:=bind.id
    if (bind.mode & 1)
      WinSet, ExStyle, % bind.oldStyle, ahk_id %bind_id%
    bind.id:=0, bind.mode:=0, bind.oldStyle:=0
  }
}

xywh2xywh(x1,y1,w1,h1, ByRef x,ByRef y,ByRef w,ByRef h
  , ByRef zx:="", ByRef zy:="", ByRef zw:="", ByRef zh:="")
{
  local
  SysGet, zx, 76
  SysGet, zy, 77
  SysGet, zw, 78
  SysGet, zh, 79
  left:=x1, right:=x1+w1-1, up:=y1, down:=y1+h1-1
  , left:=(left<zx ? zx:left), right:=(right>zx+zw-1 ? zx+zw-1:right)
  , up:=(up<zy ? zy:up), down:=(down>zy+zh-1 ? zy+zh-1:down)
  , x:=left, y:=up, w:=right-left+1, h:=down-up+1
}

GetBitsFromScreen(x, y, w, h, ScreenShot:=1
  , ByRef zx:="", ByRef zy:="", ByRef zw:="", ByRef zh:="")
{
  local
  static Ptr:="Ptr"
  bits:=this.bits
  if (!ScreenShot)
  {
    zx:=bits.zx, zy:=bits.zy, zw:=bits.zw, zh:=bits.zh
    return bits
  }
  bch:=A_BatchLines, cri:=A_IsCritical
  Critical
  if (zw<1 or zh<1)
    this.xywh2xywh(x,y,w,h,x,y,w,h,zx,zy,zw,zh)
  bits.zx:=zx, bits.zy:=zy, bits.zw:=zw, bits.zh:=zh
  if (zw>bits.oldzw or zh>bits.oldzh or !bits.hBM)
  {
    if (bits.hBM)
      DllCall("DeleteObject", Ptr,bits.hBM)
    VarSetCapacity(bi, 40, 0), NumPut(40, bi, 0, "int")
    NumPut(zw, bi, 4, "int"), NumPut(-zh, bi, 8, "int")
    NumPut(1, bi, 12, "short"), NumPut(bpp:=32, bi, 14, "short")
    bits.hBM:=DllCall("CreateDIBSection", Ptr,0, Ptr,&bi
      , "int",0, "Ptr*",ppvBits:=0, Ptr,0, "int",0, Ptr)
    bits.Scan0:=(!bits.hBM ? 0:ppvBits)
    bits.Stride:=((zw*bpp+31)//32)*4
    bits.oldzw:=zw, bits.oldzh:=zh
  }
  if (bits.hBM) and !(w<1 or h<1)
  {
    win:=DllCall("GetDesktopWindow", Ptr)
    hDC:=DllCall("GetWindowDC", Ptr,win, Ptr)
    mDC:=DllCall("CreateCompatibleDC", Ptr,hDC, Ptr)
    oBM:=DllCall("SelectObject", Ptr,mDC, Ptr,bits.hBM, Ptr)
    DllCall("BitBlt",Ptr,mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
      , Ptr,hDC, "int",x, "int",y, "uint",0x00CC0020|0x40000000)
    DllCall("ReleaseDC", Ptr,win, Ptr,hDC)
    if (id:=this.BindWindow(0,0,1))
      WinGet, id, ID, ahk_id %id%
    if (id)
    {
      WinGetPos, wx, wy, ww, wh, ahk_id %id%
      left:=x, right:=x+w-1, up:=y, down:=y+h-1
      , left:=(left<wx ? wx:left), right:=(right>wx+ww-1 ? wx+ww-1:right)
      , up:=(up<wy ? wy:up), down:=(down>wy+wh-1 ? wy+wh-1:down)
      , x:=left, y:=up, w:=right-left+1, h:=down-up+1
    }
    if (id) and !(w<1 or h<1)
    {
      if (mode:=this.BindWindow(0,0,0,1))<2
      {
        hDC2:=DllCall("GetDCEx", Ptr,id, Ptr,0, "int",3, Ptr)
        DllCall("BitBlt",Ptr,mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
        , Ptr,hDC2, "int",x-wx, "int",y-wy, "uint",0x00CC0020|0x40000000)
        DllCall("ReleaseDC", Ptr,id, Ptr,hDC2)
      }
      else
      {
        VarSetCapacity(bi, 40, 0), NumPut(40, bi, 0, "int")
        NumPut(ww, bi, 4, "int"), NumPut(-wh, bi, 8, "int")
        NumPut(1, bi, 12, "short"), NumPut(32, bi, 14, "short")
        hBM2:=DllCall("CreateDIBSection", Ptr,0, Ptr,&bi
        , "int",0, "Ptr*",0, Ptr,0, "int",0, Ptr)
        mDC2:=DllCall("CreateCompatibleDC", Ptr,0, Ptr)
        oBM2:=DllCall("SelectObject", Ptr,mDC2, Ptr,hBM2, Ptr)
        DllCall("PrintWindow", Ptr,id, Ptr,mDC2, "uint",(mode>3)*3)
        DllCall("BitBlt",Ptr,mDC,"int",x-zx,"int",y-zy,"int",w,"int",h
        , Ptr,mDC2, "int",x-wx, "int",y-wy, "uint",0x00CC0020|0x40000000)
        DllCall("SelectObject", Ptr,mDC2, Ptr,oBM2)
        DllCall("DeleteDC", Ptr,mDC2)
        DllCall("DeleteObject", Ptr,hBM2)
      }
    }
    DllCall("SelectObject", Ptr,mDC, Ptr,oBM)
    DllCall("DeleteDC", Ptr,mDC)
  }
  Critical, %cri%
  SetBatchLines, %bch%
  return bits
}

MCode(ByRef code, hex)
{
  local
  ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  VarSetCapacity(code, len:=StrLen(hex)//2)
  Loop, % len
    NumPut("0x" SubStr(hex,2*A_Index-1,2),code,A_Index-1,"uchar")
  DllCall("VirtualProtect","Ptr",&code,"Ptr",len,"uint",0x40,"Ptr*",0)
  SetBatchLines, %bch%
  ListLines, %lls%
}

base64tobit(s)
{
  local
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
  Loop, Parse, Chars
  {
    i:=A_Index-1, v:=(i>>5&1) . (i>>4&1)
      . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1)
    s:=RegExReplace(s,"[" A_LoopField "]",StrReplace(v,"0x"))
  }
  ListLines, %lls%
  return RegExReplace(RegExReplace(s,"10*$"),"[^01]+")
}

bit2base64(s)
{
  local
  s:=RegExReplace(s,"[^01]+")
  s.=SubStr("100000",1,6-Mod(StrLen(s),6))
  s:=RegExReplace(s,".{6}","|$0")
  Chars:="0123456789+/ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    . "abcdefghijklmnopqrstuvwxyz"
  ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
  Loop, Parse, Chars
  {
    i:=A_Index-1, v:="|" . (i>>5&1) . (i>>4&1)
      . (i>>3&1) . (i>>2&1) . (i>>1&1) . (i&1)
    s:=StrReplace(s,StrReplace(v,"0x"),A_LoopField)
  }
  ListLines, %lls%
  return s
}

ASCII(s)
{
  local
  if RegExMatch(s,"\$(\d+)\.([\w+/]+)",r)
  {
    s:=RegExReplace(this.base64tobit(r2),".{" r1 "}","$0`n")
    s:=StrReplace(StrReplace(s,"0","_"),"1","0")
  }
  else s=
  return s
}

; 可以在脚本的开头用 FindText.PicLib(Text,1) 导入字库,
; 然后使用 FindText.PicLib("说明文字1|说明文字2|...") 获取字库中的数据

PicLib(comments, add_to_Lib:=0, index:=1)
{
  local
  Lib:=this.Lib
  if (add_to_Lib)
  {
    re:="<([^>]*)>[^$]+\$\d+\.[\w+/]+"
    Loop, Parse, comments, |
      if RegExMatch(A_LoopField,re,r)
      {
        s1:=Trim(r1), s2:=""
        Loop, Parse, s1
          s2.="_" . Format("{:d}",Ord(A_LoopField))
        Lib[index,s2]:=r
      }
    Lib[index,""]:=""
  }
  else
  {
    Text:=""
    Loop, Parse, comments, |
    {
      s1:=Trim(A_LoopField), s2:=""
      Loop, Parse, s1
        s2.="_" . Format("{:d}",Ord(A_LoopField))
      Text.="|" . Lib[index,s2]
    }
    return Text
  }
}

; 分割字符串为单个文字并获取数据

PicN(Number, index:=1)
{
  return this.PicLib(RegExReplace(Number,".","|$0"), 0, index)
}

; 使用 FindText.PicX(Text) 可以将文字分割成多个单字的组合，从而适应间隔变化
; 但是不能用于“颜色位置二值化”模式, 因为位置是与整体图像相关的

PicX(Text)
{
  local
  if !RegExMatch(Text,"(<[^$]+)\$(\d+)\.([\w+/]+)",r)
    return Text
  v:=this.base64tobit(r3), Text:=""
  c:=StrLen(StrReplace(v,"0"))<=StrLen(v)//2 ? "1":"0"
  txt:=RegExReplace(v,".{" r2 "}","$0`n")
  While InStr(txt,c)
  {
    While !(txt~="m`n)^" c)
      txt:=RegExReplace(txt,"m`n)^.")
    i:=0
    While (txt~="m`n)^.{" i "}" c)
      i:=Format("{:d}",i+1)
    v:=RegExReplace(txt,"m`n)^(.{" i "}).*","$1")
    txt:=RegExReplace(txt,"m`n)^.{" i "}")
    if (v!="")
      Text.="|" r1 "$" i "." this.bit2base64(v)
  }
  return Text
}

; 截屏，作为后续操作要用的“上一次的截屏”

ScreenShot(x1:="", y1:="", x2:="", y2:="")
{
  local
  if (x1+y1+x2+y2="")
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=(x1<x2?x1:x2), y:=(y1<y2?y1:y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  this.GetBitsFromScreen(x,y,w,h,1)
}

; 从“上一次的截屏”中快速获取指定坐标的RGB颜色
; 如果坐标超出了屏幕范围，将返回白色

GetColor(x, y, fmt:=1)
{
  local
  c:=!(bits:=this.GetBitsFromScreen(0,0,0,0,0,zx,zy,zw,zh))
    or (x<zx or x>=zx+zw or y<zy or y>=zy+zh or !bits.Scan0)
    ? 0xFFFFFF : NumGet(bits.Scan0+(y-zy)*bits.Stride+(x-zx)*4,"uint")
  return (fmt ? Format("0x{:06X}",c&0xFFFFFF) : c)
}

; 根据 FindText() 的结果识别一行文字或验证码
; offsetX 为两个文字的最大间隔，超过会插入*号
; offsetY 为两个文字的最大高度差
; 最后返回数组:{ocr:识别结果, x:结果左上角X, y:结果左上角Y}

Ocr(ok, offsetX:=20, offsetY:=20)
{
  local
  ocr_Text:=ocr_X:=ocr_Y:=min_X:=""
  For k,v in ok
    x:=v.1
    , min_X:=(A_Index=1 or x<min_X ? x : min_X)
    , max_X:=(A_Index=1 or x>max_X ? x : max_X)
  While (min_X!="" and min_X<=max_X)
  {
    LeftX:=""
    For k,v in ok
    {
      x:=v.1, y:=v.2
      if (x<min_X) or Abs(y-ocr_Y)>offsetY
        Continue
      ; Get the leftmost X coordinates
      if (LeftX="" or x<LeftX)
        LeftX:=x, LeftY:=y, LeftW:=v.3, LeftH:=v.4, LeftOCR:=v.id
    }
    if (LeftX="")
      Break
    if (ocr_X="")
      ocr_X:=LeftX, min_Y:=LeftY, max_Y:=LeftY+LeftH
    ; If the interval exceeds the set value, add "*" to the result
    ocr_Text.=(ocr_Text!="" and LeftX-min_X>offsetX ? "*":"") . LeftOCR
    ; Update for next search
    min_X:=LeftX+LeftW, ocr_Y:=LeftY
    , (LeftY<min_Y && min_Y:=LeftY)
    , (LeftY+LeftH>max_Y && max_Y:=LeftY+LeftH)
  }
  return {ocr:ocr_Text, x:ocr_X, y:min_Y
    , w: min_X-ocr_X, h: max_Y-min_Y}
}

; 按照从左到右、从上到下的顺序排序FindText()的结果
; 忽略轻微的Y坐标差距，返回排序后的数组对象

Sort(ok, dy:=10)
{
  local
  if !IsObject(ok)
    return ok
  ypos:=[]
  For k,v in ok
  {
    x:=v.x, y:=v.y, add:=1
    For k2,v2 in ypos
      if Abs(y-v2)<=dy
      {
        y:=v2, add:=0
        Break
      }
    if (add)
      ypos.Push(y)
    n:=(y*150000+x) "." k, s:=A_Index=1 ? n : s "-" n
  }
  Sort, s, N D-
  ok2:=[]
  Loop, Parse, s, -
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return ok2
}

; 以指定点为中心，按从近到远排序FindText()的结果
; 返回排序后的数组对象

Sort2(ok, px, py)
{
  local
  if !IsObject(ok)
    return ok
  For k,v in ok
    n:=((v.x-px)**2+(v.y-py)**2) "." k, s:=A_Index=1 ? n : s "-" n
  Sort, s, N D-
  ok2:=[]
  Loop, Parse, s, -
    ok2.Push( ok[(StrSplit(A_LoopField,".")[2])] )
  return ok2
}

; 提示某个坐标的位置，或远程控制中当前鼠标的位置

MouseTip(x:="", y:="", w:=10, h:=10, d:=4)
{
  local
  if (x="")
  {
    VarSetCapacity(pt,16,0), DllCall("GetCursorPos","ptr",&pt)
    x:=NumGet(pt,0,"uint"), y:=NumGet(pt,4,"uint")
  }
  x:=Round(x-w-d), y:=Round(y-h-d), w:=(2*w+1)+2*d, h:=(2*h+1)+2*d
  ;-------------------------
  Gui, _MouseTip_: +AlwaysOnTop -Caption +ToolWindow +Hwndmyid -DPIScale
  Gui, _MouseTip_: Show, Hide w%w% h%h%
  ;-------------------------
  DetectHiddenWindows, % (dhw:=A_DetectHiddenWindows)?"On":"On"
  i:=w-d, j:=h-d
  s=0-0 %w%-0 %w%-%h% 0-%h% 0-0  %d%-%d% %i%-%d% %i%-%j% %d%-%j% %d%-%d%
  WinSet, Region, %s%, ahk_id %myid%
  DetectHiddenWindows, %dhw%
  ;-------------------------
  Gui, _MouseTip_: Show, NA x%x% y%y%
  Loop, 4
  {
    Gui, _MouseTip_: Color, % A_Index & 1 ? "Red" : "Blue"
    Sleep, 500
  }
  Gui, _MouseTip_: Destroy
}

; 快速获取屏幕图像的搜索文本数据

GetTextFromScreen(x1, y1, x2, y2, Threshold:=""
  , ScreenShot:=1, ByRef rx:="", ByRef ry:="")
{
  local
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  x:=(x1<x2?x1:x2), y:=(y1<y2?y1:y2)
  , w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  , this.xywh2xywh(x,y,w,h,x,y,w,h,zx,zy,zw,zh)
  if (w<1 or h<1)
  {
    SetBatchLines, %bch%
    return
  }
  ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
  this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy,zw,zh)
  gs:=[], k:=0
  Loop, %h%
  {
    j:=y+A_Index-1
    Loop, %w%
      i:=x+A_Index-1, c:=this.GetColor(i,j,0)
      , gs[++k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
  }
  if InStr(Threshold,"**")
  {
    Threshold:=StrReplace(Threshold,"*")
    if (Threshold="")
      Threshold:=50
    s:="", sw:=w, w-=2, h-=2, x++, y++
    Loop, %h%
    {
      y1:=A_Index
      Loop, %w%
        x1:=A_Index, i:=y1*sw+x1+1, j:=gs[i]+Threshold
        , s.=( gs[i-1]>j || gs[i+1]>j
        || gs[i-sw]>j || gs[i+sw]>j
        || gs[i-sw-1]>j || gs[i-sw+1]>j
        || gs[i+sw-1]>j || gs[i+sw+1]>j ) ? "1":"0"
    }
    Threshold:="**" Threshold
  }
  else
  {
    Threshold:=StrReplace(Threshold,"*")
    if (Threshold="")
    {
      pp:=[]
      Loop, 256
        pp[A_Index-1]:=0
      Loop, % w*h
        pp[gs[A_Index]]++
      IP:=IS:=0
      Loop, 256
        k:=A_Index-1, IP+=k*pp[k], IS+=pp[k]
      Threshold:=Floor(IP/IS)
      Loop, 20
      {
        LastThreshold:=Threshold
        IP1:=IS1:=0
        Loop, % LastThreshold+1
          k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
        IP2:=IP-IP1, IS2:=IS-IS1
        if (IS1!=0 and IS2!=0)
          Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
        if (Threshold=LastThreshold)
          Break
      }
    }
    s:=""
    Loop, % w*h
      s.=gs[A_Index]<=Threshold ? "1":"0"
    Threshold:="*" Threshold
  }
  ;--------------------
  w:=Format("{:d}",w), CutUp:=CutDown:=0
  re1=(^0{%w%}|^1{%w%})
  re2=(0{%w%}$|1{%w%}$)
  While RegExMatch(s,re1)
    s:=RegExReplace(s,re1), CutUp++
  While RegExMatch(s,re2)
    s:=RegExReplace(s,re2), CutDown++
  rx:=x+w//2, ry:=y+CutUp+(h-CutUp-CutDown)//2
  s:="|<>" Threshold "$" w "." this.bit2base64(s)
  ;--------------------
  SetBatchLines, %bch%
  ListLines, %lls%
  return s
}

; 快速保存截图为BMP文件，可用于调试

SavePic(file, x1:="", y1:="", x2:="", y2:="", ScreenShot:=1)
{
  local
  static Ptr:="Ptr"
  SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
  if (x1+y1+x2+y2="")
    n:=150000, x:=y:=-n, w:=h:=2*n
  else
    x:=(x1<x2?x1:x2), y:=(y1<y2?y1:y2), w:=Abs(x2-x1)+1, h:=Abs(y2-y1)+1
  this.xywh2xywh(x,y,w,h,x,y,w,h,zx,zy,zw,zh)
  bits:=this.GetBitsFromScreen(x,y,w,h,ScreenShot,zx,zy,zw,zh)
  if (!bits.hBM) or (w<1 or h<1)
  {
    SetBatchLines, %bch%
    return
  }
  VarSetCapacity(bi, 40, 0), NumPut(40, bi, 0, "int")
  NumPut(w, bi, 4, "int"), NumPut(h, bi, 8, "int")
  NumPut(1, bi, 12, "short"), NumPut(bpp:=24, bi, 14, "short")
  hBM:=DllCall("CreateDIBSection", Ptr,0, Ptr,&bi
    , "int",0, "Ptr*",ppvBits:=0, Ptr,0, "int",0, Ptr)
  mDC:=DllCall("CreateCompatibleDC", Ptr,0, Ptr)
  oBM:=DllCall("SelectObject", Ptr,mDC, Ptr,hBM, Ptr)
  ;-------------------------
  mDC2:=DllCall("CreateCompatibleDC", Ptr,0, Ptr)
  oBM2:=DllCall("SelectObject", Ptr,mDC2, Ptr,bits.hBM, Ptr)
  DllCall("BitBlt",Ptr,mDC,"int",0,"int",0,"int",w,"int",h
    , Ptr,mDC2, "int",x-zx, "int",y-zy, "uint",0x00CC0020)
  DllCall("SelectObject", Ptr,mDC2, Ptr,oBM2)
  DllCall("DeleteDC", Ptr,mDC2)
  ;-------------------------
  size:=((w*bpp+31)//32)*4*h
  VarSetCapacity(bf, 14, 0), StrPut("BM", &bf, "CP0")
  NumPut(54+size, bf, 2, "uint"), NumPut(54, bf, 10, "uint")
  f:=FileOpen(file,"w"), f.RawWrite(bf,14), f.RawWrite(bi,40)
  , f.RawWrite(ppvBits+0, size), f.Close()
  ;-------------------------
  DllCall("SelectObject", Ptr,mDC, Ptr,oBM)
  DllCall("DeleteDC", Ptr,mDC)
  DllCall("DeleteObject", Ptr,hBM)
  SetBatchLines, %bch%
}

; 显示上一次的截屏图像

ShowScreenShot(onoff:=1)
{
  local
  static Ptr:="Ptr"
  Gui, FindText_Screen: Destroy
  bits:=this.GetBitsFromScreen(0,0,0,0,0,zx,zy,zw,zh)
  if (!onoff or !bits.hBM or zw<1 or zh<1)
    return
  mDC:=DllCall("CreateCompatibleDC", Ptr,0, Ptr)
  oBM:=DllCall("SelectObject", Ptr,mDC, Ptr,bits.hBM, Ptr)
  hBrush:=DllCall("CreateSolidBrush", "uint",0xFFFFFF, Ptr)
  oBrush:=DllCall("SelectObject", Ptr,mDC, Ptr,hBrush, Ptr)
  DllCall("BitBlt", Ptr,mDC, "int",0, "int",0, "int",zw, "int",zh
    , Ptr,mDC, "int",0, "int",0, "uint",0xC000CA) ; MERGECOPY
  DllCall("SelectObject", Ptr,mDC, Ptr,oBrush)
  DllCall("DeleteObject", Ptr,hBrush)
  DllCall("SelectObject", Ptr,mDC, Ptr,oBM)
  DllCall("DeleteDC", Ptr,mDC)
  ;---------------------
  Gui, FindText_Screen: +AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000
  Gui, FindText_Screen: Margin, 0, 0
  Gui, FindText_Screen: Add, Picture, x0 y0 w%zw% h%zh% +Hwndid +0xE
  SendMessage, 0x172, 0, bits.hBM,, ahk_id %id%
  Gui, FindText_Screen: Show, NA x%zx% y%zy% w%zw% h%zh%, Show ScreenShot
}

; 动态运行AHK代码作为新线程

Class Thread
{
  __New(args*)
  {
    this.pid:=this.Exec(args*)
  }
  __Delete()
  {
    Process, Close, % this.pid
  }
  Exec(s, Ahk:="", args:="")
  {
    local
    Ahk:=Ahk ? Ahk:A_IsCompiled ? A_ScriptDir "\AutoHotkey.exe":A_AhkPath
    s:="DllCall(""SetWindowText"",""Ptr"",A_ScriptHwnd,""Str"",""<AHK>"")`n"
      . StrReplace(s,"`r"), pid:=""
    Try
    {
      shell:=ComObjCreate("WScript.Shell")
      oExec:=shell.Exec("""" Ahk """ /f * " args)
      oExec.StdIn.Write(s)
      oExec.StdIn.Close(), pid:=oExec.ProcessID
    }
    Catch
    {
      f:=A_Temp "\~ahk.tmp"
      s:="`n FileDelete, " f "`n" s
      FileDelete, %f%
      FileAppend, %s%, %f%
      r:=ObjBindMethod(this, "Clear")
      SetTimer, %r%, -3000
      Run, "%Ahk%" /f "%f%" %args%,, UseErrorLevel, pid
    }
    return pid
  }
  Clear()
  {
    FileDelete, % A_Temp "\~ahk.tmp"
    SetTimer,, Off
  }
}

/***** 机器码的 C语言 源代码 *****

int __attribute__((__stdcall__)) PicFind(
  int mode, unsigned int c, unsigned int n, int dir
  , unsigned char * Bmp, int Stride, int zw, int zh
  , int sx, int sy, int sw, int sh
  , unsigned char * gs, char * ss
  , int * s1, unsigned int * s0
  , char * text, int w, int h, int err1, int err0
  , unsigned int * allpos, int allpos_max )
{
  int ok=0, o, i, j, k, x, y, r, g, b, rr, gg, bb;
  int x1, y1, x2, y2, len1, len0, e1, e0, max;
  int r_min, r_max, g_min, g_max, b_min, b_max;
  //----------------------
  x2=(sx+sw>zw) ? zw : sx+sw; if (sx<0) sx=0;
  y2=(sy+sh>zh) ? zh : sy+sh; if (sy<0) sy=0;
  sw=x2-sx; sh=y2-sy; if (sw<1 || sh<1) goto Return1;
  //----------------------
  // MultColor Mode
  if (mode==5) { max=n; e1=c; e0=-c; goto StartLookUp; }
  //----------------------
  // Generate Lookup Table
  o=0; len1=0; len0=0;
  for (y=0; y<h; y++)
  {
    for (x=0; x<w; x++)
    {
      i=(mode==3) ? y*Stride+x*4 : y*sw+x;
      if (text[o++]=='1')
        s1[len1++]=i;
      else
        s0[len0++]=i;
    }
  }
  if (err1>=len1) len1=0;
  if (err0>=len0) len0=0;
  max=(len1>len0) ? len1 : len0;
  //----------------------
  // 颜色位置模式
  // 仅用于多色验证码的识别
  if (mode==3) goto StartLookUp;
  //----------------------
  // 生成二值化图像
  o=sy*Stride+sx*4; j=Stride-sw*4; i=0;
  if (mode==0)  // 颜色相似二值化
  {
    rr=(c>>16)&0xFF; gg=(c>>8)&0xFF; bb=c&0xFF;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]-rr; g=Bmp[1+o]-gg; b=Bmp[o]-bb;
        ss[i]=(3*r*r+4*g*g+2*b*b<=n) ? 1:0;
      }
  }
  else if (mode==1)  // 灰度阈值二值化
  {
    c=(c+1)<<7;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
        ss[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15<c) ? 1:0;
  }
  else if (mode==2)  // 灰度差值二值化
  {
    x2=sx+sw; y2=sy+sh;
    for (y=sy-1; y<=y2; y++)
    {
      for (x=sx-1; x<=x2; x++, i++)
        if (x<0 || x>=zw || y<0 || y>=zh)
          gs[i]=0;
        else
        {
          o=y*Stride+x*4;
          gs[i]=(Bmp[2+o]*38+Bmp[1+o]*75+Bmp[o]*15)>>7;
        }
    }
    k=sw+2; i=0;
    for (y=1; y<=sh; y++)
      for (x=1; x<=sw; x++, i++)
      {
        o=y*k+x; n=gs[o]+c;
        ss[i]=(gs[o-1]>n || gs[o+1]>n
          || gs[o-k]>n   || gs[o+k]>n
          || gs[o-k-1]>n || gs[o-k+1]>n
          || gs[o+k-1]>n || gs[o+k+1]>n) ? 1:0;
      }
  }
  else  // (mode==4) 颜色分量二值化
  {
    r=(c>>16)&0xFF; g=(c>>8)&0xFF; b=c&0xFF;
    rr=(n>>16)&0xFF; gg=(n>>8)&0xFF; bb=n&0xFF;
    r_min=r-rr; g_min=g-gg; b_min=b-bb;
    r_max=r+rr; g_max=g+gg; b_max=b+bb;
    for (y=0; y<sh; y++, o+=j)
      for (x=0; x<sw; x++, o+=4, i++)
      {
        r=Bmp[2+o]; g=Bmp[1+o]; b=Bmp[o];
        ss[i]=(r>=r_min && r<=r_max
            && g>=g_min && g<=g_max
            && b>=b_min && b<=b_max) ? 1:0;
      }
  }
  //----------------------
  StartLookUp:
  if (dir<1 || dir>4) dir=1;
  if (mode!=5 && mode!=3)
    { k=1; x1=0; y1=0; x2=sw-w; y2=sh-h; }
  else
    { k=0; x1=sx; y1=sy; x2=sx+sw-w; y2=sy+sh-h; }
  if (dir==1)  // 从上到下
  {
    for (y=y1; y<=y2; y++)
    {
      for (x=x1; x<=x2; x++)
      {
        goto GoSub;
        GoBack1:
        continue;
      }
    }
  }
  else if (dir==2)  // 从下到上
  {
    for (y=y2; y>=y1; y--)
    {
      for (x=x1; x<=x2; x++)
      {
        goto GoSub;
        GoBack2:
        continue;
      }
    }
  }
  else if (dir==3)  // 从左到右
  {
    for (x=x1; x<=x2; x++)
    {
      for (y=y1; y<=y2; y++)
      {
        goto GoSub;
        GoBack3:
        continue;
      }
    }
  }
  else  // (dir==4)  从右到左
  {
    for (x=x2; x>=x1; x--)
    {
      for (y=y1; y<=y2; y++)
      {
        goto GoSub;
        GoBack4:
        continue;
      }
    }
  }
  goto Return1;
  //----------------------
  GoSub:
  if (k)
  {
    o=y*sw+x; e1=err1; e0=err0;
    for (i=0; i<max; i++)
    {
      if (i<len1 && ss[o+s1[i]]==0 && (--e1)<0) goto NoMatch;
      if (i<len0 && ss[o+s0[i]]!=0 && (--e0)<0) goto NoMatch;
    }
    // 清空已经找到的图像
    for (i=0; i<len1; i++)
      ss[o+s1[i]]=0;
  }
  else if (mode==3)
  {
    o=y*Stride+x*4; e1=err1; e0=err0;
    j=o+c; rr=Bmp[2+j]; gg=Bmp[1+j]; bb=Bmp[j];
    for (i=0; i<max; i++)
    {
      if (i<len1)
      {
        j=o+s1[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb;
        if (3*r*r+4*g*g+2*b*b>n && (--e1)<0) goto NoMatch;
      }
      if (i<len0)
      {
        j=o+s0[i]; r=Bmp[2+j]-rr; g=Bmp[1+j]-gg; b=Bmp[j]-bb;
        if (3*r*r+4*g*g+2*b*b<=n && (--e0)<0) goto NoMatch;
      }
    }
  }
  else  // (mode==5)
  {
    o=y*Stride+x*4;
    for (i=0; i<max; i++)
    {
      j=o+s1[i]; c=s0[i];
      b=Bmp[j]-(c&0xFF);         if (b>e1 || b<e0) goto NoMatch;
      g=Bmp[1+j]-((c>>8)&0xFF);  if (g>e1 || g<e0) goto NoMatch;
      r=Bmp[2+j]-((c>>16)&0xFF); if (r>e1 || r<e0) goto NoMatch;
    }
  }
  allpos[ok*2]=k*sx+x; allpos[ok*2+1]=k*sy+y;
  if (++ok>=allpos_max)
    goto Return1;
  NoMatch:
  if (dir==1) goto GoBack1;
  if (dir==2) goto GoBack2;
  if (dir==3) goto GoBack3;
  goto GoBack4;
  //----------------------
  Return1:
  return ok;
}

*/


;==== Optional GUI interface ====


Gui(cmd, arg1:="")
{
  local
  static
  global FindText
  local lls, bch, cri
  ListLines, % InStr("|KeyDown|LButtonDown|MouseMove|"
    , "|" cmd "|") ? "Off" : A_ListLines
  static init:=0
  if (!init)
  {
    init:=1
    Gui_:=ObjBindMethod(FindText,"Gui")
    Gui_G:=ObjBindMethod(FindText,"Gui","G")
    Gui_Run:=ObjBindMethod(FindText,"Gui","Run")
    Gui_Off:=ObjBindMethod(FindText,"Gui","Off")
    Gui_Show:=ObjBindMethod(FindText,"Gui","Show")
    Gui_KeyDown:=ObjBindMethod(FindText,"Gui","KeyDown")
    Gui_LButtonDown:=ObjBindMethod(FindText,"Gui","LButtonDown")
    Gui_MouseMove:=ObjBindMethod(FindText,"Gui","MouseMove")
    Gui_ScreenShot:=ObjBindMethod(FindText,"Gui","ScreenShot")
    Gui_ShowPic:=ObjBindMethod(FindText,"Gui","ShowPic")
    Gui_ToolTip:=ObjBindMethod(FindText,"Gui","ToolTip")
    Gui_ToolTipOff:=ObjBindMethod(FindText,"Gui","ToolTipOff")
    bch:=A_BatchLines, cri:=A_IsCritical
    Critical
    #NoEnv
    %Gui_%("Load_Language_Text")
    %Gui_%("MakeCaptureWindow")
    %Gui_%("MakeMainWindow")
    OnMessage(0x100, Gui_KeyDown)
    OnMessage(0x201, Gui_LButtonDown)
    OnMessage(0x200, Gui_MouseMove)
    Menu, Tray, Add
    Menu, Tray, Add, % Lang["1"], %Gui_Show%
    if (!A_IsCompiled and A_LineFile=A_ScriptFullPath)
    {
      Menu, Tray, Default, % Lang["1"]
      Menu, Tray, Click, 1
      Menu, Tray, Icon, Shell32.dll, 23
    }
    Critical, %cri%
    SetBatchLines, %bch%
  }
  Switch cmd
  {
  Case "Off":
    return
  Case "G":
    GuiControl, +g, %id%, %Gui_Run%
    return
  Case "Run":
    Critical
    %Gui_%(A_GuiControl)
    return
  Case "Show":
    Gui, FindText_Main: Default
    Gui, Show, Center
    GuiControl, Focus, scr
    return
  Case "MakeCaptureWindow":
    ww:=35, hh:=12, WindowColor:="0xDDEEFF"
    Gui, FindText_Capture: New
    Gui, +AlwaysOnTop -DPIScale +HwndCapture_ID
    Gui, Margin, 15, 15
    Gui, Color, %WindowColor%
    Gui, Font, s12, Verdana
    Gui, Add, Text, xm w855 h315 Section
    Gui, -Theme
    nW:=71, nH:=25, w:=11, C_:=[], Cid_:=[]
    Loop, % nW*(nH+1)
    {
      i:=A_Index, j:=i=1 ? "xs ys" : Mod(i,nW)=1 ? "xs y+1":"x+1"
      j.=i>nW*nH ? " cRed BackgroundFFFFAA" : ""
      Gui, Add, Progress, w%w% h%w% %j% +Hwndid
      Control, ExStyle, -0x20000,, ahk_id %id%
      C_[i]:=id, Cid_[id]:=i
    }
    Gui, +Theme
    Gui, Add, Slider, xm w855 vMySlider1 Hwndid Disabled
      +Center Page20 Line10 NoTicks AltSubmit
    %Gui_G%()
    Gui, Add, Slider, ym h315 vMySlider2 Hwndid Disabled
      +Center Page20 Line10 NoTicks AltSubmit +Vertical
    %Gui_G%()
    MySlider1:=MySlider2:=dx:=dy:=0
    Gui, Add, Button, xm+125 w50 vRepU Hwndid, % Lang["RepU"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutU Hwndid, % Lang["CutU"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutU3 Hwndid, % Lang["CutU3"]
    %Gui_G%()
    ;--------------
    Gui, Add, Text, x+50 yp+3 Section, % Lang["SelGray"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelGray ReadOnly
    Gui, Add, Text, x+15 ys, % Lang["SelColor"]
    Gui, Add, Edit, x+3 yp-3 w120 vSelColor ReadOnly
    Gui, Add, Text, x+15 ys, % Lang["SelR"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelR ReadOnly
    Gui, Add, Text, x+5 ys, % Lang["SelG"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelG ReadOnly
    Gui, Add, Text, x+5 ys, % Lang["SelB"]
    Gui, Add, Edit, x+3 yp-3 w60 vSelB ReadOnly
    ;--------------
    Gui, Add, Button, xm w50 vRepL Hwndid, % Lang["RepL"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutL Hwndid, % Lang["CutL"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutL3 Hwndid, % Lang["CutL3"]
    %Gui_G%()
    Gui, Add, Button, x+15 w70 vAuto Hwndid, % Lang["Auto"]
    %Gui_G%()
    Gui, Add, Button, x+15 w50 vRepR Hwndid, % Lang["RepR"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutR Hwndid, % Lang["CutR"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutR3 Hwndid Section, % Lang["CutR3"]
    %Gui_G%()
    Gui, Add, Button, xm+125 w50 vRepD Hwndid, % Lang["RepD"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutD Hwndid, % Lang["CutD"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutD3 Hwndid, % Lang["CutD3"]
    %Gui_G%()
    ;--------------
    Gui, Add, Tab3, ys-8 -Wrap, % Lang["2"]
    Gui, Tab, 1
    Gui, Add, Text, x+15 y+15, % Lang["Threshold"]
    Gui, Add, Edit, x+15 w100 vThreshold
    Gui, Add, Button, x+15 yp-3 vGray2Two Hwndid, % Lang["Gray2Two"]
    %Gui_G%()
    Gui, Tab, 2
    Gui, Add, Text, x+15 y+15, % Lang["GrayDiff"]
    Gui, Add, Edit, x+15 w100 vGrayDiff, 50
    Gui, Add, Button, x+15 yp-3 vGrayDiff2Two Hwndid, % Lang["GrayDiff2Two"]
    %Gui_G%()
    Gui, Tab, 3
    Gui, Add, Text, x+15 y+15, % Lang["Similar1"] " 0"
    Gui, Add, Slider, x+0 w100 vSimilar1 Hwndid
      +Center Page1 NoTicks ToolTip, 100
    %Gui_G%()
    Gui, Add, Text, x+0, 100
    Gui, Add, Button, x+15 yp-3 vColor2Two Hwndid, % Lang["Color2Two"]
    %Gui_G%()
    Gui, Tab, 4
    Gui, Add, Text, x+15 y+15, % Lang["Similar2"] " 0"
    Gui, Add, Slider, x+0 w100 vSimilar2 Hwndid
      +Center Page1 NoTicks ToolTip, 100
    %Gui_G%()
    Gui, Add, Text, x+0, 100
    Gui, Add, Button, x+15 yp-3 vColorPos2Two Hwndid, % Lang["ColorPos2Two"]
    %Gui_G%()
    Gui, Tab, 5
    Gui, Add, Text, x+10 y+15, % Lang["DiffR"]
    Gui, Add, Edit, x+5 w70 vDiffR Limit3
    Gui, Add, UpDown, vdR Range0-255 Wrap
    Gui, Add, Text, x+5, % Lang["DiffG"]
    Gui, Add, Edit, x+5 w70 vDiffG Limit3
    Gui, Add, UpDown, vdG Range0-255 Wrap
    Gui, Add, Text, x+5, % Lang["DiffB"]
    Gui, Add, Edit, x+5 w70 vDiffB Limit3
    Gui, Add, UpDown, vdB Range0-255 Wrap
    Gui, Add, Button, x+5 yp-3 vColorDiff2Two Hwndid, % Lang["ColorDiff2Two"]
    %Gui_G%()
    Gui, Tab, 6
    Gui, Add, Text, x+10 y+15, % Lang["DiffRGB"]
    Gui, Add, Edit, x+5 w80 vDiffRGB Limit3
    Gui, Add, UpDown, vdRGB Range0-255 Wrap
    Gui, Add, Checkbox, x+15 yp+5 vMultColor Hwndid, % Lang["MultColor"]
    %Gui_G%()
    Gui, Add, Button, x+10 yp-5 vUndo Hwndid, % Lang["Undo"]
    %Gui_G%()
    Gui, Tab
    ;--------------
    Gui, Add, Button, xm vReset Hwndid, % Lang["Reset"]
    %Gui_G%()
    Gui, Add, Checkbox, x+15 yp+5 vModify Hwndid, % Lang["Modify"]
    %Gui_G%()
    Gui, Add, Text, x+30, % Lang["Comment"]
    Gui, Add, Edit, x+5 yp-2 w150 vComment
    Gui, Add, Button, x+30 yp-3 vSplitAdd Hwndid, % Lang["SplitAdd"]
    %Gui_G%()
    Gui, Add, Button, x+10 vAllAdd Hwndid, % Lang["AllAdd"]
    %Gui_G%()
    Gui, Add, Button, x+10 w80 vButtonOK Hwndid, % Lang["ButtonOK"]
    %Gui_G%()
    Gui, Add, Button, x+10 wp vClose gCancel, % Lang["Close"]
    Gui, Add, Button, xm vBind0 Hwndid, % Lang["Bind0"]
    %Gui_G%()
    Gui, Add, Button, x+15 vBind1 Hwndid, % Lang["Bind1"]
    %Gui_G%()
    Gui, Add, Button, x+15 vBind2 Hwndid, % Lang["Bind2"]
    %Gui_G%()
    Gui, Add, Button, x+15 vBind3 Hwndid, % Lang["Bind3"]
    %Gui_G%()
    Gui, Add, Button, x+15 vBind4 Hwndid, % Lang["Bind4"]
    %Gui_G%()
    Gui, Show, Hide, % Lang["3"]
    return
  Case "MakeMainWindow":
    Gui, FindText_Main: New
    Gui, +AlwaysOnTop -DPIScale
    Gui, Margin, 15, 15
    Gui, Color, %WindowColor%
    Gui, Font, s12 cBlack, Verdana
    Gui, Add, Text, xm, % Lang["NowHotkey"]
    Gui, Add, Edit, x+5 w200 vNowHotkey ReadOnly
    Gui, Add, Hotkey, x+5 w200 vSetHotkey1
    Gui, Add, DDL, x+5 w180 vSetHotkey2
      , % "||F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|MButton"
      . "|ScrollLock|CapsLock|Ins|Esc|BS|Del|Tab|Home|End|PgUp|PgDn"
      . "|NumpadDot|NumpadSub|NumpadAdd|NumpadDiv|NumpadMult"
    Gui, Add, GroupBox, xm y+0 w280 h55 vMyGroup
    Gui, Add, Text, xp+15 yp+20 Section, % Lang["Myww"] ": "
    Gui, Add, Text, x+0 w60, %ww%
    Gui, Add, UpDown, vMyww Range1-50, %ww%
    Gui, Add, Text, x+15 ys, % Lang["Myhh"] ": "
    Gui, Add, Text, x+0 w60, %hh%
    Gui, Add, UpDown, vMyhh Range1-50, %hh%
    GuiControlGet, p, Pos, Myhh
    GuiControl, Move, MyGroup, % "w" (pX+pW) " h" (pH+30)
    x:=pX+pW+15*2
    Gui, Add, Button, x%x% ys-8 w150 vApply Hwndid, % Lang["Apply"]
    %Gui_G%()
    Gui, Add, Checkbox, x+15 ys Checked vAddFunc, % Lang["AddFunc"] " FindText()"
    Gui, Add, Button, xm y+18 w144 vCutL2 Hwndid, % Lang["CutL2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutR2 Hwndid, % Lang["CutR2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutU2 Hwndid, % Lang["CutU2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCutD2 Hwndid, % Lang["CutD2"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vUpdate Hwndid, % Lang["Update"]
    %Gui_G%()
    Gui, Font, s6 bold, Verdana
    Gui, Add, Edit, xm y+10 w720 r20 vMyPic -Wrap
    Gui, Font, s12 norm, Verdana
    Gui, Add, Button, xm w240 vCapture Hwndid, % Lang["Capture"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vTest Hwndid, % Lang["Test"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vCopy Hwndid, % Lang["Copy"]
    %Gui_G%()
    Gui, Add, Button, xm y+0 wp vCaptureS Hwndid, % Lang["CaptureS"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vGetRange Hwndid, % Lang["GetRange"]
    %Gui_G%()
    Gui, Add, Button, x+0 wp vTestClip Hwndid, % Lang["TestClip"]
    %Gui_G%()
    Gui, Font, s12 cBlue, Verdana
    Gui, Add, Edit, xm w720 h350 vscr Hwndhscr -Wrap HScroll
    Gui, Show, Hide, % Lang["4"]
    return
  Case "Capture","CaptureS":
    Critical
    Gui, FindText_Main: +Hwndid
    if (show_gui:=(WinExist()=id))
    {
      Gui, FindText_Main: Default
      Gui, +LastFound
      WinMinimize
      Gui, Hide
    }
    ShowScreenShot:=InStr(cmd,"CaptureS")
    if (ShowScreenShot)
      FindText.ShowScreenShot(1)
    ;----------------------
    Gui, FindText_HotkeyIf: New, -Caption +ToolWindow +E0x80000
    Gui, Show, NA x0 y0 w0 h0, FindText_HotkeyIf
    Hotkey, IfWinExist, FindText_HotkeyIf
    Hotkey, *RButton, %Gui_Off%, On UseErrorLevel
    ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
    CoordMode, Mouse
    KeyWait, RButton
    KeyWait, Ctrl
    w:=ww, h:=hh, oldx:=oldy:="", r:=StrSplit(Lang["5"],"|")
    if (!show_gui)
      w:=20, h:=8
    Loop
    {
      Sleep, 50
      MouseGetPos, x, y, Bind_ID
      if (!show_gui)
      {
        w:=x<=1 ? w-1 : x>=A_ScreenWidth-2 ? w+1:w
        h:=y<=1 ? h-1 : y>=A_ScreenHeight-2 ? h+1:h
        w:=(w<1 ? 1:w), h:=(h<1 ? 1:h)
      }
      %Gui_%("Mini_Show")
      if (oldx=x and oldy=y)
        Continue
      oldx:=x, oldy:=y
      ToolTip, % r.1 " : " x "," y "`n" r.2
    }
    Until GetKeyState("RButton","P") or GetKeyState("Ctrl","P")
    KeyWait, RButton
    KeyWait, Ctrl
    px:=x, py:=y, oldx:=oldy:=""
    Loop
    {
      Sleep, 50
      %Gui_%("Mini_Show")
      MouseGetPos, x1, y1
      if (oldx=x1 and oldy=y1)
        Continue
      oldx:=x1, oldy:=y1
      ToolTip, % r.1 " : " x "," y "`n" r.2
    }
    Until GetKeyState("RButton","P") or GetKeyState("Ctrl","P")
    KeyWait, RButton
    KeyWait, Ctrl
    ToolTip
    %Gui_%("Mini_Hide")
    ListLines, %lls%
    Hotkey, *RButton, %Gui_Off%, Off UseErrorLevel
    Hotkey, IfWinExist
    Gui, FindText_HotkeyIf: Destroy
    if (ShowScreenShot)
      FindText.ShowScreenShot(0)
    if (!show_gui)
      return [px-w, py-h, px+w, py+h]
    ;-----------------------
    %Gui_%("getcors", !ShowScreenShot)
    %Gui_%("Reset")
    Gui, FindText_Capture: Default
    Loop, 71
      GuiControl,, % C_[71*25+A_Index], 0
    Loop, 6
      GuiControl,, Edit%A_Index%
    GuiControl,, Modify, % Modify:=0
    GuiControl,, MultColor, % MultColor:=0
    GuiControl,, GrayDiff, 50
    GuiControl, Focus, Gray2Two
    GuiControl, +Default, Gray2Two
    Gui, Show, Center
    Event:=Result:=""
    DetectHiddenWindows, Off
    Critical, Off
    WinWaitClose, ahk_id %Capture_ID%
    Critical
    ToolTip
    Gui, FindText_Main: Default
    ;--------------------------------
    if (cors.bind!="")
    {
      WinGetTitle, tt, ahk_id %Bind_ID%
      WinGetClass, tc, ahk_id %Bind_ID%
      tt:=Trim(SubStr(tt,1,30) (tc ? " ahk_class " tc:""))
      tt:=StrReplace(RegExReplace(tt,"[;``]","``$0"),"""","""""")
      Result:="`nSetTitleMatchMode, 2`nid:=WinExist(""" tt """)"
        . "`nFindText.BindWindow(id" (cors.bind=0 ? "":"," cors.bind)
        . ")  `; " Lang["6"] " FindText.BindWindow(0)`n`n" Result
    }
    if (Event="ButtonOK")
    {
      if (!A_IsCompiled)
      {
        FileRead, s, %A_LineFile%
        s:=SubStr(s, s~="i)\n[;=]+ Copy The")
      }
      else s:=""
      GuiControl,, scr, % Result "`n" s
      if !InStr(Result,"##")
        GuiControl,, MyPic, % Trim(FindText.ASCII(Result),"`n")
      Result:=s:=""
    }
    else if (Event="SplitAdd") or (Event="AllAdd")
    {
      GuiControlGet, s,, scr
      i:=j:=0, r:="<[^>\n]*>[^$\n]+\$[\w+/,.\-]+"
      While j:=RegExMatch(s,r,"",j+1)
        i:=InStr(s,"`n",0,j)
      GuiControl,, scr, % SubStr(s,1,i) . Result . SubStr(s,i+1)
      if !InStr(Result,"##")
        GuiControl,, MyPic, % Trim(FindText.ASCII(Result),"`n")
      Result:=s:=""
    }
    ;----------------------
    Gui, Show
    GuiControl, Focus, scr
    return
  Case "Mini_Show":
    Gui, FindText_Mini_4: +LastFoundExist
    IfWinNotExist
    {
      Loop, 4
      {
        i:=A_Index
        Gui, FindText_Mini_%i%: +AlwaysOnTop -Caption +ToolWindow -DPIScale +E0x08000000
        Gui, FindText_Mini_%i%: Show, Hide, Mini
      }
    }
    d:=2, w:=w<0 ? 0:w, h:=h<0 ? 0:h, c:=A_MSec<500 ? "Red":"Blue"
    Loop, 4
    {
      i:=A_Index
      x1:=Floor(i=3 ? x+w+1 : x-w-d)
      y1:=Floor(i=4 ? y+h+1 : y-h-d)
      w1:=Floor(i=1 or i=3 ? d : 2*(w+d)+1)
      h1:=Floor(i=2 or i=4 ? d : 2*(h+d)+1)
      Gui, FindText_Mini_%i%: Color, %c%
      Gui, FindText_Mini_%i%: Show, NA x%x1% y%y1% w%w1% h%h1%
    }
    return
  Case "Mini_Hide":
    Gui, FindText_Mini_4: +Hwndid
    Loop, 4
      Gui, FindText_Mini_%A_Index%: Destroy
    WinWaitClose, ahk_id %id%,, 3
    return
  Case "getcors":
    FindText.xywh2xywh(px-ww,py-hh,2*ww+1,2*hh+1,x,y,w,h)
    if (w<1 or h<1)
      return
    SetBatchLines, % (bch:=A_BatchLines)?"-1":"-1"
    if (arg1) or (!FindText.GetBitsFromScreen(0,0,0,0,0).hBM)
      FindText.ScreenShot()
    cors:=[], gray:=[], k:=0
    ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
    Loop, %nH%
    {
      j:=py-hh+A_Index-1, i:=px-ww
      Loop, %nW%
        cors[++k]:=c:=FindText.GetColor(i++,j,0)
        , gray[k]:=(((c>>16)&0xFF)*38+((c>>8)&0xFF)*75+(c&0xFF)*15)>>7
    }
    ListLines, %lls%
    cors.CutLeft:=Abs(px-ww-x)
    cors.CutRight:=Abs(px+ww-(x+w-1))
    cors.CutUp:=Abs(py-hh-y)
    cors.CutDown:=Abs(py+hh-(y+h-1))
    SetBatchLines, %bch%
    return
  Case "GetRange":
    Critical
    Gui, FindText_Main: +Hwndid
    if (show_gui:=(WinExist()=id))
      Gui, FindText_Main: Hide
    ;---------------------
    Gui, FindText_GetRange: New
    Gui, +LastFound +AlWaysOnTop +ToolWindow -Caption -DPIScale +E0x08000000
    Gui, Color, White
    WinSet, Transparent, 10
    FindText.xywh2xywh(0,0,0,0,0,0,0,0,x,y,w,h)
    Gui, Show, NA x%x% y%y% w%w% h%h%, GetRange
    ;---------------------
    Gui, FindText_HotkeyIf: New, -Caption +ToolWindow +E0x80000
    Gui, Show, NA x0 y0 w0 h0, FindText_HotkeyIf
    Hotkey, IfWinExist, FindText_HotkeyIf
    Hotkey, *LButton, %Gui_Off%, On UseErrorLevel
    ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
    CoordMode, Mouse
    KeyWait, LButton
    KeyWait, Ctrl
    oldx:=oldy:="", r:=Lang["7"]
    Loop
    {
      Sleep, 50
      MouseGetPos, x, y
      if (oldx=x and oldy=y)
        Continue
      oldx:=x, oldy:=y
      ToolTip, %r%
    }
    Until GetKeyState("LButton","P") or GetKeyState("Ctrl","P")
    px:=x, py:=y, oldx:=oldy:=""
    Loop
    {
      Sleep, 50
      MouseGetPos, x, y
      w:=Abs(px-x)//2, h:=Abs(py-y)//2, x:=(px+x)//2, y:=(py+y)//2
      %Gui_%("Mini_Show")
      if (oldx=x and oldy=y)
        Continue
      oldx:=x, oldy:=y
      ToolTip, %r%
    }
    Until !(GetKeyState("LButton","P") or GetKeyState("Ctrl","P"))
    ToolTip
    %Gui_%("Mini_Hide")
    ListLines, %lls%
    Hotkey, *LButton, %Gui_Off%, Off UseErrorLevel
    Hotkey, IfWinExist
    Gui, FindText_HotkeyIf: Destroy
    Gui, FindText_GetRange: Destroy
    Clipboard:=p:=(x-w) ", " (y-h) ", " (x+w) ", " (y+h)
    if (!show_gui)
      return StrSplit(p, ",", " ")
    ;---------------------
    Gui, FindText_Main: Default
    GuiControlGet, s,, scr
    if RegExMatch(s, "i)(=\s*FindText\()([^,]*,){4}", r)
    {
      s:=StrReplace(s, r, r1 . p ",", 0, 1)
      GuiControl,, scr, %s%
    }
    Gui, Show
    return
  Case "Test","TestClip":
    Gui, FindText_Main: Default
    Gui, +LastFound
    WinMinimize
    Gui, Hide
    DetectHiddenWindows, Off
    WinWaitClose, % "ahk_id " WinExist()
    Sleep, 100
    ;----------------------
    if (cmd="Test")
      GuiControlGet, s,, scr
    else
      s:=Clipboard
    if (!A_IsCompiled) and InStr(s,"MCode(") and (cmd="Test")
    {
      s:="`n#NoEnv`nMenu, Tray, Click, 1`n" s "`nExitApp`n"
      Thread:= new FindText.Thread(s)
      DetectHiddenWindows, On
      WinWait, % "ahk_class AutoHotkey ahk_pid " Thread.pid,, 3
      if (!ErrorLevel)
        WinWaitClose,,, 30
      Thread:=""  ; kill the Thread
    }
    else
    {
      Gui, +OwnDialogs
      t:=A_TickCount, n:=150000
      , RegExMatch(s,"<[^>\n]*>[^$\n]+\$[\w+/,.\-]+",v)
      , ok:=FindText.FindText(-n, -n, n, n, 0, 0, v)
      , X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id
      r:=StrSplit(Lang["8"],"|")
      MsgBox, 4096, Tip, % r.1 ":`t" Round(ok.MaxIndex()) "`n`n"
        . r.2 ":`t" (A_TickCount-t) " " r.3 "`n`n"
        . r.4 ":`t" X ", " Y "`n`n"
        . r.5 ":`t" (ok ? r.6 " ! " Comment : r.7 " !"), 3
      for i,v in ok
        if (i<=2)
          FindText.MouseTip(ok[i].x, ok[i].y)
      ok:=""
    }
    ;----------------------
    Gui, Show
    GuiControl, Focus, scr
    return
  Case "Copy":
    Gui, FindText_Main: Default
    ControlGet, s, Selected,,, ahk_id %hscr%
    if (s="")
    {
      GuiControlGet, s,, scr
      GuiControlGet, r,, AddFunc
      if (r != 1)
        s:=RegExReplace(s,"\n\K[\s;=]+ Copy The[\s\S]*")
    }
    Clipboard:=RegExReplace(s,"\R","`r`n")
    ;----------------------
    Gui, Hide
    Sleep, 100
    Gui, Show
    GuiControl, Focus, scr
    return
  Case "Apply":
    Gui, FindText_Main: Default
    GuiControlGet, NowHotkey
    GuiControlGet, SetHotkey1
    GuiControlGet, SetHotkey2
    if (NowHotkey!="")
      Hotkey, *%NowHotkey%,, Off UseErrorLevel
    k:=SetHotkey1!="" ? SetHotkey1 : SetHotkey2
    if (k!="")
      Hotkey, *%k%, %Gui_ScreenShot%, On UseErrorLevel
    GuiControl,, NowHotkey, %k%
    GuiControl,, SetHotkey1
    GuiControl, Choose, SetHotkey2, 0
    ;------------------------
    GuiControlGet, Myww
    GuiControlGet, Myhh
    if (Myww!=ww or Myhh!=hh)
    {
      nW:=71, dx:=dy:=0
      Loop, % 71*25
        k:=A_Index, c:=WindowColor, %Gui_%("SetColor")
      ww:=Myww, hh:=Myhh, nW:=2*ww+1, nH:=2*hh+1
      i:=nW>71, j:=nH>25
      Gui, FindText_Capture: Default
      GuiControl, Enable%i%, MySlider1
      GuiControl, Enable%j%, MySlider2
      GuiControl,, MySlider1, % MySlider1:=0
      GuiControl,, MySlider2, % MySlider2:=0
    }
    return
  Case "ScreenShot":
    Critical
    FindText.ScreenShot()
    Gui, FindText_Tip: New
    ; WS_EX_NOACTIVATE:=0x08000000, WS_EX_TRANSPARENT:=0x20
    Gui, +LastFound +AlwaysOnTop +ToolWindow -Caption -DPIScale +E0x08000020
    Gui, Color, Yellow
    Gui, Font, cRed s48 bold
    Gui, Add, Text,, % Lang["9"]
    WinSet, Transparent, 200
    Gui, Show, NA y0, ScreenShot Tip
    Sleep, 1000
    Gui, Destroy
    return
  Case "Bind0","Bind1","Bind2","Bind3","Bind4":
    Critical
    FindText.BindWindow(Bind_ID, bind_mode:=SubStr(cmd,0))
    Gui, FindText_HotkeyIf: New, -Caption +ToolWindow +E0x80000
    Gui, Show, NA x0 y0 w0 h0, FindText_HotkeyIf
    Hotkey, IfWinExist, FindText_HotkeyIf
    Hotkey, *RButton, %Gui_Off%, On UseErrorLevel
    ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
    CoordMode, Mouse
    KeyWait, RButton
    KeyWait, Ctrl
    oldx:=oldy:=""
    Loop
    {
      Sleep, 50
      MouseGetPos, x, y
      if (oldx=x and oldy=y)
        Continue
      oldx:=x, oldy:=y
      ;---------------
      px:=x, py:=y, %Gui_%("getcors",1)
      %Gui_%("Reset"), r:=StrSplit(Lang["10"],"|")
      ToolTip, % r.1 " : " x "," y "`n" r.2
    }
    Until GetKeyState("RButton","P") or GetKeyState("Ctrl","P")
    KeyWait, RButton
    KeyWait, Ctrl
    ToolTip
    ListLines, %lls%
    Hotkey, *RButton, %Gui_Off%, Off UseErrorLevel
    Hotkey, IfWinExist
    Gui, FindText_HotkeyIf: Destroy
    FindText.BindWindow(0), cors.bind:=bind_mode
    return
  Case "MySlider1","MySlider2":
    Thread, Priority, 10
    Critical, Off
    dx:=nW>71 ? Round((nW-71)*MySlider1/100) : 0
    dy:=nH>25 ? Round((nH-25)*MySlider2/100) : 0
    if (oldx=dx and oldy=dy)
      return
    oldx:=dx, oldy:=dy, k:=0
    Loop, % nW*nH
      c:=(!show[++k] ? WindowColor
      : bg="" ? cors[k] : ascii[k]
      ? "Black":"White"), %Gui_%("SetColor")
    if (cmd="MySlider2")
      return
    Loop, 71
      GuiControl,, % C_[71*25+A_Index], 0
    Loop, % nW
    {
      i:=A_Index-dx
      if (i>=1 && i<=71 && show[nW*nH+A_Index])
        GuiControl,, % C_[71*25+i], 100
    }
    return
  Case "Reset":
    show:=[], ascii:=[], bg:=""
    CutLeft:=CutRight:=CutUp:=CutDown:=k:=0
    Loop, % nW*nH
      show[++k]:=1, c:=cors[k], %Gui_%("SetColor")
    Loop, % cors.CutLeft
      %Gui_%("CutL")
    Loop, % cors.CutRight
      %Gui_%("CutR")
    Loop, % cors.CutUp
      %Gui_%("CutU")
    Loop, % cors.CutDown
      %Gui_%("CutD")
    return
  Case "SetColor":
    if (nW=71 && nH=25)
      tk:=k
    else
    {
      tx:=Mod(k-1,nW)-dx, ty:=(k-1)//nW-dy
      if (tx<0 || tx>=71 || ty<0 || ty>=25)
        return
      tk:=ty*71+tx+1
    }
    c:=c="Black" ? 0x000000 : c="White" ? 0xFFFFFF
      : ((c&0xFF)<<16)|(c&0xFF00)|((c&0xFF0000)>>16)
    SendMessage, 0x2001, 0, c,, % "ahk_id " . C_[tk]
    return
  Case "RepColor":
    show[k]:=1, c:=(bg="" ? cors[k] : ascii[k]
      ? "Black":"White"), %Gui_%("SetColor")
    return
  Case "CutColor":
    show[k]:=0, c:=WindowColor, %Gui_%("SetColor")
    return
  Case "RepL":
    if (CutLeft<=cors.CutLeft)
    or (bg!="" and InStr(color,"**")
    and CutLeft=cors.CutLeft+1)
      return
    k:=CutLeft-nW, CutLeft--
    Loop, %nH%
      k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
        ? %Gui_%("RepColor") : "")
    return
  Case "CutL":
    if (CutLeft+CutRight>=nW)
      return
    CutLeft++, k:=CutLeft-nW
    Loop, %nH%
      k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
        ? %Gui_%("CutColor") : "")
    return
  Case "CutL3":
    Loop, 3
      %Gui_%("CutL")
    return
  Case "RepR":
    if (CutRight<=cors.CutRight)
    or (bg!="" and InStr(color,"**")
    and CutRight=cors.CutRight+1)
      return
    k:=1-CutRight, CutRight--
    Loop, %nH%
      k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
        ? %Gui_%("RepColor") : "")
    return
  Case "CutR":
    if (CutLeft+CutRight>=nW)
      return
    CutRight++, k:=1-CutRight
    Loop, %nH%
      k+=nW, (A_Index>CutUp and A_Index<nH+1-CutDown
        ? %Gui_%("CutColor") : "")
    return
  Case "CutR3":
    Loop, 3
      %Gui_%("CutR")
    return
  Case "RepU":
    if (CutUp<=cors.CutUp)
    or (bg!="" and InStr(color,"**")
    and CutUp=cors.CutUp+1)
      return
    k:=(CutUp-1)*nW, CutUp--
    Loop, %nW%
      k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
        ? %Gui_%("RepColor") : "")
    return
  Case "CutU":
    if (CutUp+CutDown>=nH)
      return
    CutUp++, k:=(CutUp-1)*nW
    Loop, %nW%
      k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
        ? %Gui_%("CutColor") : "")
    return
  Case "CutU3":
    Loop, 3
      %Gui_%("CutU")
    return
  Case "RepD":
    if (CutDown<=cors.CutDown)
    or (bg!="" and InStr(color,"**")
    and CutDown=cors.CutDown+1)
      return
    k:=(nH-CutDown)*nW, CutDown--
    Loop, %nW%
      k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
        ? %Gui_%("RepColor") : "")
    return
  Case "CutD":
    if (CutUp+CutDown>=nH)
      return
    CutDown++, k:=(nH-CutDown)*nW
    Loop, %nW%
      k++, (A_Index>CutLeft and A_Index<nW+1-CutRight
        ? %Gui_%("CutColor") : "")
    return
  Case "CutD3":
    Loop, 3
      %Gui_%("CutD")
    return
  Case "Gray2Two":
    Gui, FindText_Capture: Default
    GuiControl, Focus, Threshold
    GuiControlGet, Threshold
    if (Threshold="")
    {
      pp:=[]
      Loop, 256
        pp[A_Index-1]:=0
      Loop, % nW*nH
        if (show[A_Index])
          pp[gray[A_Index]]++
      IP:=IS:=0
      Loop, 256
        k:=A_Index-1, IP+=k*pp[k], IS+=pp[k]
      Threshold:=Floor(IP/IS)
      Loop, 20
      {
        LastThreshold:=Threshold
        IP1:=IS1:=0
        Loop, % LastThreshold+1
          k:=A_Index-1, IP1+=k*pp[k], IS1+=pp[k]
        IP2:=IP-IP1, IS2:=IS-IS1
        if (IS1!=0 and IS2!=0)
          Threshold:=Floor((IP1/IS1+IP2/IS2)/2)
        if (Threshold=LastThreshold)
          Break
      }
      GuiControl,, Threshold, %Threshold%
    }
    Threshold:=Round(Threshold)
    color:="*" Threshold, k:=i:=0
    Loop, % nW*nH
    {
      ascii[++k]:=v:=(gray[k]<=Threshold)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_%("SetColor")
    }
    bg:=i>0 ? "1":"0"
    return
  Case "GrayDiff2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, GrayDiff
    if (GrayDiff="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % "`n" Lang["11"] " !`n", 1
      return
    }
    if (CutLeft=cors.CutLeft)
      %Gui_%("CutL")
    if (CutRight=cors.CutRight)
      %Gui_%("CutR")
    if (CutUp=cors.CutUp)
      %Gui_%("CutU")
    if (CutDown=cors.CutDown)
      %Gui_%("CutD")
    GrayDiff:=Round(GrayDiff)
    color:="**" GrayDiff, k:=i:=0
    Loop, % nW*nH
    {
      j:=gray[++k]+GrayDiff
      , ascii[k]:=v:=( gray[k-1]>j or gray[k+1]>j
      or gray[k-nW]>j or gray[k+nW]>j
      or gray[k-nW-1]>j or gray[k-nW+1]>j
      or gray[k+nW-1]>j or gray[k+nW+1]>j )
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_%("SetColor")
    }
    bg:=i>0 ? "1":"0"
    return
  Case "Color2Two","ColorPos2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, c,, SelColor
    if (c="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % "`n" Lang["12"] " !`n", 1
      return
    }
    UsePos:=(cmd="ColorPos2Two") ? 1:0
    GuiControlGet, n,, Similar1
    n:=Round(n/100,2), color:=c "@" n
    , n:=Floor(9*255*255*(1-n)*(1-n)), k:=i:=0
    , rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
    Loop, % nW*nH
    {
      c:=cors[++k], r:=((c>>16)&0xFF)-rr
      , g:=((c>>8)&0xFF)-gg, b:=(c&0xFF)-bb
      , ascii[k]:=v:=(3*r*r+4*g*g+2*b*b<=n)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_%("SetColor")
    }
    bg:=i>0 ? "1":"0"
    return
  Case "ColorDiff2Two":
    Gui, FindText_Capture: Default
    GuiControlGet, c,, SelColor
    if (c="")
    {
      Gui, +OwnDialogs
      MsgBox, 4096, Tip, % "`n" Lang["12"] " !`n", 1
      return
    }
    GuiControlGet, dR
    GuiControlGet, dG
    GuiControlGet, dB
    rr:=(c>>16)&0xFF, gg:=(c>>8)&0xFF, bb:=c&0xFF
    , n:=Format("{:06X}",(dR<<16)|(dG<<8)|dB)
    , color:=StrReplace(c "-" n,"0x"), k:=i:=0
    Loop, % nW*nH
    {
      c:=cors[++k], r:=(c>>16)&0xFF, g:=(c>>8)&0xFF
      , b:=c&0xFF, ascii[k]:=v:=(Abs(r-rr)<=dR
      and Abs(g-gg)<=dG and Abs(b-bb)<=dB)
      if (show[k])
        i:=(v?i+1:i-1), c:=(v?"Black":"White"), %Gui_%("SetColor")
    }
    bg:=i>0 ? "1":"0"
    return
  Case "Modify":
    GuiControlGet, Modify
    return
  Case "MultColor":
    GuiControlGet, MultColor
    Result:=""
    ToolTip
    return
  Case "Undo":
    Result:=RegExReplace(Result,",[^/]+/[^/]+/[^/]+$")
    ToolTip, % Trim(Result,"/,")
    return
  Case "Similar1":
    GuiControl, FindText_Capture:, Similar2, %Similar1%
    return
  Case "Similar2":
    GuiControl, FindText_Capture:, Similar1, %Similar2%
    return
  Case "GetTxt":
    txt:=""
    if (bg="")
      return
    ListLines, % (lls:=A_ListLines=0?"Off":"On")?"Off":"Off"
    k:=0
    Loop, %nH%
    {
      v:=""
      Loop, %nW%
        v.=!show[++k] ? "" : ascii[k] ? "1":"0"
      txt.=v="" ? "" : v "`n"
    }
    ListLines, %lls%
    return
  Case "Auto":
    %Gui_%("GetTxt")
    if (txt="")
    {
      Gui, FindText_Capture: +OwnDialogs
      MsgBox, 4096, Tip, % "`n" Lang["13"] " !`n", 1
      return
    }
    While InStr(txt,bg)
    {
      if (txt~="^" bg "+\n")
        txt:=RegExReplace(txt,"^" bg "+\n"), %Gui_%("CutU")
      else if !(txt~="m`n)[^\n" bg "]$")
        txt:=RegExReplace(txt,"m`n)" bg "$"), %Gui_%("CutR")
      else if (txt~="\n" bg "+\n$")
        txt:=RegExReplace(txt,"\n\K" bg "+\n$"), %Gui_%("CutD")
      else if !(txt~="m`n)^[^\n" bg "]")
        txt:=RegExReplace(txt,"m`n)^" bg), %Gui_%("CutL")
      else Break
    }
    txt:=""
    return
  Case "ButtonOK","SplitAdd","AllAdd":
    Gui, FindText_Capture: Default
    Gui, +OwnDialogs
    %Gui_%("GetTxt")
    if (txt="") and (!MultColor)
    {
      MsgBox, 4096, Tip, % "`n" Lang["13"] " !`n", 1
      return
    }
    if InStr(color,"@") and (UsePos) and (!MultColor)
    {
      r:=StrSplit(color,"@")
      k:=i:=j:=0
      Loop, % nW*nH
      {
        if (!show[++k])
          Continue
        i++
        if (k=cors.SelPos)
        {
          j:=i
          Break
        }
      }
      if (j=0)
      {
        MsgBox, 4096, Tip, % "`n" Lang["12"] " !`n", 1
        return
      }
      color:="#" (j-1) "@" r.2
    }
    GuiControlGet, Comment
    if (cmd="SplitAdd") and (!MultColor)
    {
      if InStr(color,"#")
      {
        MsgBox, 4096, Tip, % Lang["14"], 3
        return
      }
      bg:=StrLen(StrReplace(txt,"0"))
        > StrLen(StrReplace(txt,"1")) ? "1":"0"
      s:="", i:=0, k:=nW*nH+1+CutLeft
      Loop, % w:=nW-CutLeft-CutRight
      {
        i++
        if (!show[k++] and A_Index<w)
          Continue
        i:=Format("{:d}",i)
        v:=RegExReplace(txt,"m`n)^(.{" i "}).*","$1")
        txt:=RegExReplace(txt,"m`n)^.{" i "}"), i:=0
        While InStr(v,bg)
        {
          if (v~="^" bg "+\n")
            v:=RegExReplace(v,"^" bg "+\n")
          else if !(v~="m`n)[^\n" bg "]$")
            v:=RegExReplace(v,"m`n)" bg "$")
          else if (v~="\n" bg "+\n$")
            v:=RegExReplace(v,"\n\K" bg "+\n$")
          else if !(v~="m`n)^[^\n" bg "]")
            v:=RegExReplace(v,"m`n)^" bg)
          else Break
        }
        if (v!="")
        {
          v:=Format("{:d}",InStr(v,"`n")-1) "." FindText.bit2base64(v)
          s.="`nText.=""|<" SubStr(Comment,1,1) ">" color "$" v """`n"
          Comment:=SubStr(Comment, 2)
        }
      }
      Event:=cmd, Result:=s
      Gui, Hide
      return
    }
    if (!MultColor)
      txt:=Format("{:d}",InStr(txt,"`n")-1) "." FindText.bit2base64(txt)
    else
    {
      GuiControlGet, dRGB
      r:=StrSplit(Trim(StrReplace(Result,",","/"),"/"),"/")
      , x:=r.1, y:=r.2, s:="", i:=1
      Loop, % r.MaxIndex()//3
        s.="," (r[i++]-x) "/" (r[i++]-y) "/" r[i++]
      txt:=SubStr(s,2), color:="##" dRGB
    }
    s:="`nText.=""|<" Comment ">" color "$" txt """`n"
    if (cmd="AllAdd")
    {
      Event:=cmd, Result:=s
      Gui, Hide
      return
    }
    x:=px-ww+CutLeft+(nW-CutLeft-CutRight)//2
    y:=py-hh+CutUp+(nH-CutUp-CutDown)//2
    s:=StrReplace(s, "Text.=", "Text:="), r:=StrSplit(Lang["8"],"|")
    s:="`; #Include <FindText>`n"
    . "`n t1:=A_TickCount, X:=Y:=""""`n" s
    . "`n if (ok:=FindText(" x "-150000, " y "-150000, " x "+150000, " y "+150000, 0, 0, Text))"
    . "`n {"
    . "`n   CoordMode, Mouse"
    . "`n   X:=ok.1.x, Y:=ok.1.y, Comment:=ok.1.id"
    . "`n   `; Click, `%X`%, `%Y`%"
    . "`n }`n"
    . "`n MsgBox, 4096, Tip, `% """ r.1 ":``t"" Round(ok.MaxIndex())"
    . "`n   . ""``n``n" r.2 ":``t"" (A_TickCount-t1) "" " r.3 """"
    . "`n   . ""``n``n" r.4 ":``t"" X "", "" Y"
    . "`n   . ""``n``n" r.5 ":``t"" (ok ? """ r.6 " !"" : """ r.7 " !"")`n"
    . "`n for i,v in ok"
    . "`n   if (i<=2)"
    . "`n     FindText.MouseTip(ok[i].x, ok[i].y)`n"
    Event:=cmd, Result:=s
    Gui, Hide
    return
  Case "KeyDown":
    Critical
    if (A_Gui="FindText_Main" && A_GuiControl="scr")
      SetTimer, %Gui_ShowPic%, -150
    return
  Case "ShowPic":
    ControlGet, i, CurrentLine,,, ahk_id %hscr%
    ControlGet, s, Line, %i%,, ahk_id %hscr%
    GuiControl, FindText_Main:, MyPic, % Trim(FindText.ASCII(s),"`n")
    return
  Case "LButtonDown":
    Critical
    if (A_Gui!="FindText_Capture")
      return %Gui_%("KeyDown")
    MouseGetPos,,,, k2, 2
    if (k1:=Round(Cid_[k2]))<1
      return
    Gui, FindText_Capture: Default
    if (k1>71*25)
    {
      GuiControlGet, k3,, %k2%
      GuiControl,, %k2%, % k3 ? 0:100
      show[nW*nH+(k1-71*25)+dx]:=(!k3)
      return
    }
    k2:=Mod(k1-1,71)+dx, k3:=(k1-1)//71+dy
    if (k2>=nW || k3>=nH)
      return
    k1:=k, k:=k3*nW+k2+1, k2:=c
    if (MultColor and show[k])
    {
      c:="," Mod(k-1,nW) "/" k3 "/"
      . Format("{:06X}",cors[k]&0xFFFFFF)
      , Result.=InStr(Result,c) ? "":c
      ToolTip, % Trim(Result,"/,")
    }
    else if (Modify and bg!="" and show[k])
    {
      c:=((ascii[k]:=!ascii[k]) ? "Black":"White")
      , %Gui_%("SetColor")
    }
    else
    {
      c:=cors[k], cors.SelPos:=k
      GuiControl,, SelGray, % gray[k]
      GuiControl,, SelColor, % Format("0x{:06X}",c&0xFFFFFF)
      GuiControl,, SelR, % (c>>16)&0xFF
      GuiControl,, SelG, % (c>>8)&0xFF
      GuiControl,, SelB, % c&0xFF
    }
    k:=k1, c:=k2
    return
  Case "MouseMove":
    static PrevControl:=""
    if (PrevControl!=A_GuiControl)
    {
      PrevControl:=A_GuiControl
      SetTimer, %Gui_ToolTip%, % PrevControl ? -500 : "Off"
      SetTimer, %Gui_ToolTipOff%, % PrevControl ? -5500 : "Off"
      ToolTip
    }
    return
  Case "ToolTip":
    MouseGetPos,,, _TT
    IfWinExist, ahk_id %_TT% ahk_class AutoHotkeyGUI
      ToolTip, % Tip_Text[PrevControl ""]
    return
  Case "ToolTipOff":
    ToolTip
    return
  Case "CutL2","CutR2","CutU2","CutD2":
    Gui, FindText_Main: Default
    GuiControlGet, s,, MyPic
    s:=Trim(s,"`n") . "`n", v:=SubStr(cmd,4,1)
    if (v="U")
      s:=RegExReplace(s,"^[^\n]+\n")
    else if (v="D")
      s:=RegExReplace(s,"[^\n]+\n$")
    else if (v="L")
      s:=RegExReplace(s,"m`n)^[^\n]")
    else if (v="R")
      s:=RegExReplace(s,"m`n)[^\n]$")
    GuiControl,, MyPic, % Trim(s,"`n")
    return
  Case "Update":
    Gui, FindText_Main: Default
    GuiControl, Focus, scr
    ControlGet, i, CurrentLine,,, ahk_id %hscr%
    ControlGet, s, Line, %i%,, ahk_id %hscr%
    if !RegExMatch(s,"(<[^>]*>[^$]+\$)\d+\.[\w+/]+",r)
      return
    GuiControlGet, v,, MyPic
    v:=Trim(v,"`n") . "`n", w:=Format("{:d}",InStr(v,"`n")-1)
    v:=StrReplace(StrReplace(v,"0","1"),"_","0")
    s:=StrReplace(s,r,r1 . w "." FindText.bit2base64(v))
    v:="{End}{Shift Down}{Home}{Shift Up}{Del}"
    ControlSend,, %v%, ahk_id %hscr%
    Control, EditPaste, %s%,, ahk_id %hscr%
    ControlSend,, {Home}, ahk_id %hscr%
    return
  Case "Load_Language_Text":
    s=
    (
Myww       = 宽度 = 调整捕获范围的宽度
Myhh       = 高度 = 调整捕获范围的高度
AddFunc    = 附加 = 将 FindText() 函数代码一起复制
NowHotkey  = 截屏热键 = 当前的截屏热键
SetHotkey1 = = 第一优先级的截屏热键
SetHotkey2 = = 第二优先级的截屏热键
Apply      = 应用 = 应用新的截屏热键和调整后的捕获范围值
CutU2      = 上删 = 裁剪下面编辑框中文字的上边缘
CutL2      = 左删 = 裁剪下面编辑框中文字的左边缘
CutR2      = 右删 = 裁剪下面编辑框中文字的右边缘
CutD2      = 下删 = 裁剪下面编辑框中文字的下边缘
Update     = 更新 = 更新下面编辑框中文字到代码行中
GetRange   = 获取屏幕范围 = 获取屏幕范围到剪贴板并替换代码中的范围
TestClip   = 测试复制的文字 = 测试复制到剪贴板的文字代码
Capture    = 抓图 = 开始屏幕抓图
CaptureS   = 截屏抓图 = 先恢复上一次的截屏到屏幕再开始抓图
Test       = 测试 = 测试生成的代码是否可以找字成功
Copy       = 复制 = 复制代码到剪贴板
Reset      = 重读 = 重新读取原来的彩色图像
SplitAdd   = 分割添加 = 使用黄色的标签来分割图像为单个的图像数据，添加到旧代码中
AllAdd     = 整体添加 = 将文字数据整体添加到旧代码中
ButtonOK   = 确定 = 生成全新的代码替换旧代码
Close      = 关闭 = 关闭窗口不做任何事
Gray2Two      = 灰度阈值二值化 = 灰度小于阈值的为黑色其余白色
GrayDiff2Two  = 灰度差值二值化 = 某点与周围灰度之差大于差值的为黑色其余白色
Color2Two     = 颜色相似二值化 = 指定颜色及相似色为黑色其余白色
ColorPos2Two  = 颜色位置二值化 = 指定颜色及相似色为黑色其余白色，但是记录该色的位置
ColorDiff2Two = 颜色分量二值化 = 指定颜色及颜色分量小于允许值的为黑色其余白色
SelGray    = 灰度 = 选定颜色的灰度值 (0-255)
SelColor   = 颜色 = 选定颜色的RGB颜色值
SelR       = 红 = 选定颜色的红色分量
SelG       = 绿 = 选定颜色的绿色分量
SelB       = 蓝 = 选定颜色的蓝色分量
RepU       = -上 = 撤销裁剪上边缘1个像素
CutU       = 上 = 裁剪上边缘1个像素
CutU3      = 上3 = 裁剪上边缘3个像素
RepL       = -左 = 撤销裁剪左边缘1个像素
CutL       = 左 = 裁剪左边缘1个像素
CutL3      = 左3 = 裁剪左边缘3个像素
Auto       = 自动 = 二值化之后自动裁剪空白边缘
RepR       = -右 = 撤销裁剪右边缘1个像素
CutR       = 右 = 裁剪右边缘1个像素
CutR3      = 右3 = 裁剪右边缘3个像素
RepD       = -下 = 撤销裁剪下边缘1个像素
CutD       = 下 = 裁剪下边缘1个像素
CutD3      = 下3 = 裁剪下边缘3个像素
Modify     = 修改 = 二值化后允许修改黑白点
MultColor  = 多色查找 = 鼠标选择多种颜色，之后可以使用多色查找
Undo       = 撤销 = 撤销上一次选择的颜色
Comment    = 识别文字 = 识别文本 (包含在<>中)，分割添加时也会分解成单个文字
Threshold  = 灰度阈值 = 灰度阈值 (0-255)
GrayDiff   = 灰度差值 = 灰度差值 (0-255)
Similar1   = 相似度 = 与选定颜色的相似度
Similar2   = 相似度 = 与选定颜色的相似度
DiffR      = 红 = 红色分量允许的偏差 (0-255)
DiffG      = 绿 = 绿色分量允许的偏差 (0-255)
DiffB      = 蓝 = 蓝色分量允许的偏差 (0-255)
DiffRGB    = 红/绿/蓝 = 多色查找时各分量允许的偏差 (0-255)
Bind0      = 绑定窗口1 = 绑定窗口使用GetDCEx()获取后台窗口图像
Bind1      = 绑定窗口1+ = 绑定窗口使用GetDCEx()并修改窗口透明度
Bind2      = 绑定窗口2 = 绑定窗口使用PrintWindow()获取后台窗口图像
Bind3      = 绑定窗口2+ = 绑定窗口使用PrintWindow()并修改窗口透明度
Bind4      = 绑定窗口3 = 绑定窗口使用PrintWindow(,,3)获取后台窗口图像
1  = 查找文字工具
2  = 灰度阈值|灰度差值|颜色相似|颜色位置|颜色分量|多色查找
3  = 图像二值化及分割
4  = 抓图生成字库及找字代码
5  = 位置|先点击右键一次\n把鼠标移开\n再点击右键一次
6  = 解绑窗口使用
7  = 请用左键拖动范围\n坐标复制到剪贴板
8  = 找到|时间|毫秒|位置|结果|成功|失败
9  = 截屏成功
10 = 鼠标位置|穿透显示绑定窗口\n点击右键完成抓图
11 = 请先设定灰度差值
12 = 请先选择核心颜色
13 = 请先将图像二值化
14 = 不能用于颜色位置二值化模式, 因为分割后会导致位置错误
    )
    Lang:=[], Tip_Text:=[]
    Loop, Parse, s, `n, `r
      if InStr(v:=A_LoopField, "=")
        r:=StrSplit(StrReplace(v,"\n","`n"), "=", "`t ")
        , Lang[r.1 ""]:=r.2, Tip_Text[r.1 ""]:=r.3
    return
  }
}

}  ;// Class End
