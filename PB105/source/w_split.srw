$PBExportHeader$w_split.srw
forward
global type w_split from window
end type
type cb_1 from commandbutton within w_split
end type
end forward

global type w_split from window
integer width = 1659
integer height = 1052
boolean titlebar = true
string title = "Split Menu"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
end type
global w_split w_split

on w_split.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.cb_1=create cb_1
this.Control[]={this.cb_1}
end on

on w_split.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
end on

type cb_1 from commandbutton within w_split
integer x = 549
integer y = 320
integer width = 549
integer height = 128
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Split"
end type

event clicked;n_splitmenu ln_splitmenu

ln_splitmenu.of_register( Parent, MenuID, 5)
ln_splitmenu.of_splitmenu( )
end event

