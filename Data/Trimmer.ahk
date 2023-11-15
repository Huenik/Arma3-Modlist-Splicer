/* 	This script removes the html header and footer from ARMA3 Mod List Outputs.
	This is done to prepare them to be combined.
	It 'trims' anything within the Mod Pack Splicer/CombineThese directory.
*/

; Set the working directory to the script directory
SetWorkingDir, %A_ScriptDir%

; Specify the folder containing HTML files
FolderToProcess := A_ScriptDir "\CombineThese"

; Check if the folder exists
if (FileExist(FolderToProcess "\*.*")) {
    ; Loop through all HTML files in the folder
	Loop, Files, %FolderToProcess%\*.html
	{
        ; Get the current file path
		FilePath := A_LoopFileLongPath
		
        ; Read the content of the selected file
		FileRead, FileContent, %FilePath%
		
        ; Split the content into an array of lines
		FileContentArray := StrSplit(FileContent, "`n")
		
        ; Check if there are at least 88 lines in the file
		if (FileContentArray.Length() >= 88) {
            ; Extract the content from the 88th line onwards
			NewContent := ""
			Loop, % FileContentArray.Length()
			{
				if (A_Index >= 88)
					NewContent .= FileContentArray[A_Index] "`n"
			}
			
            ; Remove the last 7 lines
			Loop, 7
			{
				NewContent := SubStr(NewContent, 1, InStr(NewContent, "`n", true, -1) - 1)
			}
			
            ; Save the modified content back to the file
			FileDelete, %FilePath%
			FileAppend, %NewContent%, %FilePath%
		} else {
			MsgBox, The file "%FilePath%" does not have at least 88 lines.
		}
	}
	
	MsgBox, All files processed successfully!
} else {
	MsgBox, The folder "%FolderToProcess%" does not exist. Exiting script.
}
