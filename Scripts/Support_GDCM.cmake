if (NOT GDCM_VERSION) 
	FIND_PACKAGE(GDCM REQUIRED)
	unset(GDCM_USE_VTK)
	INCLUDE(${GDCM_USE_FILE})
else()
	INCLUDE(${GDCM_USE_FILE})
endif(NOT GDCM_VERSION)

dump_all_variables_starting_with( GDCM )

if (GDCM_VERSION) 
    if (${GDCM_VERSION} VERSION_GREATER_EQUAL "3.0.0") 
        # Only include the GDCM Targets that exist!
	
		set(_targetsDefined)
		set(_targetsNotDefined)
		set(_expectedTargets)
		foreach(_expectedTarget gdcmCommon gdcmDICT gdcmDSED gdcmIOD gdcmMSFF gdcmMEXD gdcmjpeg8 gdcmjpeg12 gdcmjpeg16 gdcmcharls socketxx vtkgdcm)
		  list(APPEND _expectedTargets ${_expectedTarget})
		  if(NOT TARGET ${_expectedTarget})
			list(APPEND _targetsNotDefined ${_expectedTarget})
		  endif()
		  if(TARGET ${_expectedTarget})
			list(APPEND _targetsDefined ${_expectedTarget})
		  endif()
		endforeach()
		
		SET(UPMC_EXTERNAL_LIBS ${UPMC_EXTERNAL_LIBS} ${_targetsDefined})
		
    elseif (${GDCM_VERSION} VERSION_GREATER "2.0.18") 
		SET(UPMC_EXTERNAL_LIBS ${UPMC_EXTERNAL_LIBS} 
			gdcmdict gdcmCommon gdcmcharls gdcmDSED gdcmIOD 
			gdcmexpat gdcmjpeg8 gdcmjpeg12 gdcmjpeg16 gdcmopenjpeg
			gdcmMSFF gdcmMEXD gdcmzlib
		)
	endif()
endif(GDCM_VERSION)

#dump_all_variables_starting_with(GDCM)