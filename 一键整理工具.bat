@mode con cols=63 lines=233
@echo off
chcp 65001 >nul
setlocal ENABLEDELAYEDEXPANSION
title BiliBili安卓客户端视频一键整理工具V2.0
cd /D "%~dp0"
set xml2ass="%~dp0【Danmu2Ass】\Danmu2Ass.exe"
set /A danmu2assErrorLevel=1
set /A mp4boxErrorLevel=1
set mp4box="%~dp0【MP4Box】\MP4Box.exe"
set ffmpeg="%~dp0【ffmpeg】\bin\ffmpeg.exe"
set "maddir=%cd%"
call :UserSettings
call :check
call :check_error
echo >nul
if !UserSetting3! equ 1 ( call :Rule1 ) else ( call :Rule2 )
echo >nul
echo.
echo.
echo ==============================================================
echo.　　　　　　　　　　　！！Complete！！
echo.
echo 　　　　　　　　　　　　！！完成！！
echo.
echo 　　　　　　　　　！！所有视频已成功归档！！
echo.
echo =======================请按任意键退出=========================
echo.
endlocal
@pause >nul
exit


:delxml
	if !UserSetting1! equ 0 if !UserSetting8! equ 0 (
		for /R . %%i in (*.xml) do del /q "%%~fi"
		) else (
		for /R . %%i in (*danmaku.xml.bdl) do ren "%%~fi" danmaku.xml
		)
goto :eof

:Rule1
	title bilibili安卓客户端视频一键整理工具【规则1】
	call :check_error
	if !UserSetting4! equ 1 if not exist 弹幕池 md 弹幕池
	echo >nul
	if !UserSetting5! equ 1 if not exist 弹幕池 md 弹幕池
	echo >nul
	cd. >tmp.txt
	for /F "eol=弹" %%i in ('dir /A:D /B') do echo %%i >>tmp.txt
	for /F "eol=【" %%a in (tmp.txt) do (
		set av=%%a
		call :check_error
		set Rule3_jud=!av:~0,2!
		if "!Rule3_jud!"=="s_" (
				call :Rule3
			) else (
				echo ==============================================================
				echo 　　　　　　　　正在处理：【av!av!】
				echo ==============================================================
				cd %%a
				call :delxml
				call :counter
				call :Rule1_jud
			)
		)
	del /q tmp.txt
	call :check_error
	if exist *.xml call :Danmu2Ass
	if %UserSetting8% equ 0 del /q *.xml >nul 2>nul
	if %UserSetting4% equ 1 if %UserSetting8% equ 1 move "*.xml" ".\弹幕池" >nul 2>nul
	if %UserSetting6% equ 1 if %UserSetting4% equ 1 attrib .\弹幕池\*.xml +h >nul 2>nul
	if %UserSetting6% equ 1 if %UserSetting4% equ 0 attrib *.xml +h >nul 2>nul
	echo >nul
	if %UserSetting5% equ 1 if %danmu2assErrorLevel% equ 1 move "*.ass" ".\弹幕池" >nul 2>nul >nul 2>nul
	echo >nul
	if %UserSetting7% equ 1 if %UserSetting5% equ 1 if %danmu2assErrorLevel% equ 1 attrib .\弹幕池\*.ass +h >nul 2>nul
	echo >nul
	if %UserSetting7% equ 1 if %UserSetting5% equ 2 if %danmu2assErrorLevel% equ 1 attrib *.ass +h >nul 2>nul
	echo >nul
goto :eof

:Rule2
	title bilibili安卓客户端视频一键整理工具【规则2】
	call :check_error
	cd. >tmp.txt
	for /F "eol=弹" %%i in ('dir /A:D /B') do echo %%i >>tmp.txt
	for /F "eol=【" %%a in (tmp.txt) do (
		call :check_error
		set av=%%a
		call :check_error
		set Rule3_jud=!av:~0,2!
		if "!Rule3_jud!"=="s_" (
				call :Rule3
			) else (
				echo ==============================================================
				echo 　　　　　　　　正在处理：【av!av!】
				echo ==============================================================
				cd %%a
				call :delxml
				call :counter
				call :Rule2_jud
			)
		)
	del /q tmp.txt
goto :eof


:Rule3
	cd !av!
	call :delxml
	call :check_error
	for /D %%i in  (*) do (
		 cd %%i
		 goto :out
	)
	:out
	call :readtitle
		echo ==============================================================
		echo 　正在处理：【番剧：!name!】
		echo ==============================================================
	cd ..
	for /F %%i in ('dir /B /O') do (
		cd %%i
		call :check_error
		set fanju=%%i
		call :readindex
		call :read_index_title
		call :madcounter
		cd ..
		if !UserSetting9! equ 1 ( call :Rule3_movefiles1 ) else ( call :Rule3_movefiles2 )
		rd /s /q "%%i"
		if exist *.xml call :Danmu2Ass
		if %UserSetting8% equ 0 del /q *.xml >nul 2>nul
		if !UserSetting4! equ 1 if not exist 弹幕池 md 弹幕池
		echo >nul
		if !UserSetting5! equ 1 if not exist 弹幕池 md 弹幕池
		echo >nul
		if %UserSetting4% equ 1 if %UserSetting8% equ 1 move "*.xml" ".\弹幕池" >nul 2>nul
		if %UserSetting6% equ 1 if %UserSetting4% equ 1 attrib .\弹幕池\*.xml +h >nul 2>nul
		if %UserSetting6% equ 1 if %UserSetting4% equ 0 attrib *.xml +h >nul 2>nul
		echo >nul
		if %UserSetting5% equ 1 if %danmu2assErrorLevel% equ 1 move "*.ass" ".\弹幕池" >nul 2>nul >nul 2>nul
		echo >nul
		if %UserSetting7% equ 1 if %UserSetting5% equ 1 if %danmu2assErrorLevel% equ 1 attrib .\弹幕池\*.ass +h >nul 2>nul
		echo >nul
		if %UserSetting7% equ 1 if %UserSetting5% equ 2 if %danmu2assErrorLevel% equ 1 attrib *.ass +h >nul 2>nul
	)
	cd ..
	move "!av!" "【!name!】" >nul 2>nul
goto :eof

:Rule3_movefiles1
	call :check_error
	cmd /C for /R "%cd%\!fanju!" %%j in (*danmaku.xml,*.mp4,*.flv) do move "%%~fj" ".\!index!。!name!-第!index!集!indextitle!%%~xj" >nul 2>nul
	cmd /C for /R "%cd%\!fanju!" %%j in (*.blv) do move "%%~fj" ".\!index!。!name!-第!index!集!indextitle!.mp4" >nul 2>nul
goto :eof

:Rule3_movefiles2
	call :check_error
	cmd /C for /R "%cd%\!fanju!" %%j in (*danmaku.xml,*.mp4,*.flv) do move "%%~fj" ".\!name!-第!index!集!indextitle!%%~xj" >nul 2>nul
	cmd /C for /R "%cd%\!fanju!" %%j in (*.blv) do move "%%~fj" ".\!name!-第!index!集!indextitle!.mp4" >nul 2>nul
goto :eof

:UserSettings
	if not exist Settings.ini (
		:reset_Settings.ini
		set dedede=
		set lalala=
		echo.
		cd .>Settings.ini
		choice /C yn /M "是否启用Danmaku2ass组件【输入Y为Yes，N为No】"
			if !errorlevel! equ 2 ( @echo 是否启用Danmaku2ass组件【值为1为启用，0为禁用】：0 >Settings.ini ) else ( @echo 是否启用Danmaku2ass组件【值为1为启用，0为禁用】：1 >Settings.ini )
			if !errorlevel! equ 1 (
				echo.
				choice /C yn /M "是否归档ass文件？【输入Y为Yes，N为No】" 
					set dedede=是否归档ass文件？【值为1为启用，2为禁用】：!errorlevel! 
				echo.
				choice /C yn /M "是否隐藏ASS文件？【输入Y为Yes，N为No】"
					set lalala=是否隐藏ASS文件？【值为1为启用，2为禁用】：!errorlevel! 
				)
		echo.
		choice /C yn /M "是否启用FFmpeg组件【输入Y为Yes，N为No】"
			if !errorlevel! equ 2 ( @echo 是否启用FFmpeg组件【值为1为启用，0为禁用】：0 >>Settings.ini ) else ( @echo 是否启用FFmpeg组件【值为1为启用，0为禁用】：1 >>Settings.ini )
		echo.
		choice /C 12 /M "请选择规则【输入1或2】"
			if !errorlevel! equ 1 ( @echo 使用规则【值为1或2】：1 >>Settings.ini ) else ( @echo 使用规则【值为1或2】：2 >>Settings.ini )
		echo.
		
		choice /C yn /M "是否保留XML弹幕文件？【输入Y为Yes，N为No】"
			if !errorlevel! equ 1 (
					echo.
					choice /C yn /M "是否归档xml文件？【输入Y为Yes，N为No】"  
						if !errorlevel! equ 1 ( @echo 是否归档xml文件【值为1为启用，0为禁用】：1 >>Settings.ini ) else ( @echo 是否归档xml文件【值为1为启用，0为禁用】：0 >>Settings.ini )
					if "!dedede!"=="" set dedede=是否归档ass文件？【值为1为启用，2为禁用】：2
					echo !dedede! >>Settings.ini
					echo.
					choice /C yn /M "是否隐藏XML文件？【输入Y为Yes，N为No】"
						if !errorlevel! equ 1 ( @echo 是否隐藏XML文件？【值为1为启用，0为禁用】：1 >>Settings.ini ) else ( @echo 是否隐藏XML文件？【值为1为启用，0为禁用】：0 >>Settings.ini )
					set mamama=是否保留XML弹幕文件？【值为1为保留，0为删除】：1
				) else ( 
					@echo 是否归档xml文件【值为1为启用，0为禁用】：0 >>Settings.ini
					if "!dedede!"=="" set dedede=是否归档ass文件？【值为1为启用，2为禁用】：2
					echo !dedede! >>Settings.ini
					@echo 是否隐藏XML文件？【值为1为启用，0为禁用】：0 >>Settings.ini 
					set mamama=是否保留XML弹幕文件？【值为1为保留，0为删除】：0 
				)
		if "!lalala!"=="" ( set lalala=是否隐藏ASS文件？【值为1为启用，2为禁用】：2 )	
		echo !lalala! >>Settings.ini
		echo.
		echo !mamama! >>Settings.ini
		choice /C yn /M "对于番剧目录是否在文件名前添加序列？【Y为Yes，N为No】"
				if !errorlevel! equ 1 ( @echo 对于番剧目录是否在文件名前添加序列？【值为1为是，0为否】：1 >>Settings.ini ) else ( @echo 对于番剧目录是否在文件名前添加序列？【值为1为是，0为否】：0 >>Settings.ini )
		echo.
		
		choice /C yn /M "对于番剧是否添加集标题后缀？（如果有）【Y为Yes，N为No】"
				if !errorlevel! equ 1 ( @echo 对于番剧是否添加集标题后缀？（如果有）【值为1为是，0为否】：1 >>Settings.ini ) else ( @echo 对于番剧是否添加集标题后缀？（如果有）【值为1为是，0为否】：0 >>Settings.ini )
		echo.
		
		choice /C yn /M "是否隐藏配置文件？【输入Y为Yes，N为No】"
			if !errorlevel! equ 1 attrib Settings.ini +h
		echo.
		)
	set /A jjj=1
	set /A UserSetting1=0
	set /A UserSetting2=0
	set /A UserSetting3=0
	set /A UserSetting4=0
	echo >nul
	set /A UserSetting5=0
	echo >nul
	set /A UserSetting6=0
	set /A UserSetting7=0
	set /A UserSetting8=0
	set /A UserSetting9=0
	set /A UserSetting10=-1
	for /F "tokens=2 delims=：" %%i in (Settings.ini) do (
		set /A UserSetting!jjj!=%%i
		set /A jjj+=1
		)
	if !UserSetting10! equ -1 (
		echo ==============================================================
		echo 　　　　　　　　　　　！！ＥＲＲＯＲ！！
		echo.
		echo 　　　　　　配置文件不正确！请重新配置用户设置！！
		echo ==============================================================
		goto :reset_Settings.ini
		)
	if !UserSetting1! equ 0 set /A danmu2assErrorLevel=0
	if !UserSetting2! equ 0 set /A mp4boxErrorLevel=0
	call :check_error
goto :eof

:check
if !UserSetting1! equ 1 call :check1
if !UserSetting2! equ 1 call :check2
goto :eof


:check1
	if not exist %xml2ass% (
	set /A danmu2assErrorLevel=0
	echo.
	echo.
	echo ==============================================================
	echo 　　　　　　　　　　　　！！警告！！
	echo.
	echo 　　指定的Danmu2Ass.exe路径为无效路径！将无法转换xml弹幕文件！
	echo.
	echo 　　　　　　　　如要继续请按任意键，否则请右上X
	echo ==============================================================
	echo.
	pause >nul 
	) else (
		if not exist "%windir%\Microsoft.NET\Framework\v4.0*" (
		set /A danmu2assErrorLevel=0
		echo ==============================================================
		echo 　　　　　　！缺少Danmu2Ass.exe所需的运行库 ！
		echo.
		echo 　　　　　　您的系统未安装.NET Framework 4.0
		echo               Danmu2Ass.exe组件将无法运行！
		echo.
		echo 　 您可以选择退出，将.NET Framework 4.0下载安装后再重启程序
		echo.
		echo 　　　　也可以忽略继续执行，但是将无法转换xml弹幕文件！
		echo ==============================================================
		echo.
		choice /C yn /M "是否继续？"
		if !errorlevel! equ 2 exit
		)	
	)
goto :eof
rem +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:check2
	if not exist %ffmpeg% (
	set /A mp4boxErrorLevel=0
	echo.
	echo.
	echo ==============================================================
	echo 　　　　　　　　　　　　！！警告！！
	echo.
	echo 　　指定的FFmpeg.exe路径为无效路径！将无法合并分段视频！
	echo.
	echo 　　　　　　！！请确保待整理的视频中没有分段视频！！
	echo.
	echo.　　　　　！！！否则出于数据安全考虑将强制退出程序！！！
	echo.
	echo ================如要继续请按任意键，否则请右上X===============
	echo.
	pause >nul )
goto :eof

:check_error
	set "check_dir=%cd%"
	set "check_dir=!check_dir:%maddir%=9!"
	set "check_dir=!check_dir:~0,1!"
	if not "!check_dir!"=="9" call :PrintError
goto :eof

:PrintError
	echo.
	echo.
	echo ==============================================================
	echo 　　　　　　　　　　　　！！ERROR！！
	echo.
	echo 　　　　　　　　　　！！发生致命错误！！
	echo.
	echo 　　　　　　　　　！！请检查待整理的视频！！
	echo.
	echo =======================请按任意键退出=========================
	pause >nul
	exit
goto :eof

:Rule1_jud
	call :check_error
	if !num! equ 1 (
			call :Rule1_planA
		) else (
			call :Rule1_planB
		)
goto :eof

:Rule2_jud
	call :check_error
	if !num! equ 1 (
			call :Rule2_planA
		) else (
			call :Rule2_planB
		)
goto :eof

:Danmu2Ass
	call :check_error
	if %danmu2assErrorLevel% equ 1 (
		echo ==============================================================
		echo 　　　　　正在进行对xml弹幕文件转码。请稍后…………
		echo ==============================================================
		set xmlstr= & dir /A:-D /B /O:N /O:E | findstr .xml$ >xmltmp
		for /F "delims=" %%i in (xmltmp) do set xmlstr=!xmlstr! "%%i"
		call %xml2ass%!xmlstr! /S
		del /q xmltmp
	)
goto :eof


:Rule1_planA
	call :check_error
	cd !pnum!
	call :readtitle
	call :readsubtitle
	call :madcounter
	cd ..
	cd ..
	if "%pname%"=="_【P1】" set pname=
	cmd /C for /R "%~dp0!av!\!pnum!" %%i in (*danmaku.xml,*.mp4,*.flv) do move "%%~fi" ".\【!av!】_!name!!pname!%%~xi" >nul 2>nul
	cmd /C for /R "%~dp0!av!\!pnum!" %%i in (*.blv) do move "%%~fi" ".\【!av!】_!name!!pname!.mp4" >nul 2>nul
	rd /s /q !av!
goto :eof

:Rule1_planB
	call :check_error
	call :Rule2_planB
goto :eof


:Rule2_planA
	call :check_error
	cd !pnum!
	call :readtitle
	call :readsubtitle
	call :madcounter
	cd ..
	if "%pname%"=="_【P1】" set pname=
	cmd /C for /R !pnum! %%i in (*danmaku.xml,*.mp4,*.flv) do move "%%~fi" ".\【!av!】_!name!!pname!%%~xi" >nul 2>nul
	cmd /C for /R !pnum! %%i in (*.blv) do move "%%~fi" ".\【!av!】_!name!!pname!.mp4" >nul 2>nul
	if %UserSetting6% equ 1 attrib *.xml +h
	rd /s /q !pnum!
	call :Danmu2Ass
	if %UserSetting8% equ 0 del /q *.xml >nul 2>nul
	if %UserSetting7% equ 1 if %danmu2assErrorLevel% equ 1 attrib *.ass +h
	cd ..
	ren "%av%" "【%av%】_%name%"
goto :eof

:Rule2_planB
	call :check_error
	cd %pnum%
	call :readtitle
	cd ..
	for /F %%p in ('dir /A:D /O:N /B') do (
		call :check_error
		cd %%p
		set pnum=%%p
		call :madcounter
		call :readsubtitle
		cd ..
		call :move_files
		rd /s /q %%p
		)
	echo >nul
	if !UserSetting5! equ 1 if !UserSetting4! equ 0 md ASS弹幕池
	echo >nul
	if !UserSetting5! equ 2 if !UserSetting4! equ 1 md XML弹幕池
	echo >nul
	if !UserSetting5! equ 1 if !UserSetting4! equ 1 md 弹幕池
	echo >nul
	call :Danmu2Ass
	if %UserSetting8% equ 0 del /q *.xml >nul 2>nul
	echo >nul
	if !UserSetting5! equ 1 if %danmu2assErrorLevel% equ 1 if !UserSetting4! equ 0 ( move "*.ass" ASS弹幕池 >nul 2>nul & if %UserSetting7% equ 1 attrib .\ASS弹幕池\*.ass +h )
	echo >nul
	if !UserSetting5! equ 1 if !UserSetting4! equ 1 ( 
		move "*.ass" 弹幕池 >nul 2>nul 
		move "*.xml" 弹幕池 >nul 2>nul 
		if %UserSetting7% equ 1 attrib .\弹幕池\*.ass +h
		if %UserSetting6% equ 1 attrib .\弹幕池\*.xml +h
		)
	echo >nul
	if !UserSetting5! equ 2 if !UserSetting4! equ 1 ( move "*.xml" XML弹幕池 >nul 2>nul & if %UserSetting6% equ 1 attrib .\XML弹幕池\*.xml +h )
	echo >nul
	if %UserSetting6% equ 1 if !UserSetting4! equ 0 attrib *.xml +h
	echo >nul
	if %UserSetting7% equ 1 if !UserSetting5! equ 2 if %danmu2assErrorLevel% equ 1 attrib *.ass +h
	echo >nul
	cd ..
	ren "%av%" "【%av%】_%name%" >nul 2>nul
goto :eof

:move_files
	call :check_error
	cmd /c for /R !pnum! %%i in (*danmaku.xml,*.mp4,*.flv) do move "%%~fi" ".\【!av!】_!name!!pname!%%~xi" >nul 2>nul
	cmd /c for /R !pnum! %%i in (*.blv) do move "%%~fi" ".\【!av!】_!name!!pname!.mp4" >nul 2>nul
goto :eof

:counter
	set /A pnum=9999
	set /A num=0
	for /D %%i in (*) do (
		call :check_error
		set /A num+=1
		if %%i lss !pnum! set /A pnum=%%i 
		)
goto :eof

:readtitle
	call :check_error
	REM if not exist entry.json.ansi.txt call :md_UTF8_2_ANSI
	for /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26 delims=>|<!" %%a in (entry.json) do set "name=%%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p%%q%%r%%s%%d%%u%%v%%w%%x%%y%%z"
	set "name=!name:index_title=!"
	set "name=!name:*title=!"
	set "name=!name:"=!"
	set "name=!name:?=？!"
	set "name=!name:\=!"
	set "name=!name:/=!"
	set "name=!name::=：!"
	set "name=!name:~1!"
	for /f "tokens=1 delims=," %%a in ("!name!") do set "name=%%a"
	for /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26 delims=*" %%a in ("%name%") do set "name=%%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p%%q%%r%%s%%d%%u%%v%%w%%x%%y%%z"
goto :eof

:readsubtitle
	call :check_error
	REM if not exist entry.json.ansi.txt call :md_UTF8_2_ANSI
	for /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26 delims=>|<!" %%a in (entry.json) do set "pname=%%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p%%q%%r%%s%%d%%u%%v%%w%%x%%y%%z"
	set "pname=!pname:*part=!"
	set "pname=!pname:"=!"
	set "pname=!pname:?=？!"
	set "pname=!pname:\=!"
	set "pname=!pname:/=!"
	set "pname=!pname::=：!"
	set "pname=!pname:~1!"
	for /f "tokens=1 delims=," %%a in ("!pname!") do set "pname=%%a"
	for /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26 delims=*" %%a in ("%pname%") do set "pname=%%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p%%q%%r%%s%%d%%u%%v%%w%%x%%y%%z"
	if "!pname!"=="P!pnum!" (
			set "pname=_【!pname!】"
		) else (
			if "!pname!"=="!name!" ( set "pname=" ) else ( set "pname=_【P!pnum!】【!pname!】" ) 
		)
goto :eof

:readindex
	call :check_error
	REM if not exist entry.json.ansi.txt call :md_UTF8_2_ANSI
	for /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26 delims=>|<!" %%a in (entry.json) do set "index=%%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p%%q%%r%%s%%d%%u%%v%%w%%x%%y%%z"
	set "index=!index:index_title=!"
	set "index=!index:*index=!"
	set "index=!index:"=!"
	set "index=!index:?=？!"
	set "index=!index:\=!"
	set "index=!index:/=!"
	set "index=!index::=：!"
	set "index=!index:~1!"
	for /f "tokens=1 delims=," %%a in ("!index!") do set "index=%%a"
	for /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26 delims=*" %%a in ("%index%") do set "index=%%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p%%q%%r%%s%%d%%u%%v%%w%%x%%y%%z"
goto :eof

:read_index_title
	if %UserSetting10% equ 0 (
		set "indextitle="
		goto :eof
		)
	for /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26 delims=>|<!" %%a in (entry.json) do set "indextitle=%%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p%%q%%r%%s%%d%%u%%v%%w%%x%%y%%z"
	set "indextitle=!indextitle:*index_title=!"
	set "indextitle=!indextitle:"=!"
	set "indextitle=!indextitle:?=？!"
	set "indextitle=!indextitle:\=!"
	set "indextitle=!indextitle:/=!"
	set "indextitle=!indextitle::=：!"
	set "indextitle=!indextitle:}=!"
	set "indextitle=!indextitle:~1!"
	for /f "tokens=1 delims=," %%a in ("!indextitle!") do set "indextitle=%%a"
	for /F "tokens=1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26 delims=*" %%a in ("%indextitle%") do set "indextitle=%%a%%b%%c%%d%%e%%f%%g%%h%%i%%j%%k%%l%%m%%n%%o%%p%%q%%r%%s%%d%%u%%v%%w%%x%%y%%z"
	if "!indextitle!"=="!index!" set "indextitle=Null"
	if "!indextitle!"=="page：0" set "indextitle=Null"
	if "!indextitle!"=="0!index!" set "indextitle=Null"
	if "!indextitle!"=="00!index!" set "indextitle=Null"
	if "!indextitle!"=="Null" (
		set "indextitle="
		) else (
		set "indextitle=-!indextitle!"
		)
goto :eof

:madcounter
	call :check_error
	set /A I=0
	for /R %%k in (*.mp4,*.flv,*.blv) do (
		set /A I+=1
		set madpath="%%~dpk"
		)
	if %I% geq 2 call :merge
goto :eof

:merge
	call :check_error
	if %mp4boxErrorLevel% equ 0 (
		echo ==============================================================
		echo.
		echo 　　　　　　　　　！！！！警告！！！！
		echo.
		echo      发现分段视频！由于无法找到FFmpeg.exe将无法完成合并！！ 
		if "!Rule3_jud!"=="s_" (
			echo 　　　　当前位置:【!name!】_第!index!集
			) else (
			echo 　　　　　　　当前位置:【av!av!】_【P!pnum!】
			)	
		echo.
		echo              出于数据安全考虑，程序将终止运行
		echo.
		echo =====================请按任意键退出===========================
		@pause >nul
		del /q "%~dp0tmp.txt"
		exit
		)
	echo.
	echo ==============================================================
	echo.
	echo 　　　！！！！！！发现分段视频，正在进行合并！！！！！！
	echo.
	if "!Rule3_jud!"=="s_" (
		echo 　　　　当前位置:【!name!】_第!index!集
		) else (
		echo 　　　　　　　当前位置:【av!av!】_【P!pnum!】
		)
	echo.
	echo ==============================================================
	cd /D %madpath%
	if exist *.mp4 (
			rem dir /A:-D /B /O:E /O:N | findstr .mp4$ >tmp.txt
			dir /A:-D /B /O:E /O:N | findstr "^[0-9]\.mp4$" >tmp.txt
			dir /A:-D /B /O:E /O:N | findstr "^[0-9][0-9]\.mp4$" >>tmp.txt
			dir /A:-D /B /O:E /O:N | findstr "^[0-9][0-9][0-9]\.mp4$" >>tmp.txt
		) else (
			if exist *.flv (
				REM dir /A:-D /B /O:E /O:N | findstr .flv$ >tmp.txt
				dir /A:-D /B /O:E /O:N | findstr "^[0-9]\.flv$" >tmp.txt
				dir /A:-D /B /O:E /O:N | findstr "^[0-9][0-9]\.flv$" >>tmp.txt
				dir /A:-D /B /O:E /O:N | findstr "^[0-9][0-9][0-9]\.flv$" >>tmp.txt
				) else (
				REM dir /A:-D /B /O:E /O:N | findstr .blv$ >tmp.txt
				dir /A:-D /B /O:E /O:N | findstr "^[0-9]\.blv$" >tmp.txt
				dir /A:-D /B /O:E /O:N | findstr "^[0-9][0-9]\.blv$" >>tmp.txt
				dir /A:-D /B /O:E /O:N | findstr "^[0-9][0-9][0-9]\.blv$" >>tmp.txt
				)
		)
	set str=
	del /q merge.ini >nul
	for /F "delims=" %%i in (tmp.txt) do echo file %%i>>merge.ini
	REM call %mp4box% !str! -new "merge.mp4"
	call %ffmpeg% -f concat -i merge.ini -c copy merge.mp4
	set /A existmerge=0
	for /R . %%i in (*merge.mp4) do set /A existmerge=1
	if !existmerge! equ 0 (
		echo ==============================================================
		echo.
		echo 　　　　　　　　　！！！！Error！！！！
		echo.
		echo  　　　　　 ！！！！FFmpeg.exe未正常运作！！！！
		echo.
		if "!Rule3_jud!"=="s_" (		
			echo 　　　　当前位置:【!name!】_第!index!集
			) else (
			echo 　　　　　　　当前位置:【av!av!】_【P!pnum!】
			)		
		echo.
		echo              出于数据安全考虑，程序将终止运行
		echo.
		echo =====================请按任意键退出===========================
		del /q "%~dp0tmp.txt"
		@pause >nul
		exit
		)
	del /q *.flv >nul 2>nul
	cd ..
	for /R . %%i in (*merge.mp4) do move "%%~fi" . >nul 2>nul
	dir /A:D /B >tmp.ini
	set /P bapi=<tmp.ini
	rd /s /q !bapi!
	echo.
	echo ==============================================================
	if "!Rule3_jud!"=="s_" (
		echo 　　！！【!name!】_第!index!集合并完成！！
		) else (
		echo 　　　　　　 ！！【av!av!】_【P!pnum!】合并完成！！
		)
	echo ==============================================================
goto :eof

:md_UTF8_2_ANSI
	call :check_error
	echo set fso = CreateObject("Scripting.FileSystemObject") >UTF8_2_ANSI.vbs
	echo FileList = "" >>UTF8_2_ANSI.vbs
	echo for each oFile in fso.GetFolder(".").Files >>UTF8_2_ANSI.vbs
	echo     if LCase(fso.GetExtensionName(oFile.Path)) = LCase("json") then >>UTF8_2_ANSI.vbs
	echo         FileList = FileList ^& oFile.Path ^& vbCrLf >>UTF8_2_ANSI.vbs
	echo     end if >>UTF8_2_ANSI.vbs
	echo next >>UTF8_2_ANSI.vbs
	echo Files = Split(FileList, vbCrLf) >>UTF8_2_ANSI.vbs
	echo for i=0 to UBound(Files)-1 >>UTF8_2_ANSI.vbs
	echo     U8ToAnsi Files(i) >>UTF8_2_ANSI.vbs
	echo next >>UTF8_2_ANSI.vbs
	echo function U8ToU8Bom(strFile) >>UTF8_2_ANSI.vbs
	echo     dim ADOStrm >>UTF8_2_ANSI.vbs
	echo     Set ADOStrm = CreateObject("ADODB.Stream") >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Type = 2 >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Mode = 3 >>UTF8_2_ANSI.vbs
	echo     ADOStrm.CharSet = "utf-8" >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Open >>UTF8_2_ANSI.vbs
	echo     ADOStrm.LoadFromFile strFile >>UTF8_2_ANSI.vbs
	echo     ADOStrm.SaveToFile strFile ^& ".u8.txt", 2 >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Close >>UTF8_2_ANSI.vbs
	echo     Set ADOStrm = Nothing >>UTF8_2_ANSI.vbs
	echo end function >>UTF8_2_ANSI.vbs
	echo function U8ToAnsi(strFile) >>UTF8_2_ANSI.vbs
	echo     dim ADOStrm >>UTF8_2_ANSI.vbs
	echo     dim s >>UTF8_2_ANSI.vbs
	echo     Set ADOStrm = CreateObject("ADODB.Stream") >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Type = 2 >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Mode = 3 >>UTF8_2_ANSI.vbs
	echo     ADOStrm.CharSet = "utf-8" >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Open >>UTF8_2_ANSI.vbs
	echo     ADOStrm.LoadFromFile strFile >>UTF8_2_ANSI.vbs
	echo     s = ADOStrm.ReadText >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Position = 0 >>UTF8_2_ANSI.vbs
	echo     ADOStrm.CharSet = "gbk" >>UTF8_2_ANSI.vbs
	echo     ADOStrm.WriteText s >>UTF8_2_ANSI.vbs
	echo     ADOStrm.SetEOS >>UTF8_2_ANSI.vbs
	echo     ADOStrm.SaveToFile strFile ^& ".ansi.txt", 2 >>UTF8_2_ANSI.vbs
	echo     ADOStrm.Close >>UTF8_2_ANSI.vbs
	echo     Set ADOStrm = Nothing >>UTF8_2_ANSI.vbs
	echo end function >>UTF8_2_ANSI.vbs
	wscript -e:vbs "UTF8_2_ANSI.vbs" 
goto :eof