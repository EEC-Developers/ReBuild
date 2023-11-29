OPT MODULE, OSVERSION=37

  MODULE 'reaction/reaction_macros',
        'window','classes/window',
        'gadgets/layout','layout',
        'reaction/reaction_lib',
        'button','gadgets/button',
        'chooser','gadgets/chooser',
        'radiobutton','gadgets/radiobutton',
        'images/bevel',
        'libraries/gadtools',
        'label','images/label',
        'amigalib/boopsi',
        'intuition/intuition',
        'intuition/imageclass',
        'intuition/gadgetclass'

  MODULE '*reactionForm'

EXPORT ENUM CODEGEN_LABEL, CODEGEN_LANGSELECTOR,CODEGEN_USEIDS, CODEGEN_FULLCODE, CODEGEN_OK, CODEGEN_CANCEL

CONST NUMGADS=CODEGEN_CANCEL+1

EXPORT OBJECT codeGenForm OF reactionForm
PRIVATE
  rbuttons:PTR TO LONG
  rbuttons2:PTR TO LONG
  rbuttons3:PTR TO LONG
  selectedLanguage:LONG
ENDOBJECT

EXPORT PROC create() OF codeGenForm
  DEF gads:PTR TO LONG
  DEF i
  
  NEW gads[NUMGADS]
  self.gadgetList:=gads
  NEW gads[NUMGADS]
  self.gadgetActions:=gads

  self.rbuttons:=radioButtonsA(['E source','C source',0])
  self.rbuttons2:=radioButtonsA(['Use ids for GA_ID','Use array index for GA_ID',0])
  self.rbuttons3:=radioButtonsA(['Generate full code','Generate definitions only',0])

  self.windowObj:=WindowObject,
    WA_TITLE, 'Generate Code',
    WA_LEFT, 0,
    WA_TOP, 0,
    WA_HEIGHT, 80,
    WA_WIDTH, 150,
    WA_MINWIDTH, 150,
    WA_MAXWIDTH, 8192,
    WA_MINHEIGHT, 80,
    WA_MAXHEIGHT, 8192,
    WA_ACTIVATE, TRUE,
    WA_PUBSCREEN, 0,
    WINDOW_POSITION, WPOS_CENTERSCREEN,
    ->WA_CustomScreen, gScreen,
    ->WINDOW_AppPort, gApp_port,
    WA_CLOSEGADGET, TRUE,
    WA_DEPTHGADGET, TRUE,
    WA_SIZEGADGET, TRUE,
    WA_DRAGBAR, TRUE,
    WA_NOCAREREFRESH, TRUE,
    WA_IDCMP,IDCMP_GADGETDOWN OR  IDCMP_GADGETUP OR  IDCMP_CLOSEWINDOW OR 0,
    WINDOW_PARENTGROUP, VLayoutObject,
    LAYOUT_SPACEOUTER, TRUE,
    LAYOUT_DEFERLAYOUT, TRUE,
      LAYOUT_ADDCHILD, LayoutObject,
        LAYOUT_DEFERLAYOUT, FALSE,
        LAYOUT_SPACEOUTER, FALSE,
        LAYOUT_ORIENTATION, LAYOUT_ORIENT_VERT,

        LAYOUT_ADDIMAGE, self.gadgetList[CODEGEN_LABEL]:= LabelObject,
          ->LABEL_DRAWINFO, gDrinfo,
          GA_ID, CODEGEN_LABEL,
          LABEL_TEXT, 'Select code type:',
          LABEL_JUSTIFICATION, LJ_LEFT,
          IA_BGPEN, 0,
          IA_FGPEN, 1,
        LabelEnd,
        CHILD_WEIGHTMINIMUM, TRUE,
        CHILD_WEIGHTEDHEIGHT, 0,
          
        LAYOUT_ADDCHILD, self.gadgetList[CODEGEN_LANGSELECTOR]:=RadioButtonObject,
          GA_ID, CODEGEN_LANGSELECTOR,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          RADIOBUTTON_SPACING, 1,
          RADIOBUTTON_SELECTED, 0,
          RADIOBUTTON_LABELPLACE, PLACETEXT_LEFT,
          RADIOBUTTON_LABELS, self.rbuttons,
        RadioButtonEnd,

        LAYOUT_ADDIMAGE, LabelObject,
          ->LABEL_DRAWINFO, gDrinfo,
          LABEL_TEXT, 'Gadget ids:',
          LABEL_JUSTIFICATION, LJ_LEFT,
          IA_BGPEN, 0,
          IA_FGPEN, 1,
        LabelEnd,
        CHILD_WEIGHTMINIMUM, TRUE,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, self.gadgetList[CODEGEN_USEIDS]:=RadioButtonObject,
          GA_ID, CODEGEN_USEIDS,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          RADIOBUTTON_SPACING, 1,
          RADIOBUTTON_SELECTED, 0,
          GA_UNDERSCORE, '#',
          RADIOBUTTON_LABELPLACE, PLACETEXT_LEFT,
          RADIOBUTTON_LABELS, self.rbuttons2,
        RadioButtonEnd,

        LAYOUT_ADDIMAGE, LabelObject,
          ->LABEL_DRAWINFO, gDrinfo,
          LABEL_TEXT, 'Generate:',
          LABEL_JUSTIFICATION, LJ_LEFT,
          IA_BGPEN, 0,
          IA_FGPEN, 1,
        LabelEnd,
        CHILD_WEIGHTMINIMUM, TRUE,
        CHILD_WEIGHTEDHEIGHT, 0,

        LAYOUT_ADDCHILD, self.gadgetList[CODEGEN_FULLCODE]:=RadioButtonObject,
          GA_ID, CODEGEN_FULLCODE,
          GA_RELVERIFY, TRUE,
          GA_TABCYCLE, TRUE,
          RADIOBUTTON_SPACING, 1,
          RADIOBUTTON_SELECTED, 0,
          RADIOBUTTON_LABELPLACE, PLACETEXT_LEFT,
          RADIOBUTTON_LABELS, self.rbuttons3,
        RadioButtonEnd,

        LAYOUT_ADDCHILD, LayoutObject,
          LAYOUT_ORIENTATION, LAYOUT_ORIENT_HORIZ,

          LAYOUT_ADDCHILD,self.gadgetList[CODEGEN_OK]:=ButtonObject,
            GA_ID, CODEGEN_OK,
            GA_TEXT, '_OK',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
  
          LAYOUT_ADDCHILD,self.gadgetList[CODEGEN_CANCEL]:=ButtonObject,
            GA_ID, CODEGEN_CANCEL,
            GA_TEXT, '_Cancel',
            GA_RELVERIFY, TRUE,
            GA_TABCYCLE, TRUE,
          ButtonEnd,
        LayoutEnd,
        CHILD_WEIGHTEDHEIGHT, 0,
      LayoutEnd,
    LayoutEnd,
  WindowEnd
  self.gadgetActions[CODEGEN_OK]:=MR_OK
  self.gadgetActions[CODEGEN_CANCEL]:=MR_CANCEL
ENDPROC

PROC end() OF codeGenForm
  freeRadioButtons( self.rbuttons )
  freeRadioButtons( self.rbuttons2 )
  freeRadioButtons( self.rbuttons3 )
  END self.gadgetList[NUMGADS]
  END self.gadgetActions[NUMGADS]
ENDPROC

EXPORT PROC selectLang() OF codeGenForm
  DEF res1,res2,res3
  SetGadgetAttrsA(self.gadgetList[ CODEGEN_LANGSELECTOR ],0,0,[RADIOBUTTON_SELECTED,0,TAG_END])

  IF self.showModal()=MR_OK
    res1:=Gets(self.gadgetList[ CODEGEN_LANGSELECTOR ],RADIOBUTTON_SELECTED)
    res2:=IF Gets(self.gadgetList[ CODEGEN_USEIDS ],RADIOBUTTON_SELECTED)=0 THEN TRUE ELSE FALSE
    res3:=IF Gets(self.gadgetList[ CODEGEN_FULLCODE ],RADIOBUTTON_SELECTED)=0 THEN TRUE ELSE FALSE
    RETURN res1,res2,res3
  ENDIF
ENDPROC -1,0,0


