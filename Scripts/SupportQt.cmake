#########################################################################################

set(${PROJECT_NAME}_QT_VERSION "4" CACHE STRING "Expected Qt version")
mark_as_advanced(${PROJECT_NAME}_QT_VERSION)

set_property(CACHE ${PROJECT_NAME}_QT_VERSION PROPERTY STRINGS 4 5)

if(NOT (${PROJECT_NAME}_QT_VERSION VERSION_EQUAL "4" OR ${PROJECT_NAME}_QT_VERSION VERSION_EQUAL "5"))
	message(FATAL_ERROR "Expected value for ${PROJECT_NAME}_QT_VERSION is either '4' or '5'")
endif()

#########################################################################################

if(${PROJECT_NAME}_QT_VERSION VERSION_GREATER "4")
	define_from_environment(QT_DIR Qt)
	
	#find_path(QT_CMAKE_PATH NAME CMake PATHS ${QT_DIR} ${QT_DIR}/qtbase NO_DEFAULT_PATH)
	
	if( IS_DIRECTORY ${QT_DIR}/qtbase/lib/cmake ) 
		#set_property(CACHE QT_CMAKE_PATH PROPERTY PATH ${QT_DIR}/qtbase/lib/cmake)
		set(QT_CMAKE_PATH ${QT_DIR}/qtbase/lib/cmake CACHE PATH "Set the path to help cmake find Qt5 via the .cmake files in the Qt5 build." FORCE)
	endif()
	
endif()

#########################################################################################

function( find_qt5_packages )
	foreach(MODULE ${QT_MODULES}) 
		if ( NOT TARGET ${MODULE} ) 
		
			STRING( REPLACE ":" "" COMPONENT ${MODULE})
			message( STATUS "Looking for module: ${MODULE} ${COMPONENT}")
			
			find_package(${COMPONENT} REQUIRED ${QT_CMAKE_PATH})
			include_directories(${${COMPONENT}_INCLUDE_DIRS})
			add_definitions(${${COMPONENT}_DEFINITIONS})
			
			
			
		endif()
	endforeach()
endfunction( find_qt5_packages )

#########################################################################################

if(WIN32)
	OPTION( SYSTEM_FORCE_CONSOLE_WINDOW "Make all Qt applications console applications for debugging purposes." OFF)
endif(WIN32)

#########################################################################################

macro ( setup_library_qt_wrap_support )

	if(${PROJECT_NAME}_QT_VERSION VERSION_GREATER "4")
		
		# this command will generate rules that will run rcc on all files from UPMC_LA_RCS
		# in result UPMC_LA_RC_SRCS variable will contain paths to files produced by rcc
		QT5_ADD_RESOURCES( ${LOCAL_PROJECT_NAME}_RC_SRCS ${${LOCAL_PROJECT_NAME}_RCS} )

		# and finally this will run moc:
		QT5_WRAP_CPP( ${LOCAL_PROJECT_NAME}_MOC_SRCS ${${LOCAL_PROJECT_NAME}_MOC_HDRS} )
		
		# this will run uic on .ui files:
		QT5_WRAP_UI( ${LOCAL_PROJECT_NAME}_UI_HDRS ${${LOCAL_PROJECT_NAME}_UIS} )
	else()
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
	endif()

endmacro ( setup_library_qt_wrap_support )

#########################################################################################

function( setup_qt_executable ExecTarget)

	if(${PROJECT_NAME}_QT_VERSION VERSION_GREATER "4")
		# this command will generate rules that will run rcc on all files from ${ExecTarget}_RCS
		# in result ${ExecTarget}_RC_SRCS variable will contain paths to files produced by rcc
		QT5_ADD_RESOURCES( ${ExecTarget}_RC_SRCS ${${ExecTarget}_RCS} )

		# and finally this will run moc:
		QT5_WRAP_CPP( ${ExecTarget}_MOC_SRCS ${${ExecTarget}_MOC_HDRS} )

		# this will run uic on .ui files:
		QT5_WRAP_UI( ${ExecTarget}_UI_HDRS ${${ExecTarget}_UIS} )
	else()
		# this command will generate rules that will run rcc on all files from ${ExecTarget}_RCS
		# in result ${ExecTarget}_RC_SRCS variable will contain paths to files produced by rcc
		QT4_ADD_RESOURCES( ${ExecTarget}_RC_SRCS ${${ExecTarget}_RCS} )

		# and finally this will run moc:
		QT4_WRAP_CPP( ${ExecTarget}_MOC_SRCS ${${ExecTarget}_MOC_HDRS} )

		# this will run uic on .ui files:
		QT4_WRAP_UI( ${ExecTarget}_UI_HDRS ${${ExecTarget}_UIS} )
	endif()

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