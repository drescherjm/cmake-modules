
if (NOT DEFINED CMAKE_SYSTEM_LIBRARY_ROOT)
	if (NOT "$ENV{CMAKE_SYSTEM_LIBRARY_ROOT}" STREQUAL "")
		string (REPLACE "\\" "/" LIB_ROOT_DIR $ENV{CMAKE_SYSTEM_LIBRARY_ROOT})
		MESSAGE( STATUS ${LIB_ROOT_DIR})
		SET (CMAKE_SYSTEM_LIBRARY_ROOT ${LIB_ROOT_DIR} CACHE PATH "Please set the root path where system libararies are installed.") 
	else()
		MESSAGE( FATAL_ERROR "Please either set the CMAKE_SYSTEM_LIBRARY_ROOT" )
	endif()
endif()

get_qt_base_dir()

FIND_LIBRARY(wwWidgets_LIB_RELEASE NAME wwwidgets${${PROJECT_NAME}_QT_VERSION}
	PATHS
	${QT_BASE_DIR}/lib
	${QT_BASE_DIR}/bin
	${QT_LIBRARY_DIR}
	NO_DEFAULT_PATH
)

FIND_LIBRARY(wwWidgets_LIB_DEBUG NAME wwwidgets${${PROJECT_NAME}_QT_VERSION}d
	PATHS
	${QT_BASE_DIR}/lib
	${QT_BASE_DIR}/bin
	${QT_LIBRARY_DIR}
	NO_DEFAULT_PATH
)

find_path( wwWidgets_INCLUDE_DIR NAMES wwglobal.h 
	PATHS
	${QT_BASE_DIR}/include/wwWidgets
)

#=============================================================================
# Register imported libraries:
# 1. If we can find a Windows .dll file (or if we can find both Debug and
#    Release libraries), we will set appropriate target properties for these.
# 2. However, for most systems, we will only register the import location and
#    include directory.

# Look for dlls, or Release and Debug libraries.
if(WIN32)
  string( REPLACE ".lib" ".dll" wwWidgets_LIB_RELEASE_DLL 	"${wwWidgets_LIB_RELEASE}" )
  string( REPLACE ".lib" ".dll" wwWidgets_LIB_DEBUG_DLL 	"${wwWidgets_LIB_DEBUG}" )
endif()

dump_all_variables_starting_with( wwWidgets )

message( STATUS CMAKE_SYSTEM_LIBRARY_ROOT=${CMAKE_SYSTEM_LIBRARY_ROOT} )
message( STATUS wwWidgets_LIB_DEBUG=${wwWidgets_LIB_DEBUG} )
	
if ( EXISTS ${wwWidgets_LIB_RELEASE_DLL} )
	add_library( wwWidgets  SHARED IMPORTED )
	
	set_target_properties( wwWidgets PROPERTIES
      IMPORTED_LOCATION_RELEASE         "${wwWidgets_LIB_RELEASE_DLL}"
      IMPORTED_IMPLIB                   "${wwWidgets_LIB_RELEASE}"
	  IMPORTED_LOCATION_DEBUG         	"${wwWidgets_LIB_DEBUG_DLL}"
      IMPORTED_IMPLIB_DEBUG           	"${wwWidgets_LIB_DEBUG}"
      INTERFACE_INCLUDE_DIRECTORIES     "${wwWidgets_INCLUDE_DIR}"
      IMPORTED_CONFIGURATIONS           "Release;Debug"
      IMPORTED_LINK_INTERFACE_LANGUAGES "C++" )
else()
	add_library( wwWidgets  UNKNOWN IMPORTED )
	
	set_target_properties( wwWidgets PROPERTIES
      IMPORTED_LOCATION_RELEASE         "${wwWidgets_LIB_RELEASE}"
  	  IMPORTED_LOCATION_DEBUG         	"${wwWidgets_LIB_DEBUG}"
      INTERFACE_INCLUDE_DIRECTORIES     "${wwWidgets_INCLUDE_DIR}"
      IMPORTED_CONFIGURATIONS           "Release;Debug"
      IMPORTED_LINK_INTERFACE_LANGUAGES "C++" )
endif()

set (wwWidgets_LIBRARIES wwWidgets)

# SET (wwWidgets_BINARY_DIR ${QT_BINARY_DIR})

# SET( wwWidgets_INCLUDE_DIR 
	# ${QT_INCLUDE_DIR}/wwWidgets
# )
