#Requires AutoHotkey v2.0

;================================
; File_Exists
; 检查文件是否存在
;
; 参数:
; path 文件路径
;
; 返回:
; 存在返回路径信息，不存在返回空
;================================
File_Exists(path)
{
    return FileExist(path)
}


;================================
; File_Read
; 读取文本文件内容
;
; 参数:
; path 文件路径
;
; 返回:
; 文件内容
;================================
File_Read(path)
{
    return FileRead(path)
}


;================================
; File_Write
; 写入文本数据到文件
;
; 参数:
; path 文件路径
; data 写入内容
;
; 返回:
; true 写入完成
;================================
File_Write(path, data)
{
    FileAppend(data, path)

    return true
}


;================================
; File_Delete
; 删除指定文件
;
; 参数:
; path 文件路径
;
; 返回:
; true 删除完成
;================================
File_Delete(path)
{
    if FileExist(path)
        FileDelete(path)

    return true
}
