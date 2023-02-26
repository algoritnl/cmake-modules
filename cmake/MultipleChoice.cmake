# SPDX-License-Identifier: MIT
# Copyright (c) 2023 AlgorIT Software Consultancy, the Netherlands

#[============================================================================[

Provides a function to define a multiple_choice configuration option.

    multiple_choice(<variable> <docstring> VALID_VALUES <valid_value>...
                    [DEFAULT <default_value>] [FORCE_ON_INVALID|FATAL_ERROR])

#]============================================================================]

function(multiple_choice CHOICE CHOICE_DOCSTRING)
    cmake_parse_arguments(CHOICE "FORCE_ON_INVALID;FATAL_ERROR" "DEFAULT" "VALID_VALUES" ${ARGN})
    set(${CHOICE} ${CHOICE_DEFAULT} CACHE STRING "${CHOICE_DOCSTRING}")
    set_property(CACHE ${CHOICE} PROPERTY STRINGS ${CHOICE_VALID_VALUES})
    if(NOT ${CHOICE} IN_LIST CHOICE_VALID_VALUES)
        if(CHOICE_FATAL_ERROR)
            message(FATAL_ERROR "Invalid multiple-choice value ${CHOICE}=${${CHOICE}}.")
        elseif(CHOICE_FORCE_ON_INVALID)
            message(WARNING "Invalid multiple-choice value ${CHOICE}=${${CHOICE}}.\n"
                            "Continuing with the default: ${CHOICE}=${CHOICE_DEFAULT}.")
            set_property(CACHE ${CHOICE} PROPERTY VALUE ${CHOICE_DEFAULT})
        else()
            message(WARNING "Unknown multiple-choice value ${CHOICE}=${${CHOICE}}.")
        endif()
    endif()
endfunction()
