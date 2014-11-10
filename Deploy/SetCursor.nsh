; SetCursor.nsh
; By Afrow UK, portions by Razor and DOCa Cola

!ifndef SetCursor
!define SetCursor

; List of system cursors to be passed to SetSystemCursor.
!define OCR_NORMAL      32512
!define OCR_IBEAM       32513
!define OCR_WAIT        32514
!define OCR_CROSS       32515
!define OCR_UP          32516
!define OCR_SIZENWSE    32642
!define OCR_SIZENESW    32643
!define OCR_SIZEWE      32644
!define OCR_SIZENS      32645
!define OCR_SIZEALL     32646
!define OCR_NO          32648
!define OCR_HAND        32649
!define OCR_APPSTARTING 32650

; Other defines.
!define NULL            0
!define GCLP_HCURSOR    -12
!define LR_SHARED       0x8000
!define LR_LOADFROMFILE 0x10
!define IMAGE_CURSOR    2
!ifndef WM_SETCURSOR
!define WM_SETCURSOR    0x0020
!endif
; typedef struct tagPOINT { 
;   LONG x; 
;   LONG y; 
; } POINT, *PPOINT; 
!define stPOINT '(i, i) i'

!macro SetCursor

 System::Call `user32::SetClassLong(i $HWNDPARENT, i ${GCLP_HCURSOR}, i r0)`

 System::Call '*${stPOINT} .R0'
 System::Call `user32::GetCursorPos(i) i(R0) .r0`
 System::Call '*$R0${stPOINT} (.R1, .R2)'
 System::Call `user32::SetCursorPos(i $R1, i $R2)`
 System::Free $R0

!macroend

!macro SetSystemCursor Cursor

 System::Call `user32::LoadImage(i ${NULL}, i ${${Cursor}}, i ${IMAGE_CURSOR}, i 0, i 0, i ${LR_SHARED}) i.r0`
 !insertmacro SetCursor

!macroend
!define SetSystemCursor `!insertmacro SetSystemCursor`

!macro SetFileCursor File

 System::Call `user32::LoadImage(i ${NULL}, t "${File}", i ${IMAGE_CURSOR}, i 0, i 0, i ${LR_LOADFROMFILE}) i.r0`
 !insertmacro SetCursor

!macroend
!define SetFileCursor `!insertmacro SetFileCursor`

!endif