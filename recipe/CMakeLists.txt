cmake_minimum_required( VERSION 3.17 )
project( OCP
         LANGUAGES CXX )

if( NOT WIN32 )
    enable_language( C )
endif()

list( APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR} )

find_package (Python3 REQUIRED COMPONENTS Interpreter Development.Module)
message( STATUS "Python lib: ${Python_LIBRARIES}" )

SET(PYTHON_SP_DIR "site-packages" CACHE PATH "Python site-packages directory (for installing)")

find_package( pybind11 REQUIRED )
find_package( VTK REQUIRED COMPONENTS WrappingPythonCore RenderingCore CommonDataModel CommonExecutionModel)
find_package( OpenCASCADE REQUIRED )

include_directories( ${PROJECT_SOURCE_DIR} )
file( GLOB CPP_FILES ${PROJECT_SOURCE_DIR}/*.cpp )

add_library( OCP MODULE ${CPP_FILES} )

target_link_libraries( OCP PRIVATE ${OpenCASCADE_LIBRARIES} )
target_link_libraries( OCP PRIVATE pybind11::pybind11 VTK::WrappingPythonCore VTK::RenderingCore VTK::CommonDataModel VTK::CommonExecutionModel)
set_target_properties( OCP
                       PROPERTIES
                       CXX_STANDARD 17
                       INTERPROCEDURAL_OPTIMIZATION FALSE
                       PREFIX "${PYTHON_MODULE_PREFIX}"
                       SUFFIX "${PYTHON_MODULE_EXTENSION}" )

if(WIN32)
  target_compile_options( OCP PRIVATE /bigobj )
  target_compile_definitions( OCP PRIVATE
                              "Standard_EXPORT="
                              "Standard_EXPORTEXTERN="
                              "Standard_EXPORTEXTERNC=extern \"C\""
                              "Standard_IMPORT=extern"
                              "Standard_IMPORTC=extern \"C\""
                              "_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING")
  target_link_libraries( OCP PRIVATE opengl32 )
  target_link_libraries( OCP PRIVATE ${Python_LIBRARIES} )

else()
  set_target_properties( OCP
                         PROPERTIES
                         CMAKE_CXX_FLAGS_RELEASE "-O3 "
                         COMPILE_FLAGS "-fpermissive -fvisibility=hidden -fvisibility-inlines-hidden" )
endif()

if(UNIX AND NOT APPLE)
  target_link_options( OCP PRIVATE "LINKER:--allow-multiple-definition")
endif()

if(APPLE)
  target_link_libraries( OCP PRIVATE "-undefined dynamic_lookup")
endif()


install( TARGETS OCP LIBRARY DESTINATION ${PYTHON_SP_DIR} )