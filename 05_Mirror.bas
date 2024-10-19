'' ----------------------------------------------------------------------------
'' Example 5: The Mirror node
'' ----------------------------------------------------------------------------

#include "../Include/SGM.bi"
#include "../Include/SampleFunctions.bi"
'Variables
Dim as wFont MyFont				=0
Dim as wMesh CharacterMesh		=0
Dim as wTexture MeshTexture		=0
Dim as wMesh FloorMesh			=0
Dim as wTexture FloorTexture	=0
Dim as wNode SceneNode			=0
Dim as wNode FloorNode			=0
Dim as wNode OurCamera			=0
Dim as wNode SkyBox				=0

Dim as wTexture mirrorOverlay	=0
Dim as wNode mirror1			=0
Dim as wNode mirror2			=0
Dim as wVector2f mirrorScaleFactor=(0.5f, 0.5f)
Dim as wVector2f mirrorScaleFactor2=(0.5f, 0.5f)
Dim as Float32 v1				=0.5f
Dim as Float32 v2				=0.5f

Dim vec as wVector3f			=wVECTOR3f_ZERO 
Dim vec2 as wVector3f			=wVECTOR3f_ZERO

Dim as wVector2i fromPos		
Dim as wVector2i toPos			

Dim as wMaterial mat			=0

Dim as string wndCaption 		="Example 5: Mirror "

Dim as Int32 prevFPS 			=0

'Start engine
Dim as Boolean init = wEngineStart(wDRT_OPENGL, wDEFAULT_SCREENSIZE, 32, false, false, true, false)
If Not init Then PrintWithColor ("wEngineStart() failed!") : End: End If

Dim as string cMeshPath="../../Assets/Models/Characters/Bioshock_dude/Bioshock dude.x"
Dim as string fMeshPath="../../Assets/Models/Sci-fi_floor2.obj"
Dim as string fTexPath="../../Assets/Textures/Floor_2.jpg"
Dim as string mTexPath= "../../Assets/Models/Characters/Bioshock_dude/bioshock dude.png"
Dim as string sPath(5)
Dim as string fontPath="../../Assets/Fonts/Roboto_12.xml"

sPath(0)="../../Assets/SkyBoxes/Trivial/Skybox_up.jpg"
sPath(1)="../../Assets/SkyBoxes/Trivial/Skybox_dn.jpg"
sPath(2)="../../Assets/SkyBoxes/Trivial/Skybox_rt.jpg"
sPath(3)="../../Assets/SkyBoxes/Trivial/Skybox_lf.jpg"
sPath(4)="../../Assets/SkyBoxes/Trivial/Skybox_ft.jpg"
sPath(5)="../../Assets/SkyBoxes/Trivial/Skybox_bk.jpg"

Dim as string mirrorTexPath="../../Assets/Textures/mirrordirt2.png"

'Check resources
CheckFilePath(fontPath)

CheckFilePath(cMeshPath)
CheckFilePath(fMeshPath)
CheckFilePath(fTexPath)
CheckFilePath(mTexPath)
CheckFilePath(mirrorTexPath)

For i as Int32 =0 to 5
	CheckFilePath(sPath(i))
Next i

'Show logo WS3D
'logo

'Load resources
Dim as wTexture tex(5)
For i as Int32 =0 to 5
    tex(i)=wTextureLoad(sPath(i))
Next i
MyFont=wFontLoad(fontPath)

mirrorOverlay=wTextureLoad(mirrorTexPath)

'Create sky box
SkyBox=wSkyBoxCreate(tex(0),tex(1),tex(2),tex(3),tex(4),tex(5))

CharacterMesh = wMeshLoad(cMeshPath)

MeshTexture = wTextureLoad(mTexPath)

FloorMesh = wMeshLoad(fMeshPath)

FloorTexture=wTextureLoad(fTexPath)

'Scene node
SceneNode = wNodeCreateFromMesh( CharacterMesh )

vec.x=0.1 : vec.y=0.1 : vec.z=0.1
wNodeSetScale(SceneNode, vec)

vec.x=0 : vec.y=180 : vec.z=0
wNodeSetRotation(SceneNode,vec)

wNodeSetAnimationSpeed(SceneNode, 7.0 )

mat=wNodeGetMaterial(SceneNode,0)
wMaterialSetTexture(mat,0,MeshTexture)
wMaterialSetFlag(mat,wMF_LIGHTING,false)

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
OurCamera=wFpsCameraCreate(100,_
							0.1f,_
							@wKeyMapDefault(1),_
							8,_
							false,_
							0)

vec.x=0 : vec.y=13 : vec.z=-20		
wNodeSetPosition(OurCamera,vec)

'Ambient scene color
wSceneSetAmbientLight(wCOLOR4f_WHITE)

'Back scene color
Dim as wColor4s backColor=(255,15,25,15)

'Create mirrors
Dim as wVector2i reflectSize=(1024,1024)
mirror1=wMirrorCreate(OurCamera,reflectSize, mirrorOverlay)

vec.x=-10 : vec.y=12 : vec.z=13
wNodeSetPosition(mirror1,vec)

vec.x=0 : vec.y=-25 : vec.z=0
wNodeSetRotation(mirror1,vec)

vec.x=0.3f : vec.y=0.4f : vec.z=0 '/z- doesn't affect
wNodeSetScale(mirror1,vec)

mirror2=wMirrorCreate(OurCamera,reflectSize, mirrorOverlay)

vec.x=10 : vec.y=12 : vec.z=13
wNodeSetPosition(mirror2,vec)

vec.x=0 : vec.y=25 : vec.z=0
wNodeSetRotation(mirror2,vec)

vec.x=0.3f : vec.y=0.4f : vec.z=0 '/z- doesn't affect
wNodeSetScale(mirror2,vec)

while wEngineRunning()
    
    wSceneBegin(backColor)
    
    'Update mirrors
    wMirrorReflect(mirror1, backColor)
    wMirrorReflect(mirror2, backColor)

    wSceneDrawAll()
    
	'Draw text info
	fromPos.x = 400: toPos.x = 700: fromPos.y = 20: toPos.y = 40
	wFontDraw(MyFont, "F1 / F2 - Set mirrors scale factor", fromPos, toPos, wCOLOR4s_WHITE)
	fromPos.x = 400: toPos.x = 700: fromPos.y = 520: toPos.y = 540
	wFontDraw(MyFont, "Scale factor: ["+str(mirrorScaleFactor.x)+", "+str(mirrorScaleFactor2.y)+"]", fromPos, toPos, wCOLOR4s_WHITE)

    wSceneEnd()

    'Close with ESC
    wEngineCloseEsc()

    ' update FPS
      If prevFPS <> wEngineGetFPS() Then
        prevFPS = wEngineGetFPS()
        wWindowSetCaption(wndCaption+ "(FPS = "+str(prevFPS)+")")
     End If 
     
     If wInputIsKeyHit(wKC_F1) Then
		v1-=0.05f
		If v1<=0.05 Then v1=0.05
		v2+=0.05
		If (v2>0.95) Then v2=0.95
		mirrorScaleFactor.x=v1
		mirrorScaleFactor.y=v1
		wMirrorSetScaleFactor(mirror1, mirrorScaleFactor)
		mirrorScaleFactor2.x=v2
		mirrorScaleFactor2.y=v2
		wMirrorSetScaleFactor(mirror2, mirrorScaleFactor2)
     End If
      If wInputIsKeyHit(wKC_F2) Then
		v1+=0.05f
		If (v1>0.95) Then v1=0.95
		v2-=0.05
		If v2<=0.05 Then v2=0.05
		mirrorScaleFactor.x=v1
		mirrorScaleFactor.y=v1
		wMirrorSetScaleFactor(mirror1, mirrorScaleFactor)
		mirrorScaleFactor2.x=v2
		mirrorScaleFactor2.y=v2
		wMirrorSetScaleFactor(mirror2, mirrorScaleFactor2)
     End If
       
wend

'Stop engine
wEngineStop()

End
