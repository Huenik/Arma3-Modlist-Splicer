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
	
	MsgBox, Prepared all files.
} else {
	MsgBox, The folder "%FolderToProcess%" does not exist. Exiting script.
}


; Check if the folder exists
if (FileExist(FolderToProcess "\*.*")) {
    ; Initialize a variable to store combined content
	CombinedContent := ""
	
    ; Read the content of the pre.txt file and add it to CombinedContent
	PreFilePath := A_ScriptDir "\Data\pre.txt"
	if (FileExist(PreFilePath)) {
		FileRead, PreContent, %PreFilePath%
		CombinedContent .= PreContent . "`n"
	} else {
		MsgBox, The file "%PreFilePath%" does not exist. Exiting script.
		ExitApp
	}
	
    ; Loop through all HTML files in the folder
	Loop, Files, %FolderToProcess%\*.html
	{
        ; Get the current file path
		FilePath := A_LoopFileLongPath

        ; Check if the current file is the one to exclude
        if (InStr(FilePath, "\put modlists here.ahk")) {
            continue  ; Skip the current iteration if the file is to be excluded
        }

        ; Read the content of the selected file
		FileRead, FileContent, %FilePath%
		
        ; Add the content to the combined variable
		CombinedContent .= FileContent . "`n"
	}
	
    ; Read the content of the post.txt file and add it to CombinedContent
	PostFilePath := A_ScriptDir "\Data\post.txt"
	if (FileExist(PostFilePath)) {
		FileRead, PostContent, %PostFilePath%
		CombinedContent .= PostContent . "`n"
	} else {
		MsgBox, The file "%PostFilePath%" does not exist. Exiting script.
		ExitApp
	}
	
    ; Specify the combined file path
	CombinedFilePath := A_ScriptDir "\output\CombinedOutput.html"
	
    ; Save the combined content to the new file
	FileDelete, %CombinedFilePath%
	FileAppend, %CombinedContent%, %CombinedFilePath%
	
	MsgBox, All files combined successfully! Output saved to "%CombinedFilePath%"
} else {
	MsgBox, The folder "%FolderToProcess%" does not exist. Exiting script.
}
