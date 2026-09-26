#Requires AutoHotkey v2.0

; File_FileControl_Exists - 检查文件是否存在；参数：path=文件路径。
File_FileControl_Exists(commonFileExistsPath) {
    return FileExist(commonFileExistsPath)
}

; File_FileControl_Read - 读取文本文件内容；参数：path=文件路径。
File_FileControl_Read(commonFileReadPath) {
    return FileRead(commonFileReadPath)
}

; File_FileControl_Write - 覆盖写入文本数据到文件；参数：path=文件路径，data=要写入的文本内容。
File_FileControl_Write(commonFileWritePath, commonFileWriteData) {
    if FileExist(commonFileWritePath)
        FileDelete(commonFileWritePath)

    FileAppend(commonFileWriteData, commonFileWritePath)
    return true
}

; File_FileControl_Delete - 删除指定文件，文件不存在时不执行删除；参数：path=文件路径。
File_FileControl_Delete(commonFileDeletePath) {
    if FileExist(commonFileDeletePath)
        FileDelete(commonFileDeletePath)

    return true
}
