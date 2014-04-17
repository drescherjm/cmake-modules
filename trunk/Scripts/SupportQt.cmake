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

setup_library_source_groups()

endmacro ( setup_library_qt_wrap_support )

#########################################################################################