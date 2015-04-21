option (USE_MSVC_PCH				"Use precompiled headers in MSVC." ON)
if(USE_MSVC_PCH)
	option (USE_MSVC_PCH_WITH_MOC		"Use precompiled headers in MSVC for moc generated sources." ON)
	option (DEBUG_PCH_MOC				"Debug MOC generation for precompiled headers." OFF)
endif(USE_MSVC_PCH)

#########################################################################################

conditional_define(USE_MSVC_PCH USING_PCH)
conditional_define(USE_MSVC_PCH_WITH_MOC USING_PCH_WITH_MOC)

#########################################################################################

macro ( create_pch_source_if_needed ProjectName )
	if ( NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${ProjectName}PCH.cxx" AND  NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/${ProjectName}PCH.cxx")
		message( STATUS ${CMAKE_CURRENT_SOURCE_DIR}/${ProjectName}PCH.cxx" does not exist! This file will be generated in the build tree." )
		
		FILE( WRITE "${CMAKE_CURRENT_BINARY_DIR}/${ProjectName}PCH.cxx" "\#include \"${ProjectName}PCH.h\"")
		
	endif ()
endmacro(create_pch_source_if_needed)

#########################################################################################

macro( MSVC_PCH_SUPPORT ProjectName )
if (MSVC)
	if (USE_MSVC_PCH)
	
		create_pch_source_if_needed( ${ProjectName} )
	
		add_definitions(-DUSING_PCH)
		
		set_source_files_properties(${ProjectName}PCH.cxx
			PROPERTIES
			COMPILE_FLAGS "/Yc${ProjectName}PCH.h"
			)
		foreach( src_file ${${ProjectName}_SRCS} ${PROJECT_NAME}_MOC_SRCS )
			set_source_files_properties(
				${src_file}
				PROPERTIES
				COMPILE_FLAGS "/Yu${ProjectName}PCH.h"
				)
		endforeach( src_file ${${ProjectName}_SRCS} ${PROJECT_NAME}_MOC_SRCS )
		
		list(APPEND ${ProjectName}_SRCS ${ProjectName}PCH.cxx)
		list(APPEND ${ProjectName}_EXT_HDRS ${ProjectName}PCH.h)

	endif(USE_MSVC_PCH)
endif (MSVC)
endmacro (MSVC_PCH_SUPPORT)

#########################################################################################

if( ${CMAKE_VERSION} VERSION_LESS "2.8.12" )

	# PATCHED QT4_WRAP_CPP for use with StdAfx
	# Original source: Qt4Macros.cmake
	MACRO (PCH_QT4_WRAP_CPP HeaderName outfiles )
	  # get include dirs
	  QT4_GET_MOC_FLAGS(moc_flags)
	  QT4_EXTRACT_OPTIONS(moc_files moc_options ${ARGN})
	 
	  FOREACH (it ${moc_files})
		GET_FILENAME_COMPONENT(it ${it} ABSOLUTE)
		QT4_MAKE_OUTPUT_FILE(${it} moc_ cxx outfile)
		set (moc_flags_append "-f${HeaderName}.h" "-f${it}") # StdAfx hack.
		
		if (DEBUG_PCH_MOC) 
			message (STATUS "Moc Flags append ${moc_flags_append}")
		endif(DEBUG_PCH_MOC)
		
		QT4_CREATE_MOC_COMMAND(${it} ${outfile} "${moc_flags};${moc_flags_append}" "${moc_options}")
		SET(${outfiles} ${${outfiles}} ${outfile})
	  ENDFOREACH(it)
	ENDMACRO (PCH_QT4_WRAP_CPP)

else(${CMAKE_VERSION} VERSION_LESS "2.8.12")
	# CMake 2.8.12 changed the number of arguments to QT4_CREATE_MOC_COMMAND
	MACRO (PCH_QT4_WRAP_CPP HeaderName outfiles )
	  # get include dirs
	  QT4_GET_MOC_FLAGS(moc_flags)
	  QT4_EXTRACT_OPTIONS(moc_files moc_options moc_target ${ARGN})
	 
	  FOREACH (it ${moc_files})
		GET_FILENAME_COMPONENT(it ${it} ABSOLUTE)
		QT4_MAKE_OUTPUT_FILE(${it} moc_ cxx outfile)
		set (moc_flags_append "-f${HeaderName}.h" "-f${it}") # StdAfx hack.
		
		if (DEBUG_PCH_MOC) 
			message (STATUS "Moc Flags append ${moc_flags_append}")
		endif(DEBUG_PCH_MOC)
		
		QT4_CREATE_MOC_COMMAND(${it} ${outfile} "${moc_flags};${moc_flags_append}" "${moc_options}" "${moc_target}")
		SET(${outfiles} ${${outfiles}} ${outfile})
	  ENDFOREACH(it)
	ENDMACRO (PCH_QT4_WRAP_CPP)
	
endif(${CMAKE_VERSION} VERSION_LESS "2.8.12")

#########################################################################################