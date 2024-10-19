'' ----------------------------------------------------------------------------
'' Example 02: 2D images (sprites)
'' ----------------------------------------------------------------------------
'' The Example loads several 2D images and uses them for rendering
'' graphics (in this example sprites) on the screen.
'' ----------------------------------------------------------------------------

#Include "../Include/SGM.bi"
#include "../Include/SampleFunctions.bi"

Dim As wTexture Planet			=0
Dim As wTexture Alien_face		=0
Dim As wTexture Crosshair		=0
Dim As wTexture Power_icon		=0
Dim As wTexture Teleport_icon	=0
Dim As wTexture Score_tex	=0
Dim As wTexture Hp_bar_panel	=0
Dim As wTexture hp_bar_out	=0
Dim As wTexture SGM_logo	=0

Dim As wGuiObject scroll_alpha	=0
Dim As wGuiObject scroll_red	=0
Dim As wGuiObject scroll_green	=0
Dim As wGuiObject scroll_blue	=0

Dim As wFont myFont				=0
Dim As wGuiEvent ptr GUIEvent	=0

Dim As wColor4s color1
Dim As wVector2i fromPos,toPos,tempVec

Dim rotation As Float32			=0
Dim scale_tex as wVector2f = wVECTOR2f_ONE
Dim timer_hp as integer = 0
Dim score as integer = 0

Dim As string wndCaption 		= "Example 02: 2D Images / Sprites "

Dim prevFPS As Int32 			=0

#define GUI_SCROLLBAR_ALPHA  	101
#define GUI_SCROLLBAR_RED    		102
#define GUI_SCROLLBAR_GREEN  	103
#define GUI_SCROLLBAR_BLUE   		104


'Start engine
Dim as Boolean init = wEngineStart (wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, FALSE, TRUE, TRUE, FALSE)
If Not init Then PrintWithColor ("wEngineStart() failed!") : End: End If

Dim as String texPath= "../../Assets/Sprites/planet_1.png"
Dim as String texPath2= "../../Assets/Sprites/citizen.png" 
Dim as String texPath3= "../../Assets/Sprites/crosshair.png" 
Dim as String texPath4= "../../Assets/Sprites/power.png" 
Dim as String texPath5= "../../Assets/Sprites/teleport.png"
Dim as String texPath6= "../../Assets/Sprites/score.png"
Dim as String texPath7= "../../Assets/Sprites/hp_bar_panel.png"
Dim as String texPath8= "../../Assets/Sprites/hp_bar_out.png" 
Dim as String texPath9= "../../Assets/Sprites/SGM_Logo_small.png" 

Dim as String fontPath= "../../Assets/Fonts/Roboto_12.xml"

'Check resources
CheckFilePath(texPath)
CheckFilePath(texPath2)
CheckFilePath(texPath3)
CheckFilePath(texPath4)
CheckFilePath(texPath5)
CheckFilePath(texPath6)
CheckFilePath(texPath7)
CheckFilePath(texPath8)
CheckFilePath(texPath9)

'Show logo WS3D
'logo

'Load resources
Planet = wTextureLoad(texPath)
Alien_face = wTextureLoad(texPath2)
Crosshair = wTextureLoad(texPath3)
Power_icon = wTextureLoad(texPath4)
Teleport_icon = wTextureLoad(texPath5)
Score_tex = wTextureLoad(texPath6)
Hp_bar_panel = wTextureLoad(texPath7)
Hp_bar_out = wTextureLoad(texPath8)
SGM_logo = wTextureLoad(texPath9)

myFont = wFontLoad(fontPath)
Dim As wGuiObject skin = wGuiGetSkin()
wGuiSkinSetFont(skin, myFont)

'Gui skin configure
color1.alpha = 255
color1.red = 100
color1.green = 0
color1.blue = 0
wGuiSkinSetColor(skin, wGDC_SCROLLBAR, color1)

color1.alpha = 255
color1.red = 100
color1.green = 100
wGuiSkinSetColor(skin, wGDC_BUTTON_TEXT, color1)

'Gui objects create
fromPos.x = 10: fromPos.y = 350: toPos.x = 50: toPos.y = 380
Dim As wGuiObject labelAlpha = wGuiLabelCreate("Alpha", fromPos, toPos)

fromPos.x = 50: fromPos.y = 350: toPos.x = 300: toPos.y = 365
scroll_alpha = wGuiScrollBarCreate(true, fromPos, toPos)
wGuiScrollBarSetMaxValue(scroll_alpha, 255)
wGuiScrollBarSetValue(scroll_alpha, 255)
wGuiObjectSetId(scroll_alpha, GUI_SCROLLBAR_ALPHA)

fromPos.x = 10: fromPos.y = 380: toPos.x = 50: toPos.y = 410
Dim As wGuiObject labelRed = wGuiLabelCreate("Red", fromPos, toPos)

fromPos.x = 50:fromPos.y = 380: toPos.x = 300: toPos.y = 395
scroll_red = wGuiScrollBarCreate(true, fromPos, toPos)
wGuiScrollBarSetMaxValue(scroll_red, 255)
wGuiScrollBarSetValue(scroll_red, 255)
wGuiObjectSetId(scroll_red, GUI_SCROLLBAR_RED)

fromPos.x = 10: fromPos.y = 410: toPos.x = 50: toPos.y = 440
Dim As wGuiObject labelGreen = wGuiLabelCreate("Green", fromPos, toPos)

fromPos.x = 50: fromPos.y = 410: toPos.x = 300: toPos.y = 425
scroll_green = wGuiScrollBarCreate(true, fromPos, toPos)
wGuiScrollBarSetMaxValue(scroll_green, 255)
wGuiScrollBarSetValue(scroll_green, 255)
wGuiObjectSetId(scroll_green, GUI_SCROLLBAR_GREEN)

fromPos.x = 10: fromPos.y = 440: toPos.x = 50: toPos.y = 470
Dim As wGuiObject labelBlue = wGuiLabelCreate("Blue", fromPos, toPos)

fromPos.x = 50: fromPos.y = 440: toPos.x = 300: toPos.y = 455
scroll_blue = wGuiScrollBarCreate(true, fromPos, toPos)
wGuiScrollBarSetMaxValue(scroll_blue, 255)
wGuiScrollBarSetValue(scroll_blue, 255)
wGuiObjectSetId(scroll_blue, GUI_SCROLLBAR_BLUE)

color1 = wCOLOR4s_WHITE

While wEngineRunning()
	wSceneBegin()
	'timer_hp = timer_hp + 1 : If timer_hp = 100 Then timer_hp = 0
	If (wInputIsKeyHit(wKC_LEFT)) Then
		If scale_tex.x > 0.01 Then scale_tex.x-=0.01
	End If	
	If (wInputIsKeyHit(wKC_RIGHT)) Then
		If scale_tex.x < 1.0 Then scale_tex.x+=0.01
	End If
	If (wInputIsMouseHit(wMB_LEFT)) Then score+=10

	'Draw images
	fromPos.x = 10: fromPos.y = 10
	wTextureDraw(Alien_face, fromPos, true, color1)

   rotation-=.1
   fromPos.x = 640: fromPos.y = 140
   toPos.x = 640 + 128/2: toPos.y = 140 + 128/2
   wTextureDrawAdvanced(Planet, fromPos, toPos, rotation, wVECTOR2f_ONE, true, color1)

   fromPos.x = 480: fromPos.y = 256
   wTextureDraw(Crosshair, fromPos, true, color1)
	
	Dim i as byte
	For i = 1 to 5 
		fromPos.x = 10 + (i*32): fromPos.y = 520
		wTextureDraw(Power_icon, fromPos, true, color1)
	Next i	

	Dim k as byte
	For k = 1 to 5 
		fromPos.x = 800 + (k*32): fromPos.y = 520
		wTextureDraw(Teleport_icon, fromPos, true, color1)
	Next k
	
	fromPos.x = 820: fromPos.y = 10
	wTextureDraw(Score_tex, fromPos, true, color1)
	fromPos.x = 900: fromPos.y = 30
	wFontDraw (myFont, str(score), fromPos, toPos, color1)
	
	fromPos.x = 400: fromPos.y = 500
	wTextureDraw(Hp_bar_panel, fromPos, true, color1)

	fromPos.x = 470 : fromPos.y = 520
	wTextureDrawEx (Hp_bar_out, fromPos, scale_tex, true) 

   fromPos.x = 350: fromPos.y = 20
   wTextureDraw(SGM_logo, fromPos, true, color1)

   'Draw all gui objects
   wGuiDrawAll()
	
   'Gui events
   If wGuiIsEventAvailable() Then
      GUIEvent = wGuiReadEvent()

      If (GUIEvent -> event = wGCT_SCROLL_BAR_CHANGED) Then
         Select Case(GUIEvent -> id)
         	case GUI_SCROLLBAR_ALPHA
                    color1.alpha = wGuiScrollBarGetValue(scroll_alpha)
         	case GUI_SCROLLBAR_BLUE
                    color1.blue = wGuiScrollBarGetValue(scroll_blue)
         	Case GUI_SCROLLBAR_GREEN
                    color1.green = wGuiScrollBarGetValue(scroll_green)
         	case GUI_SCROLLBAR_RED
                    color1.red = wGuiScrollBarGetValue(scroll_red)
         End Select
      End If

   End If
   	'Draw text info
	fromPos.x = 350: toPos.x = 700: fromPos.y = 430: toPos.y = 450
	wFontDraw(MyFont, "Left Mouse Button to gain points (score)", fromPos, toPos, wCOLOR4s_GRAY)	
	fromPos.x = 350: toPos.x = 700: fromPos.y = 460: toPos.y = 480
	wFontDraw(MyFont, "LEFT or RIGHT arrow keys to lose or restore health (hit points)", fromPos, toPos, wCOLOR4s_GRAY)

   wSceneEnd()
	
   'Close
   wEngineCloseEsc()

   'update FPS
    If prevFPS <> wEngineGetFPS() Then
      prevFPS = wEngineGetFPS()
      wWindowSetCaption(wndCaption + "(FPS = " + str(prevFPS) +")")
    End If

Wend

'Stop engine
wEngineStop()

End

