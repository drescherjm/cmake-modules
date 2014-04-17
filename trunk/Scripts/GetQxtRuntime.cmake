# --------------------------------------------------------------------
# Copy the needed Qt libraries into the Build directory. Also add installation
# and CPack code to support installer generation.
# --------------------------------------------------------------------

if (GET_RUNTIME)
	IF (WIN32)
		string (REPLACE "," ";" QXT_LIB_NAMES ${QXT_FIND_COMPONENTS})
		FOREACH(LIB  ${QXT_LIB_NAMES})
				add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QXT_BINARY_DIR}/${LIB}d.dll" Debug )
				add_runtime_file_release( ${RUNTIME_BATCH_FILENAME} "${QXT_BINARY_DIR}/${LIB}.dll" RelWithDebInfo )
		ENDFOREACH(LIB)
		
	ENDIF(WIN32)
endif(GET_RUNTIME)