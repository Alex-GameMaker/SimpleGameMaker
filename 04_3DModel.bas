'' ----------------------------------------------------------------------------
'' Example 04: 3D Models - Meshes and Nodes
'' ----------------------------------------------------------------------------
'' This example loads an .x (directX) model and adds it as a node to the scene
'' ----------------------------------------------------------------------------

#include "../Include/SGM.bi"
#include "../Include/SampleFunctions.bi"
'Variables
Dim as wMesh CharacterMesh		=0
Dim as wTexture MeshTexture		=0
Dim as wMesh FloorMesh			=0
Dim as wTexture FloorTexture	=0
Dim as wNode SceneNode			=0
Dim as wNode FloorNode			=0
Dim as wNode OurCamera			=0
Dim as wFont BitmapFont			=0
Dim vec as wVector3f			=wVECTOR3f_ZERO 
Dim vec2 as wVector3f			=wVECTOR3f_ZERO
Dim as wVector2i fromPos		=wVECTOR2i_ZERO
Dim as wVector2i toPos			=wVECTOR2i_ZERO

Dim as wMaterial mat			=0

Dim as Boolean isOutline		=false
Dim as wColor4s testColor		=wColor4s_BLACK

Dim as string wndCaption 		="Example 04: 3D Models - Meshes and Nodes "

Dim as Int32 prevFPS 			=0

'Start engine
Dim as Boolean init = wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false, false, true, false)
If Not init Then PrintWithColor ("wEngineStart() failed!") : End: End If

Dim as String fontPath="../../Assets/Fonts/3.png"
Dim as string cMeshPath="../../Assets/Models/Characters/Bioshock_dude/Bioshock dude.x"
''Dim as string cMeshPath="../../Assets/Models/Characters/test/robot.fbx"
Dim as string fMeshPath="../../Assets/Models/Sci-fi_floor2.obj"
Dim as string fTexPath="../../Assets/Textures/Floor_2.jpg"
Dim as string mTexPath= "../../Assets/Models/Characters/Bioshock_dude/bioshock dude.png"
''Dim as string mTexPath= "../../Assets/Models/Characters/test/robot_color.png"

'Check resources
CheckFilePath(fontPath)
CheckFilePath(cMeshPath)
CheckFilePath(fMeshPath)
CheckFilePath(fTexPath)
CheckFilePath(mTexPath)

'Show logo WS3D
'logo

'Load resources
BitmapFont = wFontLoad(fontPath)
If (BitmapFont=0) Then BitmapFont=wFontGetDefault()

CharacterMesh = wMeshLoad(cMeshPath)

MeshTexture = wTextureLoad(mTexPath)

FloorMesh = wMeshLoad(fMeshPath)

FloorTexture=wTextureLoad(fTexPath)

'Scene node
SceneNode = wNodeCreateFromMesh (CharacterMesh) ' create a node
vec.x = 0.1: vec.y = 0.1: vec.z = 0.1												  ' define the node scale 
wNodeSetScale (SceneNode, vec)											  ' set the node scale
wNodeSetAnimationSpeed (SceneNode, 10.0)					  ' set the node animation speed
mat = wNodeGetMaterial (SceneNode, 0)							  ' get the node material
wMaterialSetTexture (mat, 0, MeshTexture)						  ' set a texture as the node material
wMaterialSetFlag (mat, wMF_LIGHTING, False)					  ' set the node light flag

'Floor node
FloorNode = wNodeCreateFromMesh( FloorMesh )
vec.x=0 : vec.y=-0.2 : vec.z=0
wNodeSetPosition( FloorNode, vec)

For i as Int32=0 To wNodeGetMaterialsCount(FloorNode)-1
    mat=wNodeGetMaterial(FloorNode,i)
    wMaterialSetTexture(mat,0,FloorTexture)
    wMaterialSetType(mat,wMT_LIGHTMAP)
Next i

'Camera
vec.x=0 : vec.y=10 : vec.z=-10
vec2.x=0 : vec2.y=5 : vec2.z=0
OurCamera = wCameraCreate(vec,vec2)

'Ambient scene color
wSceneSetAmbientLight(wCOLOR4f_WHITE)

'Back scene color
Dim as wColor4s backColor=(255,15,25,15)

While wEngineRunning()
    
    wSceneBegin(backColor)
    
    wSceneDrawAll()

    'Draw text info
    fromPos.x=370 : fromPos.y=20
	toPos.x=500 : toPos.y=36
    wFontDraw ( BitmapFont, "3D model with animation", fromPos,toPos )
    
    fromPos.x=200 : fromPos.y=40 : toPos.x=700 : toPos.y=70
    wFontDraw ( BitmapFont, "SPACE: ON/OFF outline mode     1...0: Select color lines",fromPos,toPos)
    
    fromPos.x=290 : fromPos.y=500 : toPos.x=400: toPos.y=516
    wFontDraw ( BitmapFont, "Simple Game Maker supports the following formats:",fromPos,toPos)
    
    fromPos.x=125 : fromPos.y=520 : toPos.x=200 : toPos.y=536
    wFontDraw ( BitmapFont, "with bone-based (sceletal) or morph target animations - x, ms3d, b3d, and fbx (some versions)", fromPos,toPos )
    
    fromPos.x=125 : fromPos.y=540 : toPos.x=500 : toPos.y=556
    wFontDraw ( BitmapFont, "without bone-based or morph animations - fbx, 3ds, obj, lwo, dae, stl and other", fromPos,toPos )

    If (wInputIsKeyHit(wKC_SPACE)) Then  isOutline= Not isOutline
    
    If (isOutline) Then OutlineNode(SceneNode,4,testColor)

    If (wInputIsKeyHit(wKC_KEY_1)) Then testColor=wCOLOR4s_RED

    If (wInputIsKeyHit(wKC_KEY_2)) Then testColor=wCOLOR4s_GREEN

    If (wInputIsKeyHit(wKC_KEY_3)) Then testColor=wCOLOR4s_BLUE

    If (wInputIsKeyHit(wKC_KEY_4)) Then testColor=wCOLOR4s_WHITE

    If (wInputIsKeyHit(wKC_KEY_5)) Then testColor=wCOLOR4s_BLACK

    If (wInputIsKeyHit(wKC_KEY_6)) Then testColor=wCOLOR4s_YELLOW

    If (wInputIsKeyHit(wKC_KEY_7)) Then testColor=wCOLOR4s_MAGENTA

    If (wInputIsKeyHit(wKC_KEY_8)) Then testColor=wCOLOR4s_INDIGO

    If (wInputIsKeyHit(wKC_KEY_9)) Then testColor=wCOLOR4s_GOLD

    If (wInputIsKeyHit(wKC_KEY_0)) Then testColor=wCOLOR4s_SILVER

    wSceneEnd()
	wEngineSetFPS (60)
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




