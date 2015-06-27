cmake_minimum_required(VERSION 2.8.12)

project(OdbCMake)

option (AT_ONCE "Build all structures into one file." FALSE)

set(TARGET_DB "sqlite")

list(APPEND CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake/Modules")

find_package(ODB REQUIRED COMPONENTS ${TARGET_DB} OPTIONAL_COMPONENTS pgsql)
include(${ODB_USE_FILE})

set(OdbCMake_SOURCES
	driver.cpp
	database.h)

set(OdbCMake_ODB_HEADERS
	person.h
  employee.h)

if (AT_ONCE)
	message(STATUS "All database code in one file personal_*")
	odb_compile(OdbCMake_SOURCES FILES ${OdbCMake_ODB_HEADERS} DB ${TARGET_DB} GENERATE_QUERY GENERATE_SESSION INPUT_NAME "personal")
else()
	odb_compile(OdbCMake_SOURCES FILES ${OdbCMake_ODB_HEADERS} DB ${TARGET_DB} GENERATE_QUERY GENERATE_SESSION)
endif()

add_executable(odbcmake
	${OdbCMake_SOURCES}
	${OdbCMake_ODB_HEADERS})

target_compile_definitions(odbcmake PUBLIC AT_ONCE)

target_link_libraries(odbcmake
	${ODB_LIBRARIES})
target_include_directories(odbcmake
	PRIVATE
		${ODB_INCLUDE_DIRS}
		${ODB_COMPILE_OUTPUT_DIR})
target_compile_definitions(odbcmake
	PRIVATE
		DATABASE_SQLITE)
