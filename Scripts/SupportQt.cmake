if(WIN32)
	OPTION( SYSTEM_FORCE_CONSOLE_WINDOW "Make all programs console applications for debugging purposes." OFF)
endif(WIN32)

#########################################################################################

macro ( setup_library_qt_wrap_support )

# this command will generate rules that will run rcc on all files from UPMC_LA_RCS
# in result UPMC_LA_RC_SRCS variable will contain paths to files produced by rcc
QT4_ADD_RESOURCES( ${LOCAL_PROJECT_NAME}_RC_SRCS ${${LOCAL_PROJECT_NAME}_RCS} )

# and finally this will run moc:
if (USE_MSVC_PCH AND USE_MSVC_PCH_WITH_MOC)
	PCH_QT4_WRAP_CPP( ${LOCAL_PROJECT_NAME}PCH ${LOCAL_PROJECT_NAME}_MOC_SRCS ${${LOCAL_PROJECT_NAME}_MOC_HDRS} )
else (USE_MSVC_PCH AND USE_MSVC_PCH_WITH_MOC) 
	 QT4_WRAP_CPP( ${LOCAL_PROJECT_NAME}_MOC_SRCS ${${LOCAL_PROJECT_NAME}_MOC_HDRS} )
endif (USE_MSVC_PCH AND USE_MSVC_PCH_WITH_MOC)

# this will run uic on .ui files:
QT4_WRAP_UI( ${LOCAL_PROJECT_NAME}_UI_HDRS ${${LOCAL_PROJECT_NAME}_UIS} )

#setup_library_source_groups()

endmacro ( setup_library_qt_wrap_support )

#########################################################################################

function( setup_qt_executable ExecTarget)

	# this command will generate rules that will run rcc on all files from ${ExecTarget}_RCS
	# in result ${ExecTarget}_RC_SRCS variable will contain paths to files produced by rcc
	QT4_ADD_RESOURCES( ${ExecTarget}_RC_SRCS ${${ExecTarget}_RCS} )

	# and finally this will run moc:
	QT4_WRAP_CPP( ${ExecTarget}_MOC_SRCS ${${ExecTarget}_MOC_HDRS} )

	# this will run uic on .ui files:
	QT4_WRAP_UI( ${ExecTarget}_UI_HDRS ${${ExecTarget}_UIS} )

	SOURCE_GROUP("Generated" FILES
		  ${${ExecTarget}_RC_SRCS}
		  ${${ExecTarget}_MOC_SRCS}
		  ${${ExecTarget}_UI_HDRS}
	)

	SOURCE_GROUP("Resources" FILES
		  ${${ExecTarget}_UIS}
		  ${${ExecTarget}_RCS}
	)

	# Default GUI type is blank
	set(GUI_TYPE "")

	#-- Configure the OS X Bundle Plist
	if (APPLE)
	   SET(GUI_TYPE MACOSX_BUNDLE)
	elseif(WIN32)
		if ( SYSTEM_FORCE_CONSOLE_WINDOW )
			set(GUI_TYPE)
		else( SYSTEM_FORCE_CONSOLE_WINDOW )
			set(GUI_TYPE WIN32)
		endif(SYSTEM_FORCE_CONSOLE_WINDOW)
	endif()

	add_executable(${ExecTarget} ${GUI_TYPE} ${${ExecTarget}_SRCS} 
		${${ExecTarget}_MOC_SRCS} 
		${${ExecTarget}_HDRS}
		${${ExecTarget}_MOC_HDRS}
		${${ExecTarget}_UI_HDRS}
		${${ExecTarget}_RC_SRCS}
	)

endfunction( setup_qt_executable )

#########################################################################################

function( setup_qt_plugin PluginTargetName)
	set_target_properties(${PluginTargetName} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_DEBUG ${CMAKE_BINARY_DIR}/bin/Debug/plugins)
	set_target_properties(${PluginTargetName} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELEASE ${CMAKE_BINARY_DIR}/bin/Release/plugins)
	set_target_properties(${PluginTargetName} PROPERTIES RUNTIME_OUTPUT_DIRECTORY_RELWITHDEBINFO ${CMAKE_BINARY_DIR}/bin/RelWithDebInfo/plugins)
	set_target_properties(${PluginTargetName} PROPERTIES FOLDER Plugins)
	
	if(PACKAGE_FOR_INSTALL)
		INSTALL(TARGETS ${PluginTargetName}
			DESTINATION bin/plugins
			COMPONENT Plugins
		)
	endif(PACKAGE_FOR_INSTALL)
	
endfunction( setup_qt_plugin)

#########################################################################################