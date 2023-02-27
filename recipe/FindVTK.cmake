message( STATUS Using custom FindVTK )

list( APPEND target_names
    FiltersGeneral
    WrappingPythonCore
    RenderingCore
    CommonDataModel
    CommonExecutionModel
    CommonCore
    Sys
    RenderingFreeType
    InteractionStyle
    RenderingOpenGL2
    RenderingGL2PSOpenGL2
)
 
list( APPEND target_files
    libvtkFiltersGeneral
    libvtkWrappingPythonCore
    libvtkRenderingCore
    libvtkCommonDataModel
    libvtkCommonExecutionModel
    libvtkCommonCore
    libvtksys
    libvtkRenderingFreeType
    libvtkInteractionStyle
    libvtkRenderingOpenGL2
    libvtkRenderingGL2PSOpenGL2
)

foreach( name lib_pat IN ZIP_LISTS target_names target_files)
    add_library( VTK::${name} SHARED IMPORTED )
    file( GLOB lib_file "$ENV{PREFIX}/lib/${lib_pat}*")
    list (GET lib_file 0 lib_file)
    set_target_properties( VTK::${name} PROPERTIES
	IMPORTED_LOCATION "${lib_file}"
    )
endforeach()

file( GLOB include_dir LIST_DIRECTORIES True "$ENV{PREFIX}/include/vtk-*")
set_target_properties( VTK::WrappingPythonCore PROPERTIES
	INTERFACE_INCLUDE_DIRECTORIES "${include_dir}"
	INTERFACE_LINK_LIBRARIES "VTK::CommonCore;VTK::Sys"
)

message( STATUS "VTK py core file: ${python_core_file}" )
