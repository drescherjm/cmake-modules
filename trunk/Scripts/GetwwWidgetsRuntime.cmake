# --------------------------------------------------------------------
# Copy the needed Qt libraries into the Build directory. Also add installation
# and CPack code to support installer generation.
# --------------------------------------------------------------------

if (GET_RUNTIME)
	if (WIN32)
		add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${wwWidgets_LIB_DEBUG_DLL}" Debug )
		add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${wwWidgets_LIB_RELEASE_DLL}" Release )
		add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${wwWidgets_LIB_RELEASE_DLL}" RelWithDebInfo )
		add_runtime_file_for_packaging( ${RUNTIME_BATCH_FILENAME} "${wwWidgets_LIB_RELEASE_DLL}" Release )		
	endif(WIN32)
endif(GET_RUNTIME)