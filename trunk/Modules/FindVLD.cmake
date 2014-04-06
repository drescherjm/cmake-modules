#message( STATUS "Looking for VLD" )

FIND_PATH(VLD_DIR NAMES vld.ini
 PATHS
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]"
    "$ENV{ProgramFiles}/Visual Leak Detector"
	"$ENV{ProgramW6432}/Visual Leak Detector"
)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(VLD DEFAULT_MSG VLD_DIR)

FIND_PATH(VLD_INCLUDE_DIRS NAMES vld.h
 PATHS
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/Include"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/Include"
    "$ENV{ProgramFiles}/Visual Leak Detector/Include"
	"$ENV{ProgramW6432}/Visual Leak Detector/Include"
)

IF(CMAKE_SIZEOF_VOID_P MATCHES 4)
	FIND_LIBRARY(VLD_LIBRARIES NAMES vld.lib
	PATHS
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/lib/Win32"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/lib/Win32"
		"$ENV{ProgramFiles}/Visual Leak Detector/lib/Win32"
		"$ENV{ProgramW6432}/Visual Leak Detector/lib/Win32"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/lib"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/lib"
		"$ENV{ProgramFiles}/Visual Leak Detector/lib"
		"$ENV{ProgramW6432}/Visual Leak Detector/lib"
	)
ELSE(CMAKE_SIZEOF_VOID_P MATCHES 4)
	FIND_LIBRARY(VLD_LIBRARIES NAMES vld.lib
	PATHS
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/lib/Win64"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/lib/Win64"
		"$ENV{ProgramFiles}/Visual Leak Detector/lib/Win64"
		"$ENV{ProgramW6432}/Visual Leak Detector/lib/Win64"
	)
ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 4)

# Now support getting the runtime dll names. 

IF(CMAKE_SIZEOF_VOID_P MATCHES 4)
	FIND_FILE(VLD_DEBUG_DLL NAMES vld_x86.dll vld.dll
	PATHS
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/bin/Win32"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/bin/Win32"
		"$ENV{ProgramFiles}/Visual Leak Detector/bin/Win32"
		"$ENV{ProgramW6432}/Visual Leak Detector/bin/Win32"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/bin"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/bin"
		"$ENV{ProgramFiles}/Visual Leak Detector/bin"
		"$ENV{ProgramW6432}/Visual Leak Detector/bin"
	)
ELSE(CMAKE_SIZEOF_VOID_P MATCHES 4)
	FIND_FILE(VLD_DEBUG_DLL NAMES vld_x64.dll vld.dll
	PATHS
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/bin/Win64"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/bin/Win64"
		"$ENV{ProgramFiles}/Visual Leak Detector/bin/Win64"
		"$ENV{ProgramW6432}/Visual Leak Detector/bin/Win64"
	)
ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 4)

IF(CMAKE_SIZEOF_VOID_P MATCHES 4)
	FIND_FILE(VLD_DBGHELP_DEBUG NAME dbghelp.dll
	PATHS
		"$ENV{ProgramFiles}/Visual Leak Detector/bin/Win32"
		"$ENV{ProgramW6432}/Visual Leak Detector/bin/Win32"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/bin/Win32"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/bin/Win32"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/bin"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/bin"
		"$ENV{ProgramFiles}/Visual Leak Detector/bin"
		"$ENV{ProgramW6432}/Visual Leak Detector/bin"
		NO_DEFAULT_PATH
	)
ELSE(CMAKE_SIZEOF_VOID_P MATCHES 4)
	FIND_FILE(VLD_DBGHELP_DEBUG NAME dbghelp.dll
	PATHS
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/bin/Win64"
		"[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/bin/Win64"
		"$ENV{ProgramFiles}/Visual Leak Detector/bin/Win64"
		"$ENV{ProgramW6432}/Visual Leak Detector/bin/Win64"
		NO_DEFAULT_PATH
	)
ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 4)

#list( APPEND VLD_RUNTIME_DEBUG ${VLD_DBGHELP_DEBUG} ${VLD_DEBUG_DLL} )

set(VLD_RUNTIME_DEBUG ${VLD_DBGHELP_DEBUG} ${VLD_DEBUG_DLL})

