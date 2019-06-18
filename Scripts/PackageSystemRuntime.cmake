macro ( PackageSystemRuntime Component )

	 set(MY_PFX86 "PROGRAMFILES(X86)") 
	 
	# MESSAGE( STATUS MSVC_VERSION=${MSVC_VERSION} )
	# MESSAGE( STATUS CMAKE_CXX_COMPILER_VERSION=${CMAKE_CXX_COMPILER_VERSION} )
	 
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
		if(MSVC_VERSION GREATER_EQUAL 1920 AND MSVC_VERSION LESS 1930)
		find_program(MSVC_REDIST NAMES vcredist_${CMAKE_MSVC_ARCH}.exe
		  PATHS
		  "$ENV{ProgramW6432}/Microsoft Visual Studio/2019/Community/VC/Redist/MSVC/14.20.27508/"
		  "$ENV{PROGRAMFILES}/Microsoft Visual Studio/2019/Community/VC/Redist/MSVC/14.20.27508/"
		  "$ENV{${MY_PFX86}}/Microsoft Visual Studio/2019/Community/VC/Redist/MSVC/14.20.27508/"
		  "$ENV{ProgramW6432}/Microsoft Visual Studio/2019/Community/VC/Redist/MSVC/14.21.27702/"
		  "$ENV{PROGRAMFILES}/Microsoft Visual Studio/2019/Community/VC/Redist/MSVC/14.21.27702/"
		  "$ENV{${MY_PFX86}}/Microsoft Visual Studio/2019/Community/VC/Redist/MSVC/14.21.27702/"
		  )
		elseif(MSVC_VERSION GREATER_EQUAL 1910 AND MSVC_VERSION LESS 1920)
		find_program(MSVC_REDIST NAMES vcredist_${CMAKE_MSVC_ARCH}.exe
		  PATHS
		  "$ENV{ProgramW6432}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.16.27012/"
		  "$ENV{PROGRAMFILES}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.16.27012/"
		  "$ENV{${MY_PFX86}}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.16.27012/"
		  "$ENV{ProgramW6432}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.14.26405/"
		  "$ENV{PROGRAMFILES}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.14.26405/"
		  "$ENV{${MY_PFX86}}/Microsoft Visual Studio/2017/Community/VC/Redist/MSVC/14.14.26405/"
		  )
		elseif(MSVC_VERSION GREATER_EQUAL 1900 AND MSVC_VERSION LESS 1910)
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