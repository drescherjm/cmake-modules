# Find the Qwt 5.x includes and library, either the version linked to Qt3 or the version linked to Qt4
#
# On Windows it makes these assumptions:
#    - the Qwt DLL is where the other DLLs for Qt are (QT_DIR\bin) or in the path
#    - the Qwt .h files are in QT_DIR\include\Qwt or in the path
#    - the Qwt .lib is where the other LIBs for Qt are (QT_DIR\lib) or in the path
#
# QWT_INCLUDE_DIR - where to find qwt.h if Qwt
# Qwt5_Qt4_LIBRARY - The Qwt5 library linked against Qt4 (if it exists)
# Qwt5_Qt3_LIBRARY - The Qwt5 library linked against Qt4 (if it exists)
# Qwt5_Qt4_FOUND   - Qwt5 was found and uses Qt4
# Qwt5_Qt3_FOUND   - Qwt5 was found and uses Qt3
# Qwt5_FOUND - Set to TRUE if Qwt5 was found (linked either to Qt3 or Qt4)

# Copyright (c) 2007, Pau Garcia i Quiles, <pgquiles@elpauer.org>
#
# Redistribution and use is allowed according to the terms of the BSD license.
# For details see the accompanying COPYING-CMAKE-SCRIPTS file.


IF (NOT SYSTEM_LIBRARY_ROOT)
	if ($ENV{SYSTEM_LIBRARY_ROOT})
		string (REPLACE "\\" "/" LIB_ROOT_DIR $ENV{SYSTEM_LIBRARY_ROOT})
		MESSAGE( STATUS ${LIB_ROOT_DIR})
		SET (SYSTEM_LIBRARY_ROOT ${LIB_ROOT_DIR} CACHE PATH "Please set the root path where system libararies are installed.") 
	else($ENV{SYSTEM_LIBRARY_ROOT})
		# MESSAGE( FATAL_ERROR "Please either set the
	endif($ENV{SYSTEM_LIBRARY_ROOT})
ENDIF(NOT SYSTEM_LIBRARY_ROOT)

# IF(NOT (QT4_FOUND OR Qt5_FOUND) )

	# FIND_PACKAGE( Qt4 REQUIRED QUIET )
# ENDIF(NOT QT4_FOUND)

IF( QT4_FOUND )
	# Is QWT installed? Look for header files
	FIND_PATH( QWT_INCLUDE_DIR qwt_global.h 
               PATHS ${QT_INCLUDE_DIR} ${SYSTEM_LIBRARY_ROOT} /usr/local/qwt/include /usr/include/qwt 
               PATH_SUFFIXES qwt qwt5 qwt-qt4 qwt5-qt4 qwt-qt3 qwt5-qt3 include qwt/include qwt5/include qwt-qt4/include qwt5-qt4/include qwt-qt3/include qwt5-qt3/include ENV PATH)
		
	# Find Qwt version
	IF( EXISTS ${QWT_INCLUDE_DIR} )
	
		SET( QWT_FOUND 1)
	
		FILE( READ ${QWT_INCLUDE_DIR}/qwt_global.h QWT_GLOBAL_H )
		STRING( REGEX MATCH "#define *QWT_VERSION[\\t\\ ]+(0x05)" QWT_IS_VERSION_5 ${QWT_GLOBAL_H})
		STRING( REGEX MATCH "#define *QWT_VERSION[\\t\\ ]+(0x06)" QWT_IS_VERSION_6 ${QWT_GLOBAL_H})

		SET( QWT_BASE Qwt )
		
		IF(MSVC90)
			SET(QWT_COMPILER_STR "_2008")
		ENDIF(MSVC90)
		
		IF(MSVC80)
			SET(QWT_COMPILER_STR "_2005")
		ENDIF(MSVC80)
		
		IF(MSVC10)
			SET(QWT_COMPILER_STR "_2010")
		ENDIF(MSVC10)
		
		IF(MSVC11)
			SET(QWT_COMPILER_STR "_2012")
		ENDIF(MSVC11)
		
		IF(MSVC12)
			SET(QWT_COMPILER_STR "_2013")
		ENDIF(MSVC12)
		
		IF(CMAKE_SIZEOF_VOID_P MATCHES 8)
			SET(QWT_ARCH_STR "_x64")
		ELSE(CMAKE_SIZEOF_VOID_P MATCHES 8)
			SET(QWT_ARCH_STR "")
		ENDIF(CMAKE_SIZEOF_VOID_P MATCHES 8)
		
		IF( QWT_IS_VERSION_5 )
			STRING(REGEX REPLACE ".*#define[\\t\\ ]+QWT_VERSION_STR[\\t\\ ]+\"([0-9]+\\.[0-9]+\\.[0-9]+)[-_\"].*" "\\1" QWT_VERSION "${QWT_GLOBAL_H}")
			
			MESSAGE( STATUS "Found QWT5: VERSION=" ${QWT_VERSION})
			SET( QWT_VERSION_MAJOR 5 )
			
			FIND_LIBRARY(QWT_LIB_RELEASE NAME ${QWT_BASE}${QWT_COMPILER_STR}${QWT_ARCH_STR}_${QWT_VERSION_MAJOR}
			PATH_SUFFIXES Qwt/lib64 Qwt/lib lib64 lib
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
			"${QWT_INCLUDE_DIR}/.."
			NO_DEFAULT_PATH
		)
		
		FIND_LIBRARY(QWT_LIB_DEBUG NAME  ${QWT_BASE}${QWT_COMPILER_STR}${QWT_ARCH_STR}_d${QWT_VERSION_MAJOR}
			PATH_SUFFIXES Qwt/lib64 Qwt/lib lib64 lib
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
			"${QWT_INCLUDE_DIR}/.."
			NO_DEFAULT_PATH
		)
		
		ENDIF( QWT_IS_VERSION_5 )
		
		IF( QWT_IS_VERSION_6 )
			STRING(REGEX REPLACE ".*#define[\\t\\ ]+QWT_VERSION_STR[\\t\\ ]+\"([0-9]+\\.[0-9]+\\.[0-9]+)[-_\"].*" "\\1" QWT_VERSION "${QWT_GLOBAL_H}")
			
			MESSAGE( STATUS "Found QWT6: VERSION=" ${QWT_VERSION})
					
			FIND_LIBRARY(QWT_LIB_RELEASE NAME ${QWT_BASE}-${QWT_VERSION}${QWT_COMPILER_STR}${QWT_ARCH_STR}
			PATH_SUFFIXES Qwt/lib64 Qwt/lib lib64 lib
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
			"${QWT_INCLUDE_DIR}/.."
			NO_DEFAULT_PATH
		)
		
		FIND_LIBRARY(QWT_LIB_DEBUG NAME  ${QWT_BASE}-${QWT_VERSION}${QWT_COMPILER_STR}${QWT_ARCH_STR}_d
			PATH_SUFFIXES Qwt/lib64 Qwt/lib lib64 lib
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
			"${QWT_INCLUDE_DIR}/.."
			NO_DEFAULT_PATH
		)
		ENDIF( QWT_IS_VERSION_6 )

		SET(QWT_LIBRARIES ${QWT_LIBRARIES};optimized;${QWT_LIB_RELEASE};debug;${QWT_LIB_DEBUG})
		
		add_definitions(-DQWT_DLL)
				
		MARK_AS_ADVANCED( QWT_INCLUDE_DIR QWT_LIB_RELEASE QWT_LIB_DEBUG )
		
	ENDIF( EXISTS ${QWT_INCLUDE_DIR} )

   	IF (NOT QWT_FOUND )
      		MESSAGE(FATAL_ERROR "Could not find Qwt")
   	ENDIF (NOT QWT_FOUND )

ENDIF( QT4_FOUND )
