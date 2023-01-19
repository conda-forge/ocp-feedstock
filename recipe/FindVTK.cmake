message( STATUS Using custom FindVTK )

add_library( VTK::WrappingPythonCore SHARED IMPORTED )
add_library( VTK::RenderingCore SHARED IMPORTED )
add_library( VTK::CommonDataModel SHARED IMPORTED )
add_library( VTK::CommonExecutionModel SHARED IMPORTED )
add_library( VTK::CommonCore SHARED IMPORTED )
add_library( VTK::Sys SHARED IMPORTED )

file( GLOB python_core_file "$ENV{PREFIX}/lib/libvtkWrappingPythonCore*")
file( GLOB rendernig_core_file "$ENV{PREFIX}/lib/libvtkRenderingCore*")
file( GLOB data_model_file "$ENV{PREFIX}/lib/libvtkCommonDataModel*")
file( GLOB execution_model_file "$ENV{PREFIX}/lib/libvtkCommonExecutionModel*")
file( GLOB common_core_file "$ENV{PREFIX}/lib/libvtkCommonCore*")
file( GLOB sys_file "$ENV{PREFIX}/lib/libvtksys*")
file( GLOB include_dir LIST_DIRECTORIES True "$ENV{PREFIX}/include/vtk-*")

set_target_properties( VTK::WrappingPythonCore PROPERTIES
	INTERFACE_INCLUDE_DIRECTORIES "${include_dir}"
	INTERFACE_LINK_LIBRARIES "VTK::CommonCore;VTK::sys"
	IMPORTED_LOCATION "${python_core_file}"
)

set_target_properties( VTK::RenderingCore PROPERTIES
	IMPORTED_LOCATION "${rendering_core_file}"
)

set_target_properties( VTK::CommonDataModel PROPERTIES
	IMPORTED_LOCATION "${data_model_file}"
)

set_target_properties( VTK::CommonExecutionModel PROPERTIES
	IMPORTED_LOCATION "${execution_model_file}"
)

set_target_properties( VTK::CommonCore PROPERTIES
	IMPORTED_LOCATION "${common_core_file}"
)

set_target_properties( VTK::Sys PROPERTIES
	IMPORTED_LOCATION "${sys_file}"
)

message( STATUS "VTK include dir: ${include_dir}" )
