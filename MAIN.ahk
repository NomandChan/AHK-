#SingleInstance
 
A_HotkeyInterval := 2000  ; This is the default value (milliseconds).
A_MaxHotkeysPerInterval := 200
SetCapsLockState("AlwaysOff")  
; SetWorkingDir(A_ScriptDir)  
CoordMode("Mouse", "Screen")
; init_pixel_find()
ScriptStartModTime := FileGetTime( A_ScriptFullPath)
SetTimer(CheckScriptUpdate,100,0x7FFFFFFF) ; 100 ms, highest priority
SetTimer(WatchCursor,100)  ;这个设置了获取鼠标信息的频率，数值越小边缘热区越灵敏
InstallKeybdHook
InstallMouseHook


; 函数最好直接放在第一个本体，后面的细节再慢慢添加。
; 多个文件看得清楚，功能相当于复制到这里。 vscode 装了 ahkv2-lsp 插件以后，在文件名上点击 F12 可以直接跳转过去。
#Include "%A_ScriptDir%\Modifiers.ahk"
#Include "%A_ScriptDir%\Basic_Remap.ahk"
#Include "%A_ScriptDir%\HotStrings.ahk"
#Include "%A_ScriptDir%\Mouse.ahk"

; vscode 拆分两列用菜单进行选择就行了： alt+v； 编辑器布局 L ；双列 T；  而传统软件 Obsidian 需要 alt + shift + ijkl 切换， n/m 新建分列。
; 切换直接用 ctrl +1/2 就能切换
; C:\Users\c1560\scoop\apps\autohotkey\1.1.33.09\v2.0-beta.7

A_TrayMenu.Add()  ; 创建分隔线.
A_TrayMenu.Add("虚拟桌面1 Ctrl+Win+←→", MenuHandler1)  ; 创建新菜单项.
A_TrayMenu.Add("虚拟桌面2", MenuHandler2)  
A_TrayMenu.Add("虚拟桌面3", MenuHandler3)  
A_TrayMenu.Add("Pomodoro Timer", MenuHandler4)  
A_TrayMenu.Add("End Pomodoro", MenuHandler5)  

I_Icon := A_ScriptDir . "\open-book.png"
if FileExist(I_Icon)
TraySetIcon(I_Icon)





cn(mode := "两次切换Ctrl+Shift", smart_half:=0){  
    switch mode{
        ; 通过两次 ctrl+shift 切换，利用中文输入法的默认状态变成中文。（假设平时只使用 shift，并且默认状态是 chn）
        case "两次切换Ctrl+Shift":   
        Func_flip_IME_state("^+")  
        Sleep 30
        Func_flip_IME_state("^+")  


        ;1 2 两种中文输入法 
        case "set win hotkey":   Send("!+{2}")   
        case "强制通过 postmessage 切换输入法": PostMessage 0x0050, 0, 0x8040804,, "A"  
             ; 0x4040404 是繁体中文！，简体中文的编号是什么  0x8040804


;下面切换的方法都不太靠谱
        case "TrackingByMyself":  Function_Set_Language_by_tracking(2)    
        case "flip_toogle":            Func_flip_IME_state()
        case "讯飞输入法的特殊逻辑Ctrl+. space":       Send("^.^{Space 2}")  ; 利用 全角半角切换一定是中文内这个特性进行切换。
        case "讯飞输入法的特殊逻辑Ctrl+. shift":       Send("^.{Shift 2}")  ; 利用 全角半角切换一定是中文内这个特性进行切换。

    }
    clear_mouse_flag_altered()
    if( smart_half == 1)
        Other_things_when_toggling_IME()  ; vscode 之中使用半角中文.
}


; 只是 set language 的快捷入口，不要做派发！
en(mode := "两次切换Ctrl+Shift"){  
    switch mode{
        ; 通过两次 ctrl+shift 切换，利用中文输入法的默认状态变成中文。（假设平时只使用 shift，并且默认状态是 chn）
        case "两次切换Ctrl+Shift":   
        Func_flip_IME_state("^+")  
        Sleep 30
        Func_flip_IME_state("^+")  
        Func_flip_IME_state("Shift")

        case "set win hotkey":   Send("!+{3}")   ;  win11 快捷键丢失的 bug 更严重了，甚至不是重启后丢失?? 设置丢失只是看不见，但还能用
        case "强制通过 postmessage 切换输入法": PostMessage 0x0050, 0, 0x4090409,, "A"  ; 0x0050 is WM_INPUTLANGCHANGEREQUEST.

        ;下面切换的方法都不太靠谱
        case "TrackingByMyself":  Function_Set_Language_by_tracking(1)    
        case "flip_toogle":            Func_flip_IME_state()
        case "讯飞输入法的特殊逻辑Ctrl+. space":       Send("^.^{Space 1}")  ; 利用 全角半角切换一定是中文内这个特性进行切换。
        case "讯飞输入法的特殊逻辑Ctrl+. shift":       Send("^.{Shift 1}")  ; 利用 全角半角切换一定是中文内这个特性进行切换。

    }
    clear_mouse_flag_altered()
    Sleep(100)
    ; Other_things_when_toggling_IME()
}



; switch IME 
Func_flip_IME_state(mode:="Shift"){
    
    switch mode
    {
        case "Shift":            Send("{Shift down}{Shift Up}")
        case "ctrl+space":       Send("^{Space}")
        case "tilde":   Send("{sc029}")  ; ctrl+shift , alt+shift, grave 这三个是一组
        case "^":      Send("{Ctrl Down}{Ctrl Up}")   ; ctrl,ctrl+space,shift     这三个是一组
        case "shift":   Send("{Shift Down}{Shift up}") 
        case "^+" :     Send("{Ctrl Down}{Shift Down}{Shift up}{Ctrl Up}")   ; 正常是 ctrl + shift，但其实你可以先按shift再按control，这样就没有操作界面了。 没有 GUI 界面反应会快一点。                  ; 或者说。使用 alt 加shift切换语言。 shift + ctrl works in onenote, meanwhile ctrl + shift won't work. I guess it's OSD lagging the windows.
        case "^space":  Send("^{Space}") 
        
    }
    ; ToolTip("wait to release")
    ; KeyWait("Shift")
    ; KeyWait("Alt")
    ; KeyWait("Ctrl")           

    ToolTip()   
}
     


!+8::cn("set win hotkey")
!+9::en("set win hotkey")

; Obsidian 切换搜索时候进入中文（必须要清楚或者等待之前的快捷键松开。
~^p::TagAlongEN()
~^!l::TagAlongCN()

TagAlongCN()
{   

    KeyWait "ctrl"
    KeyWait "alt"
    KeyWait "shift" 
    cn() 
}
TagAlongEN()
{   

    KeyWait "ctrl"
    KeyWait "alt"
    KeyWait "shift" 
    en() 
}
checkCurrentKeyboardLayout() {
    ThreadId := DllCall("User32.dll\GetWindowThreadProcessId", "Ptr", WinExist("A"), "Ptr", 0, "UInt")

    hCurrentKBLayout := DllCall("User32.dll\GetKeyboardLayout", "UInt", ThreadId, "Ptr")
    msgbox(hCurrentKBLayout)
    return
    }


MenuHandler1(ItemName, ItemPos, MyMenu) {
    Send("^#{left}")
    Send("^#{left}")
}
MenuHandler2(ItemName, ItemPos, MyMenu) {
    Send("^#{left}")
    Send("^#{Right}")
}
MenuHandler3(ItemName, ItemPos, MyMenu) {
    Send("^#{Right}")
    Send("^#{Right}")
}



; 主要功能
; 输入αωκλ 希腊字符、上下标、特殊符号。      ; The hotstring and and formula typing Greek letters example is in the readme on the website. (superscripts and undersccripts)



;  keywait 等待然后一起返回 更方便一个快捷键重复使用多次。    第二个参数，字符串以逗号隔开，自行确保很选相对应。 
; 不等待模式： immediateMode 从 1 到 n
updateSharedRepeat( NeedToBeDisplay := "", immediateMode_length := 0){
    global repeatTime
    
    if( A_PriorHotkey != A_ThisHotKey or A_TimeSincePriorHotKey  > 1000)
        repeatTime := 0  ;list 从0 到 maxindex（）

    if( immediateMode_length > 0){
        len := immediateMode_length
        if( A_PriorHotkey == A_ThisHotKey )
            repeatTime += 1   ;immediateMode_length 从 1 到 inf 手动归零。
        if (repeatTime >= len)
            repeatTime -= len   ;归零。

        return repeatTime
    }

    ToolTip( repeatTime ,,999,8 )
    
    result_key := Trim(A_ThisHotKey, "$")
    result_key := Trim(result_key, "~")
    result_key := Trim(result_key, "#")
    result_key := Trim(result_key, "!")
    ; 如果还有别的修饰键就不行了。
    Array := StrSplit(result_key , " ", ">$~+^< &", 3)    ; a & b 会返回三个值，两个空格之间的符号也算上了，手动跳过。

    first_key := Array[1]
    latter_key := Array[Array.Length]

    options := StrSplit(NeedToBeDisplay , ",")  ;",，" 不能同时有两个 delimiter
    len := options.length
    flag := 1
    while (flag ){  
        display := ""
        if (repeatTime >= len)
            repeatTime -= len
        if (NeedToBeDisplay =="")
            display :=  "repeatTime=  "  repeatTime   "latter_key  " latter_key
        else{
            
            For Index, Value in options{
                ; Send(Value)
              if(  Index == repeatTime + 1)
                    display .= repeatTime . "　" 
                else
                    display .= "　　" 
                display .= Value "`n"  
            }   
        }

        ToolTip(display,,999,8 )
        KeyWait(latter_key)   ;等待松开然后再按下
        flag1 := KeyWait(latter_key , "T.75D")   ; 超时返回  0     这里不能用 A_ThisHotkey，这里还在等待，但下一个 key 已经把全局变量替换掉了。
        flag2 := GetKeyState(first_key,"p")  ; 松开时 = 0
        flag := flag1
        if( flag == 1){
            repeatTime += 1 
        }
        
        sleep(50)
    }
    SetTimer () => ToolTip(,,,8), -1750  
    SoundBeep()
    return repeatTime
}





Other_things_when_toggling_IME(){
    name := WinGetProcessName("A")
    ; Sleep(1000)
     ; tooltip, %name% 
    ; ；----------------------------------------------
    ; 希望默认英文的环境 Code.exe ← VSCODE,      Obsidian.exe  OneCommander.exe
    if( name == "Code.exe" or  name == "OneCommander.exe")
    {
        ; Send("^.") ;bug！？ ctrl + 句号 在讯飞输入法竟然能从英文切换到中文！！
        Send("^{sc034}") ;还是存在？！？！ 原来是因为shift 还没有松手……
    }
    
    ; msedge.exe  WeChat.exe 。但是  onenote 和 系统设置区分不开、的 ahk——exe 都是这个 ApplicationFrameHost.exe ，区分不开
    else if( name == "msedge.exe" or  name == "Obsidian.exe" or  name == "ApplicationFrameHost.exe" or  name == "WeChat.exe" )
    {
        ;not change
    }

    ;soundbeep,1000,100
    ; send,{ctrl up}{shift up}{alt up}   
    ; Func_Heads_up_using_scrollLock(num)
    ; Func_Mouse_Indicator(num)
    ; func_head_up_sound_ime()     不切换
}

Function_Set_Language_by_tracking(target_state) {
    global Current_IME_State
    
    return_IME_state_from_pixel()
    if (  target_state != Current_IME_State   or true)   ; 加一点“智能”，只有想要切换的语言和当前语言不同的时候，才切换语言。  9 ≠ 1 and 9 ≠ 2 ，
    {
        Current_IME_State := 3 - Current_IME_State ;" jump between 1,2"
        Func_flip_IME_state()  
    }
}

    
 



; 根据周围字符判断语言环境，有点影响使用，需要复制文本，最终放弃
; 测试： IsAlpha("按", "Locale") IsAlpha("ddddddd", "Locale") IsAlpha("   ", "Locale") IsAlpha("111", "Locale")
; 四个结果是 1 1 0 0， 也就是说不分中文英文，是文字返回1，数组、空格返回0.
; ~LButton::
; {
;     global MpositionX, MpositionY
;     global LastX, LastY
;     global flag_idle_space
;     LastX := MpositionX
;     LastY := MpositionY
;     global moveFar
;     global threshold_idle
;     MouseGetPos(&MpositionX, &MpositionY, &id, &control)
;     ; ToolTip( MpositionX  MpositionY )

;     ; guess := GetAcharactor_and_return_language_clipboard() 
;     ; ToolTip(guess)
;     if ( Abs(MpositionY - LastY) > 500 or Abs(MpositionX - LastX) > 500 ){
;             moveFar := 1
;             ;  threshold_idle :=  别耦合了，想不出来，直接做一个 keywait 等待就完事了。
;         }
;     else 
;         moveFar := 0


;     if (A_Cursor = "IBeam" and moveFar == 1)   ;Unknown ; cursor is on link
;     {
        
;         en()
;         ; change_this_program_perfer() ;根据程序名称判断。
;     }
;     ; SetTimer(RemoveToolTip,-1000) ;     ; guess := GetAcharactor_and_return_language_clipboard() ; 直接根据 ascii 码判断。有点影响使用。放弃
;     ; ToolTip(guess)
    
; }

if_temp_toggle_IME_is_ture_then_change_it_back()
{
    global temporal_change_IME
    if( temporal_change_IME == 1)
        {
           en()
            temporal_change_IME := 0
        }
} 
   


global XwhereMwas := 0
global YwhereMwas := 0
global M_altered_wait_click:=0
global Ts:= A_TickCount
global height_PDF := 1300
global threshold_idle:= 6000
global Current_IME_State :=1
global TimeIdleKeyboardArray:= []
global flag_mouse_wheel_change:=0 
global W := A_ScreenWidth - 1    ; 1920  如果屏幕是竖过来的，这个值 AHK 会帮你改变。（但是第一段只执行一次，可能需要重载。）
global H := A_ScreenHeight - 1  ;  1080
global index_Time := 0
global maxValue_Time := 10
global repeatTime := 0

global using_shift_to_help_typing_in_Chinese:=1
global n_mouse_move_momentum:=0
global StartTime:= 0
global idle_time_number:=0

global Stop_Sitting_counter:=0
global Stop_Sitting_Lastime_triggered:= A_TickCount

global Press_Start_time
global now_language :=0
global repeat_key:=0
global exclude_apps_string := []
global MpositionX :=0
global MpositionY :=0
WatchCursor() 
{ 
    global Current_IME_State
    global flag_mouse_wheel_change
    global TimeIdleKeyboardArray
    global index_Time 
    global maxValue_Time
    global threshold_idle
    global flag_idle_space
    global moveFar
    global M_altered_wait_click
    global XwhereMwas
    global YwhereMwas
    MouseGetPos(&xpos, &ypos, &id, &control)
    W := A_ScreenWidth
    ; ToolTip(A_TimeIdlePhysical)

    global XwhereMwas := xpos
    global YwhereMwas := ypos
    
    ;------------------------ Pomodoro    --------------
    ; AutoMaticPomodoro() 
    
       ; ；------------------------移动距离足够大以后，改变键盘的逻辑---------------
    ; if( Abs( XwhereMwas - xpos) + Abs(YwhereMwas - ypos) > 100 and (A_TimeIdleKeyboard >200))
    ; {
        
    ;     M_altered_wait_click := 1
    ;     CoordMode("ToolTip" , "Screen")
    ;     ToolTip(" "  ,0 ,  9200,9 )
    ;     ; SetTimer ()=> ToolTip(,0,9999,9 )  ,-1000
    ;     ; if_temp_toggle_IME_is_ture_then_change_it_back()
    ; }


 
    ; ；------------------------移动距离足够大以后，改变键盘的逻辑---------------
    
 
    ; if( Abs( XwhereMwas - xpos) >  700 and !GetKeyState("LButton"))   ;相对移动甚至不需要区分副屏幕。
    ;     {
 
    ;     }
 




    ; -----------------------  闲置足够长时间就清除 modifer---------------------
    ; t := Mod(A_TimeIdleKeyboard, threshold_idle)           ;      鼠标切换的话 keyboard idle 时间不更新.                 ;  取余是最简单的,不用记录之前是哪个程序,和现在比较.   取余一定要用 后面的 100 ms,而不是开始的 100 ms,不然总是重置 IME.

    ; if( t > 300 ){
    ;     ; change_this_program_perfer() 
    ;     global modifier
    ;     modifier := ""
    ;     ; showIMEstateRIME()
    ; }


    ; if( A_TimeIdleKeyboard > 1600 )
    ;     {
    ;         M_altered_wait_click := 0
    ;         ToolTip(  ,0 ,  ypos+ 200,9 )
            
    ; }


    ; if( t > threshold_idle - 100 ){    时间过长修改输入就太影响输入思路了，鼠标、换程序时修改最好。
    ;     en() 
    ; }
    ; if( A_TimeIdleKeyboard > threshold_idle - 100 ){
    ;     flag_idle_space := 1
    ; }
    ; else {
    ;     flag_idle_space := 0
    ; }
    ; -----------------------  闲置足够长时间就清除 modifer-------------------
   


    ; ToolTip(A_ScreenHeight ypos xpo )
    if( GetKeyState("Ctrl","P"))
        if(  (xpos = 0 ))   ;and  ypos = A_ScreenHeight -1    往左拖动(同时按住 ctrl）触发删除，这样鼠标可以直接拖动文字复制、移动、删除。
            {
                Send("{LButton Up}")
                Send("{BackSpace}")
                Sleep(2000)
            }

    
    ; 大部分程序都不会汇报 caret 的位置，所以不可能知道键盘输入点在哪。 追踪鼠标更加合理。
    ; ToolTip, X%A_CaretX% Y%A_CaretY%, A_CaretX, A_CaretY - 20
    ; 但是数组从 0 开始。对于 1920*1080 的电脑来说， 左上角 0,0 ；右上角 1919，0 ；左下角 0,1079；  右下角1919 1079。

    ;若要重设边缘热区的范围请，把下一行的 ; 号去掉，就会在鼠标位置显示鼠标的坐标，根据坐标修改以下数值
    ; ToolTip,x:%xpos% y:%ypos% :%% `t  Hei =  %Hei%  Wei =%Wei%
    
    ; -----------------------
    ; tooltip, %A_ScreenWidth%

    ; 根据鼠标在 screen 的位置修改鼠标滚轮的功能。               ; 副屏幕坐标是负的，整个屏幕的基准不是 0；副屏幕左上角是 -1440,661 
    ; if(GetKeyState("LButton")){   ;没有按下鼠标才触发。
    if(GetKeyState("``")){          ;没有__`__才触发。  但是这个规则没有用？和上条不一样？
    ; if(GetKeyState("SC029")){     ;没有__`__才触发。  但是这个规则没有用？和上条不一样？
        return
    }

        
     
        ; 滚轮控制音量                              else if ↓↓↓  ypos < H * 0.25 or
        if( xpos = 0 and ( ypos > H * 0.75  )  or (   xpos = -1440 and ypos < 900)){   ;屏幕左上角, 左下角，副屏幕。
                flag_mouse_wheel_change :=3
                ToolTip("滚轮控制音量" xpos , A_ScreenWidth,,15)
                ToolTip()
        }

        ; 左上角   ;切换上一个任务  alt+Tab
        ; else if(xpos = 0 and ypos = 0){
        ;     Sleep( 1000)
        ;     ;if still here
        ;     MouseGetPos(&xpos, &ypos, &id, &control)
        ;     if(xpos < 50 and ypos < 50){
        ;             Send("!{Tab}")  
        ;             Sleep( 1000)
        ;         }
        ; }    
        
        ;  ; 右上角    F11 或者切换任务   已经设置了『全面屏手势』，就不用这个了。
        ; else if(xpos + 1 = A_ScreenWidth and ypos = 0){

        ;     Sleep( 1000)
        ;     ;if still here
        ;     MouseGetPos(&xpos, &ypos, &id, &control)
        ;     if( Abs( A_ScreenWidth - xpos) < 50 and ypos < 50){
        ;             Send("#{Tab}")      ;切换任务    任务管理器
        ;             ; Send("{F11}")
        ;             Sleep( 1000)
        ;         }
        ; }

        ;     ;屏幕右边直接控制翻页  条件较小的一定要放右边！！
        else if( xpos = A_ScreenWidth - 1 ){   
            flag_mouse_wheel_change := 4
            ToolTip("PG", A_ScreenWidth,,15)
        }

        else {  ;重置状态  ，必须要
            if( flag_mouse_wheel_change != 0){
                flag_mouse_wheel_change :=0
                ToolTip(,,,15)
            }
        }
;  ----------------------------------放弃---------------------------------
        ; 浏览器标签，上方，快速切换。 稍微往下，第二行，第三行，屏幕左侧 75% 调音量，右侧控制翻页，功能都有。
        ; if (  (xpos > 250 and  xpos < W-250 )) {
        ;     ; 屏幕中央，去除两侧，避免 bug
        ;     if (   ypos < 50   ){   
        ;             flag_mouse_wheel_change :=1
        ;         ToolTip("屏幕左上方 1 滚轮控制翻页  `n 右键打开 ↑任务菜单全部任务↑ " ,A_ScreenHeight,,15)
        ;     }
        ;     else if( ypos > 50 and ypos < 100){
        ;         flag_mouse_wheel_change :=2
        ;         ToolTip("屏幕左上方 2 滚轮控制22    左右", A_ScreenWidth,,15)
        ;     }
            
        ;     else if( ypos > 100 and ypos < 150){
        ;         flag_mouse_wheel_change := 4
        ;         ToolTip("屏幕左上方 3 滚轮控制上下", A_ScreenWidth,,15)
        ;     }

        ;     else if( flag_mouse_wheel_change != 0){
        ;         flag_mouse_wheel_change :=0
        ;         ToolTip(,,,15)
        ;     }
        ; }
        ;  
        ; else if(xpos <-50 and ypos = 603) {
        ;         flag_mouse_wheel_change :=1
        ;         ToolTip("屏幕左上方 1 滚轮控制翻页   `n 右键打开 ↑任务菜单全部任务↑ ", A_ScreenWidth,,15)
        ; }
         ;  mousinc 这个鼠标手势软件有很多功能，https://zhuanlan.zhihu.com/p/400590907  绿色，
        ; 手写识别，carnac 按键回显，边缘滚动，有意思的音响效果，甚至 altsnap 移动窗口（只不过是 alt + 鼠标滚轮，而我这个鼠标没有滚轮。）、 ditto 的画中画都有！
;  ----------------------------------放弃---------------------------------


;---------------------------------------------------------
 
        ; else if(xpos = 0 and ypos = H){
        ;     tooltip, 屏幕左下角  如果还在这里 still here `n 那么触发。。。左下角  0 1079    W L 
        ;     Sleep, 1000
    
        ;     MouseGetPos, xpos, ypos, id, control
        ;     if(xpos < 50 and ypos > H -50){
        ;         ;WinMinimizeAll
        ;         Sleep, 1500
        ;         ;WinMinimizeAllUndo
        ;     }

        
        

        ; 
        ;     if( flag_mouse_wheel_change != 0)
        ;         flag_mouse_wheel_change :=0
        ;        
    ; }

   
}

AutoMaticPomodoro()
{

if(  A_TimeIdlePhysical < 60000 )   ;1 minutes = 60*1000 ms 函数里面自动过滤掉太远的输入，只需要进入的时候过滤一下。
    {
        My_automatic_Pomodoro_Stop_Sitting_function_couting_up()
    }

else if( A_TimeIdlePhysical > 300000)
    {
    Pomodoro_Kill()   ; 太长的空闲，重置计数器。
    global Stop_Sitting_block_once
    Stop_Sitting_block_once := 1
    ToolTip("Clear",0,0)
}
}
; ~Tab::                  
; ~LButton::showIMEstateRIME()          陈饭FDSFshUIFFDSFhsDhui

; LCtrl::
; ; ~Shift::
; LAlt::
; {
;     if_temp_toggle_IME_is_ture_then_change_it_back()
;     global temporal_change_IME
;     temporal_change_IME :=0
;     ; showIMEstateRIME(1000)                                                    
;     Send("{A_ThisHotkey}")
; }


; RIME 和手心输入法切换的时候屏幕上有提示，非常方便。我只需要触发它就行了。
showIMEstateRIME(time := 100)
{
    Sleep(time)   
    Send("{LShift 2}")
}




;0 is normal ; 位置修改功能
WheelUp:: 
{
global flag_mouse_wheel_change
    switch flag_mouse_wheel_change
    {
        case 1: Send("+{tab}")
        case 2: Send("{Left}")
        case 3: Send("{Volume_Up}")
        case 4: Send("{PgUp}")
        default: Send("{WheelUp}")

    }
}
WheelDown:: 
{
global flag_mouse_wheel_change
    switch flag_mouse_wheel_change
    {
        case 1: Send("^{tab}")
        case 2: Send("{Right}")
        case 3: Send("{Volume_Down 3}")
        case 4: Send("{PgDn}")
        default: Send("{WheelDown}")

    }
}

#HotIf flag_mouse_wheel_change=4
; 全面屏手势，鼠标在屏幕右侧时，唤出任务菜单。（按住显示，松手选择）
RButton::
{
    Send("#{Tab}")
    KeyWait("RButton")   
    Click()

}

#HotIf

delete_a_word(){
    Send("^{backspace}")
}

adds_two_space_before_and_after(){
    Send("^{left}")
    Send("{space}")
    Send("^{right}")
    Send("{space}")
}
func_delete_traling_newline_and_enter(){
    Send("{end}{delete}{space}{down}{end}")
}
;注意空格就可以连接字符串！
showtip( string,t:=500){
    ToolTip(string)
    SetTimer () => ToolTip( ), -300000  
    ; SetTimer(RemoveToolTip,-%t%)
}

delete_one_line(){
    Send("{Home}{Shift down}{End}{Shift up}")
    Sleep(10)
    Send("{BackSpace}")  ;删除一行，而不是删除所有文字，功能挺顺手的。
    return
    }
delete_from_here_to_end_of_the_line(){
    Send("{Shift down}{End}{Shift up}")
    Sleep(10)
    Send("{BackSpace}")  ;删除一行，而不是删除所有文字，功能挺顺手的。
    return
    }
    
; Delete & a::delete_a_word()
; Delete::Send("{Delete}")

;wordpress 文字修改，这个是添加软回车，wordpress  需要一整块的文字，
func_wordpress_change_to_soft_enter(){
    Send("{End}")
    Sleep(50)
    Send("{delete}")
    Sleep(50)
    Send("{Shift down}{Enter}{Shift up}{End}")
    return
}
func_superscript_text(){
    Send("{Shift down}{Left}{Shift up}")
    Send("{Ctrl down}{Shift down}{=}{Shift up}{Ctrl up}")
    Send("{Left}")
    return
}
func_underscript_text(){
    Send("{Shift down}{Left}{Shift up}")
    Send("{Ctrl down}{=}{Ctrl up}")
    Send("{Left}")
    return
}


; ~ki
~k::
{
    ; check_io_pressed_in_the_same_time()
    ; if( GetKeyState("j") and GetKeyState("i") and GetKeyState("o")dededeededeeedede
    if( GetKeyState("i")){
        Send("{bs 2}")
        Sleep(200)
        cn()
        
        
    } 
        
}
; ~ed
~d::
{
    ; check_ew_pressed_in_the_same_time()   
    if(  GetKeyState("e") and GetKeyState("d")  ){
        Send("{bs 2}")
        Sleep(200)
        en()
    } 
}

    


;这个功能需要一个 exe,很小，是封装的微软“讲述人”功能: https://elifulkerson.com/projects/commandline-text-to-speech.php

voice_text_to_speach( lan := "en"){
    ; BackUpClip := ClipboardAll
    Send("^{c}")
    ; Send("{Media_Play_Pause}")
    Sleep(50)  ; 必须有，确保 clipboard 数据更新。
    ; say    PowerShell "C:\Users\Administrator\OneDrive\代码\voice.exe  /n 'Microsoft David Desktop'  'output'" , ,Hide
    ;                   ↑↑   
    ; 若要在单引号字符串中包含单引号，请使用第二个连续单引号。
    ; 若要使双引号显示在字符串中，请将整个字符串括在单引号中。           详情见 https://docs.microsoft.com/zh-cn/powershell/module/microsoft.powershell.core/about/about_quoting_rules?view=powershell-7.2
    
    textRaw := A_Clipboard
    ; 里面的单引号会出 bug， 指令里面有单引号，还是 shell 不许参数有引号？ 那我直接做一个替换也许就可以了。
    textraw := StrReplace(textraw, "'", "''")
    textraw := StrReplace(textraw, "’", "''")
    textraw := StrReplace(textraw, "‘", "''")
    
    ; ToolTip(A_NowUTC "`n" textraw)
    switch lan
    {
    ; 用 voice.exe --list 查看可用的语音源。
    ;     PS C:\Users\Administrator\OneDrive\代码\AHK> ./voice.exe --list
    ; "Microsoft Huihui Desktop" - Adult,Female,zh-CN     ;中英都可以念，但是英文有点卡。
    ; "Microsoft Zira Desktop" - Adult,Female,en-US   ; 英文流畅但是完全念不了中文
    ; "Microsoft David Desktop" - Adult,Male,en-US
    case "en":     command := A_ScriptDir . "\voice.exe /n 'Microsoft Zira Desktop'  '" . textRaw . "'"        
    case "cn":     command := A_ScriptDir . "\voice.exe /n 'Microsoft Huihui Desktop'  '" . textRaw . "'"  
    }
    try
        ExitCode :=RunWait("PowerShell `" " command "`"", , "Min")
    catch
        MsgBox(ExitCode)
    
    ; MsgBox(ExitCode)
    ; Send("{Media_Play_Pause}")
    
    ; Clipboard := BackUpClip
    ;test  
    ; such as Tchaikovsky's Symphony No. 6, are not placed in quotes, but if the work also has a title, the title is placed in quotes. (Tchaikovsky's Symphony No. 6, "Pathetique.")
}
CheckScriptUpdate() {   ;自动更新功能，来自于例子：https://www.it1352.com/1954002.html
    global ScriptStartModTime
    curModTime := FileGetTime(A_ScriptFullPath)
    If (curModTime != ScriptStartModTime) {
        SetTimer(CheckScriptUpdate,0)
        Loop
        {
            reload
            Sleep(300) ; ms
            msgResult := MsgBox("Reload failed.", A_ScriptName, 2) ; 0x2 = Abort/Retry/Ignore
            if (msgResult = "Abort")
                ExitApp()
            if (msgResult = "Ignore")
                break
        } ; loops reload on "Retry"
    }
}


maximizeORrestore(){
    global Title

    if( A_PriorHotkey != A_ThisHotKey)
        { 
                Title := WinGetTitle("A")
                ToolTip("new window`n" Title)
        }
    else
            ToolTip("old window`n" Title)

    ; get MinMax state for the given title and save it to variable MX
    MX := WinGetMinMax(Title)
    ; -1: The window is minimized (WinRestore can unminimize it).
    ; 1: The window is maximized (WinRestore can unmaximize it).
    ; 0: The window is neither minimized nor maximized.
    ; if it is maximized, minimize it
    if (MX!=1)
        WinMaximize(Title)
    ; if it is minimized, maximize it
    else 
        ; WinMaximize, %Title%
        WinRestore(Title)
    ; else
        ; WinMinimize, A
        ; Tooltip
    return
}

    
    
minimizeORrestore(){
    if WinExist("ahk_id " lastWindow)
    {
        WinState := WinGetMinMax("ahk_id " lastWindow)
        if (WinState = -1)
            WinActivate()
        else
            WinMinimize()
    }
    else
    {
        lastWindow:= WinExist("A")
        WinMinimize("ahk_id " lastWindow)
    }
    return
}
take_notes( program){
    ; freeze_clipboard()
    
    the_clipboard:= A_Clipboard
    Send("^{c}")
    Sleep(100)
    switch_to_a_program( program )
    Sleep(200)
    Send("{Enter}")
    Send("^{v}")
    Sleep(100)
    Send("!{Tab}")

    A_Clipboard := the_clipboard

}
;这是一个单独的模式，不能输入，某些功能需要管理员权限，来重新实现键盘逻辑。
Func_Heads_up_using_scrollLock(num){
    if(num = 1){
        SetScrollLockState("Off")
    }
        
    else {
        SetScrollLockState("On")
    }
return
}







; 不允许模拟  ctrl + alt + del，Send,^!{Del}。  但是你可以发送 win+x,t  来唤出任务管理器
; onenote 2016 shortkeys , 新旧 OneNote 都有 bug，放弃了.
Lshift & WheelDown::Send("{WheelRight}")
Lshift & WheelUp::Send("{WheelLeft}")



; pomodoro 
F3 & p::   
{  
    repeatTime:=  updateSharedRepeat(" pomodoro 开始,关闭时钟   并清空自动时钟")
        switch repeatTime
        {
        case 0:     PomodoroStart()
        case 1:     Pomodoro_Kill()

        }
    return



}    
MenuHandler4(ItemName, ItemPos, MyMenu) {
    PomodoroStart()
}

MenuHandler5(ItemName, ItemPos, MyMenu) {
    Pomodoro_Kill()
    global blockPomodoro:= 1
}

PomodoroStart()
{
    global StartTime
StartTime := A_TickCount
SetTimer(pomodoro_tips,1000)  ; 每秒更新
; t := "1000*60*25"  = 1500000
SetTimer(endPomodoro,-1500200)  ;负数是倒计时关闭。  正数是周期提示。  25分钟是  1,500,000 ms
}

Pomodoro_Kill()
{
    SetTimer(pomodoro_tips,0)  ; 删除 Pomodoro 时钟
    global Stop_Sitting_counter  ;把另一个自动的重置
    Stop_Sitting_counter :=0
}

pomodoro_tips()
{  
    global StartTime
    ElapsedTime := A_TickCount - StartTime
    sec := Floor(ElapsedTime/1000)
    minute := Floor(sec / 60)
    CoordMode("ToolTip" , "Screen")
    ToolTip(minute ":" sec,   9990 ,  0, 16)
    
}   

endPomodoro()
{  
    SetTimer(pomodoro_tips,0)
    Send("{Media_Play_Pause}")   ;pause_play_beep:
    SoundBeep(1204, 300)
    ;write to file
    FileObj := FileOpen("Pomodoro.txt", "a")
    strings := "🍅 completed Year Week:" . A_YWeek  . "day " . A_DD 
    FileObj.WriteLine(strings)
    Send("^#{c}")  ; windows color filter
    ; MsgBox("🍅 end. Rest 5 Min")
    SetTimer () => MsgBox(" Back to Work"), -300000  
    SetTimer () => Send("^#{c}") , -300000  
    
return
}

; zxcv 是几个最好用的快捷键了。我放进去了，窗口最小化、关闭、浏览器搜索所选文字，还有。。
; !x::WinRestore("A")
; !z::WinMinimize("A")
; #z::Send("!{Esc}")   ; Sends a window to the bottom of stack; that is, beneath all other windows.   The effect is similar to pressing Alt+Esc.





Send_with_delay( retype_text ){
    ToolTip( StrLen(retype_text) ) 
    loop(StrLen(retype_text))
        {
            char := SubStr(retype_text, A_Index , 1)
          Send( char )
          Sleep 10
        }

}

;  还不如我自己主动占用掉它：输入法根本不会考虑到这个问题，键位不能改，所以不如自己抢先占用掉最好用的快捷键。
; vscode 如何改 hotkey ctrl k/s 如果实在输入法和软件冲突，倒不如改软件的快捷键，
;  非常常见的问题，这多个组合键之间本来就不应该触发别的功能。        例如你要使用格式刷，它的快捷键是 ctrl + shift + C/V。  但是ctrl加shift会触发更换语言的快捷键。

Clip(Text)
{
    SoundBeep()
	Send(Text)
}
ClipL(Text)
{
	Send(Text)
    Send("{Left}")
}
;^LAlt   欠考虑了，不能用这个。 例如 ctrl + alt + h ，会提前触发本组合。
;^RAlt:: 欠考虑了，不能用这个。
; ^Shift::return 欠考虑了，不能用这个。

F8 & N::take_notes("OneNote")
F8 & O::take_notes("Obsidian")


F9 & u::Send("^{u}")
F9 & r::Send("^{r}")
F9 & q::Send("^{q}")





; 切换到一组程序的首个，（如果能找到）。  这个程序有记忆，重复按键可以跳过第一个程序。

switch_to_a_program(titile_names, custom_behavior := False){
    SetTitleMatchMode(2)
    global n_time
    global exclude_apps_string
    global repeat_key
    this_search_start_number :=1

    ; WinActivate, % array[1] ,,2

    ;if this hotkey is same as last hotkey, which means double taps, then jump to last "jump number".
    ; else reset the "jump number"
    
    if( A_PriorHotkey != A_ThisHotKey)
    {
            ; showtip( A_PriorHotkey "新的按键" A_ThisHotKey) 
            repeat_key:= 0
            this_search_start_number := 1 
            exclude_apps_string := []
    }
    else{
        repeat_key := repeat_key+1
        ; showtip("多次点击" A_PriorHotkey A_ThisHotKey repeat_key)  
        this_search_start_number := n_time
    }

    if (custom_behavior){
        if ( titile_names[1] = "Edge"){
            if (repeat_key = 0){
                WinActivate("Edge")    ;←← 不用加引号！
            }
            else{
                Send("^{Tab}")
            }
        }
        else if ( titile_names[1] = "OneNote"){
            if (repeat_key = 0){
                WinActivate("OneNote")    ;←← 不用加引号！
            }
            
            else{
                ;我的 OneNote 导航页,连接到其他所有页面.
                {   
                    ; Run("`"onenote:https://d.docs.live.net/ff64712bc759b896/文档/雨爽/快速笔记.one#ToDo_FrontPage&section-id={C25FCCD8-1E30-460B-94D4-356C742E9CD6}&page-id={C2166799-8231-A942-9101-C8A5CDBE9172}&end`"", , "", )
                }
            }
        }

        
        else{
            showtip("wrong" )  
        }
        return
    }

    is_found :=0
    for index, element in titile_names ; Enumeration is the recommended approach in most cases.
    {
        if ( index < this_search_start_number)
        {
            Continue
        }
        if WinExist(element)
        {
            WinActivate()
            Title := WinGetTitle("A")
            ; tooltip,  "foundit" "`n1" WinExist("A") "`n2" Title "`n3" exclude_apps_string
            ; showtip( "foundit" "`n3" ExcludeTitle_string) 
            
            n_time := index
            is_found :=1
            Break
        }
        else
        {
            
        }  
            ; 
        ; MsgBox % "Element number " . index . " is " . element
    }
    if (is_found = 0 )
    {
        n_time := 1
        ; showtip( "not found any programs in" titile_names A_ThisHotKey)
        SoundBeep(1200, 100)
        ; Send,#{m}
    }
    
}



global temporal_change_IME :=0



Capslock::Func_flip_IME_state()
Shift::Send("{Shift}")  ; 通过多余的一次, 屏蔽 shift.  dfdf
; Capslock::Send("^{Space}")
; ~Capslock::
; { 
;     SetCapsLockState("AlwaysOff")
   

;     count:=0
;     while(getkeystate("Capslock","p"))
;     {
;         count++
;         ; ToolTip(count)
;         sleep 50
;     }
;     if(count<5)
;         en()
;     else
;         cn()
    
;     BlockInput("Off")
;     ; SoundBeep()
; }


; Shift::smartVimCN()
; Shift::smartVimCN()
; /sc033	逗号    sc034 句号
; $^sc033::cn()
; $^,::en()   bug 没用
; RAlt::cn()
Esc::
{
    Send("{Esc}")
    ; en()
    ToolTip()
}
; Pause::Send("{Delete}")  ;下面的语法才是完全重映射。
Pause::Delete

; #HotIf WinActive("ahk_exe msedge.exe")
; #HotIf

IMEtoggle(){
en("ctrl+space") 
}
                      
; $Space::
; {
;     Send("{Space}")
;     ret := KeyWait("Space","Up T1")   
;     if( ret := 0)
;      Send("{BackSpace}")
;     ; KeyWait("Space","Up")   
; }                          

; 按住 shift 太长时间，不小心切换输入法  。 但是 shift+↑←↓→ 也会统计进去。  
; ~$Shift::
; {
;     count:=0
;     while(getkeystate("Shift","p"))
;     {
;         count++
;         sleep 50
;     }
;     if(count>5)
;     {
;         ToolTip(A_TimeSincePriorHotKey)
;         Send("{Shift}")  ; 把它切回来，但不能阻止他
;     }
; }


; // 第二种写法也不能提前进入计时器。
; *LShift::
; {
;     global shift_press_time
;     while(getkeystate("Shift","p"))
;     {
;         shift_press_time++
;         sleep 50
;         ToolTip(shift_press_time)
;     }
    
; }
; global shift_press_time :=0
; *LShift UP::
; {
;     global shift_press_time
;     if(shift_press_time<5)
;         {
;             ToolTip(shift_press_time)
;             Send("{Shift}")  ; 把它切回来，但不能阻止他
;         }

; }




;     global shiftTick :=0
; $LShift Up::
; {
;     global shiftTick

;     ToolTip(A_TickCount - shiftTick )
;     ; if(shiftTick - A_TickCount < 200)
;     ; ToolTip("ffff")
; }


;  LCtrl::cn() 这个不能要

smartVimCN(){
    if WinActive("ahk_exe Obsidian.exe"){   ; 这个笔记本里才生效，其他软件不生效。  encn 切换及时 vim 状态错了也会被冲刷掉。
        en()
        Send("{i}")
        cn()       
    }
    else {
        cn()
    }
}
  

; 清除鼠标滚轮打上的标记。
clear_mouse_flag_altered() 
{
    global M_altered_wait_click 
    M_altered_wait_click := 0  
    ToolTip(,0,0,9 ) 
}
; ^space::Func_flip_IME_state()
~BackSpace::clear_mouse_flag_altered() 

         
; 模仿不 burst 的行为，但是还是不顺手。
; Space::
; {
;     ret := KeyWait("Space","T.85")
;     if( ret == 1) ; 提前到达，松开                
;         Send("{Space}")        
;     else
;         {
;             xxxx(9) 
;             KeyWait("Space")   ;  不加的话，会进入 “if”，多一个空格。   
;         }
; }

 

RemoveToolTip()
{ 
ToolTip()
return
} 
array2string(titile_names)
{
    length := titile_names.MaxIndex()
    ret :=""
    for entry in titile_names
    {
        ret := ret titile_names[A_Index]
    }
    return ret
}
temp_search(){
    Send("^{c}")
    Sleep(100)
    Send("!{Tab}")
    Sleep(100)
    Send("^{f}^{v}")
    Sleep(1000)
    ; Send("!{Tab}")
    ; Sleep(100)
}

temp_source()
{
    Send("^{u}")
    Sleep(100)
    Send("^{f}")
    Sleep(100)
    ; Send("单选题, 1.5分)")
    ; Send("(多选题, 2.0分)")
    Send("(判断题, 1.0分)")
    Sleep(100)
    Send("{enter}")

}

GetAcharactor_and_return_language_clipboard() ; 有点影响使用。放弃
{
    global Current_IME_State
	Send("+{Left}")
	
    ClipSaved := ClipboardAll()   ; Save the entire clipboard to a variable of your choice.
    A_Clipboard := ""  ; Start off empty to allow ClipWait to detect when the text has arrived.
    Send("^c")
    Errorlevel := !ClipWait()  ; Wait for the clipboard to contain text.
    
    
    c := A_Clipboard
    ; ... here make temporary use of the clipboard, such as for pasting Unicode text via Transform Unicode ...
    A_Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of Clipboard (not ClipboardAll).
    ClipSaved := ""   ; Free the memory in case the clipboard was very large.
    

    
    ascii := Ord(c)
    FoundPos := RegExMatch(c, "[a-zA-Z]")
    ToolTip(c " " ascii)
    
    
	;sleep, 150
	Send("{Right}")
	
	if (FoundPos =1  )   ; found! if it is Eng
	{
		;Tooltip, Found! Eng! %FoundPos%`n%c%
		return_val:= 1
	}
	else if ( ascii > 256) ; is Chn, not found
	{
		;Tooltip, Chn found %FoundPos%`n%c%`n%ascii%
		return_val:= 2
	}
	else
		return_val:= Current_IME_State
    ; if(c = "`n" or c = " "){
    ;     return Current_IME_State
    ; }

    return return_val

}
; 返回的是 1 0 ，是否被按下。 如果用 BlockInput 功能，那么必须加 “P” 表示物理按键，而不是逻辑按键。
key(a){
    return GetKeyState(a,"P")   
}


change_this_program_perfer(){
    name := WinGetProcessName("A")
    ; tooltip, %name% 
    ; 希望默认英文的环境 Code.exe ← VSCODE,      Obsidian.exe  OneCommander.exe
    if( name == "Code.exe" or  name == "Obsidian.exe" or  name == "OneCommander.exe")
    {
        en()
    }

    ; msedge.exe  WeChat.exe  ApplicationFrameHost.exe  onenote 和 系统设置的 ahk——exe 都是这个，区分不开
    else if( name == "msedge.exe" or  name == "ApplicationFrameHost.exe" or  name == "WeChat.exe" )
    {
        cn()
    }
    else {
        ;not change
    }

}

 

 ;交给 ditto 复制粘贴就行了。有更多的文本处理选择。
Text_only_paste(){  ; Text–only paste from ClipBoard. 
    Clip0 := ClipboardAll()
    A_Clipboard := A_Clipboard     
    Send("^v")              
    Sleep(50)                      ; Don't change clipboard while it is pasted! (Sleep > 0)
    A_Clipboard := Clip0           ; Restore original ClipBoard
    VarSetStrCapacity(&Clip0, 0)      ; Free memory ; V1toV2: if 'Clip0' is NOT a UTF-16 string, use 'Clip0 := Buffer(0)'
 Return
 }



RunWaitOne(command) {
    ; WshShell 对象: http://msdn.microsoft.com/en-us/library/aew9yb99
    shell := ComObject("WScript.Shell")
    ; 通过 cmd.exe 执行单条命令
    exec := shell.Exec(A_ComSpec " /C " command)
    ; 读取并返回命令的输出
    return exec.StdOut.ReadAll()
}
 
RunWaitMany(commands) {
    shell := ComObject("WScript.Shell")
    ; 打开 cmd.exe 禁用命令显示
    exec := shell.Exec(A_ComSpec " /Q /K echo off")
    ; 发送并执行命令,使用新行分隔
    exec.StdIn.WriteLine(commands "`nexit")  ; 保证执行完毕后退出!
    ; 读取并返回所有命令的输出
    return exec.StdOut.ReadAll()
}



search_with_edge( need_to_copy := 1){

    if ( need_to_copy == 1){
        Send("^{c}")
        Sleep(200)
    }
    ErrorLevel := "ERROR"
   Try ErrorLevel := Run("msedge.exe `"https://www.google.com/search?q=" A_Clipboard "`"", , "", )

}

url_go(string){  ; url_go("")
    {   ErrorLevel := "ERROR"
       Try ErrorLevel := Run("msedge.exe `"" string "`"", , "", )
    }
}

; 个人资料-南昌航空大学统一身份认证 (nchu.edu.cn)  ; url_go("http://passport.nchu.edu.cn/main.aspx?action=Srun_Login")
go_school_online()
{
    ; url_go(" http://login.network.nchu.edu.cn/srun_portal_pc?ac_id=1&theme=pro") ; 这个网址总是加载不出来！
    url_go("http://10.1.88.4/srun_portal_pc?ac_id=1&theme=pro")
    SS()
    SS("f")
    SS("e")
}

go_school_offline(){
    ; url_go(" http://login.network.nchu.edu.cn/srun_portal_pc?ac_id=1&theme=pro") ; 这个网址总是加载不出来！
    ; url_go("http://10.1.88.4/srun_portal_pc?ac_id=1&theme=pro")  ; 这两都行，下面这个是已经成功的，少一个跳转。
    url_go("http://10.1.88.4/srun_portal_success?ac_id=1&theme=pro")
    SS()
    SS("f")
    SS("a")
    SS("f")
    SS("s")


    ; http://login.network.nchu.edu.cn/srun_portal_pc?ac_id=1&theme=pro
    ; url_go("http://passport.nchu.edu.cn/logout.aspx")  ; 两套学校的认证网页.
}

;sleep and send key
SS( a:="" ){
    Sleep(1000)
    Send(a)

}



CapsLock & F8::recorder()
recorder(){
       ; Hotkey, Capslock, Off
    ; Input, keystrokes, V, {Capslock}
    ; ClipBoard := keystrokes
    ; SetCapsLockState, Off
    ; Hotkey, Capslock, On
    ; Return
    ih := InputHook( ,"`n")
    ih.Start()
    ih.Wait()
    ToolTip(ih.Input )


    ;     记录所有按键只需要加一个 keyopt。

    ; hook := InputHook()
    ; hook.KeyOpt("{All}", "NS")
    ; hook.OnKeyDown := Func("spam")
    ; hook.Start()
    ; spam(hook, vk, sc)
    ; {
    ;     loop 3
    ;         SendInput % "{sc" Format("{:03X}", sc) "}"
    ; }

}

return_last_combined_key()
{
    Array := StrSplit(A_ThisHotKey , " ", ">$~+^< &", 3)    ; a & b 会返回三个值，两个空格之间的符号也算上了，手动跳过。
    first_key := Array[1]
    latter_key := Array[Array.Length]
    if( Array.Length == 1)
        return first_key
    else
        return latter_key

}

; 等待并返回按键 ； but don't block the key.  KeyWaitAny("V")
KeyWaitAny(Options:="")
{
    ih := InputHook(Options)
    if !InStr(Options, "V")
        ih.VisibleNonText := false
    ih.KeyOpt("{All}", "E")  ; End
    ih.Start()
    ih.Wait()
    return ih.EndKey  ; Return the key name
}

Pause5Seconds(){
    Suspend(-1)
    Pause()
    Sleep(5000)
    Reload
    return
}


; ebebeb 灰色， zotero 页面直接的分割线，用于找到一页的开始。
; ffffff 白色，000000 黑色。
; find the bar, then decede the size, wheel up/down to the page beginning.
check_calc_space_and_skip_bar( direction := "↓↓" ){
   
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")
    if( direction == "↓↓" ){
        Send("{Space}")
    }
    else{
        Send("+{Space}")
    }
    Sleep(200)
    if (WinExist("A")){
        Title := WinGetTitle()
        Class := WinGetClass()
        Proc := WinGetProcessName()
        ; ToolTip(Title  "`n"   Title   "`n" Proc)
        if(   Proc == "zotero.exe" ){
            while (true){
                found := PixelSearch(  &outx,&outy, 25 ,164, 25,250,0xebebeb,1)
                if( found == 1){   ; 在 合适的地方找到了页面的开始。
                    ; ToolTip( " Found at x:=" outx "   y:= " outy "`n color = " PixelGetColor(outx,outy) , 999,outy)
                    break
                }
                else
                    flag := 0
                if( direction == "↓↓")
                    Send("{Up}")
                else
                    Send("{Down}")
                Sleep(50)
            }  
        }                                          
    }
}



; 去除 PDF 文字复制时候多余的回车。 粘贴到沙拉查词里面。
thesis_remove_enter_saladict(){
    Send("^{c}")
    Sleep(100)
    textRaw := A_Clipboard
    t2 := StrReplace(textRaw, "`n")
    t2 := StrReplace(t2, "`r")
    textWithout_enter := t2
    Sleep(100)
    Send("!{d}")  ; 查词软件快捷键
    Sleep(100)
    A_Clipboard:= textWithout_enter
    Send("^{v}")
    Send("{enter}")
}
F7 & 7::init_pixel_find()

;  根据  像素的位置 找到 第一次搜索是 eng,第二次是 cn

init_pixel_find(){
    global true_position:= [ 885,17,0xD9D8E5,887,16,0x76767A]  ;enXYColor_cnXYColor
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")
    
    startX := 870
    sY := 0
    endX:=900
    eY:=50
    flag := 1
    while (flag == 1){
    PixelSearch( &a, &b , startX,sY,endX,eY,0x000000,150)
    Sleep(400)
    Send("{Shift}")
    PixelSearch( &c, &d , startX,sY,endX,eY,0x000000,150)
        if(a != c){
            flag := 0
        }
        else{
            ; startX := a+1  
            sY := b+1
            if( startX >= endX or sY > eY){
                MsgBox("can't find!")
                break
            }
            continue
        }
    }
    if( a > c){ ;第一次搜索是 eng,第二次是 cn
        true_position[1]:= a
        true_position[2] := b
        true_position[3] := PixelGetColor(a, b,"Alt")  
        true_position[4]:= c
        true_position[5] := d
        true_position[6] := PixelGetColor(c, d,"Alt")  
    }
    else{ ;第一次搜索是 cn
        true_position[4]:= a
        true_position[5] := b
        true_position[6] := PixelGetColor(a, b,"Alt")  
        true_position[1] := c
        true_position[2] := d
        true_position[3] := PixelGetColor(c, d,"Alt")  
    }
    ToolTip(   return_IME_state_from_pixel())
}

return_IME_state_from_pixel(){
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")
    global Current_IME_State
    startX :=  870         ; 任务栏长度不固定，最好搜索范围大一些 870
    sY := 0
    endX:= 950      ;900
    eY:=42
    ImageSearch( &outa, &outb,startX,sY, endX,eY,"*5 *TransBlack C:\Users\Administrator\OneDrive\代码\AHK\eng1.png")
    ImageSearch( &c, &d,startX, sY, endX, eY,"*5 *TransBlack C:\Users\Administrator\OneDrive\代码\AHK\cn1.png")
    ; ToolTip( "outa" outa "   outb" outb "`n" c "cd"  d,,,4)
    ; if ( outa =="" or c == ""  ) {
    ;     MsgBox("没找到！")
    ; }
    if( outa !=""){
        Current_IME_State := 1
    }
    else if(c !=""){
        Current_IME_State := 2
    }
}

; 根据颜色找到 IME 状态。
return_IME_state_from_pixel_failed(){
    CoordMode("Mouse", "Screen")
    CoordMode("Pixel", "Screen")
    MouseGetPos(&MouseX, &MouseY)
    global Current_IME_State
    global true_position

    if( A_UserName == "Administrator"){  

    posi1x := 862  
    posi1y := 30
    cursorColor := PixelGetColor(MouseX, MouseY,"Alt")    ;学校的电脑
    

    ; group1 := [862,30,0xD9D8E5,0x6e6e75,0x6d6d74,0xdbdae8]  ;学校的电脑
    ; group2 := [898,26,0x76767A,0xEDEDF4,0x6d6d74,0xdbdae8]   ;还是学校的电脑，但是位置怎么变了？
    ; 日历控件的长度是不一样的，得写一个初始化函数，自动寻找位置。
    engX    :=true_position[1]
    engY    :=true_position[2]
    EngColor:=true_position[3]
    cnX     :=true_position[4]
    cnY     :=true_position[5]
    cnColor :=true_position[6]
    realColorEn := PixelGetColor(engX, engY,"Alt")  
    realColorCN := PixelGetColor(cnX, cnY,"Alt")  
    char := ""

    
        if( realColorEn == EngColor ){                          ; ime 图标在选中的时候会偏亮, 色彩不对,后两个才是平常状态的色彩
            Current_IME_State :=  1  ;eng
            char := "1"
        }
        else if( realColorCN == cnColor){
            Current_IME_State :=  2  ;chn
            char := "2"
        }
        else{
            ToolTip("没找到！")
        }
    }

    ; ----------------------dbug
    ToolTip( char "position is "   "`t" 
    " MouseX=" MouseX " MouseY="  MouseY " cursorColor :="  PixelGetColor(MouseX,MouseY,"Alt") "`n"
    A_UserName  "`n"  
    true_position[1] " " true_position[2] " " true_position[3] " " true_position[4] " " true_position[5] " " true_position[6] 
    "`n"   Current_IME_State
    ,862,30,7)


    return Current_IME_State
}

; 发送，切换，回车。  
change_to_en_and_put_stringSpace(){
    Send("{Enter}")
    en()
    Send("{Space}")
}

; 把之前的字退回，重新送给 IME。  
change_to_chn_and_retype(){
    Send("{Ctrl Up}{Shift down}{Shift Up}") ; 提前发一个 ctrl 抬起避免 ctrl+shift；  shift to flip IME_state 
    Sleep(50)
    Send("^+{Left}") ;  eng 向左，剪切，切换 chn，发送。Send（“Left”） ；  English向左，剪切，切换 chn
    ClipSaved := ClipboardAll()   ; Save the entire clipboard to a variable of your choice.    ToolTip(ClipSaved)
    A_Clipboard := "" ; Empty the clipboard
    Send("^{x}")
    ClipWait()  ; 等待剪切板有东西. 必须保留.

    stringRetype := Trim(A_Clipboard," ")
    ; Send(  )  ;    ;  手心输入法有问题，最后发送一定会丢失第二个字符串。需要单独发送每个字母这里有问题 ;  手心输入法有问题，最后发送一定会丢失第二个字符串。需要单独发送每个字母
    ; 自己实现延迟发送 clipboard 里面的数据 ↓
    loop parse stringRetype     ;  each character of the input string will be treated as a separate substring.
        {
            if( A_LoopField == "`n")
                break
            Send(A_LoopField)
            Sleep(50)  
        }

    A_Clipboard := ClipSaved   ; Restore the original clipboard. Note the use of A_Clipboard (not ClipboardAll).
    ClipSaved := ""   ; Free the memory in case the clipboard was very large.
}

 ; if(StrLen(A_Clipboard) >30)   return 0
; SetKeyDelay(150,150,)  ; 这种写法没用，感觉是在最后加了一个延迟 ，而不是每个字符之间加了一个延迟。
;
regretChangeIME_EtC(){ 
    ; ClipSaved  := ClipboardAll()
    Send("^+{Left}{sleep 550}^{x}")
    Sleep(500)
    retype_text := A_Clipboard       ; Convert to text
    retype_text := RTrim(retype_text , " ")

    cn()
    ; ToolTip("A_Clipboard = " A_Clipboard  )
    SendMode "Input"
    ;手心输入法有 bug , 怎么调都没用一定会丢失第二个字符,不如 自己实现一个 send 函数。
    ; SetKeyDelay(100)
    ; Send(retype_text)
    ; ; SetKeyDelay, 1000, 50   
    ; SetKeyDelay(0)

    Send_with_delay( retype_text )



    ; A_Clipboard := ClipSaved            ; Restore original ClipBoard
    ClipSaved := ""  ; Free the memory in case the clipboard was very large.

}
global VyVi := 0
global Iivi := 0

; ~k::
; ~d::
; {
;     global VyVi
;     VyVi := A_TickCount
;     checkforce(1)
; }
; ~f::
; ~j::
; {
;     global Iivi
;     Iivi := A_TickCount
;     checkforce(2)
; }
; checkforce( num:=1){
    
;     global VyVi 
;     global Iivi 
;     if( Abs(VyVi - Iivi) <135 ){
;         Send("{BackSpace 2}")
;         if(  VyVi < Iivi  )  ;fdjkkjfdfdfsfs放大df叫
;             cn()
;         if(  VyVi > Iivi  )
;             en()

;     }

; }


; ~^s::
; {
;     if( A_PriorHotkey == A_ThisHotKey )
;         Reload    ;;;; f 
; }

; 记录 stopsitting 小工具的时间，并显示在屏幕右上角
;  函数内过滤太近的输入
global Stop_Sitting_block_once := 0
global blockPomodoro:= 0
My_automatic_Pomodoro_Stop_Sitting_function_couting_up(){
    global blockPomodoro
    if(blockPomodoro == 1)
        return 
    global Stop_Sitting_counter
    global Stop_Sitting_Lastime_triggered
    global Stop_Sitting_block_once
    total_minius := 20       ; pomodoro 时长;
    time_gap := 15 * 1000  ; 最小检测时长,推荐 15s 到一分钟。如果间隔太短一次检测的话，工作的时间没有被记录上。 20Min 需要 35 Min 触发。
    dt := A_TickCount - Stop_Sitting_Lastime_triggered 
    jigger := A_TimeIdlePhysical
    if( dt > time_gap )
    {
        if( dt > 300000)
            Stop_Sitting_counter:=0    ; 太长的空闲，重置计数器。
        if( Stop_Sitting_block_once == 1){
            Stop_Sitting_block_once := 0
            return
        }
        Stop_Sitting_Lastime_triggered:= A_TickCount
        Stop_Sitting_counter += dt
        ; ToolTip("+" Stop_Sitting_Lastime_triggered "`n" Stop_Sitting_counter  , 200,,3)
        ElapsedTime := Stop_Sitting_counter
        sec := Floor(ElapsedTime/1000)
        minute := Floor(sec / 60)
        CoordMode("ToolTip" , "Screen")
        MouseGetPos(&xpos, &ypos, &id, &control)
        ; ToolTip(minute ":" sec,   A_ScreenWidth ,  0, 16)
        ToolTip(minute ":" sec,  A_ScreenWidth  , ypos, 16)
    }

    
    if( Stop_Sitting_counter > total_minius * 60 * 1000  ){
            
            result := MsgBox("Get Up！ `n Yes to End this work & take a walk  `n No to clear remind me short after",, "Y/N ")
            if(result == "Yes"){
                clear_and_wait_for_new_run_automatic_Pomodoro_Stop_Sitting_function_Reset()
                Send("#^{c}")
            }
            else if(result == "No"){
                Stop_Sitting_counter := Stop_Sitting_counter * 0.9
                Stop_Sitting_Lastime_triggered:=A_TickCount
            }
        }  
         
        
}


clear_and_wait_for_new_run_automatic_Pomodoro_Stop_Sitting_function_Reset(){
    global Stop_Sitting_counter
    global Stop_Sitting_Lastime_triggered
    Stop_Sitting_counter:= 0 
    Stop_Sitting_Lastime_triggered:=A_TickCount
    ToolTip( , 100,,2)
    SetTimer () =>  tooltip("rest enough for 5 min") , -30*10 *1000    ;  5 minus Good to Sit Back.
    SetTimer () =>  Send("#^{c}")                   , -30*10 *1000    
    SetTimer () =>  tooltip("rest enough for 10 min"), -60*10 *1000    ;  10 minus Good to Sit Back.
    SetTimer () =>  Pomodoro_Kill()                 , -60*10 *1000   
}


global cVE:=1  
; singal hand virgo like virtual desktop     currentVirtualEnvironment
VirgoRight(){
    global cVE
    cVE :=  Mod(cVE + 1,4)
    if( cVE = 0 )
        cVE := 4
    ToolTip(cVE)
    Send("!{" cVE "}")

}



virgoLeft(){
    global cVE
    cVE :=  Mod(cVE -1,4)

    if( cVE = 0 )
        cVE := 4
        ToolTip(cVE)
    Send("!{" cVE "}")
    
}


WinRotate(ver){
 
}







; 所以 1033 是英文的 windows 编号，这样能 用 2052 切换中文输入法！ 
; D:\Win\Download\im-select.exe  1033

; D:\Win\Download\im-select.exe  {im}

; D:\Win\Download\im-select.exe locale


; void switchInputMethod(int locale) {
; 	HWND hwnd = GetForegroundWindow();
; 	LPARAM currentLayout = ((LPARAM)locale);
; 	PostMessage(hwnd, WM_INPUTLANGCHANGEREQUEST, 0, currentLayout);
; }

; 我把这个方法摘出来，自己写一个！
; 官网 postmessage 的例子 居然就是这个。。。 
; 切换活动窗口的键盘布局/语言为英语(US).    →→→  PostMessage 0x0050, 0, 0x4090409,, "A"  ; 0x0050 is WM_INPUTLANGCHANGEREQUEST.


; 致谢 不再誤打，讓Windows快速切換到指定的輸入法 - TLLhttp://tll.tl › ...
; 
; 2017年1月24日 — 這兩行的功能是將::前的按鍵，右Alt或左Alt定義成後面的功能，也就是將現在的鍵盤配置切換為中文(0x4040404)或英文(0x4090409)。同理，你也可以設定成自己 ...
