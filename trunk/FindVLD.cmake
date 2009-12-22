FIND_PATH(VLD_DIR NAMES vld.ini
 PATHS
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]"
    $ENV{ProgramFiles}/Visual Leak Detector
)

include(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(VLD DEFAULT_MSG VLD_DIR)

FIND_PATH(VLD_INCLUDE_DIRS NAMES vld.h
 PATHS
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/Include"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/Include"
    $ENV{ProgramFiles}/Visual Leak Detector/Include
	
)

FIND_LIBRARY(VLD_LIBRARIES NAMES vld.lib
 PATHS
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Visual Leak Detector;InstallPath]/lib"
    "[HKEY_LOCAL_MACHINE\\SOFTWARE\\Wow6432Node\\Visual Leak Detector;InstallPath]/lib"
    $ENV{ProgramFiles}/Visual Leak Detector/lib
)

