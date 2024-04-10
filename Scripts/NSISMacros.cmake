# This file contains macros and functions that help with the CPackNSIS module.

#########################################################################################

macro( NSIS_CREATE_DIRECTORY FolderPath )

	string( REPLACE "\\" "\\\\" FolderPathNew "${FolderPath}" )
	
	message( STATUS FolderPathNew="${FolderPathNew}" )

	# Create extra start menu folder for Admin tasks 
	set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS 
		${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
		"\\n  CreateDirectory \\\"${FolderPathNew}\\\" "
	)
	
	# Uninstall remove extra start menu folder for Admin tasks 
	set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS 
		"\\n  RMDir \\\"${FolderPathNew}\\\" "
		${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
	)
	
endmacro( NSIS_CREATE_DIRECTORY )

#########################################################################################

macro( NSIS_CREATE_DIRECTORY_NO_EXTRA_ESCAPING FolderPathNew )
	
	message( STATUS FolderPathNew="${FolderPathNew}" )

	# Create extra start menu folder for Admin tasks 
	set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS 
		${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
		"\n  CreateDirectory \"${FolderPathNew}\" "
	)
	
	# Uninstall remove extra start menu folder for Admin tasks 
	set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS 
		"\n  RMDir \"${FolderPathNew}\" "
		${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
	)
	
endmacro( NSIS_CREATE_DIRECTORY_NO_EXTRA_ESCAPING )

#########################################################################################

macro( NSIS_CREATE_SHORTCUT ShortCutName ShortCutTarget )

	string( REPLACE "\\" "\\\\" ShortCutNameNew "${ShortCutName}" )
	string( REPLACE "\\" "\\\\" ShortCutTargetNew "${ShortCutTarget}" )
		
	set(result)
	foreach(VALUE ${ARGN})
		string( REPLACE "\\" "\\\\" VALUENew "${VALUE}" )
		if ( "${result}" STREQUAL "" )
			set(result "\\n  CreateShortCut \\\"${ShortCutNameNew}\\\" \\\"${ShortCutTargetNew}\\\" \\\"${VALUENew}\\\" ")
		else()
			set(result "${result} \\\"${VALUENew}\\\" ")
		endif()
	endforeach(VALUE)
	
	#message( STATUS ARGC=${ARGC} )
	
	if ( ${ARGC} LESS 3 )
		set(result "\\n  CreateShortCut \\\"${ShortCutNameNew}\\\" \\\"${ShortCutTargetNew}\\\" ")
	endif (  ${ARGC} LESS 3 )
	
	# Create extra start menu folder for Admin tasks 
	set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS 
		${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
		"${result}"
	)

	# Uninstall remove extra start menu folder for Admin tasks 
	set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS 
		"\\n  Delete \\\"${ShortCutNameNew}\\\" " 
		${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
	)

endmacro( NSIS_CREATE_SHORTCUT )

#########################################################################################

macro( NSIS_CREATE_SHORTCUT_NO_EXTRA_ESCAPING ShortCutNameNew ShortCutTargetNew )

	#string( REPLACE "\\" "\\\\" ShortCutNameNew "${ShortCutName}" )
	#string( REPLACE "\\" "\\\\" ShortCutTargetNew "${ShortCutTarget}" )
		
	set(result)
	foreach(VALUENew ${ARGN})
		#string( REPLACE "\\" "\\\\" VALUENew "${VALUE}" )
		if ( "${result}" STREQUAL "" )
			set(result "\n  CreateShortCut \"${ShortCutNameNew}\" \"${ShortCutTargetNew}\" \"${VALUENew}\" ")
		else()
			set(result "${result} \"${VALUENew}\" ")
		endif()
	endforeach(VALUENew)
	
	#message( STATUS Result=${result} )
	
	if ( ${ARGC} LESS 3 )
		set(result "\n  CreateShortCut \"${ShortCutNameNew}\" \"${ShortCutTargetNew}\" ")
	endif (  ${ARGC} LESS 3 )
	
	# Create extra start menu folder for Admin tasks 
	set(CPACK_NSIS_EXTRA_INSTALL_COMMANDS 
		${CPACK_NSIS_EXTRA_INSTALL_COMMANDS}
		"${result}"
	)

	# Uninstall remove extra start menu folder for Admin tasks 
	set(CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS 
		"\n  Delete \"${ShortCutNameNew}\" " 
		${CPACK_NSIS_EXTRA_UNINSTALL_COMMANDS}
	)

endmacro( NSIS_CREATE_SHORTCUT_NO_EXTRA_ESCAPING )

#########################################################################################