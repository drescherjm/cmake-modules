
###############################################################################

if ( NOT DEFINED CMAKE_SYSTEM_INCLUDE_ROOT ) 
    #message( STATUS "Got Here " $ENV{CMAKE_SYSTEM_INCLUDE_ROOT} )
	if( NOT "$ENV{CMAKE_SYSTEM_INCLUDE_ROOT}" STREQUAL "" )
		#message( STATUS "Got Here " $ENV{CMAKE_SYSTEM_INCLUDE_ROOT} )
		set(CMAKE_SYSTEM_INCLUDE_ROOT "$ENV{CMAKE_SYSTEM_INCLUDE_ROOT}" CACHE PATH "The path to the location of the root system headers" FORCE)
	endif( NOT "$ENV{CMAKE_SYSTEM_INCLUDE_ROOT}" STREQUAL "" )
endif( NOT DEFINED CMAKE_SYSTEM_INCLUDE_ROOT ) 

###############################################################################