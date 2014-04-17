# --------------------------------------------------------------------
# Copy the needed Qt libraries into the Build directory. Also add installation
# and CPack code to support installer generation.
# --------------------------------------------------------------------

if (GET_RUNTIME)
	IF (WIN32)
		string (REPLACE "," ";" QXT_LIB_NAMES ${QXT_FIND_COMPONENTS})
		FOREACH(LIB  ${QXT_LIB_NAMES})
				add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QXT_BINARY_DIR}/${LIB}d.dll" Debug )
				add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QXT_BINARY_DIR}/${LIB}.dll" RelWithDebInfo )
				add_runtime_file_for_packaging( ${RUNTIME_BATCH_FILENAME} "${QXT_BINARY_DIR}/${LIB}.dll" Release )
		ENDFOREACH(LIB)
		
	ENDIF(WIN32)
endif(GET_RUNTIME)