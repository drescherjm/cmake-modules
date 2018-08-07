macro ( PackageSystemRuntime Component )

	 set(MY_PFX86 "PROGRAMFILES(X86)") 

	if(MSVC10)
		find_program(MSVC_REDIST NAMES vcredist_${CMAKE_MSVC_ARCH}/vcredist_${CMAKE_MSVC_ARCH}.exe
		  PATHS
		  "$ENV{ProgramW6432}/Microsoft SDKs/Windows/v7.0A/Bootstrapper/Packages/"
		  "$ENV{PROGRAMFILES}/Microsoft SDKs/Windows/v7.0A/Bootstrapper/Packages/"
		  )
		GET_FILENAME_COMPONENT(vcredist_name "${MSVC_REDIST}" NAME)
		INSTALL(PROGRAMS ${MSVC_REDIST} COMPONENT ${Component} DESTINATION bin)
		set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "ExecWait '\\\"$INSTDIR\\\\bin\\\\${vcredist_name}\\\"'")
	endif(MSVC10)

	if(MSVC11)
		find_program(MSVC_REDIST NAMES vcredist_${CMAKE_MSVC_ARCH}.exe
		  PATHS
		  "$ENV{ProgramW6432}/Microsoft Visual Studio 11.0/VC/redist/1033/"
		  "$ENV{PROGRAMFILES}/Microsoft Visual Studio 11.0/VC/redist/1033/"
		  "$ENV{ProgramW6432}/Microsoft SDKs/Windows/v8.0A/Bootstrapper/Packages/vcredist_${CMAKE_MSVC_ARCH}/"
		  "$ENV{PROGRAMFILES}/Microsoft SDKs/Windows/v8.0A/Bootstrapper/Packages/vcredist_${CMAKE_MSVC_ARCH}/"
		  )
		GET_FILENAME_COMPONENT(vcredist_name "${MSVC_REDIST}" NAME)
		INSTALL(PROGRAMS ${MSVC_REDIST} COMPONENT ${Component} DESTINATION bin)
		set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "ExecWait '\\\"$INSTDIR\\\\bin\\\\${vcredist_name}\\\"'")
	endif(MSVC11)

	if(MSVC12)
	
		#message( STATUS ARCH=${CMAKE_MSVC_ARCH} $ENV{${MY_PFX86}} )
		find_program(MSVC_REDIST NAMES vcredist_${CMAKE_MSVC_ARCH}.exe
		  PATHS
		  "$ENV{ProgramW6432}/Microsoft Visual Studio 12.0/VC/redist/1033/"
		  "$ENV{PROGRAMFILES}/Microsoft Visual Studio 12.0/VC/redist/1033/"
		  "$ENV{${MY_PFX86}}/Microsoft Visual Studio 12.0/VC/redist/1033/"
		  )
		GET_FILENAME_COMPONENT(vcredist_name "${MSVC_REDIST}" NAME)
		INSTALL(PROGRAMS ${MSVC_REDIST} COMPONENT ${Component} DESTINATION bin)
		set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "ExecWait '\\\"$INSTDIR\\\\bin\\\\${vcredist_name}\\\"'")
	endif(MSVC12)
	if(MSVC14)
		if(MSVC_VERSION GREATER_EQUAL 1910)
		find_program(MSVC_REDIST NAMES vcredist_${CMAKE_MSVC_ARCH}.exe
		  PATHS
		  "$ENV{ProgramW6432}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.14.26405/"
		  "$ENV{PROGRAMFILES}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.14.26405/"
		  "$ENV{${MY_PFX86}}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.14.26405/"
		  )
		else()
		find_program(MSVC_REDIST NAMES vcredist_${CMAKE_MSVC_ARCH}.exe
		  PATHS
		  "$ENV{ProgramW6432}/Microsoft Visual Studio 14.0/VC/redist/1033/"
		  "$ENV{PROGRAMFILES}/Microsoft Visual Studio 14.0/VC/redist/1033/"
		  "$ENV{${MY_PFX86}}/Microsoft Visual Studio 14.0/VC/redist/1033/"
		  )
		endif()
		  
		GET_FILENAME_COMPONENT(vcredist_name "${MSVC_REDIST}" NAME)
		INSTALL(PROGRAMS ${MSVC_REDIST} COMPONENT ${Component} DESTINATION bin)
		set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS "ExecWait '\\\"$INSTDIR\\\\bin\\\\${vcredist_name}\\\"'")
	endif(MSVC14)
endmacro(PackageSystemRuntime)