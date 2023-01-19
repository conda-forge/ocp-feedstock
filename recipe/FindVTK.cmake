message( STATUS Using custom FindVTK )

add_library( VTK::WrappingPythonCore SHARED IMPORTED )
add_library( VTK::RenderingCore SHARED IMPORTED )
add_library( VTK::CommonDataModel SHARED IMPORTED )
add_library( VTK::CommonExecutionModel SHARED IMPORTED )
