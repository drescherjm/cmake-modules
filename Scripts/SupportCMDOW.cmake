if(WIN32)
	option(USE_CMDOW_TO_MANIPULATE_NETSERVER_WINDOWS "Use cmdow with the network server" ON)
	
	if ( USE_CMDOW_TO_MANIPULATE_NETSERVER_WINDOWS ) 
		
		FIND_PROGRAM(CMDOW_EXECUTABLE NAME cmdow.exe PATHS C:/Utils/Other )

		if ( (${CMDOW_EXECUTABLE} MATCHES "RUNJOBS_EXECUTABLE_NOTFOUND") OR (NOT EXISTS ${CMDOW_EXECUTABLE}) )
			message( FATAL_ERROR "Please set the location of the cmdow executable or disable the cmdow feature." )
		endif ( (${CMDOW_EXECUTABLE} MATCHES "RUNJOBS_EXECUTABLE_NOTFOUND") OR (NOT EXISTS ${CMDOW_EXECUTABLE}))
			
	endif( USE_CMDOW_TO_MANIPULATE_NETSERVER_WINDOWS )
	
endif(WIN32)