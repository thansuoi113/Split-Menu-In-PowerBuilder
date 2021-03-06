$PBExportHeader$n_splitmenu.sru
forward
global type n_splitmenu from nonvisualobject
end type
end forward

global type n_splitmenu from nonvisualobject autoinstantiate
end type

type prototypes
Function UInt GetMenu ( UInt WindowHandle ) Library "USER32.DLL"
Function Integer ModifyMenu ( UInt MenuHandle, Int Position, UInt Flags, Int NewItemID, Ref String NewItem ) Library "USER32.DLL" Alias For "ModifyMenuA;Ansi"
Function Long GetMenuItemID ( UInt MenuHandle, Int Position ) Library "USER32.DLL"
//Function UInt GetSubMenu ( UInt MenuHandle, Int Position ) Library "USER32.DLL"
Subroutine DrawMenuBar ( UInt WindowHandle ) Library "USER32.DLL"
Function Integer InsertMenu ( UInt MenuHandle, Int Position, UInt Flags, Int NewItemID, Ref String NewItem ) Library "USER32.DLL" Alias For "InsertMenu;Ansi"
Function Integer GetMenuString ( UInt MenuHandle, UInt ItemID, 	Ref String MenuText, Int MaxLen, UInt Flag ) Library "USER32.DLL" Alias For "GetMenuStringA;Ansi"
function ulong GetSubMenu ( ulong menuhandle, int itempos ) Library "user32.dll"
end prototypes

type variables
window	iw_parent
uint		iui_menu_handle, iui_window_handle
menu im_menu
int ii_numitem
end variables

forward prototypes
public subroutine of_split (unsignedinteger aui_pop_handle, integer ai_numitem, integer ai_flags)
public subroutine of_splitmenu ()
public subroutine of_register (window aw_parent, menu am_menu, integer ai_numitem)
public subroutine of_register (window aw_parent, menu am_menu)
public function menu of_find_menuitem (menu am_parent, string as_itemtext, string as_key)
public subroutine of_splitmenu (menu am_menu, integer ai_numitem, long al_flag)
end prototypes

public subroutine of_split (unsignedinteger aui_pop_handle, integer ai_numitem, integer ai_flags);//Declare local variables
Integer	li_result, li_newitem, li_length = 144
String	ls_newitem = Space ( li_length )

//Get the menuid for the item we want to change
li_newitem = GetMenuItemID ( aui_pop_handle, ai_numitem )

//Get the test for that menu item
li_result = GetMenuString ( iui_menu_handle, li_newitem, ls_newitem, li_length, 0 )

//Modify the menu
li_result = ModifyMenu ( iui_menu_handle, li_newitem, ai_flags, li_newitem, ls_newitem )

//Redraw the menu
DrawMenuBar ( iui_window_handle )


end subroutine

public subroutine of_splitmenu ();of_splitmenu( im_menu, ii_numitem, 64)
end subroutine

public subroutine of_register (window aw_parent, menu am_menu, integer ai_numitem);iw_parent = aw_parent
im_menu = am_menu
ii_numitem = ai_numitem

//default 20 item
If ai_numitem <= 0 Then
	ii_numitem = 20
End If

//Get the handle of the window
iui_window_handle = Handle ( aw_parent )

//Get the handle of the menu
iui_menu_handle = GetMenu ( iui_window_handle )

end subroutine

public subroutine of_register (window aw_parent, menu am_menu);of_register(aw_parent, am_menu, 0 )
end subroutine

public function menu of_find_menuitem (menu am_parent, string as_itemtext, string as_key);menu lm_Null
Integer li_Item,li_row

li_Item = UpperBound(am_parent.Item)

For li_row = 1 To li_Item
	
	Choose Case Lower(Trim(as_key))
		Case "text"
			If Lower(am_parent.Item[li_row].Text) = Lower(as_itemtext) Then
				Return am_parent.Item[li_row]
				Exit
			End If
		Case "tag"
			If Lower(am_parent.Item[li_row].Tag) = Lower(as_itemtext) Then
				Return am_parent.Item[li_row]
				Exit
			End If
		Case "mic"
			If Lower(am_parent.Item[li_row].MicroHelp) = Lower(as_itemtext) Then
				Return am_parent.Item[li_row]
				Exit
			End If
	End Choose
	
	lm_Null = of_find_menuitem(am_parent.Item[li_row],as_itemtext, as_key)
	If IsValid(lm_Null) Then Exit
Next
Return lm_Null

end function

public subroutine of_splitmenu (menu am_menu, integer ai_numitem, long al_flag);String     ls_text, ls_code
Integer li_loop, li_count
Long ll_row
ULong lul_pop_handle, lul_handle


li_count = UpperBound(am_menu.Item[])
For li_loop = 1 To li_count
	
	If UpperBound(am_menu.Item[li_loop].Item[]) <= 0  Then Continue

	//hand parent menu
	lul_handle = Handle(am_menu.Item[1])
	//Get the handle for the popup menu
	lul_pop_handle = GetSubMenu ( lul_handle, li_loop -1 )
	of_split(lul_pop_handle,ai_numitem , al_flag)
	
	//sub menu
	of_splitmenu(am_menu.Item[li_loop], ai_numitem, al_flag)
Next


end subroutine

on n_splitmenu.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_splitmenu.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

