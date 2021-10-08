; ===========================================================================================================================================================================

/*
	Password Generator (written in AutoHotkey)

	Author ....: jNizM
	Released ..: 2021-10-08
	Modified ..: 2021-10-08
	License ...: MIT
	GitHub ....: https://github.com/jNizM/password-generator
	Forum .....: https://www.autohotkey.com/boards/viewtopic.php?t=95321
*/


; SCRIPT DIRECTIVES =========================================================================================================================================================

#Requires AutoHotkey v2.0-


; GLOBALS ===================================================================================================================================================================

app          := Map("name", "Password Generator", "version", "0.1", "release", "2021-10-08", "author", "jNizM", "licence", "MIT")

PW_UPPER     := [65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90]
PW_LOWER     := [97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122]
PW_DIGITS    := [48, 49, 50, 51, 52, 53, 54, 55, 56, 57]
PW_MINUS     := [45]
PW_SPACE     := [32]
PW_SPECIAL   := [33, 34, 35, 36, 37, 38, 39, 42, 43, 44, 45, 46, 47, 58, 59, 61, 63, 64, 92, 94, 96, 124, 126]
PW_BRACKETS  := [40, 41, 60, 62, 91, 93, 123, 125]
PW_UNDERLINE := [95]
PW_LOOKALIKE := [48, 49, 73, 79, 108, 124]


; GUI =======================================================================================================================================================================

Main := Gui(, app["name"])
Main.MarginX := 10
Main.MarginY := 10
Main.SetFont("s10", "Segoe UI")

Main.AddGroupBox("xm ym w500 h268 Section", "Settings")

Main.AddText("xs+15 ys+25 w200 h25 0x200", "Length of generated password:")
MainEDT01 := Main.AddEdit("x+50 yp w100 0x2 0x2000 Limit4")
Main.AddUpDown("Range1-9999", 64)
MainCB01 := Main.AddCheckBox("xs+15 y+10 w200 h25 Checked", "Upper-Case ( A, B, C, ... )")
MainCB05 := Main.AddCheckBox("x+50 yp w200 h25", "Space (   )")
MainCB02 := Main.AddCheckBox("xs+15 y+10 w200 h25 Checked", "Lower-Case ( a, b, c, ... )")
MainCB06 := Main.AddCheckBox("x+50 yp w200 h25 Checked", "Special ( !, $, %, &, ... )")
MainCB03 := Main.AddCheckBox("xs+15 y+10 w200 h25 Checked", "Digits ( 0, 1, 2, ... )")
MainCB07 := Main.AddCheckBox("x+50 yp w200 h25 Checked", "Brackets ( [ ], { }, ( ), < > )")
MainCB04 := Main.AddCheckBox("xs+15 y+10 w200 h25", "Minus ( - )")
MainCB08 := Main.AddCheckBox("x+50 yp w200 h25", "Underline ( _ )")
Main.AddText("xs+15 y+10 w470 h25 0x200", "Also include the following characters:")
MainCB09 := Main.AddEdit("xs+15 y+0 w470")


Main.AddGroupBox("xm ym+278 w500 h128 Section", "Advanced")

MainCB10 := Main.AddCheckBox("xs+15 ys+25 w470 h25", "Exclude look-alike characters ( |I1l, O0 )")
Main.AddText("xs+15 y+10 w470 h25 0x200", "Exclude the following characters:")
MainCB11 := Main.AddEdit("xs+15 y+0 w470")


Main.AddGroupBox("xm ym+416 w500 h136 Section", "Preview")
MainEDT02 := Main.AddEdit("xs+15 ys+25 w470 r5 0x800")


MainBTN01 := Main.AddButton("xm+330 ym+562 w80 h25", "Generate").OnEvent("Click", Event_Generate)
MainBTN02 := Main.AddButton("xm+420 yp w80 h25", "Copy").OnEvent("Click", Event_Copy)

Main.Show()


; CONTROL EVENTS ============================================================================================================================================================

Event_Generate(*)
{
	PW_GENERATED := ""
	PW_SELECTED  := []


	if (MainCB01.Value) {
		loop PW_UPPER.Length
			PW_SELECTED.Push(PW_UPPER[A_Index])
	}

	if (MainCB02.Value) {
		loop PW_LOWER.Length
			PW_SELECTED.Push(PW_LOWER[A_Index])
	}

	if (MainCB03.Value) {
		loop PW_DIGITS.Length
			PW_SELECTED.Push(PW_DIGITS[A_Index])
	}

	if (MainCB04.Value) {
		loop PW_MINUS.Length
			PW_SELECTED.Push(PW_MINUS[A_Index])
	}

	if (MainCB05.Value) {
		loop PW_SPACE.Length
			PW_SELECTED.Push(PW_SPACE[A_Index])
	}

	if (MainCB06.Value) {
		loop PW_SPECIAL.Length
			PW_SELECTED.Push(PW_SPECIAL[A_Index])
	}

	if (MainCB07.Value) {
		loop PW_BRACKETS.Length
			PW_SELECTED.Push(PW_BRACKETS[A_Index])
	}

	if (MainCB08.Value) {
		loop PW_UNDERLINE.Length
			PW_SELECTED.Push(PW_UNDERLINE[A_Index])
	}

	if (MainCB09.Value) {
		loop parse MainCB09.Text
			PW_SELECTED.Push(Ord(A_LoopField))
	}

	if (MainCB10.Value) {
		for i, v in PW_LOOKALIKE
			for j, w in PW_SELECTED
				if (v = w)
					PW_SELECTED.RemoveAt(j)
	}

	if (MainCB11.Value) {
		loop parse MainCB11.Text
			for j, w in PW_SELECTED
				if (Ord(A_LoopField) = w)
					PW_SELECTED.RemoveAt(j)
	}


	if (PW_SELECTED.Length = 0) {
		Main.Opt("+OwnDialogs")
		MsgBox("Select at least one character set", app["name"], "48 T3")
		return
	}


	loop MainEDT01.Value
		PW_GENERATED .= Chr(PW_SELECTED[Floor(Random() * PW_SELECTED.Length) + 1])
	MainEDT02.Text := PW_GENERATED
}


Event_Copy(*)
{
	A_Clipboard := MainEDT02.Text
}


; ===========================================================================================================================================================================
