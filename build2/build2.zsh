#Clang
alias clf='ln -s ~/.clang* .'

#Build2
#alias bnew='bdep new -t empty'
#alias blib='bdep new --package -l c++ -t lib,split'
#alias bexe='bdep new --package -l c++ -t exe,prefix=src'
alias cldb='b -vn clean update |& compiledb'

#GCC FLAGS AND MACROS
activate_assert_macro='-DDEBUG'
deactivate_assert_macro='-DNDEBUG'
gcc_debug_macros='-D_FORTIFY_SOURCE=2 -D_GLIBCXX_DEBUG'
gcc_debug_flags='-grecord-gcc-switches'
gcc_flags_cpp='-Weffc++ -Woverloaded-virtual -Wsuggest-final-types -Wsuggest-final-methods -Wsuggest-override'
gcc_warning_flags='-Wnull-dereference -Wstack-protector  -Wconversion -Wmissing-noreturn -Wshadow'
gcc_instumentation_option='-fsanitize=address -fsanitize=undefined -fstack-clash-protection -fstack-protector-strong -fcf-protection=full'
gcc_codegen='-fasynchronous-unwind-tables -fstrict-overflow'
gcc_optimization_options='-fomit-frame-pointer'
gcc_optimization_options_linker='-fuse-ld=gold -flto=4 -flto-compression-level=9 -fuse-linker-plugin'

basic_warning_flags='-Wall -Wextra -pedantic -pedantic-errors -Werror'

gcc_compiler_flags=$basic_warning_flags" "$gcc_flags_cpp" "$gcc_warning_flags" "$gcc_codegen" "$gcc_optimization_options" "$gcc_optimization_options_linker" "$gcc_instumentation_option" "$gcc_debug_flags
gcc_linker_flags=$gcc_optimization_options_linker" "$gcc_instumentation_option
gcc_preprocessor_flags=$gcc_debug_macros" "$activate_assert_macro

gcc_compiler_name='gcc'
gcc_compiler_build_mode='debug'
gcc_build_name=$gcc_compiler_name"-"$gcc_compiler_build_mode
gcc_b2_init='bdep init -C ~/repos/c++/build2/build2builds/'$gcc_build_name" "@$gcc_build_name' cc'
gcc_debug_compiler='g++ -ggdb -Og'
gcc_release_compiler='g++ -O3'
gcc_cxx_mode_config=' config.cxx'='"'$gcc_debug_compiler'"'' config.cxx.coptions'='"'$gcc_compiler_flags'"'
gcc_cxx_preprocessor_config='config.cxx.poptions'='"'$gcc_preprocessor_flags'"'
gcc_cxx_linker_config='config.bin.ar=gcc-ar config.bin.ranlib=gcc-ranlib config.cxx.loptions'='"'$gcc_linker_flags'"'
alias gcc_b_config_debug=$gcc_b2_init" "$gcc_cxx_mode_config" "$gcc_cxx_preprocessor_config" "$gcc_cxx_linker_config

#CLANG FLAGS AND MACROS
clang_codegen='-fstrict-vtable-pointers -fwhole-program-vtables -fsanitize-cfi-icall-generalize-pointers -fomit-frame-pointer -fno-optimize-sibling-calls'
clang_optimization_options_linker='-flto=thin'
clang_instumentation_option='-fsanitize=address -fsanitize=undefined -static-libasan'
clang_linker_flags=$clang_instumentation_option" "$clang_optimization_options_linker
clang_compiler_flags='-Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-missing-prototypes'" "$clang_codegen" "$clang_linker_flags
clang_preprocessor_flags=$activate_assert_macro


clang_compiler_name='clang'
clang_compiler_build_mode='debug'
clang_build_name=$clang_compiler_name"-"$clang_compiler_build_mode
clang_b2_init='bdep init -C ~/repos/c++/build2/build2builds/'$clang_build_name" "@$clang_build_name' cc'
clang_debug_compiler='clang++ -ggdb -Og'
clang_release_compiler='clang++ -O3'
clang_cxx_mode_config=' config.cxx'='"'$clang_debug_compiler'"'' config.cxx.coptions'='"'$clang_compiler_flags'"'
clang_cxx_preprocessor_config='config.cxx.poptions'='"'$clang_preprocessor_flags'"'
clang_cxx_linker_config='config.cxx.loptions'='"'$clang_linker_flags'"'
alias clang_b_config_debug=$clang_b2_init" "$clang_cxx_mode_config" "$clang_cxx_preprocessor_config" "$clang_cxx_linker_config
#Create project configurations for Clang build type
#alias bconr='bdep init -C ~/repos/c++/build2/build2builds/clang-release @clang-release cc config.cxx="clang++-11 -03"\
    #config.cxx.coptions="-Wall -Wextra -pedantic -pedantic-errors -Werror -DNDEBUG"'
#alias bcond='bdep init -C ~/repos/c++/build2/build2builds/clang-debug @clang-debug cc config.cxx="clang++-11 -g -O0"\
    #config.cxx.coptions="-Weverything -Wno-c++98-compat -Wno-c++98-compat-pedantic -Wno-missing-prototypes -DDEBUG"'
#alias bgconr='bdep init -C ~/repos/c++/build2/build2builds/gcc-release @gcc-release cc config.cxx="g++ -03"\
    #config.cxx.coptions="-Wall -Wextra -pedantic -pedantic-errors -Werror -DNDEBUG"'
#bgcond='bdep init -C ~/repos/c++/build2/build2builds/gcc-debug @gcc-debug cc config.cxx="g++ -g -Og"'
##b_c='config.cxx.coptions="-Wfatal-errors -Wpedantic -Wall -Wextra -DDEBUG"'
#b_c='config.cxx.coptions=''"'$compiler_flags'"'
#alias bgcondd=$bgcond" "$b_c

#Add project to particular clang configuration
alias bgcadr='bdep init -A ~/repos/c++/build2/build2builds/clang-release'
alias bcadr='bdep init -A ~/repos/c++/build2/build2builds/gcc-release'
alias b_init_clang_debug='bdep init -A ~/repos/c++/build2/build2builds/clang-debug @clang-debug'
alias b_init_gcc_debug='bdep init -A ~/repos/c++/build2/build2builds/gcc-debug @gcc-debug'

#Create exeutables and library
alias bexe='bdep new -l c++ -t exe'
alias blib='bdep new -l c++ -t lib'


