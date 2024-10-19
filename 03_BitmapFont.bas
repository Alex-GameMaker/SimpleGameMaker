'' ----------------------------------------------------------------------------
'' Example 03: Bitmap Fonts (.bmp)
'' ----------------------------------------------------------------------------
'' This example uses a bitmap based font to draw text to the screen.
'' You can also use .png format
'' ----------------------------------------------------------------------------

#Include "../Include/SGM.bi"
#include "../Include/SampleFunctions.bi"

'Variables
Dim as wFont BitmapFont			=0
Dim as wFont BitmapFont_2		=0
Dim as wFont BitmapFont_3		=0
Dim as wFont BitmapFont_4=0

Dim as wVector2i fromPos		=(120,0)
Dim as wVector2i toPos			=(250,0)

Dim as wColor4s textColor		=wCOLOR4s_WHITE

Dim as string wndCaption 		="Example 03: Bitmap Fonts "

Dim as Int32 prevFPS 			=0

'Start engine
Dim as Boolean init = wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false, false, true, false)
If Not init Then PrintWithColor ("wEngineStart() failed!") : End: End If

Dim as String fontPath="../../Assets/Fonts/thunder16.png"
Dim as String fontPath2="../../Assets/Fonts/myfont4.png"
Dim as String fontPath3= "../../Assets/Fonts/papyrus_bold.png" 
Dim as String fontPath4= "../../Assets/Fonts/Roboto_12.xml" 

'Check resources
CheckFilePath(fontPath)
CheckFilePath(fontPath2)
CheckFilePath(fontPath3)
CheckFilePath(fontPath4)

'Show logo WS3D
'logo

'Load resources
BitmapFont = wFontLoad (fontPath)
If (BitmapFont=0) Then BitmapFont=wFontGetDefault()

BitmapFont_2 = wFontLoad (fontPath2)
If (BitmapFont_2=0) Then BitmapFont_2=wFontGetDefault()

BitmapFont_3 = wFontLoad (fontPath3)
If (BitmapFont_3=0) Then BitmapFont_3=wFontGetDefault()

BitmapFont_4 = wFontLoad (fontPath4)
If (BitmapFont_4=0) Then BitmapFont_4=wFontGetDefault()

while wEngineRunning()
   
    wSceneBegin(wCOLOR4s_BLACK)
	
	'Draw text info
    fromPos.y=70: toPos.y=86
    textColor.red=255: textColor.green=20: textColor.blue=30
    wFontDraw ( BitmapFont, "I'll be back!", fromPos,toPos,textColor)


    fromPos.y=100: toPos.y=116
    textColor.red=0: textColor.green=255: textColor.blue=0
    wFontDraw ( BitmapFont_2, "Simple Game Maker", fromPos,toPos,textColor)

    fromPos.y=130: toPos.y=146
    textColor.red=0: textColor.green=150: textColor.blue=155
    wFontDraw ( BitmapFont_3, "Game Over", fromPos,toPos,textColor)

    fromPos.y=170: toPos.y=186
    textColor.red=0: textColor.green=255: textColor.blue=255
    wFontDraw ( BitmapFont_4, "I'm gonna make a game of my dream!", fromPos,toPos,textColor)

    wSceneEnd()
	
	'Close with ESC
    wEngineCloseEsc()

    ' update FPS
    If prevFPS <> wEngineGetFPS() Then
       prevFPS = wEngineGetFPS()
       wWindowSetCaption(wndCaption+ "(FPS = "+str(prevFPS)+")")
    End If
wend

'Stop engine
wEngineStop()

End









