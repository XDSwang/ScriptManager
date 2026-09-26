#Requires AutoHotkey v2.0

; File_Exists - 检查文件是否存在；参数：path=文件路径。
File_Exists(fileExistsPath) {
    return FileExist(fileExistsPath)
}

; File_Read - 读取文本文件内容；参数：path=文件路径。
File_Read(fileReadPath) {
    return FileRead(fileReadPath)
}

; File_Write - 覆盖写入文本数据到文件；参数：path=文件路径，data=要写入的文本内容。
File_Write(fileWritePath, fileWriteData) {
    if FileExist(fileWritePath)
        FileDelete(fileWritePath)

    FileAppend(fileWriteData, fileWritePath)
    return true
}

; File_Delete - 删除指定文件，文件不存在时不执行删除；参数：path=文件路径。
File_Delete(fileDeletePath) {
    if FileExist(fileDeletePath)
        FileDelete(fileDeletePath)

    return true
}
