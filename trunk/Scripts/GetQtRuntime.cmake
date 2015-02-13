# --------------------------------------------------------------------
# Copy the needed Qt libraries into the Build directory. Also add installation
# and CPack code to support installer generation.
# --------------------------------------------------------------------

if (GET_RUNTIME)

	OPTION(DEBUG_GET_QT_RUNTIME "Debug the Qt libraries added to the getruntime script." ON)

#########################################################################################

	macro( add_qt_sqldriver_file BatchFileName RuntimeFile Release )

		GET_FILENAME_COMPONENT( BatchFile ${BatchFileName} NAME_WE )
		
		#The following will truncate the file on the first call to add_qt_sqldriver_file.
		if ( NOT DEFINED __add_runtime_file_${BatchFile}__ ) 
			set ( __add_runtime_file_${BatchFile}__ 1)
			file( WRITE ${BatchFileName} "REM This file will copy the runtimes to the Debug and Release binary folders\n" )
		endif ( NOT DEFINED __add_runtime_file_${BatchFile}__)
		
		message( STATUS "CREATING ${EXECUTABLE_OUTPUT_PATH}/${Release}/sqldrivers")
		file( MAKE_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}/${Release}/sqldrivers" )
		#The following line will add the entry in the batch file for copying the Runtime file to the folder ${PROJECT_BINARY_DIR}/${Release}/
		file( APPEND ${BatchFileName} "@\"${CMAKE_COMMAND}\" -E copy_if_different \"${RuntimeFile}\" \"${EXECUTABLE_OUTPUT_PATH}/${Release}/sqldrivers/\"\n" )
		
	endmacro( add_qt_sqldriver_file )
	
#########################################################################################

	macro( add_sqldriver_file_for_packaging BatchFileName RuntimeFile Release )
		add_qt_sqldriver_file( ${BatchFileName} ${RuntimeFile} ${Release} )
		#SET( ${PROJECT_NAME}_RELEASE_RUNTIME  ${${PROJECT_NAME}_RELEASE_RUNTIME} ${RuntimeFile} )
		
		INSTALL(FILES ${RuntimeFile}
			DESTINATION bin/sqldrivers
			COMPONENT Applications
		)
		
	endmacro( add_sqldriver_file_for_packaging )
	
#########################################################################################	

	IF (WIN32)
		
		# Get the list of Qt components.
		set( QT_COMPONENTS QtCore )
		foreach(LIB ${QT_MODULES})
			string( TOUPPER ${LIB} _COMPONENT )
			if ( QT_USE_${_COMPONENT} ) 
				list(APPEND QT_COMPONENTS ${LIB})
			endif()
		endforeach(LIB)
			
		# Add each component to the list of runtime files
		FOREACH(LIB ${QT_COMPONENTS})
				if ( DEBUG_GET_QT_RUNTIME )
					message( STATUS "Adding Qt Runtime file: " ${LIB} )
				endif (DEBUG_GET_QT_RUNTIME)
				add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QT_BINARY_DIR}/${LIB}d${QT_VERSION_MAJOR}.dll" Debug )
				add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QT_BINARY_DIR}/${LIB}${QT_VERSION_MAJOR}.dll" RelWithDebInfo )
				add_runtime_file_for_packaging( ${RUNTIME_BATCH_FILENAME} "${QT_BINARY_DIR}/${LIB}${QT_VERSION_MAJOR}.dll" Release )
		ENDFOREACH(LIB)
		
		if (QT_USE_QTSQL)
			foreach(SQLDRIVER ${QT_QTSQL_PLUGINS}) 
				string( TOUPPER ${SQLDRIVER} _COMPONENT )
				if ( QT_${_COMPONENT}_PLUGIN_RELEASE )
					
					if ( DEBUG_GET_QT_RUNTIME )
						message( STATUS "Found SQL Driver: " ${SQLDRIVER} )
					endif ( DEBUG_GET_QT_RUNTIME )
					
					add_qt_sqldriver_file( ${RUNTIME_BATCH_FILENAME} "${QT_${_COMPONENT}_PLUGIN_DEBUG}" Debug )
					add_qt_sqldriver_file( ${RUNTIME_BATCH_FILENAME} "${QT_${_COMPONENT}_PLUGIN_RELEASE}" RelWithDebInfo )
					add_sqldriver_file_for_packaging( ${RUNTIME_BATCH_FILENAME} "${QT_${_COMPONENT}_PLUGIN_RELEASE}" Release )
				endif()
			endforeach(SQLDRIVER)
		endif (QT_USE_QTSQL)
		
	ENDIF(WIN32)
endif(GET_RUNTIME)

