#############
## basic FindQxt.cmake
## This is an *EXTREMELY BASIC* cmake find/config file for
## those times you have a cmake project and wish to use
## libQxt.
##
## It should be noted that at the time of writing, that
## I (mschnee) have an extremely limited understanding of the
## way Find*.cmake files work, but I have attempted to
## emulate what FindQt4.cmake and a few others do.
##
##  To enable a specific component, set your QXT_USE_${modname}:
##  SET(QXT_USE_QXTCORE TRUE)
##  SET(QXT_USE_QXTGUI FALSE)
##  Currently available components:
##  QxtCore, QxtGui, QxtNetwork, QxtWeb, QxtSql
##  Auto-including directories are enabled with INCLUDE_DIRECTORIES(), but
##  can be accessed if necessary via ${QXT_INCLUDE_DIRS}
##
## To add the libraries to your build, TARGET_LINK_LIBRARIES(), such as...
##  TARGET_LINK_LIBRARIES(YourTargetNameHere ${QXT_LIBRARIES})
## ...or..
##  TARGET_LINK_LIBRARIES(YourTargetNameHere ${QT_LIBRARIES} ${QXT_LIBRARIES})
################### TODO:
##      The purpose of this cmake file is to find what components
##  exist, regardless of how libQxt was build or configured, thus
##  it should search/find all possible options.  As I am not aware
##  that any module requires anything special to be used, adding all
##  modules to ${QXT_MODULES} below should be sufficient.
##      Eventually, there should be version numbers, but
##  I am still too unfamiliar with cmake to determine how to do
##  version checks and comparisons.
##      At the moment, this cmake returns a failure if you
##  try to use a component that doesn't exist.  I don't know how to
##  set up warnings.
##      It would be nice having a FindQxt.cmake and a UseQxt.cmake
##  file like done for Qt - one to check for everything in advance

##############

define_from_environment(QXT_DIR Qxt)

if (VCPKG_TARGET_TRIPLET) 
	if (NOT QXT_VERSION)
		find_path(QXT_INCLUDE_DIR
			NAMES
				qxtversion.h
			HINTS
				${_QXT_INCLUDEDIR}
				${_QXT_ROOT_HINTS_AND_PATHS}
			PATH_SUFFIXES
				include
				"include/qxt"
		)	
	
		if (EXISTS "${QXT_INCLUDE_DIR}/qxtversion.h")
			file(READ "${QXT_INCLUDE_DIR}/qxtversion.h" QXT_VERSION_CONTENT)

			string(REGEX MATCH "#define +QXT_VER_MAJOR +([0-9]+)" _dummy "${QXT_VERSION_CONTENT}")
			set(QXT_VER_MAJOR "${CMAKE_MATCH_1}")

			string(REGEX MATCH "#define +QXT_VER_MINOR +([0-9]+)" _dummy "${QXT_VERSION_CONTENT}")
			set(QXT_VER_MINOR "${CMAKE_MATCH_1}")

			string(REGEX MATCH "#define +QXT_VER_PATCH +([0-9]+)" _dummy "${QXT_VERSION_CONTENT}")
			set(QXT_VER_PATCH "${CMAKE_MATCH_1}")

			set(QXT_VERSION "${QXT_VER_MAJOR}.${QXT_VER_MINOR}.${QXT_VER_PATCH}")
			set(QXT_VERSION_STRING QXT_VERSION)
			
		endif ()
	endif()
endif()

if ( (NOT DEFINED QXT_FIND_COMPONENTS) OR ("${QXT_FIND_COMPONENTS}" STREQUAL ""))
	message( FATAL_ERROR "Please populate QXT_FIND_COMPONENTS before find_package(Qxt REQUIRED)")
endif()

# Look for Qxt in $ENV{CMAKE_SYSTEM_BUILD_ROOT}/Libraries/Qxt-$ENV{QXT_VERSION}
if (NOT DEFINED ${QXT_DIR} OR ${QXT_DIR} STREQUAL "")
	
	if (NOT "$ENV{CMAKE_SYSTEM_BUILD_ROOT}" STREQUAL "")
		if (NOT "$ENV{QXT_VERSION}" STREQUAL "")
		  FIND_PATH(QXT_DIR 
		  NAMES Build Include
		  PATHS 
			$ENV{CMAKE_SYSTEM_BUILD_ROOT}/Libraries/Qxt-$ENV{QXT_VERSION}
			NO_DEFAULT_PATH
		  )
		endif(NOT "$ENV{QXT_VERSION}" STREQUAL "")
	endif(NOT "$ENV{CMAKE_SYSTEM_BUILD_ROOT}" STREQUAL "")
	
	if (NOT DEFINED VERSION_STR_TO_INTS)
		Include(${PROJECT_SOURCE_DIR}/CMake/External/Scripts/HelperMacros.cmake)
	endif()
endif(NOT DEFINED ${QXT_DIR} OR ${QXT_DIR} STREQUAL "")

if ("${QXT_VER_MAJOR}" STREQUAL "")
	set( QXT_VER_MAJOR )
	set( QXT_VER_MINOR )
	set( QXT_VER_PATCH )

	VERSION_STR_TO_INTS( QXT_VER_MAJOR QXT_VER_MINOR QXT_VER_PATCH $ENV{QXT_VERSION} )
endif()

if (QXT_VER_MAJOR GREATER 6)
	SET(QXT_MODULES QxtWidgets QxtWeb QxtZeroConf QxtNetwork QxtSql QxtBerkeley QxtCore)
	string( REPLACE QxtGui QxtWidgets QXT_FIND_COMPONENTS ${QXT_FIND_COMPONENTS})
else()
	SET(QXT_MODULES QxtGui QxtWeb QxtZeroConf QxtNetwork QxtSql QxtBerkeley QxtCore)
endif()

# Add each component so we do not need to set USE variables if the QXT_FIND_COMPONENTS variable is populated.
if (QXT_FIND_COMPONENTS)
	string (REPLACE "," ";" QXT_LIB_NAMES ${QXT_FIND_COMPONENTS})
	FOREACH(component ${QXT_LIB_NAMES})
		STRING(TOUPPER ${component} U_MOD)
		SET(QXT_USE_${U_MOD} TRUE)
	ENDFOREACH(component)
endif (QXT_FIND_COMPONENTS)

SET(QXT_FOUND_MODULES)
FOREACH(mod ${QXT_MODULES})
	STRING(TOUPPER ${mod} U_MOD)
	SET(QXT_${U_MOD}_INCLUDE_DIR NOTFOUND)
	SET(QXT_${U_MOD}_LIB_DEBUG NOTFOUND)
	SET(QXT_${U_MOD}_LIB_RELEASE NOTFOUND)
	SET(QXT_FOUND_${U_MOD} FALSE)
ENDFOREACH(mod)

SET(QXT_QXTWIDGETS_DEPENDSON QxtCore)
SET(QXT_QXTGUI_DEPENDSON QxtCore)
SET(QXT_QXTWEB_DEPENDSON QxtCore QxtNetwork)
SET(QXT_QXTZEROCONF_DEPENDSON QxtCore QxtNetwork)
SET(QXT_QXTNETWORK_DEPENDSON QxtCore)
SET(QXT_QXTQSQL_DEPENDSON QxtCore)
SET(QXT_QXTBERKELEY_DEPENDSON QxtCore)

#message( STATUS CMAKE_SHARED_LIBRARY_SUFFIX=${CMAKE_SHARED_LIBRARY_SUFFIX} )

#FIND_PATH(QXT_DIR libqxt.pro Qxt/include/QxtCore/Qxt)
FIND_PATH(QXT_BINARY_DIR 
	NAMES QxtCore${CMAKE_SHARED_LIBRARY_SUFFIX} QxtCored${CMAKE_SHARED_LIBRARY_SUFFIX} 
	PATHS ${QXT_DIR}/bin ${QXT_DIR}/Bin 
	NO_DEFAULT_PATH
)

if (VCPKG_TARGET_TRIPLET) 
    #unset(QXT_BINARY_DIR_RELEASE CACHE)
	#unset(QXT_BINARY_DIR_DEBUG CACHE)
	
	message(STATUS VCPKG_DIR -> ${_VCPKG_INSTALLED_DIR}/${VCPKG_TARGET_TRIPLET})
	
	message(STATUS CMAKE_PREFIX_PATH= ${QXT_INCLUDE_DIR})
	
	FIND_PATH(QXT_BINARY_DIR_RELEASE 
		NAME QxtCore${CMAKE_SHARED_LIBRARY_SUFFIX}
		PATH_SUFFIXES "bin" 
	)
	
	if (NOT QXT_BINARY_DIR_RELEASE)
	
			message(STATUS "Could not find QXT_BINARY_DIR_RELEASE using the prefix attempting to use QXT_INCLUDE_DIR")
	
			FIND_PATH(QXT_BINARY_DIR_RELEASE 
				NAME QxtCore${CMAKE_SHARED_LIBRARY_SUFFIX}
				PATH_SUFFIXES "/bin" "/../bin" "/../../bin" "/../../../bin"
				PATHS "${QXT_INCLUDE_DIR}/../.." "${QXT_INCLUDE_DIR}/.." "${QXT_INCLUDE_DIR}/../../.."
				NO_DEFAULT_PATH
			)
	endif()
			
	FIND_PATH(QXT_BINARY_DIR_DEBUG
		NAME QxtCored${CMAKE_SHARED_LIBRARY_SUFFIX}
		PATH_SUFFIXES "debug/bin" 
	)
	
	if (NOT QXT_BINARY_DIR_DEBUG)
	
		message(STATUS "Could not find QXT_BINARY_DIR_DEBUG using the prefix attempting to use QXT_INCLUDE_DIR")
	
		FIND_PATH(QXT_BINARY_DIR_DEBUG 
			NAME QxtCored${CMAKE_SHARED_LIBRARY_SUFFIX}
			PATH_SUFFIXES debug/bin ../debug/bin
			PATHS "${QXT_INCLUDE_DIR}/../.." "${QXT_INCLUDE_DIR}/.." "${QXT_INCLUDE_DIR}/../../.."
			NO_DEFAULT_PATH 
		)
	endif()
			
else()
	FIND_PATH(QXT_BINARY_DIR_RELEASE 
		NAME QxtCore${CMAKE_SHARED_LIBRARY_SUFFIX}
		PATHS ${QXT_DIR}/bin ${QXT_DIR}/Bin 
	)

	FIND_PATH(QXT_BINARY_DIR_DEBUG 
		NAME QxtCored${CMAKE_SHARED_LIBRARY_SUFFIX}
		PATHS ${QXT_DIR}/bin ${QXT_DIR}/Bin 
	)
endif()

if (NOT QXT_BINARY_DIR_RELEASE)
	message( WARNING "Could not find the QXT_BINARY_DIR_RELEASE")
endif()

if (NOT QXT_BINARY_DIR_DEBUG)
	message( WARNING "Could not find the QXT_BINARY_DIR_DEBUG")
endif()

#dump_all_variables()

#message(FATAL_ERROR QXT_BINARY_DIR_RELEASE=${QXT_BINARY_DIR_RELEASE} QxtCore${CMAKE_SHARED_LIBRARY_SUFFIX})

#SET(QXT_BINARY_DIR "${QXT_DIR}/bin" CACHE PATH "${QXT_DIR}/bin")

FOREACH(mod ${QXT_MODULES})
	STRING(TOUPPER ${mod} U_MOD)
	FIND_PATH(QXT_${U_MOD}_INCLUDE_DIR ${mod}
		PATH_SUFFIXES ${mod} include/${mod} Qxt/include/${mod} include/Qxt/${mod}
		PATHS
		~/Library/Frameworks/
		/Library/Frameworks/
		/sw/
		/usr/local/
		/usr
		/opt/local/
		/opt/csw
		/opt
		"C:\\"
		"C:\\Program Files\\"
		"C:\\Program Files(x86)\\"
		${QXT_INCLUDE_DIR}/include
		${QXT_DIR}
		NO_DEFAULT_PATH
	)
	FIND_LIBRARY(QXT_${U_MOD}_LIB_RELEASE NAME ${mod}
		PATH_SUFFIXES Qxt/lib64 Qxt/lib lib64 lib
		PATHS
		/sw
		/usr/local
		/usr
		/opt/local
		/opt/csw
		/opt
		"C:\\"
		"C:\\Program Files"
		"C:\\Program Files(x86)"
		${QXT_DIR}
		NO_DEFAULT_PATH
	)
	FIND_LIBRARY(QXT_${U_MOD}_LIB_DEBUG NAME ${mod}d
		PATH_SUFFIXES Qxt/lib64 Qxt/lib lib64 lib
		PATHS
		/sw
		/usr/local
		/usr
		/opt/local
		/opt/csw
		/opt
		"C:\\"
		"C:\\Program Files"
		"C:\\Program Files(x86)"
		${QXT_DIR}
		NO_DEFAULT_PATH
	)
	IF (QXT_${U_MOD}_LIB_RELEASE)
		SET(QXT_FOUND_MODULES "${QXT_FOUND_MODULES} ${mod}")
	else()
		message(STATUS "Could not find ${mod}")
	ENDIF (QXT_${U_MOD}_LIB_RELEASE)

	IF (QXT_${U_MOD}_LIB_DEBUG)
		SET(QXT_FOUND_MODULES "${QXT_FOUND_MODULES} ${mod}")
	ENDIF (QXT_${U_MOD}_LIB_DEBUG)
ENDFOREACH(mod)

FOREACH(mod ${QXT_MODULES})
	STRING(TOUPPER ${mod} U_MOD)
	IF(QXT_${U_MOD}_INCLUDE_DIR AND QXT_${U_MOD}_LIB_RELEASE)
		SET(QXT_FOUND_${U_MOD} TRUE)
	ENDIF(QXT_${U_MOD}_INCLUDE_DIR AND QXT_${U_MOD}_LIB_RELEASE)
ENDFOREACH(mod)


##### find and include
# To use a Qxt Library....
#   SET(QXT_FIND_COMPONENTS QxtCore, QxtGui)
# ...and this will do the rest
IF( QXT_FIND_COMPONENTS )
	FOREACH( component ${QXT_FIND_COMPONENTS} )
		STRING( TOUPPER ${component} _COMPONENT )
		SET(QXT_USE_${_COMPONENT}_COMPONENT TRUE)
	ENDFOREACH( component )
ENDIF( QXT_FIND_COMPONENTS )

SET(QXT_LIBRARIES "")
SET(QXT_INCLUDE_DIRS "")

# like FindQt4.cmake, in order of dependence
FOREACH( module ${QXT_MODULES} )
	STRING(TOUPPER ${module} U_MOD)
	IF(QXT_USE_${U_MOD} OR QXT_DEPENDS_${U_MOD})
		IF(QXT_FOUND_${U_MOD})
			#message( STATUS Module=${U_MOD} " " Include=${QXT_${U_MOD}_INCLUDE_DIR} )
			STRING(REPLACE "QXT" "" qxt_module_def "${U_MOD}")
			ADD_DEFINITIONS(-DQXT_${qxt_module_def}_LIB)
			SET(QXT_INCLUDE_DIRS ${QXT_INCLUDE_DIRS} ${QXT_${U_MOD}_INCLUDE_DIR})
			INCLUDE_DIRECTORIES(${QXT_${U_MOD}_INCLUDE_DIR})
			SET(QXT_LIBRARIES ${QXT_LIBRARIES};optimized;${QXT_${U_MOD}_LIB_RELEASE};debug;${QXT_${U_MOD}_LIB_DEBUG})
		ELSE(QXT_FOUND_${U_MOD})
			MESSAGE(FATAL_ERROR "Could not find Qxt Module ${module}")
			RETURN()
		ENDIF(QXT_FOUND_${U_MOD})
		FOREACH(dep QXT_${U_MOD}_DEPENDSON)
			SET(QXT_DEPENDS_${dep} TRUE)
		ENDFOREACH(dep)
	ENDIF(QXT_USE_${U_MOD} OR QXT_DEPENDS_${U_MOD})
ENDFOREACH(module)

MESSAGE( STATUS "Found Qxt Libraries:${QXT_FOUND_MODULES}")
MESSAGE( STATUS "Qxt Include directories:${QXT_INCLUDE_DIRS}")

#dump_all_variables_starting_with( QXT )

dump_all_variables_starting_with( _VCPKG )