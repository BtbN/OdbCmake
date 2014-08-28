#
# Doc is still TODO
#

set(ODB_USE_FILE "${CMAKE_CURRENT_LIST_DIR}/UseODB.cmake")

find_package(PkgConfig QUIET)

function(find_odb_api component)
	string(TOUPPER "${component}" component_u)
	set(ODB_${component_u}_FOUND FALSE PARENT_SCOPE)

	pkg_check_modules(PC_ODB_${component} QUIET "libodb-${component}")

	find_path(ODB_${component}_INCLUDE_DIR
		NAMES odb/${component}/version.hxx
		HINTS
			${LIBODB_INCLUDE_DIRS}
			${PC_ODB_${component}_INCLUDE_DIRS})

	find_library(ODB_${component}_LIBRARY
		NAMES odb-${component} libodb-${component}
		HINTS
			${ODB_LIBRARY_PATH}
			${PC_ODB_${component}_LIBRARY_DIRS})

	set(ODB_${component_u}_INCLUDE_DIRS ${ODB_${component}_INCLUDE_DIR} CACHE STRING "ODB ${component} include dirs")
	set(ODB_${component_u}_LIBRARIES ${ODB_${component}_LIBRARY} CACHE STRING "ODB ${component} libraries")

	mark_as_advanced(ODB_${component}_INCLUDE_DIR ODB_${component}_LIBRARY)

	if(ODB_${component_u}_INCLUDE_DIRS AND ODB_${component_u}_LIBRARIES)
		set(ODB_${component_u}_FOUND TRUE PARENT_SCOPE)
		set(ODB_${component}_FOUND TRUE PARENT_SCOPE)

		list(APPEND ODB_INCLUDE_DIRS ${ODB_${component_u}_INCLUDE_DIRS})
		list(REMOVE_DUPLICATES ODB_INCLUDE_DIRS)
		set(ODB_INCLUDE_DIRS ${ODB_INCLUDE_DIRS} PARENT_SCOPE)

		list(APPEND ODB_LIBRARIES ${ODB_${component_u}_LIBRARIES})
		list(REMOVE_DUPLICATES ODB_LIBRARIES)
		set(ODB_LIBRARIES ${ODB_LIBRARIES} PARENT_SCOPE)
	endif()
endfunction()

pkg_check_modules(PC_LIBODB QUIET "libodb")

set(ODB_LIBRARY_PATH "" CACHE STRING "Common library search hint for all ODB libs")

find_path(libodb_INCLUDE_DIR
	NAMES odb/version.hxx
	HINTS
		${PC_LIBODB_INCLUDE_DIRS})

find_library(libodb_LIBRARY
	NAMES odb libodb
	HINTS
		${ODB_LIBRARY_PATH}
		${PC_LIBODB_LIBRARY_DIRS})

find_program(odb_BIN
	NAMES odb
	HINTS
		${libodb_INCLUDE_DIR}/../bin)

set(LIBODB_INCLUDE_DIRS ${libodb_INCLUDE_DIR} CACHE STRING "ODB libodb include dirs")
set(LIBODB_LIBRARIES ${libodb_LIBRARY} CACHE STRING "ODB libodb library")
set(ODB_EXECUTABLE ${odb_BIN} CACHE STRING "ODB executable")

mark_as_advanced(libodb_INCLUDE_DIR libodb_LIBRARY odb_BIN)

if(LIBODB_INCLUDE_DIRS AND LIBODB_LIBRARIES)
	set(LIBODB_FOUND TRUE)
endif()

set(ODB_INCLUDE_DIRS ${LIBODB_INCLUDE_DIRS})
set(ODB_LIBRARIES ${LIBODB_LIBRARIES})

foreach(component ${ODB_FIND_COMPONENTS})
	find_odb_api(${component})
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ODB
	FOUND_VAR ODB_FOUND
	REQUIRED_VARS ODB_EXECUTABLE LIBODB_FOUND
	HANDLE_COMPONENTS)
