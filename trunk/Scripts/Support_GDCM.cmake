if (NOT GDCM_VERSION) 
	FIND_PACKAGE(GDCM REQUIRED)
	INCLUDE(${GDCM_USE_FILE})
endif(NOT GDCM_VERSION)

if (GDCM_VERSION) 
	if (${GDCM_VERSION} VERSION_GREATER "2.0.18") 
		SET(UPMC_EXTERNAL_LIBS ${UPMC_EXTERNAL_LIBS} 
			gdcmdict gdcmCommon gdcmcharls gdcmDSED gdcmIOD 
			gdcmexpat gdcmjpeg8 gdcmjpeg12 gdcmjpeg16 gdcmopenjpeg
			gdcmMSFF gdcmMEXD gdcmzlib
		)
	endif(${GDCM_VERSION} VERSION_GREATER "2.0.18")
endif(GDCM_VERSION)