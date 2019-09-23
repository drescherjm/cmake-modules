#########################################################################################
#
#	This module contains a few Helper Macros that add case insensitive list operations
#	among other functionality.
#
#########################################################################################

#########################################################################################
# The print_properties ... macros were taken from the following StackOverflow post:
# https://stackoverflow.com/questions/32183975/how-to-print-all-the-properties-of-a-target-in-cmake
#
#########################################################################################

function(print_properties)
    message ("CMAKE_PROPERTY_LIST = ${CMAKE_PROPERTY_LIST}")
endfunction(print_properties)

function(print_whitelisted_properties)
    message ("CMAKE_WHITELISTED_PROPERTY_LIST = ${CMAKE_WHITELISTED_PROPERTY_LIST}")
endfunction(print_whitelisted_properties)

function(print_target_properties tgt)
    if ("${CMAKE_PROPERTY_LIST}" STREQUAL "") 
		# Get all propreties that cmake supports
		execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

		# Convert command output into a CMake list
		STRING(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
		STRING(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
		# Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
		list(FILTER CMAKE_PROPERTY_LIST EXCLUDE REGEX "^LOCATION$|^LOCATION_|_LOCATION$")
		# For some reason, "TYPE" shows up twice - others might too?
		list(REMOVE_DUPLICATES CMAKE_PROPERTY_LIST)

		# build whitelist by filtering down from CMAKE_PROPERTY_LIST in case cmake is
		# a different version, and one of our hardcoded whitelisted properties
		# doesn't exist!
		unset(CMAKE_WHITELISTED_PROPERTY_LIST)
		foreach(prop ${CMAKE_PROPERTY_LIST})
			if(prop MATCHES "^(INTERFACE|[_a-z]|IMPORTED_LIBNAME_|MAP_IMPORTED_CONFIG_)|^(COMPATIBLE_INTERFACE_(BOOL|NUMBER_MAX|NUMBER_MIN|STRING)|EXPORT_NAME|IMPORTED(_GLOBAL|_CONFIGURATIONS|_LIBNAME)?|NAME|TYPE|NO_SYSTEM_FROM_IMPORTED)$")
				list(APPEND CMAKE_WHITELISTED_PROPERTY_LIST ${prop})
			endif()
		endforeach(prop)
	endif()

    if(NOT TARGET ${tgt})
      message("There is no target named '${tgt}'")
      return()
    endif()

    get_target_property(target_type ${tgt} TYPE)
    if(target_type STREQUAL "INTERFACE_LIBRARY")
        set(PROP_LIST ${CMAKE_WHITELISTED_PROPERTY_LIST})
    else()
        set(PROP_LIST ${CMAKE_PROPERTY_LIST})
    endif()

    foreach (prop ${PROP_LIST})
        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
        # message ("Checking ${prop}")
        get_property(propval TARGET ${tgt} PROPERTY ${prop} SET)
        if (propval)
            get_target_property(propval ${tgt} ${prop})
            message ("${tgt} ${prop} = ${propval}")
        endif()
    endforeach(prop)
endfunction(print_target_properties)

#########################################################################################

MACRO(LIST_CONTAINS var value)
  SET(${var})
  FOREACH (value2 ${ARGN})
    if (${value} STREQUAL ${value2})
      SET(${var} TRUE)
	  break()
    endif (${value} STREQUAL ${value2})
  ENDFOREACH (value2)
ENDMACRO(LIST_CONTAINS)

#########################################################################################

MACRO(LIST_CONTAINS_IGNORE_CASE var value)
  SET(${var})
  FOREACH (value2 ${ARGN})
    if (${value} STREQUAL ${value2})
      SET(${var} TRUE)
	ELSE(${value} STREQUAL ${value2})
		STRING( TOUPPER ${value} UpcaseValue )
		STRING( TOUPPER ${value2} UpcaseValue2 )
		 if (${UpcaseValue} STREQUAL ${UpcaseValue2})
			set(${var} TRUE)
			break()
		 endif (${UpcaseValue} STREQUAL ${UpcaseValue2})
    endif (${value} STREQUAL ${value2})
  ENDFOREACH (value2)
ENDMACRO(LIST_CONTAINS_IGNORE_CASE)

#########################################################################################
# Returns ${value}-NOTFOUND if not found or the matched string in the same case as the 
# list

MACRO(LIST_FIND_IGNORE_CASE var value)
  SET(${var} "${value}-NOTFOUND")
  FOREACH (value2 ${ARGN})
    if (${value} STREQUAL ${value2})
      SET(${var} ${value2})
	  break()
	ELSE(${value} STREQUAL ${value2})
		STRING( TOUPPER ${value} UpcaseValue )
		STRING( TOUPPER ${value2} UpcaseValue2 )
		 if (${UpcaseValue} STREQUAL ${UpcaseValue2})
			set(${var} ${value2})
			break()
		 endif (${UpcaseValue} STREQUAL ${UpcaseValue2})
    endif (${value} STREQUAL ${value2})
  ENDFOREACH (value2)
ENDMACRO(LIST_FIND_IGNORE_CASE)

#########################################################################################

MACRO(LIST_FIND var value)
  SET(${var} "${value}-NOTFOUND")
  FOREACH (value2 ${ARGN})
    if (${value} STREQUAL ${value2})
      SET(${var} ${value2})
	  break()
    endif (${value} STREQUAL ${value2})
  ENDFOREACH (value2)
ENDMACRO(LIST_FIND)

#########################################################################################

macro(LIST_TO_CSV_STRING my_string)
	unset( ___TEMP___ )
	FOREACH (value2 ${ARGN})
		if (___TEMP___)
			set ( ___TEMP___ ${___TEMP___} "," ${value2} )
		else(___TEMP___)
			set ( ___TEMP___ ${value2} )
		endif(___TEMP___)
	ENDFOREACH (value2) 
	set( ${my_string} "${___TEMP___}" )
	unset( ___TEMP___ )
endmacro(LIST_TO_CSV_STRING)

#########################################################################################

macro( print_list my_message)
	unset(__LIST_OUTPUT__)
	LIST_TO_CSV_STRING( __LIST_OUTPUT__ ${ARGN} )
	MESSAGE( STATUS "${my_message} " ${__LIST_OUTPUT__})
	unset(__LIST_OUTPUT__)
endmacro( print_list )

#########################################################################################

macro( conditional_define VariableName DefineName)
	if (${VariableName})
	
		message( STATUS "add_definitions(-D${DefineName})" )
		add_definitions(-D${DefineName})
		
	endif(${VariableName})
endmacro( conditional_define )

#########################################################################################

macro( conditional_not_define VariableName DefineName)
	if (NOT ${VariableName})
	
		message( STATUS "add_definitions(-D${DefineName})" )
		add_definitions(-D${DefineName})
		
	endif(NOT ${VariableName})
endmacro( conditional_not_define )

#########################################################################################

function( define_from_environment VariableName PackageName)
	if (NOT DEFINED ${VariableName})
		message( STATUS "${VariableName}=$ENV{${VariableName}}" )
		if (NOT "$ENV{${VariableName}}" STREQUAL "")
			set(${VariableName} $ENV{${VariableName}} CACHE PATH "Set the path for ${PackageName}" FORCE)
		endif (NOT "$ENV{${VariableName}}" STREQUAL "")
	endif(NOT DEFINED ${VariableName})
endfunction( define_from_environment)

#########################################################################################

macro( myproject ProjectName )
	set( LOCAL_PROJECT_NAME ${ProjectName})
	set( LOCAL_PROJECT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
	set( LOCAL_PROJECT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})

	set (${LOCAL_PROJECT_NAME}_VERSION_MAJOR ${${PROJECT_NAME}_VERSION_MAJOR})
	set (${LOCAL_PROJECT_NAME}_VERSION_MINOR ${${PROJECT_NAME}_VERSION_MINOR})
	set (${LOCAL_PROJECT_NAME}_VERSION_PATCH ${${PROJECT_NAME}_VERSION_PATCH_CLEAN})
	set (${LOCAL_PROJECT_NAME}_VERSION_STRING "${${LOCAL_PROJECT_NAME}_VERSION_MAJOR}.${${LOCAL_PROJECT_NAME}_VERSION_MINOR}.${${LOCAL_PROJECT_NAME}_VERSION_PATCH}")

	#RESET_OPTIMIZATIONS()
	initialize_project(${LOCAL_PROJECT_NAME})
	
endmacro( myproject )

#########################################################################################

macro( mysubproject ProjectName )
	set( LOCAL_SUBPROJECT_NAME ${ProjectName})
	set( LOCAL_SUBPROJECT_SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR})
	set( LOCAL_SUBPROJECT_BINARY_DIR ${CMAKE_CURRENT_BINARY_DIR})			
endmacro( mysubproject )

#########################################################################################

macro(create_string_from_list my_str)
 foreach(VALUE ${ARGN})
  if ("${VALUE}" STREQUAL "${ARGV1}")
   set(result "${VALUE}")
  else()
   set(result "${result} ${VALUE}")
  endif()
 endforeach(VALUE)
 set(${my_str} ${result})
endmacro(create_string_from_list) 

#########################################################################################

macro(SUBDIRLIST result curdir)
  FILE(GLOB children RELATIVE ${curdir} ${curdir}/*)
  SET(dirlist "")
  FOREACH(child ${children})
    IF(IS_DIRECTORY ${curdir}/${child})
        SET(dirlist ${dirlist} ${child})
    ENDIF()
  ENDFOREACH()
  SET(${result} ${dirlist})
endmacro()

#########################################################################################

macro ( setup_library_source_groups )
	
	set (extra_macro_args ${ARGN})
	list(LENGTH extra_macro_args num_extra_args)
	if (${num_extra_args} GREATER 0)
		
		SOURCE_GROUP("${ARGV0}\\Generated" FILES
			  ${${LOCAL_PROJECT_NAME}_RC_SRCS}
			  ${${LOCAL_PROJECT_NAME}_MOC_SRCS}
			  ${${LOCAL_PROJECT_NAME}_UI_HDRS}
		)

		SOURCE_GROUP("${ARGV0}\\Resources" FILES
			  ${${LOCAL_PROJECT_NAME}_UIS}
			  ${${LOCAL_PROJECT_NAME}_RCS}
		)
		SOURCE_GROUP("${ARGV0}\\Source Files" FILES
			 ${${LOCAL_PROJECT_NAME}_SRCS}
		)
			
		SOURCE_GROUP("${ARGV0}\\Header Files" FILES
			 ${${LOCAL_PROJECT_NAME}_EXT_HDRS}
			 ${${LOCAL_PROJECT_NAME}_MOC_HDRS}
		)
	else()
		SOURCE_GROUP("Generated" FILES
			  ${${LOCAL_PROJECT_NAME}_RC_SRCS}
			  ${${LOCAL_PROJECT_NAME}_MOC_SRCS}
			  ${${LOCAL_PROJECT_NAME}_UI_HDRS}
		)

		SOURCE_GROUP("Resources" FILES
			  ${${LOCAL_PROJECT_NAME}_UIS}
			  ${${LOCAL_PROJECT_NAME}_RCS}
		)
	endif()
	
endmacro ( setup_library_source_groups )

#########################################################################################

macro( add_library_module ModuleListName ModuleName )
	get_property(is_defined GLOBAL PROPERTY ${ModuleListName} DEFINED)
	if(NOT is_defined)
		define_property(GLOBAL PROPERTY ${ModuleListName} 
			BRIEF_DOCS "List of library modules"
			FULL_DOCS "List of library modules")
	endif()
	set_property(GLOBAL APPEND PROPERTY ${ModuleListName} "${ModuleName}")	
endmacro( add_library_module )

#########################################################################################

macro(init_lib_shared_static_option shared)
option (BUILD_${LOCAL_PROJECT_NAME}_SHARED		"Build ${LOCAL_PROJECT_NAME} as a shared library" ${shared})

if (BUILD_${LOCAL_PROJECT_NAME}_SHARED)
	set(${LOCAL_PROJECT_NAME}_SHARED SHARED)
else (BUILD_${LOCAL_PROJECT_NAME}_SHARED)
	set(${LOCAL_PROJECT_NAME}_SHARED)
endif (BUILD_${LOCAL_PROJECT_NAME}_SHARED)

endmacro(init_lib_shared_static_option)

#########################################################################################

# VERSION_STR_TO_INTS Macro
# This macro converts a version string into its three integer components.
#
# Usage:
#     VERSION_STR_TO_INTS( major minor patch version )
#
# Parameters:
#     major      The variable to store the major integer component in.
#     minor      The variable to store the minor integer component in.
#     patch      The variable to store the patch integer component in.
#     version    The version string to convert ("#.#.#" format).
macro( VERSION_STR_TO_INTS major minor patch version )

    string( REGEX REPLACE "([0-9]+).[0-9]+.[0-9]+" "\\1" ${major} ${version} )
    string( REGEX REPLACE "[0-9]+.([0-9]+).[0-9]+" "\\1" ${minor} ${version} )
    string( REGEX REPLACE "[0-9]+.[0-9]+.([0-9]+)" "\\1" ${patch} ${version} )

endmacro( VERSION_STR_TO_INTS )

#########################################################################################

macro( dump_all_variables )

	get_cmake_property(_variableNames VARIABLES)
	foreach (_variableName ${_variableNames})
		message(STATUS "${_variableName}=${${_variableName}}")
	endforeach()

endmacro( dump_all_variables )

#########################################################################################

macro( dump_all_variables_starting_with Name )

	get_cmake_property(_variableNames VARIABLES)
	foreach (_variableName ${_variableNames})
		if ( _variableName MATCHES ^${Name}* )
			message(STATUS "${_variableName}=${${_variableName}}")
		endif()
	endforeach()

endmacro( dump_all_variables_starting_with )

#########################################################################################
