cmake_minimum_required(VERSION 2.8.12)

project(OdbCMake)

# windows section - generate paths based on ODB_ROOT 
if(${CMAKE_SYSTEM_NAME} MATCHES "Windows")
	if(DEFINED ENV{ODB_ROOT})
		set(ODB_ROOT $ENV{ODB_ROOT})
	endif(DEFINED ENV{ODB_ROOT})
    message(STATUS "Prepare variables using ODB_ROOT=${ODB_ROOT}")
	set(PC_LIBODB_INCLUDE_DIRS "${ODB_ROOT}\\include")
	set(PC_LIBODB_LIBRARY_DIRS "${ODB_ROOT}\\lib")
	set(ODB_LIBODB_INCLUDE_DIRS "${ODB_ROOT}\\include")
	set(ODB_LIBRARY_PATH "${ODB_ROOT}\\lib")
endif(${CMAKE_SYSTEM_NAME} MATCHES "Windows")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules")

find_package(ODB REQUIRED COMPONENTS mysql OPTIONAL_COMPONENTS pgsql)
include(${ODB_USE_FILE})

set(OdbCMake_SOURCES
	driver.cpp
	database.h)

set(OdbCMake_ODB_HEADERS
	person.h
  employee.h)

odb_compile(OdbCMake_SOURCES FILES ${OdbCMake_ODB_HEADERS} DB mysql GENERATE_QUERY GENERATE_SESSION INPUT_NAME "personal")

add_executable(odbcmake
	${OdbCMake_SOURCES}
	${OdbCMake_ODB_HEADERS})
target_link_libraries(odbcmake
	${ODB_LIBRARIES})
target_include_directories(odbcmake
	PRIVATE
		${ODB_INCLUDE_DIRS}
		${ODB_COMPILE_OUTPUT_DIR})
target_compile_definitions(odbcmake
	PRIVATE
		DATABASE_SQLITE)
