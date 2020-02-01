; author: valuex
; v1: 2020/2/1, take snapshot and use win title as source

; #NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#Include WinClipAPI.ahk
#Include WinClip.ahk
wc := new WinClip
; remove last picture
IniRead, LastClipImg, Config.ini, LastImg, ImgName
IfExist, %LastClipImg%
    FileDelete, %LastClipImg%
; get title:
WinGetActiveTitle, aTitle
; take snapshot
irfanview:="i_view64.exe"
ClipImgFile:= A_ScriptDir . "\" . A_Now . ".jpg"
SnapCMD:= irfanview .  " /capture=4 /convert=" . ClipImgFile
Runwait, %SnapCMD%
IfExist, %ClipImgFile%
{
    Goto, lblSetClipContent
    IniWrite, %ClipImgFile%, Config.ini, LastImg, ImgName
}
Else
    MsgBox, , Info, Snapshot cancelled, 2
Return
lblSetClipContent:
    StringReplace, ClipImgFile, ClipImgFile, \ , /,all
    ClipImgFile:="file:///" . ClipImgFile
    html=
    (
        <html><body>
        <img src="%ClipImgFile%">
        <p>Source:
        <a href="%aTitle%">link</a></p>
        </body></html>
    )
    if html
    {
    WinClip.Clear()
    WinClip.SetHTML( html )
    }
    Return

