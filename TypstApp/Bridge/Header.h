//
//  Header.h
//  TypstApp
//
//  Created by Tiankai Ma on 2023/7/28.
//

#ifndef Header_h
#define Header_h

#include <stdarg.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdlib.h>

int32_t run(const uint8_t *arguments);

typedef struct TSLanguage TSLanguage;

const TSLanguage *tree_sitter_typst(void);

#endif /* Header_h */
