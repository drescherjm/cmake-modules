option (GET_RUNTIME			"Create a target that will get the runtime" ON)

if (GET_RUNTIME) 

	SET (${PROJECT_NAME}_PACKAGING_RUNTIME "")

	SET (RUNTIME_BATCH_FILENAME "${PROJECT_BINARY_DIR}/GetRuntime.bat" CACHE FILEPATH "${PROJECT_BINARY_DIR}/GetRuntime.bat")
	
	add_custom_target(GetRuntime  "${RUNTIME_BATCH_FILENAME}")
	
#########################################################################################

	macro( add_runtime_file BatchFileName RuntimeFile Configuration )
		
		# Test if this is a valid configuration.
		#STRING( REGEX MATCH ${Configuration} __MATCHED__ ${CMAKE_CONFIGURATION_TYPES})
		
		LIST_CONTAINS_IGNORE_CASE( __MATCHED__ ${Configuration} ${CMAKE_CONFIGURATION_TYPES})
		
		#message(FATAL_ERROR MATCHED=${__MATCHED__})
		if ( NOT "${__MATCHED__}" STREQUAL "" )
		
			if (NOT EXISTS "${EXECUTABLE_OUTPUT_PATH}/${Configuration}")
				file( MAKE_DIRECTORY "${EXECUTABLE_OUTPUT_PATH}/${Configuration}" )
			endif (NOT EXISTS "${EXECUTABLE_OUTPUT_PATH}/${Configuration}")
		
			GET_FILENAME_COMPONENT( BatchFile ${BatchFileName} NAME_WE )
			
			#The following will truncate the file on the first call to add_runtime_file.
			if ( NOT DEFINED __add_runtime_file_${BatchFile}__ ) 
				set ( __add_runtime_file_${BatchFile}__ 1)
				file( WRITE ${BatchFileName} "REM This file will copy the runtimes to the Debug and Release binary folders\n" )
			endif ( NOT DEFINED __add_runtime_file_${BatchFile}__)
			
			#The following line will add the entry in the batch file for copying the Runtime file to the folder ${PROJECT_BINARY_DIR}/${Configuration}/
			file( APPEND ${BatchFileName} "\"${CMAKE_COMMAND}\" -E copy_if_different \"${RuntimeFile}\" \"${EXECUTABLE_OUTPUT_PATH}/${Configuration}/\"\n" )
		else()
			message( STATUS "Not adding ${RuntimeFile} because the configuration ${Configuration} was not listed in the project's configuration types." ) 
		endif( )
	endmacro( add_runtime_file )
	
#########################################################################################

#	macro( add_runtime_file_for_packaging RuntimeFile )
#	    message( STATUS "Packaging File: " ${RuntimeFile} )
#		add_runtime_file( ${RUNTIME_BATCH_FILENAME} ${RuntimeFile} Release )
#		add_runtime_file( ${RUNTIME_BATCH_FILENAME} ${RuntimeFile} RelWithDebInfo )
#		SET( ${PROJECT_NAME}_PACKAGING_RUNTIME  ${${PROJECT_NAME}_PACKAGING_RUNTIME} ${RuntimeFile} )
#	endmacro( add_runtime_file_for_packaging )
	
	
macro( add_runtime_file_for_packaging BatchFileName RuntimeFile Release )

	if (DEBUG_NSIS_PACKAGING)
		message( STATUS "Packaging File: " ${RuntimeFile} )
	endif(DEBUG_NSIS_PACKAGING)
	
	add_runtime_file( ${BatchFileName} ${RuntimeFile} ${Release} )
	SET( ${PROJECT_NAME}_PACKAGING_RUNTIME  ${${PROJECT_NAME}_PACKAGING_RUNTIME} ${RuntimeFile} )
endmacro( add_runtime_file_for_packaging )

#########################################################################################

	macro( add_runtime_for_imported_target TargetName )
		if ( TARGET ${TargetName})
			# Add optional arguments for the configurations to package. If used you 
			# most likely just want Release
			
			set (extra_args ${ARGN})
			list(LENGTH extra_args extra_count)
    
			get_target_property( Configurations ${TargetName} IMPORTED_CONFIGURATIONS )
						
			FOREACH(Configuration ${Configurations})
				message( STATUS "Supporting ${TargetName} Configuration ${Configuration}" )
				get_target_property( implib ${TargetName} IMPORTED_IMPLIB_${Configuration} )
				# Remember results ending in -NOTFOUND are evaluated to FALSE
				if(implib)
					get_target_property( sharedlib ${TargetName} IMPORTED_LOCATION_${Configuration} )
					if(sharedlib)
						add_runtime_file( "${RUNTIME_BATCH_FILENAME}" "${sharedlib}" "${Configuration}" )
					else()
						message(FATAL_ERROR No DLL)
					endif(sharedlib)
				else(implib)
					get_target_property( target_type ${TargetName} TYPE )
					message( STATUS "Could not find import library for target ${TargetName} Configuration ${Configuration} Type=${target_type}" )
					if (target_type STREQUAL "EXECUTABLE")
						get_target_property( sharedlib ${TargetName} IMPORTED_LOCATION_${Configuration} )
						if (sharedlib) 
							add_runtime_file( "${RUNTIME_BATCH_FILENAME}" "${sharedlib}" "${Configuration}" )
						endif()
					endif()
				endif(implib)
				
				# This part is for packaging
				if (${extra_count} GREATER 0)
					if (sharedlib) 
						FOREACH(arg ${extra_args}) 
							string(TOUPPER ${arg} uppercase_arg)
							message(STATUS Arg=${uppercase_arg}, Configuration=${Configuration})
							if (${uppercase_arg} STREQUAL ${Configuration})
								SET( ${PROJECT_NAME}_PACKAGING_RUNTIME  ${${PROJECT_NAME}_PACKAGING_RUNTIME} ${sharedlib} )	
							endif()
						ENDFOREACH(arg)
					endif()
				endif()
			ENDFOREACH(Configuration)
		else()
			message( FATAL_ERROR ${TargetName} is not a target!)
		endif()
	endmacro( add_runtime_for_imported_target )
	
endif(GET_RUNTIME)