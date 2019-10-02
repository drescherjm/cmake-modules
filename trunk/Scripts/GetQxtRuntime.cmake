# --------------------------------------------------------------------
# Copy the needed Qt libraries into the Build directory. Also add installation
# and CPack code to support installer generation.
# --------------------------------------------------------------------

#dump_all_variables()

if (GET_RUNTIME)
	if (WIN32)
		if (QXT_FIND_COMPONENTS) 
					message( STATUS "QXT_LIB_NAMES=" ${QXT_LIB_NAMES})
			message( STATUS "QXT_FIND_COMPONENTS=" ${QXT_FIND_COMPONENTS})
		
			string (REPLACE "," ";" QXT_LIB_NAMES ${QXT_FIND_COMPONENTS})
			FOREACH(LIB  ${QXT_LIB_NAMES})
					if (QXT_BINARY_DIR_DEBUG AND QXT_BINARY_DIR_DEBUG )
						add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QXT_BINARY_DIR_DEBUG}/${LIB}d.dll" Debug )
						add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QXT_BINARY_DIR_RELEASE}/${LIB}.dll" RelWithDebInfo )
						add_runtime_file_for_packaging( ${RUNTIME_BATCH_FILENAME} "${QXT_BINARY_DIR_RELEASE}/${LIB}.dll" Release )
					else()
						message(FATAL_ERROR "Could not find the binary folder for the QXT DLLs")
					endif()

				#endif()
			ENDFOREACH(LIB)
		endif()
	endif()
endif(GET_RUNTIME)