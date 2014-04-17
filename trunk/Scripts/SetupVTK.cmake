
define_from_environment(VTK_DIR VTK)

FIND_PACKAGE( VTK REQUIRED ${DEFAULT_CMAKE_FIND_OPTIONS} )

# The following supports VTK Includes being copied to the CMAKE_SYSTEM_INCLUDE_ROOT folder at 
# CMAKE_SYSTEM_INCLUDE_ROOT/VTK-${VTK_VERSION_MAJOR}.${VTK_VERSION_MINOR}.${VTK_VERSION_PATCH}
# if that folder exits it will reset the VTK_INCLUDE_DIRS variable set in FIND_PACKAGE.

if (NOT ${CMAKE_SYSTEM_INCLUDE_ROOT} STREQUAL "" )
	set ( __INCLUDE_DIR__ "${CMAKE_SYSTEM_INCLUDE_ROOT}/VTK-${VTK_VERSION_MAJOR}.${VTK_VERSION_MINOR}.${VTK_VERSION_PATCH}" )
	if ( IS_DIRECTORY "${__INCLUDE_DIR__}" )
	    message( STATUS "Found VTK Headers in CMAKE_SYSTEM_INCLUDE_ROOT. We will reset VTK_INCLUDE_DIRS to this path." )
		set( VTK_INCLUDE_DIRS "${__INCLUDE_DIR__}" )
	endif ( IS_DIRECTORY "${__INCLUDE_DIR__}" )
	unset( __INCLUDE_DIR__ )
else(NOT ${CMAKE_SYSTEM_INCLUDE_ROOT} STREQUAL "" )
	message( STATUS "CMAKE_SYSTEM_INCLUDE_ROOT is empty. Include folder optimization will not be available" )
endif(NOT ${CMAKE_SYSTEM_INCLUDE_ROOT} STREQUAL "")

if( "${VTK_VERSION_MAJOR}" EQUAL 5 )
	add_definitions(-DUSING_VTK5)
endif ( "${VTK_VERSION_MAJOR}" EQUAL 5 )

if( "${VTK_VERSION_MAJOR}" EQUAL 6 )
	add_definitions(-DUSING_VTK6)
endif ( "${VTK_VERSION_MAJOR}" EQUAL 6 )