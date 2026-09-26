#Requires AutoHotkey v2.0

; Common_File_Exists - 检查文件是否存在；参数：path=文件路径。
Common_File_Exists(commonFileExistsPath) {
    return FileExist(commonFileExistsPath)
}

; Common_File_Read - 读取文本文件内容；参数：path=文件路径。
Common_File_Read(commonFileReadPath) {
    return FileRead(commonFileReadPath)
}

; Common_File_Write - 覆盖写入文本数据到文件；参数：path=文件路径，data=要写入的文本内容。
Common_File_Write(commonFileWritePath, commonFileWriteData) {
    if FileExist(commonFileWritePath)
        FileDelete(commonFileWritePath)

    FileAppend(commonFileWriteData, commonFileWritePath)
    return true
}

; Common_File_Delete - 删除指定文件，文件不存在时不执行删除；参数：path=文件路径。
Common_File_Delete(commonFileDeletePath) {
    if FileExist(commonFileDeletePath)
        FileDelete(commonFileDeletePath)

    return true
}
