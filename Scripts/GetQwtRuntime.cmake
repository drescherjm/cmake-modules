# --------------------------------------------------------------------
# Copy the needed Qt libraries into the Build directory. Also add installation
# and CPack code to support installer generation.
# --------------------------------------------------------------------

if (GET_RUNTIME)
	IF (WIN32)
		
		if (NOT "${QWT_LIB_DEBUG}" STREQUAL "") 
			GET_FILENAME_COMPONENT(  QWT_DEBUG_DLL_BASE ${QWT_LIB_DEBUG} PATH )
			GET_FILENAME_COMPONENT(  QWT_DEBUG_DLL_NAME_EXT ${QWT_LIB_DEBUG} NAME )
			
			# I have to use the following line to strip off the .lib from the end since instead of using NAME_WE as
			# a param in the following line:
			# GET_FILENAME_COMPONENT(  QWT_DEBUG_DLL_NAME_EXT ${QWT_LIB_DEBUG} NAME_WE )
			# The reason is qwt now has more than 1 '.' in the filename. GET_FILENAME_COMPONENT considers the
			# extension is everything following the first '.'
			STRING( REGEX REPLACE ".lib$" "" QWT_DEBUG_DLL_NAME ${QWT_DEBUG_DLL_NAME_EXT})
				
			
			GET_FILENAME_COMPONENT(  QWT_RELEASE_DLL_BASE ${QWT_LIB_RELEASE} PATH )
			GET_FILENAME_COMPONENT(  QWT_RELEASE_DLL_NAME_EXT ${QWT_LIB_RELEASE} NAME )
			
			STRING( REGEX REPLACE ".lib$" "" QWT_RELEASE_DLL_NAME ${QWT_RELEASE_DLL_NAME_EXT})
			
			
			if (VCPKG_TARGET_TRIPLET) 
			
				# The lib folder in vcpkg does not have the dlls
				SET(QWT_DEBUG_DLL_BASE ${QWT_DEBUG_DLL_BASE}/../bin)
				SET(QWT_RELEASE_DLL_BASE ${QWT_RELEASE_DLL_BASE}/../bin)
				
				#dump_all_variables_starting_with(QWT)
			endif()
			
			add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QWT_DEBUG_DLL_BASE}/${QWT_DEBUG_DLL_NAME}.dll" Debug )
			add_runtime_file( ${RUNTIME_BATCH_FILENAME} "${QWT_RELEASE_DLL_BASE}/${QWT_RELEASE_DLL_NAME}.dll" RelWithDebInfo )
			add_runtime_file_for_packaging( ${RUNTIME_BATCH_FILENAME} "${QWT_RELEASE_DLL_BASE}/${QWT_RELEASE_DLL_NAME}.dll" Release )
		endif()
	ENDIF(WIN32)
endif(GET_RUNTIME)