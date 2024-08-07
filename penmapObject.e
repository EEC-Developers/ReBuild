OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'images/bevel',
        'string',
        'penmap','images/penmap',
        'gadgets/integer','integer',
        'gadgets/checkbox','checkbox',
        'images/label','label',
        'amigalib/boopsi',
        'exec/memory',
        'libraries/gadtools',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionObject','*reactionForm','*colourPicker','*sourceGen','*validator'

EXPORT ENUM PENMAPGAD_IDENT, PENMAPGAD_LABEL, PENMAPGAD_LEFTEDGE, PENMAPGAD_TOPEDGE,
            PENMAPGAD_WIDTH, PENMAPGAD_HEIGHT, PENMAPGAD_BGPEN, PENMAPGAD_TRANSPARENT, 
      PENMAPGAD_OK, PENMAPGAD_CHILD, PENMAPGAD_CANCEL

CONST NUM_PENMAP_GADS=PENMAPGAD_CANCEL+1

EXPORT DEF imageData:PTR TO CHAR

EXPORT OBJECT penMapObject OF reactionObject
  leftEdge:INT
  topEdge:INT
  width:INT
  height:INT
  bgPen:INT
  transparent:CHAR
PRIVATE
  bitmapData:PTR TO CHAR
ENDOBJECT

OBJECT penMapSettingsForm OF reactionForm
PRIVATE
  penMapObject:PTR TO penMapObject
  tempBgPen:INT
  labels1:PTR TO LONG
ENDOBJECT

PROC create() OF penMapSettingsForm
  DEF gads:PTR TO LONG
  
  NEW gads[NUM_PENMAP_GADS]
  self.gadgetList:=gads
  NEW gads[NUM_PENMAP_GADS]
  self.gadgetActions:=gads
  
  self.windowObj:=WindowObject,
    WA_TITLE, 'PenMap Attribute Setting',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, TRUE,
    WINDOW_POSITION, WPOS_CENTERSCREEN,
    WA_PUBSCREEN, 0,
    ->WA_CustomScreen, gScreen,
    ->WINDOW_AppPort, gApp_port,
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR 0,

    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,

      LAYOUT_ADDCHILD, self.gadgetList[ PENMAPGAD_IDENT ]:=StringObject,
        GA_ID, PENMAPGAD_IDENT,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, 'Identifier',
      LabelEnd,

      LAYOUT_ADDCHILD, self.gadgetList[ PENMAPGAD_LABEL ]:=StringObject,
        GA_ID, PENMAPGAD_LABEL,
        GA_RELVERIFY, TRUE,
        GA_TABCYCLE, TRUE,
        STRINGA_MAXCHARS, 80,
      StringEnd,
      CHILD_LABEL, LabelObject,
        LABEL_TEXT, '_Label',
      LabelEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ PENMAPGAD_LEFTEDGE ]:=IntegerObject,
          GA_ID, PENMAPGAD_LEFTEDGE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, '_LeftEdge',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ PENMAPGAD_TOPEDGE ]:=IntegerObject,
          GA_ID, PENMAPGAD_TOPEDGE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Top_Edge',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ PENMAPGAD_WIDTH ]:=IntegerObject,
          GA_ID, PENMAPGAD_WIDTH,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Width',
        LabelEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ PENMAPGAD_HEIGHT ]:=IntegerObject,
          GA_ID, PENMAPGAD_HEIGHT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          INTEGER_MAXCHARS, 4,
          INTEGER_MINIMUM, 0,
          INTEGER_MAXIMUM, 9999,
        IntegerEnd,
        CHILD_LABEL, LabelObject,
          LABEL_TEXT, 'Height',
        LabelEnd,
      LayoutEnd,

      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ PENMAPGAD_BGPEN ]:=ButtonObject,
          GA_ID, PENMAPGAD_BGPEN,
          GA_TEXT, '_Background Pen',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD, self.gadgetList[ PENMAPGAD_TRANSPARENT ]:=CheckBoxObject,
          GA_ID, PENMAPGAD_TRANSPARENT,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          GA_TEXT, 'Transparent',
          CHECKBOX_TEXTPLACE, PLACETEXT_LEFT,
        CheckBoxEnd,
      LayoutEnd,


      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

        LAYOUT_ADDCHILD,  self.gadgetList[ PENMAPGAD_OK ]:=ButtonObject,
          GA_ID, PENMAPGAD_OK,
          GA_TEXT, '_OK',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ PENMAPGAD_CHILD ]:=ButtonObject,
          GA_ID, PENMAPGAD_CHILD,
          GA_TEXT, 'C_hild',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,

        LAYOUT_ADDCHILD,  self.gadgetList[ PENMAPGAD_CANCEL ]:=ButtonObject,
          GA_ID, PENMAPGAD_CANCEL,
          GA_TEXT, '_Cancel',
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
        ButtonEnd,
      LayoutEnd,
    LayoutEnd,
  WindowEnd

  self.gadgetActions[PENMAPGAD_BGPEN]:={selectPen}
  self.gadgetActions[PENMAPGAD_CHILD]:={editChildSettings}
  self.gadgetActions[PENMAPGAD_CANCEL]:=MR_CANCEL
  self.gadgetActions[PENMAPGAD_OK]:=MR_OK
ENDPROC

PROC editChildSettings(nself,gadget,id,code) OF penMapSettingsForm
  self:=nself
  self.setBusy()
  self.penMapObject.editChildSettings()
  self.clearBusy()
ENDPROC

PROC end() OF penMapSettingsForm
  END self.gadgetList[NUM_PENMAP_GADS]
  END self.gadgetActions[NUM_PENMAP_GADS]
  DisposeObject(self.windowObj)
ENDPROC

PROC selectPen(nself,gadget,id,code) OF penMapSettingsForm
  DEF frmColourPicker:PTR TO colourPickerForm
  DEF selColour
  DEF colourProp:PTR TO INT

  self:=nself

  self.setBusy()
  SELECT id
    CASE PENMAPGAD_BGPEN
      colourProp:={self.tempBgPen}
  ENDSELECT

  NEW frmColourPicker.create()
  IF (selColour:=frmColourPicker.selectColour(colourProp[]))<>-1
    colourProp[]:=selColour
  ENDIF
  END frmColourPicker
  self.clearBusy()
ENDPROC

EXPORT PROC canClose(modalRes) OF penMapSettingsForm
  DEF res
  IF modalRes=MR_CANCEL THEN RETURN TRUE
  
  IF checkIdent(self,self.penMapObject,PENMAPGAD_IDENT)=FALSE
    RETURN FALSE
  ENDIF
ENDPROC TRUE

PROC editSettings(comp:PTR TO penMapObject) OF penMapSettingsForm
  DEF res

  self.penMapObject:=comp

  self.tempBgPen:=comp.bgPen
  SetGadgetAttrsA(self.gadgetList[ PENMAPGAD_IDENT ],0,0,[STRINGA_TEXTVAL,comp.ident,0])
  SetGadgetAttrsA(self.gadgetList[ PENMAPGAD_LABEL ],0,0,[STRINGA_TEXTVAL,comp.label,0])
  SetGadgetAttrsA(self.gadgetList[ PENMAPGAD_LEFTEDGE ],0,0,[INTEGER_NUMBER,comp.leftEdge,0])
  SetGadgetAttrsA(self.gadgetList[ PENMAPGAD_TOPEDGE ],0,0,[INTEGER_NUMBER,comp.topEdge,0])
  SetGadgetAttrsA(self.gadgetList[ PENMAPGAD_WIDTH ],0,0,[INTEGER_NUMBER,comp.width,0])
  SetGadgetAttrsA(self.gadgetList[ PENMAPGAD_HEIGHT ],0,0,[INTEGER_NUMBER,comp.height,0])
  SetGadgetAttrsA(self.gadgetList[ PENMAPGAD_TRANSPARENT  ],0,0,[CHECKBOX_CHECKED,comp.transparent,0]) 

  res:=self.showModal()
  IF res=MR_OK
    AstrCopy(comp.ident,Gets(self.gadgetList[ PENMAPGAD_IDENT ],STRINGA_TEXTVAL))
    AstrCopy(comp.label,Gets(self.gadgetList[ PENMAPGAD_LABEL ],STRINGA_TEXTVAL))
    comp.leftEdge:=Gets(self.gadgetList[ PENMAPGAD_LEFTEDGE ],INTEGER_NUMBER)
    comp.topEdge:=Gets(self.gadgetList[ PENMAPGAD_TOPEDGE ],INTEGER_NUMBER)
    comp.width:=Gets(self.gadgetList[ PENMAPGAD_WIDTH ],INTEGER_NUMBER)
    comp.height:=Gets(self.gadgetList[ PENMAPGAD_HEIGHT ],INTEGER_NUMBER)
    comp.bgPen:=self.tempBgPen
    comp.transparent:=Gets(self.gadgetList[ PENMAPGAD_TRANSPARENT ],CHECKBOX_CHECKED)
  ENDIF
ENDPROC res=MR_OK

EXPORT PROC createPreviewObject(scr) OF penMapObject
    self.previewObject:=NewObjectA(PenMap_GetClass(),NIL,[TAG_IGNORE,0,
        IA_LEFT, self.leftEdge,
        IA_TOP, self.topEdge,
        IA_WIDTH, self.width,
        IA_HEIGHT, self.height,
        IA_BGPEN, self.bgPen,
        PENMAP_TRANSPARENT, self.transparent,
        PENMAP_SCREEN, scr,
        PENMAP_RENDERDATA, self.bitmapData,
        PENMAP_PALETTE,[2,-1,-1,-1,0,0,0]:LONG,
        ->LABEL_DRAWINFO, self.drawInfo,
      TAG_DONE])
  IF self.previewObject=0 THEN self.previewObject:=self.createErrorObject(scr)

  self.makePreviewChildAttrs(0)
ENDPROC

EXPORT PROC create(parent) OF penMapObject
  DEF i,i4,j
  self.type:=TYPE_PENMAP
  SUPER self.create(parent)
  self.leftEdge:=0
  self.topEdge:=0
  self.width:=0
  self.height:=0
  self.bgPen:=0
  self.transparent:=TRUE
  self.bitmapData:=NewM(260,MEMF_CHIP OR MEMF_CLEAR)
  self.bitmapData[1]:=16
  self.bitmapData[3]:=16
  FOR i:=0 TO 15
    i4:=i<<4
    self.bitmapData[i4+4]:=1
    self.bitmapData[i4+15+4]:=1
    self.bitmapData[i+4]:=1
    self.bitmapData[15<<4+i+4]:=1
    FOR j:=0 TO 7
      self.bitmapData[i4+j+4+(IF i>7 THEN 8 ELSE 0)]:=1
    ENDFOR
  ENDFOR
  self.libsused:=[TYPE_PENMAP]
ENDPROC

PROC end() OF penMapObject
  Dispose(self.bitmapData)
  SUPER self.end()
ENDPROC

EXPORT PROC editSettings() OF penMapObject
  DEF editForm:PTR TO penMapSettingsForm
  DEF res
  
  NEW editForm.create()
  res:=editForm.editSettings(self)
  END editForm
ENDPROC res

#define makeProp(a,b) 'a',{self.a},b

EXPORT PROC serialiseData() OF penMapObject IS
[
  makeProp(leftEdge,FIELDTYPE_INT),
  makeProp(topEdge,FIELDTYPE_INT),
  makeProp(width,FIELDTYPE_INT),
  makeProp(height,FIELDTYPE_INT),
  makeProp(bgPen,FIELDTYPE_INT),
  makeProp(transparent,FIELDTYPE_CHAR)
]

EXPORT PROC genCodeProperties(srcGen:PTR TO srcGen) OF penMapObject

  srcGen.componentPropertyInt('IA_Left',self.leftEdge)
  srcGen.componentPropertyInt('IA_Top',self.topEdge)
  srcGen.componentPropertyInt('IA_Width',self.width)
  srcGen.componentPropertyInt('IA_Height',self.topEdge)
  srcGen.componentProperty('PENMAP_Screen','gScreen',FALSE)
  
  IF self.bgPen<>0 THEN srcGen.componentPropertyInt('IA_BGPen',self.bgPen)
  IF self.transparent=FALSE THEN srcGen.componentProperty('PENMAP_Transparent','FALSE',FALSE)
ENDPROC

EXPORT PROC genCodeChildProperties(srcGen:PTR TO srcGen) OF penMapObject
  srcGen.componentAddChildLabel(self.label)
  SUPER self.genCodeChildProperties(srcGen)
ENDPROC

EXPORT PROC getTypeName() OF penMapObject
  RETURN 'PenMap'
ENDPROC

EXPORT PROC getTypeEndName() OF penMapObject
  RETURN 'End'
ENDPROC

EXPORT PROC isImage() OF penMapObject IS TRUE

EXPORT PROC createPenMapObject(parent)
  DEF penmap:PTR TO penMapObject
  
  NEW penmap.create(parent)
ENDPROC penmap
