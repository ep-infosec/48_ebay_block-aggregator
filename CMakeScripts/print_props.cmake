function(echo_target_property tgt prop)
    get_property(v TARGET ${tgt} PROPERTY ${prop})
    get_property(d TARGET ${tgt} PROPERTY ${prop} DEFINED)
    get_property(s TARGET ${tgt} PROPERTY ${prop} SET)

    # only produce output for values that are set

    if (s)
        message("tgt='${tgt}' prop='${prop}'")

        message("  value='${v}'")

        message("  defined='${d}'")

        message("  set='${s}'")

        message("")

    endif ()
endfunction()

function(echo_target tgt)
    if (NOT TARGET ${tgt})
        message("There is no target named '${tgt}'")
        return()
    endif ()
    set(props
            DEBUG_OUTPUT_NAME
            DEBUG_POSTFIX
            RELEASE_OUTPUT_NAME
            RELEASE_POSTFIX
            ARCHIVE_OUTPUT_DIRECTORY
            ARCHIVE_OUTPUT_DIRECTORY_DEBUG
            ARCHIVE_OUTPUT_DIRECTORY_RELEASE
            ARCHIVE_OUTPUT_NAME
            ARCHIVE_OUTPUT_NAME_DEBUG
            ARCHIVE_OUTPUT_NAME_RELEASE
            AUTOMOC
            AUTOMOC_MOC_OPTIONS
            BUILD_WITH_INSTALL_RPATH
            BUNDLE
            BUNDLE_EXTENSION
            COMPILE_DEFINITIONS
            COMPILE_DEFINITIONS_DEBUG
            COMPILE_DEFINITIONS_RELEASE
            COMPILE_FLAGS
            DEBUG_POSTFIX
            RELEASE_POSTFIX
            DEFINE_SYMBOL
            ENABLE_EXPORTS
            EXCLUDE_FROM_ALL
            EchoString
            FOLDER
            FRAMEWORK
            Fortran_FORMAT
            Fortran_MODULE_DIRECTORY
            GENERATOR_FILE_NAME
            GNUtoMS
            HAS_CXX
            IMPLICIT_DEPENDS_INCLUDE_TRANSFORM
            IMPORTED
            IMPORTED_CONFIGURATIONS
            IMPORTED_IMPLIB
            IMPORTED_IMPLIB_DEBUG
            IMPORTED_IMPLIB_RELEASE
            IMPORTED_LINK_DEPENDENT_LIBRARIES
            IMPORTED_LINK_DEPENDENT_LIBRARIES_DEBUG
            IMPORTED_LINK_DEPENDENT_LIBRARIES_RELEASE
            IMPORTED_LINK_INTERFACE_LANGUAGES
            IMPORTED_LINK_INTERFACE_LANGUAGES_DEBUG
            IMPORTED_LINK_INTERFACE_LANGUAGES_RELEASE
            IMPORTED_LINK_INTERFACE_LIBRARIES
            IMPORTED_LINK_INTERFACE_LIBRARIES_DEBUG
            IMPORTED_LINK_INTERFACE_LIBRARIES_RELEASE
            IMPORTED_LINK_INTERFACE_MULTIPLICITY
            IMPORTED_LINK_INTERFACE_MULTIPLICITY_DEBUG
            IMPORTED_LINK_INTERFACE_MULTIPLICITY_RELEASE
            IMPORTED_LOCATION
            IMPORTED_LOCATION_DEBUG
            IMPORTED_LOCATION_RELEASE
            IMPORTED_NO_SONAME
            IMPORTED_NO_SONAME_DEBUG
            IMPORTED_NO_SONAME_RELEASE
            IMPORTED_SONAME
            IMPORTED_SONAME_DEBUG
            IMPORTED_SONAME_RELEASE
            IMPORT_PREFIX
            IMPORT_SUFFIX
            INCLUDE_DIRECTORIES
            INSTALL_NAME_DIR
            INSTALL_RPATH
            INSTALL_RPATH_USE_LINK_PATH
            INTERPROCEDURAL_OPTIMIZATION
            INTERPROCEDURAL_OPTIMIZATION_DEBUG
            INTERPROCEDURAL_OPTIMIZATION_RELEASE
            LABELS
            LIBRARY_OUTPUT_DIRECTORY
            LIBRARY_OUTPUT_DIRECTORY_DEBUG
            LIBRARY_OUTPUT_DIRECTORY_RELEASE
            LIBRARY_OUTPUT_NAME
            LIBRARY_OUTPUT_NAME_DEBUG
            LIBRARY_OUTPUT_NAME_RELEASE
            LINKER_LANGUAGE
            LINK_DEPENDS
            LINK_FLAGS
            LINK_FLAGS_DEBUG
            LINK_FLAGS_RELEASE
            LINK_INTERFACE_LIBRARIES
            LINK_INTERFACE_LIBRARIES_DEBUG
            LINK_INTERFACE_LIBRARIES_RELEASE
            LINK_INTERFACE_MULTIPLICITY
            LINK_INTERFACE_MULTIPLICITY_DEBUG
            LINK_INTERFACE_MULTIPLICITY_RELEASE
            LINK_SEARCH_END_STATIC
            LINK_SEARCH_START_STATIC
            MACOSX_BUNDLE
            MACOSX_BUNDLE_INFO_PLIST
            MACOSX_FRAMEWORK_INFO_PLIST
            MAP_IMPORTED_CONFIG_DEBUG
            MAP_IMPORTED_CONFIG_RELEASE
            OSX_ARCHITECTURES
            OSX_ARCHITECTURES_DEBUG
            OSX_ARCHITECTURES_RELEASE
            OUTPUT_NAME
            OUTPUT_NAME_DEBUG
            OUTPUT_NAME_RELEASE
            POST_INSTALL_SCRIPT
            PREFIX
            PRE_INSTALL_SCRIPT
            PRIVATE_HEADER
            PROJECT_LABEL
            PUBLIC_HEADER
            RESOURCE
            RULE_LAUNCH_COMPILE
            RULE_LAUNCH_CUSTOM
            RULE_LAUNCH_LINK
            RUNTIME_OUTPUT_DIRECTORY
            RUNTIME_OUTPUT_DIRECTORY_DEBUG
            RUNTIME_OUTPUT_DIRECTORY_RELEASE
            RUNTIME_OUTPUT_NAME
            RUNTIME_OUTPUT_NAME_DEBUG
            RUNTIME_OUTPUT_NAME_RELEASE
            SKIP_BUILD_RPATH
            SOURCES
            SOVERSION
            STATIC_LIBRARY_FLAGS
            STATIC_LIBRARY_FLAGS_DEBUG
            STATIC_LIBRARY_FLAGS_RELEASE
            SUFFIX
            TYPE
            VERSION
            VS_DOTNET_REFERENCES
            VS_GLOBAL_WHATEVER
            VS_GLOBAL_KEYWORD
            VS_GLOBAL_PROJECT_TYPES
            VS_KEYWORD
            VS_SCC_AUXPATH
            VS_SCC_LOCALPATH
            VS_SCC_PROJECTNAME
            VS_SCC_PROVIDER
            VS_WINRT_EXTENSIONS
            VS_WINRT_REFERENCES
            WIN32_EXECUTABLE
            XCODE_ATTRIBUTE_WHATEVER
            )

    message("======================== ${tgt} ========================")
    foreach (p ${props})
        echo_target_property("${t}" "${p}")
    endforeach ()
    message("")
endfunction()
function(echo_targets)
    set(tgts ${ARGV})
    foreach (t ${tgts})
        echo_target("${t}")
    endforeach ()
endfunction()
#
#set(targets
#        CMakeLib
#        cmake-gui
#        MathFunctions
#        Tutorial
#        vtkCommonCore
#        )
#echo_targets(${targets})

# Get all propreties that cmake supports
execute_process(COMMAND cmake --help-property-list OUTPUT_VARIABLE CMAKE_PROPERTY_LIST)

# Convert command output into a CMake list
STRING(REGEX REPLACE ";" "\\\\;" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")
STRING(REGEX REPLACE "\n" ";" CMAKE_PROPERTY_LIST "${CMAKE_PROPERTY_LIST}")

function(print_properties)
    message ("CMAKE_PROPERTY_LIST = ${CMAKE_PROPERTY_LIST}")
endfunction(print_properties)

function(print_target_properties tgt)
    if(NOT TARGET ${tgt})
        message("There is no target named '${tgt}'")
        return()
    endif()

    foreach (prop ${CMAKE_PROPERTY_LIST})
        string(REPLACE "<CONFIG>" "${CMAKE_BUILD_TYPE}" prop ${prop})
        # Fix https://stackoverflow.com/questions/32197663/how-can-i-remove-the-the-location-property-may-not-be-read-from-target-error-i
        if(prop STREQUAL "LOCATION" OR prop MATCHES "^LOCATION_" OR prop MATCHES "_LOCATION$")
            continue()
        endif()
        # message ("Checking ${prop}")
        get_property(propval TARGET ${tgt} PROPERTY ${prop} SET)
        if (propval)
            get_target_property(propval ${tgt} ${prop})
            message ("${tgt} ${prop} = ${propval}")
        endif()
    endforeach(prop)
endfunction(print_target_properties)