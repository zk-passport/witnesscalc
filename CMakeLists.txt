cmake_minimum_required(VERSION 3.5)

include(cmake/platform.cmake)

set(USE_ASM ON CACHE BOOL "Use asm implementation for Fr and Fq")

project(witnesscalc LANGUAGES CXX ASM)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

message("USE_ASM=" ${USE_ASM})
message("CMAKE_CROSSCOMPILING=" ${CMAKE_CROSSCOMPILING})

message("GMP_PREFIX=" ${GMP_PREFIX})
message("GMP_INCLUDE_DIR=" ${GMP_INCLUDE_DIR})
message("GMP_LIB_DIR=" ${GMP_LIB_DIR})

if (NOT EXISTS ${GMP_INCLUDE_FILE_FULLPATH})
    message("WARNING: ${GMP_INCLUDE_FILE_FULLPATH} is not found and so system ${GMP_INCLUDE_FILE} is used.")
endif()

if (NOT EXISTS ${GMP_LIB_FILE_FULLPATH})
    message("WARNING: ${GMP_LIB_FILE_FULLPATH} is not found and so system ${GMP_LIB_FILE} is used.")
    set(GMP_LIB gmp)
endif()


include_directories(BEFORE ${GMP_INCLUDE_DIR})

add_subdirectory(src)


install(TARGETS
    tests
    test_platform
    authV2
    witnesscalc_authV2
    witnesscalc_authV2Static
    credentialAtomicQueryMTPV2
    witnesscalc_credentialAtomicQueryMTPV2
    witnesscalc_credentialAtomicQueryMTPV2Static
    credentialAtomicQuerySigV2
    witnesscalc_credentialAtomicQuerySigV2
    witnesscalc_credentialAtomicQuerySigV2Static
    credentialAtomicQueryMTPV2OnChain
    witnesscalc_credentialAtomicQueryMTPV2OnChain
    witnesscalc_credentialAtomicQueryMTPV2OnChainStatic
    credentialAtomicQuerySigV2OnChain
    witnesscalc_credentialAtomicQuerySigV2OnChain
    witnesscalc_credentialAtomicQuerySigV2OnChainStatic
    credentialAtomicQueryV3
    witnesscalc_credentialAtomicQueryV3
    witnesscalc_credentialAtomicQueryV3Static
    credentialAtomicQueryV3OnChain
    witnesscalc_credentialAtomicQueryV3OnChain
    witnesscalc_credentialAtomicQueryV3OnChainStatic
    linkedMultiQuery10
    witnesscalc_linkedMultiQuery10
    witnesscalc_linkedMultiQuery10Static
    proveSha384Sha384Sha384EcdsaBrainpoolP384r1
    witnesscalc_proveSha384Sha384Sha384EcdsaBrainpoolP384r1
    witnesscalc_proveSha384Sha384Sha384EcdsaBrainpoolP384r1Static
    proveSha1Sha1Sha1EcdsaBrainpoolP224r1
    witnesscalc_proveSha1Sha1Sha1EcdsaBrainpoolP224r1
    witnesscalc_proveSha1Sha1Sha1EcdsaBrainpoolP224r1Static
    proveSha1Sha1Sha1EcdsaSecp256r1
    witnesscalc_proveSha1Sha1Sha1EcdsaSecp256r1
    witnesscalc_proveSha1Sha1Sha1EcdsaSecp256r1Static
    proveSha1Sha1Sha1Rsa655374096
    witnesscalc_proveSha1Sha1Sha1Rsa655374096
    witnesscalc_proveSha1Sha1Sha1Rsa655374096Static
    proveSha1Sha256Sha256Rsa655374096
    witnesscalc_proveSha1Sha256Sha256Rsa655374096
    witnesscalc_proveSha1Sha256Sha256Rsa655374096Static
    proveSha256Sha224Sha224EcdsaBrainpoolP224r1
    witnesscalc_proveSha256Sha224Sha224EcdsaBrainpoolP224r1
    witnesscalc_proveSha256Sha224Sha224EcdsaBrainpoolP224r1Static
    proveSha256Sha256Sha256EcdsaBrainpoolP224r1
    witnesscalc_proveSha256Sha256Sha256EcdsaBrainpoolP224r1
    witnesscalc_proveSha256Sha256Sha256EcdsaBrainpoolP224r1Static
    proveSha256Sha256Sha256EcdsaBrainpoolP256r1
    witnesscalc_proveSha256Sha256Sha256EcdsaBrainpoolP256r1
    witnesscalc_proveSha256Sha256Sha256EcdsaBrainpoolP256r1Static
    fr
    RUNTIME DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    BUNDLE DESTINATION ${CMAKE_INSTALL_PREFIX}/app
    LIBRARY DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

install(FILES "${GMP_LIB_DIR}/${GMP_LIB_FILE}"
    DESTINATION ${CMAKE_INSTALL_PREFIX}/lib)

install(FILES
    src/authV2.dat
    src/credentialAtomicQuerySigV2.dat
    src/credentialAtomicQueryMTPV2.dat
    src/credentialAtomicQuerySigV2OnChain.dat
    src/credentialAtomicQueryMTPV2OnChain.dat
    src/proveSha384Sha384Sha384EcdsaBrainpoolP384r1.dat
    src/proveSha1Sha1Sha1EcdsaBrainpoolP224r1.dat
    src/proveSha1Sha1Sha1EcdsaSecp256r1.dat
    src/proveSha1Sha1Sha1Rsa655374096.dat
    src/proveSha1Sha256Sha256Rsa655374096.dat
    src/proveSha256Sha224Sha224EcdsaBrainpoolP224r1.dat
    src/proveSha256Sha256Sha256EcdsaBrainpoolP224r1.dat
    src/proveSha256Sha256Sha256EcdsaBrainpoolP256r1.dat
    src/credentialAtomicQueryV3.dat
    src/credentialAtomicQueryV3OnChain.dat
    src/linkedMultiQuery10.dat
    DESTINATION ${CMAKE_INSTALL_PREFIX}/bin)

install(FILES
    src/witnesscalc.h
    src/witnesscalc_authV2.h
    src/witnesscalc_credentialAtomicQuerySigV2.h
    src/witnesscalc_credentialAtomicQueryMTPV2.h
    src/witnesscalc_credentialAtomicQuerySigV2OnChain.h
    src/witnesscalc_proveSha384Sha384Sha384EcdsaBrainpoolP384r1.h
    src/witnesscalc_proveSha1Sha1Sha1EcdsaBrainpoolP224r1.h
    src/witnesscalc_proveSha1Sha1Sha1EcdsaSecp256r1.h
    src/witnesscalc_proveSha1Sha1Sha1Rsa655374096.h
    src/witnesscalc_proveSha1Sha256Sha256Rsa655374096.h
    src/witnesscalc_proveSha256Sha224Sha224EcdsaBrainpoolP224r1.h
    src/witnesscalc_proveSha256Sha256Sha256EcdsaBrainpoolP224r1.h
    src/witnesscalc_proveSha256Sha256Sha256EcdsaBrainpoolP256r1.h
    src/witnesscalc_credentialAtomicQueryMTPV2OnChain.h
    src/witnesscalc_credentialAtomicQueryV3.h
    src/witnesscalc_credentialAtomicQueryV3OnChain.h
    src/witnesscalc_linkedMultiQuery10.h
    DESTINATION ${CMAKE_INSTALL_PREFIX}/include)
