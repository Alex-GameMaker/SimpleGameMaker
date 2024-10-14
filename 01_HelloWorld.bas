'' ----------------------------------------------------------------------------
'' Example 01: Hello World
'----------------------------------------------------------------------------
'' This simple Example opens the 'Simple Game Maker' window, shows the text "Hello World"
'' on the screen and waits for the user to close the application.
'' ----------------------------------------------------------------------------

#Include "../Include/SGM.bi"
#include "../Include/SampleFunctions.bi"

'Variables
Dim as wFont MyFont				= 0

Dim as Int32 prevFPS 					= 0

Dim as wColor4s sceneColor	= (255, 125, 100, 255)
Dim as wVector2i fromPos		= (470, 80)
Dim as wVector2i toPos			= (500, 96)

Dim as String wndCaption 		= "Example 1: Hello World! "

'Start the engine
Dim as Boolean init = wEngineStart (wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, FALSE, TRUE, TRUE, FALSE)
If Not init Then PrintWithColor ("wEngineStart() failed!") : End: End If

Dim as string fontPath = "../../Assets/Fonts/Roboto_12.xml"

'Check resources
CheckFilePath (fontPath)

'Load resources
MyFont = wFontLoad (fontPath)

'Show engine's logo
'logo

While (wEngineRunning())
	
	wSceneBegin(sceneColor)
	
	'Draw text info
	wFontDraw(MyFont, "Hello World!", fromPos, toPos, wCOLOR4s_WHITE)
	
	wSceneEnd ()
	
	'Close the WS3D window with ESC key
	wEngineCloseEsc ()
	
	'Update fps
	If prevFPS <> wEngineGetFPS () Then
		prevFPS = wEngineGetFPS ()
		wWindowSetCaption (wndCaption + "(FPS = " + str (prevFPS) + ")")
	End If
Wend

'Stop engine
wEngineStop ()

End
